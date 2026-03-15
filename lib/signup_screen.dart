import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

// ---------------------------------------------------------------------------
// Signup Screen
// ---------------------------------------------------------------------------

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    // Prefilled test data
    _emailController = TextEditingController(text: 'sophia@example.com');
    _phoneController = TextEditingController(text: '9999999999');
    _passwordController = TextEditingController(text: 'Password@123');
    _confirmPasswordController = TextEditingController(text: 'Password@123');
  }

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _signUp() {
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    // Validation
    if (email.isEmpty) {
      _showError('Please enter your email');
      return;
    }
    if (!email.contains('@')) {
      _showError('Please enter a valid email');
      return;
    }
    if (phone.isEmpty) {
      _showError('Please enter your phone number');
      return;
    }
    if (phone.length != 10) {
      _showError('Phone number must be 10 digits');
      return;
    }
    if (password.isEmpty) {
      _showError('Please enter a password');
      return;
    }
    if (password.length < 6) {
      _showError('Password must be at least 6 characters');
      return;
    }
    if (password != confirmPassword) {
      _showError('Passwords do not match');
      return;
    }

    // Navigate to registration screen
    context.goNamed('register');
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFFFF4566),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F14),
      appBar: AppBar(
        backgroundColor: const Color(0xFF13131C),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        children: [
          const SizedBox(height: 20),

          // Header
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Create Account',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Join Voca and find your perfect match through voice',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),

          const SizedBox(height: 40),

          // Email field
          _SignupField(
            label: 'Email Address',
            controller: _emailController,
            hint: 'your@email.com',
            icon: Icons.email_rounded,
            keyboardType: TextInputType.emailAddress,
          ),

          const SizedBox(height: 18),

          // Phone field
          _PhoneField(
            label: 'Phone Number',
            controller: _phoneController,
            hint: '9999999999',
          ),

          const SizedBox(height: 18),

          // Password field
          _PasswordField(
            label: 'Password',
            controller: _passwordController,
            hint: 'Enter your password',
            obscureText: _obscurePassword,
            onVisibilityToggle: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
          ),

          const SizedBox(height: 18),

          // Confirm Password field
          _PasswordField(
            label: 'Confirm Password',
            controller: _confirmPasswordController,
            hint: 'Confirm your password',
            obscureText: _obscureConfirmPassword,
            onVisibilityToggle: () {
              setState(() {
                _obscureConfirmPassword = !_obscureConfirmPassword;
              });
            },
          ),

          const SizedBox(height: 28),

          // Sign up button
          GestureDetector(
            onTap: _signUp,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF9B4DFF), Color(0xFF5E17EB)],
                ),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF7B2FFF).withOpacity(0.5),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person_add_rounded, color: Colors.white, size: 22),
                  SizedBox(width: 10),
                  Text(
                    'Sign Up',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.4,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Terms text
          Center(
            child: Text(
              'By signing up, you agree to our Terms of Service',
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Phone Field (Custom)
// ---------------------------------------------------------------------------

class _PhoneField extends StatelessWidget {
  const _PhoneField({
    required this.label,
    required this.controller,
    required this.hint,
  });

  final String label;
  final TextEditingController controller;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 13,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E2C),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFF2D1F4E)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            child: Row(
              children: [
                // +91 prefix (non-editable)
                const Text(
                  '+91 ',
                  style: TextStyle(
                    color: Color(0xFFCBA6FF),
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: controller,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                    decoration: InputDecoration(
                      hintText: hint,
                      hintStyle: const TextStyle(color: Colors.white30),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 0,
                      ),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                  ),
                ),
                Icon(Icons.phone_rounded,
                    color: const Color(0xFFCBA6FF), size: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Signup Text Field
// ---------------------------------------------------------------------------

class _SignupField extends StatelessWidget {
  const _SignupField({
    required this.label,
    required this.controller,
    required this.hint,
    required this.icon,
    this.keyboardType = TextInputType.text,
  });

  final String label;
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final TextInputType keyboardType;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 13,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E2C),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFF2D1F4E)),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.white30),
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 12, right: 8),
                child: Icon(icon, color: const Color(0xFFCBA6FF), size: 22),
              ),
              prefixIconConstraints: const BoxConstraints(minWidth: 0),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Password Field
// ---------------------------------------------------------------------------

class _PasswordField extends StatelessWidget {
  const _PasswordField({
    required this.label,
    required this.controller,
    required this.hint,
    required this.obscureText,
    required this.onVisibilityToggle,
  });

  final String label;
  final TextEditingController controller;
  final String hint;
  final bool obscureText;
  final VoidCallback onVisibilityToggle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 13,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E2C),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFF2D1F4E)),
          ),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.white30),
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 12, right: 8),
                child: Icon(Icons.lock_rounded,
                    color: const Color(0xFFCBA6FF), size: 22),
              ),
              prefixIconConstraints: const BoxConstraints(minWidth: 0),
              suffixIcon: GestureDetector(
                onTap: onVisibilityToggle,
                child: Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Icon(
                    obscureText ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                    color: const Color(0xFFCBA6FF),
                    size: 22,
                  ),
                ),
              ),
              suffixIconConstraints: const BoxConstraints(minWidth: 0),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}
