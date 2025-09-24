import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../utils/app_colors.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/keyboard_widget.dart';
import '../../services/auth_service.dart';
import '../main_navigation_screen.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String phoneNumber;
  final bool isSignUp;
  final bool rememberMe;

  const OTPVerificationScreen({
    super.key,
    required this.phoneNumber,
    this.isSignUp = false,
    this.rememberMe = false,
  });

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final List<String> _otpDigits = ['', '', '', ''];
  int _currentIndex = 0;

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
        title: Text(
          'OTP Code Verification',
          style: GoogleFonts.inter(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  // Instruction text
                  Text(
                    'Code has been sent to ${widget.phoneNumber}',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  // OTP input fields
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                      4,
                      (index) => _buildOTPField(index),
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Resend code
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Resend code in ",
                        style: GoogleFonts.inter(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Text(
                        "55 s",
                        style: GoogleFonts.inter(
                          color: AppColors.primaryGreen,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  // Verify button
                  CustomButton(
                    text: 'Verify',
                    onPressed: _otpDigits.every((digit) => digit.isNotEmpty)
                        ? () => _verifyOTP()
                        : null,
                  ),
                ],
              ),
            ),
          ),
          // Custom keyboard
          KeyboardWidget(
            onNumberPressed: _onNumberPressed,
            onBackspacePressed: _onBackspacePressed,
          ),
        ],
      ),
    );
  }

  Widget _buildOTPField(int index) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: _otpDigits[index].isNotEmpty
            ? AppColors.primaryGreen.withValues(alpha: 0.1)
            : AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _currentIndex == index
              ? AppColors.primaryGreen
              : Colors.transparent,
          width: 2,
        ),
      ),
      child: Center(
        child: Text(
          _otpDigits[index],
          style: GoogleFonts.inter(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ),
    );
  }

  void _onNumberPressed(String number) {
    if (_currentIndex < 4) {
      setState(() {
        _otpDigits[_currentIndex] = number;
        if (_currentIndex < 3) {
          _currentIndex++;
        }
      });
    }
  }

  void _onBackspacePressed() {
    if (_currentIndex >= 0) {
      setState(() {
        if (_otpDigits[_currentIndex].isEmpty && _currentIndex > 0) {
          _currentIndex--;
        }
        _otpDigits[_currentIndex] = '';
      });
    }
  }

  void _verifyOTP() async {
    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: AppColors.primaryGreen),
      ),
    );

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Complete authentication using instance method through provider
      final authService = Provider.of<AuthService>(context, listen: false);

      // Complete onboarding (static method)
      await AuthService.completeOnboarding();

      // Login with phone (instance method)
      final success = await authService.loginWithPhone(
          widget.phoneNumber, _otpDigits.join(''));

      // Close loading
      if (mounted) Navigator.pop(context);

      if (success) {
        // Navigate to main navigation screen
        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => const MainNavigationScreen()),
            (route) => false,
          );
        }
      } else {
        // Show error
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Invalid OTP. Please try again.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      // Close loading if still showing
      if (mounted) Navigator.pop(context);

      // Show error
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Verification failed. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
