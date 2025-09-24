// lib/widgets/onboarding_card.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/app_colors.dart';
import '../../screens/onboarding_screen.dart';

class OnboardingCard extends StatelessWidget {
  final OnboardingData data;

  const OnboardingCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Illustration container
          Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              color: AppColors.primaryGreen.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(140),
            ),
            child: Center(
              child: Image.asset(data.image, width: 180, height: 180),
            ),
          ),
          const SizedBox(height: 48),
          // Title
          Text(
            data.title,
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          // Subtitle
          Text(
            data.subtitle,
            style: GoogleFonts.inter(
              fontSize: 16,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
