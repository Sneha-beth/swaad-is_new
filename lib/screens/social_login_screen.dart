// lib/screens/social_login_screen.dart (New)
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_colors.dart';
import '../widgets/custom_button.dart';
import '../widgets/social_login_button.dart';
import 'create_account_screen.dart';
import 'login_screen.dart';

class SocialLoginScreen extends StatelessWidget {
  const SocialLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Illustration
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Center(
                child: Image.asset(
                  'assets/images/social_login_illustration.png',
                  width: 150,
                  height: 150,
                ),
              ),
            ),
            const SizedBox(height: 40),
            // Title
            Text(
              "Let's you in",
              style: GoogleFonts.inter(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 40),
            // Social login buttons
            SocialLoginButton(
              icon: 'assets/images/facebook_icon.png',
              text: 'Continue with Facebook',
              onPressed: () {
                // Handle Facebook login
                _handleSocialLogin(context, 'Facebook');
              },
            ),
            const SizedBox(height: 16),
            SocialLoginButton(
              icon: 'assets/images/google_icon.png',
              text: 'Continue with Google',
              onPressed: () {
                // Handle Google login
                _handleSocialLogin(context, 'Google');
              },
            ),
            const SizedBox(height: 16),
            SocialLoginButton(
              icon: 'assets/images/apple_icon.png',
              text: 'Continue with Apple',
              onPressed: () {
                // Handle Apple login
                _handleSocialLogin(context, 'Apple');
              },
            ),
            const SizedBox(height: 32),
            // Or divider
            Row(
              children: [
                const Expanded(child: Divider(color: AppColors.borderColor)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'or',
                    style: GoogleFonts.inter(
                      color: AppColors.textSecondary,
                      fontSize: 16,
                    ),
                  ),
                ),
                const Expanded(child: Divider(color: AppColors.borderColor)),
              ],
            ),
            const SizedBox(height: 32),
            // Sign in with phone button
            CustomButton(
              text: 'Sign in with Phone Number',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
              },
            ),
            const Spacer(),
            // Sign up link
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have an account? ",
                  style: GoogleFonts.inter(
                    color: AppColors.textSecondary,
                    fontSize: 16,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CreateAccountScreen(),
                      ),
                    );
                  },
                  child: Text(
                    'Sign up',
                    style: GoogleFonts.inter(
                      color: AppColors.primaryGreen,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _handleSocialLogin(BuildContext context, String provider) {
    // Show loading and simulate social login
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: AppColors.primaryGreen),
      ),
    );

    // Simulate API call
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context); // Close loading
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$provider login successful!'),
          backgroundColor: AppColors.primaryGreen,
        ),
      );
      // Navigate to home or next screen
    });
  }
}
