import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:dio/dio.dart';
import '../../../shared/widgets/accessible_button.dart';
import '../../../shared/widgets/accessible_tappable.dart';
import '../../../shared/utils/app_logger.dart';
import '../../../services/network/api_client.dart';
import '../application/onboarding_provider.dart';

class ManualRegistrationScreen extends ConsumerStatefulWidget {
  const ManualRegistrationScreen({super.key});

  @override
  ConsumerState<ManualRegistrationScreen> createState() =>
      _ManualRegistrationScreenState();
}

class _ManualRegistrationScreenState
    extends ConsumerState<ManualRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String _normalizePhoneNumber(String input) {
    final digitsOnly = input.replaceAll(RegExp(r'[^\d]'), '');
    if (input.trim().startsWith('+')) {
      return '+$digitsOnly';
    }
    return '+$digitsOnly';
  }

  String _extractErrorMessage(DioException error) {
    final statusCode = error.response?.statusCode;
    final responseData = error.response?.data;

    if (responseData is Map<String, dynamic>) {
      final message = responseData['message'];
      if (message is String && message.isNotEmpty) {
        return message;
      }
      if (message is Map<String, dynamic> && message.isNotEmpty) {
        return message.values.join('\n');
      }
    }

    switch (statusCode) {
      case 400:
        return 'Validation failed. Please check your email, password, and phone number.';
      case 401:
      case 409:
        return 'An account with this email may already exist.';
      case 429:
        return 'Too many requests. Please try again in a minute.';
      default:
        return 'Sign up failed. Please try again.';
    }
  }

  void _showErrorSnackbar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.black),
    );
  }

  Future<void> _submitForm() async {
    if (!(_formKey.currentState?.validate() ?? false) || _isSubmitting) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    final email = _emailController.text.trim().toLowerCase();
    final phoneNumber = _normalizePhoneNumber(_phoneController.text);
    final password = _passwordController.text;

    try {
      final dio = ref.read(apiClientProvider);
      final response = await dio.post(
        AuthApiEndpoints.signUp,
        data: {
          'email': email,
          'password': password,
          'phoneNumber': phoneNumber,
        },
      );

      final responseData = response.data;
      if (response.statusCode != 201 || responseData is! Map<String, dynamic>) {
        AppLogger.logError(
          'Unexpected sign-up response: status=${response.statusCode}, data=$responseData',
        );
        _showErrorSnackbar('Unexpected server response. Please try again.');
        return;
      }

      final userToken = responseData['userToken'] as String?;
      final sessionToken = responseData['sessionToken'] as String?;

      if (userToken == null || sessionToken == null) {
        AppLogger.logError(
          'Sign-up response missing token fields: $responseData',
        );
        _showErrorSnackbar('Missing authentication tokens in response.');
        return;
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userToken', userToken);
      await prefs.setString('sessionToken', sessionToken);

      final registrationData = {
        'fullName': _nameController.text.trim(),
        'email': email,
        'phone': phoneNumber,
        'registrationType': 'manual',
      };

      ref
          .read(onboardingNotifierProvider.notifier)
          .updateRegistrationData(registrationData);
      ref.read(onboardingNotifierProvider.notifier).completeOnboarding();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registration completed successfully!'),
          backgroundColor: Colors.black,
        ),
      );

      context.go('/');
    } on DioException catch (error, stackTrace) {
      AppLogger.logError(
        'Sign-up API error: status=${error.response?.statusCode}, data=${error.response?.data}, message=${error.message}, stack=$stackTrace',
      );
      _showErrorSnackbar(_extractErrorMessage(error));
    } catch (error, stackTrace) {
      AppLogger.logError('Unexpected sign-up error: $error\n$stackTrace');
      _showErrorSnackbar('Something went wrong. Please try again.');
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Manual Registration',
          semanticsLabel: 'Manual Registration Form',
        ),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Container(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Center(
                  child: Column(
                    children: [
                      const Icon(
                        Icons.person_add,
                        size: 60,
                        color: Colors.black,
                        semanticLabel: 'Create account icon',
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Create Your Account',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        semanticsLabel: 'Create Your Account',
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Fill in your details below',
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                        semanticsLabel:
                            'Fill in your personal details in the form below',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Full Name Field
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    prefixIcon: const Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your full name';
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 16),

                // Email Field
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email Address',
                    prefixIcon: const Icon(Icons.email),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 16),

                // Phone Field
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    prefixIcon: const Icon(Icons.phone),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 16),

                // Password Field
                TextFormField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: AccessibleTappable(
                      semanticLabel:
                          _isPasswordVisible
                              ? 'Hide password'
                              : 'Show password',
                      onTap: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                      child: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    if (value.length < 8) {
                      return 'Password must be at least 8 characters';
                    }
                    if (!RegExp(r'[A-Z]').hasMatch(value)) {
                      return 'Password must contain at least one uppercase letter';
                    }
                    if (!RegExp(r'[a-z]').hasMatch(value)) {
                      return 'Password must contain at least one lowercase letter';
                    }
                    if (!RegExp(r'[0-9]').hasMatch(value)) {
                      return 'Password must contain at least one number';
                    }
                    if (!RegExp(r'[^A-Za-z0-9]').hasMatch(value)) {
                      return 'Password must contain at least one special character';
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 16),

                // Confirm Password Field
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: !_isConfirmPasswordVisible,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: AccessibleTappable(
                      semanticLabel:
                          _isConfirmPasswordVisible
                              ? 'Hide password confirmation'
                              : 'Show password confirmation',
                      onTap: () {
                        setState(() {
                          _isConfirmPasswordVisible =
                              !_isConfirmPasswordVisible;
                        });
                      },
                      child: Icon(
                        _isConfirmPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _submitForm(),
                ),
                const SizedBox(height: 32),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: AccessibleButton(
                    onPressed:
                        _isSubmitting
                            ? null
                            : () {
                              _submitForm();
                            },
                    label: _isSubmitting ? 'Registering...' : 'Register',
                    semanticHint: 'Complete manual registration',
                  ),
                ),
                const SizedBox(height: 16),

                // Back to selection
                Center(
                  child: AccessibleTappable(
                    semanticLabel: 'Go back to registration type selection',
                    onTap: () => Navigator.pop(context),
                    child: const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Text(
                        'Back to Registration Type',
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
