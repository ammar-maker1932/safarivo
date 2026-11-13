
import 'package:flutter/material.dart';
import 'screens/auth/login_screen.dart';

void main() {
  runApp(const SafarivoApp());
}

class SafarivoApp extends StatelessWidget {
  const SafarivoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Safarivo',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF18A999),
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F7F4),
      ),
      home: const WelcomeScreen(),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 700;

            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 1100,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: isWide
                      ? _buildWideLayout(context)
                      : _buildMobileLayout(context),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLogo(),
        const Spacer(),
        _buildTravelIllustration(),
        const SizedBox(height: 35),
        _buildWelcomeText(),
        const SizedBox(height: 28),
        _buildGetStartedButton(context),
        const SizedBox(height: 16),
        const Center(
          child: Text(
            'Discover. Explore. Experience.',
            style: TextStyle(color: Colors.grey),
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget _buildWideLayout(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLogo(),
              const Spacer(),
              _buildWelcomeText(),
              const SizedBox(height: 30),
              _buildGetStartedButton(context),
              const Spacer(),
            ],
          ),
        ),
        const SizedBox(width: 35),
        const Expanded(
          child: _TravelIllustration(),
        ),
      ],
    );
  }

  Widget _buildLogo() {
    return const Row(
      children: [
        Icon(
          Icons.explore,
          color: Color(0xFF18A999),
          size: 32,
        ),
        SizedBox(width: 8),
        Text(
          'safarivo.',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Color(0xFF102C35),
          ),
        ),
      ],
    );
  }

  Widget _buildTravelIllustration() {
    return const _TravelIllustration();
  }

  Widget _buildWelcomeText() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your next journey\nstarts here.',
          style: TextStyle(
            fontSize: 38,
            height: 1.15,
            fontWeight: FontWeight.bold,
            color: Color(0xFF102C35),
          ),
        ),
        SizedBox(height: 16),
        Text(
          'Explore beautiful destinations, discover amazing '
              'tour packages and create unforgettable memories.',
          style: TextStyle(
            fontSize: 16,
            height: 1.6,
            color: Color(0xFF66777A),
          ),
        ),
      ],
    );
  }

  Widget _buildGetStartedButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,

      child: FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: const Color(0xFF18A999),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),

        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            ),
          );
        },

        child: const Text(
          'Get Started',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

    );
  }
}

class _TravelIllustration extends StatelessWidget {
  const _TravelIllustration();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFB9E7DF),
            Color(0xFF18A999),
            Color(0xFF102C35),
          ],
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 25,
            right: 30,
            child: Icon(
              Icons.wb_sunny_rounded,
              color: Colors.white.withValues(alpha: 0.85),
              size: 55,
            ),
          ),
          const Icon(
            Icons.landscape_rounded,
            size: 175,
            color: Colors.white,
          ),
          const Positioned(
            bottom: 30,
            child: Text(
              'EXPLORE THE WORLD',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 3,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}