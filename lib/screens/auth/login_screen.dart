
import 'package:flutter/material.dart';
import 'signup_screen.dart';
import '../home/home_screen.dart';

const Color primaryColor = Color(0xFF102C35);
const Color accentColor = Color(0xFF18A999);
const Color backgroundColor = Color(0xFFF7F7F2);
const Color secondaryText = Color(0xFF778387);

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isPasswordVisible = false;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 460),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 26,
                      vertical: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(context),
                        const SizedBox(height: 55),
                        const Text(
                          'Welcome\nback.',
                          style: TextStyle(
                            fontSize: 46,
                            height: 1.08,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -1.8,
                            color: primaryColor,
                          ),
                        ),
                        const SizedBox(height: 14),
                        const Text(
                          'Sign in to continue exploring '
                              'your next adventure.',
                          style: TextStyle(
                            fontSize: 15,
                            height: 1.6,
                            color: secondaryText,
                          ),
                        ),
                        const SizedBox(height: 38),
                        _buildLabel('Email address'),
                        const SizedBox(height: 10),
                        _buildInput(
                          controller: emailController,
                          hint: 'Enter your email address',
                          icon: Icons.mail_outline_rounded,
                        ),
                        const SizedBox(height: 24),
                        _buildLabel('Password'),
                        const SizedBox(height: 10),
                        _buildPasswordInput(),
                        const SizedBox(height: 12),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Password recovery will be added later.',
                                  ),
                                ),
                              );
                            },
                            child: const Text(
                              'Forgot password?',
                              style: TextStyle(
                                color: accentColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildPrimaryButton(),
                        const SizedBox(height: 30),
                        _buildSignupLink(context),
                        const SizedBox(height: 30),
                        const Center(
                          child: Text(
                            'DISCOVER. EXPLORE. EXPERIENCE.',
                            style: TextStyle(
                              fontSize: 10,
                              letterSpacing: 2,
                              color: secondaryText,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_rounded),
          color: primaryColor,
        ),
        const Spacer(),
        const Text(
          'safarivo.',
          style: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.bold,
            color: primaryColor,
            letterSpacing: -0.8,
          ),
        ),
      ],
    );
  }

  Widget _buildLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: primaryColor,
      ),
    );
  }

  Widget _buildInput({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          fontSize: 14,
          color: Color(0xFFA0AAAC),
        ),
        prefixIcon: Icon(icon, color: secondaryText, size: 20),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 19,
          horizontal: 16,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE8ECE9)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: accentColor,
            width: 1.5,
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordInput() {
    return TextField(
      controller: passwordController,
      obscureText: !isPasswordVisible,
      decoration: InputDecoration(
        hintText: 'Enter your password',
        hintStyle: const TextStyle(
          fontSize: 14,
          color: Color(0xFFA0AAAC),
        ),
        prefixIcon: const Icon(
          Icons.lock_outline_rounded,
          color: secondaryText,
          size: 20,
        ),
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              isPasswordVisible = !isPasswordVisible;
            });
          },
          icon: Icon(
            isPasswordVisible
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: secondaryText,
          ),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 19,
          horizontal: 16,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE8ECE9)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: accentColor,
            width: 1.5,
          ),
        ),
      ),
    );
  }

  Widget _buildPrimaryButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),

        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            ),
          );
        },

        child: const Text(
          'Sign In',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildSignupLink(BuildContext context) {
    return Center(
      child: Wrap(
        alignment: WrapAlignment.center,
        children: [
          const Text(
            "Don't have an account? ",
            style: TextStyle(color: secondaryText, fontSize: 14),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SignupScreen(),
                ),
              );
            },
            child: const Text(
              'Create account',
              style: TextStyle(
                color: accentColor,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
