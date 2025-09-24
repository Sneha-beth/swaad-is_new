// lib/screens/welcome_screen.dart (Updated - Fix deprecated withOpacity)
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/common/custom_button.dart';
import 'onboarding_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/welcome_pizza.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Dark overlay for better text readability
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black.withValues(
                alpha: 0.4), // ← FIX: Use withValues instead of withOpacity
          ),
          // Content overlay
          Positioned(
            left: 24,
            right: 24,
            bottom: 120,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black
                            .withValues(alpha: 0.1), // ← FIX: Use withValues
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: 60,
                      height: 60,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Main heading
                Text(
                  'Welcome to\nFoodu',
                  style: GoogleFonts.inter(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 16),
                // Subtitle
                Text(
                  'Your favourite foods delivered\nfast at your door.',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    color: Colors.white
                        .withValues(alpha: 0.9), // ← FIX: Use withValues
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          // Bottom buttons
          Positioned(
            left: 24,
            right: 24,
            bottom: 48,
            child: CustomButton(
              text: 'Get Started',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const OnboardingScreen(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
