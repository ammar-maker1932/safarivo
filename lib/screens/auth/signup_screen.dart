
import 'package:flutter/material.dart';

const Color signupPrimary = Color(0xFF102C35);
const Color signupAccent = Color(0xFF18A999);
const Color signupBackground = Color(0xFFF7F7F2);

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool isPasswordVisible = false;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: signupBackground,
      body: SafeArea(
        child: SingleChildScrollView(
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
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back_rounded),
                          color: signupPrimary,
                        ),
                        const Spacer(),
                        const Text(
                          'safarivo.',
                          style: TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.bold,
                            color: signupPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 45),
                    const Text(
                      'Start your\njourney.',
                      style: TextStyle(
                        fontSize: 44,
                        height: 1.08,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -1.5,
                        color: signupPrimary,
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Create an account and discover '
                          'places worth remembering.',
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.6,
                        color: Color(0xFF778387),
                      ),
                    ),
                    const SizedBox(height: 34),
                    _buildLabel('Full name'),
                    const SizedBox(height: 10),
                    _buildField(
                      controller: nameController,
                      hint: 'Your full name',
                      icon: Icons.person_outline_rounded,
                    ),
                    const SizedBox(height: 22),
                    _buildLabel('Email address'),
                    const SizedBox(height: 10),
                    _buildField(
                      controller: emailController,
                      hint: 'Enter your email',
                      icon: Icons.mail_outline_rounded,
                    ),
                    const SizedBox(height: 22),
                    _buildLabel('Password'),
                    const SizedBox(height: 10),
                    TextField(
                      controller: passwordController,
                      obscureText: !isPasswordVisible,
                      decoration: _decoration(
                        hint: 'Create a password',
                        icon: Icons.lock_outline_rounded,
                      ).copyWith(
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
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: signupPrimary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Account creation will be connected to Firebase later.',
                              ),
                            ),
                          );
                        },
                        child: const Text(
                          'Create Account',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Center(
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        children: [
                          const Text(
                            'Already have an account? ',
                            style: TextStyle(
                              color: Color(0xFF778387),
                              fontSize: 14,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: const Text(
                              'Sign in',
                              style: TextStyle(
                                color: signupAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 25),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        color: signupPrimary,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      decoration: _decoration(hint: hint, icon: icon),
    );
  }

  InputDecoration _decoration({
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        fontSize: 14,
        color: Color(0xFFA0AAAC),
      ),
      prefixIcon: Icon(icon, color: const Color(0xFF778387)),
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
          color: signupAccent,
          width: 1.5,
        ),
      ),
    );
  }
}
