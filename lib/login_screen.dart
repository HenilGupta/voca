import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// ---------------------------------------------------------------------------
// Login Screen
// ---------------------------------------------------------------------------

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    // Prefilled test data
    _emailController = TextEditingController(text: 'sophia@example.com');
    _passwordController = TextEditingController(text: 'Password@123');
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _signIn() {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    // Validation
    if (email.isEmpty) {
      _showError('Please enter your email');
      return;
    }
    if (!email.contains('@')) {
      _showError('Please enter a valid email');
      return;
    }
    if (password.isEmpty) {
      _showError('Please enter your password');
      return;
    }
    if (password.length < 6) {
      _showError('Password must be at least 6 characters');
      return;
    }

    // Navigate to dating screen (cards page)
    context.goNamed('profile');
  }

  void _signUpWithAI() {
    // Navigate to AI voice screen
    context.goNamed('ai-voice');
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
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        children: [
          const SizedBox(height: 60),

          // Header
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Welcome Back',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Sign in to continue your journey',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),

          const SizedBox(height: 50),

          // Email field
          _LoginField(
            label: 'Email Address',
            controller: _emailController,
            hint: 'your@email.com',
            icon: Icons.email_rounded,
            keyboardType: TextInputType.emailAddress,
          ),

          const SizedBox(height: 20),

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

          const SizedBox(height: 12),

          // Forgot password link
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              'Forgot Password?',
              style: TextStyle(
                color: const Color(0xFFCBA6FF),
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const SizedBox(height: 32),

          // Sign in button
          GestureDetector(
            onTap: _signIn,
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
                  Icon(Icons.login_rounded, color: Colors.white, size: 22),
                  SizedBox(width: 10),
                  Text(
                    'Sign In',
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

          const SizedBox(height: 28),

          // Divider
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 1,
                  color: Colors.white10,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'OR',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 1,
                  color: Colors.white10,
                ),
              ),
            ],
          ),

          const SizedBox(height: 28),

          // Sign up with AI button
          GestureDetector(
            onTap: _signUpWithAI,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E2C),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFF7A3FD4), width: 2),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF7B2FFF).withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_rounded, color: Color(0xFFCBA6FF), size: 22),
                  SizedBox(width: 10),
                  Text(
                    'Sign Up with AI',
                    style: TextStyle(
                      color: Color(0xFFCBA6FF),
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.4,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 32),

          // Terms text
          Center(
            child: Text(
              'By signing in, you agree to our Terms of Service',
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
// Login Text Field
// ---------------------------------------------------------------------------

class _LoginField extends StatelessWidget {
  const _LoginField({
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
                    obscureText
                        ? Icons.visibility_off_rounded
                        : Icons.visibility_rounded,
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
