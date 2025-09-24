// lib/screens/forgot_password_otp_screen.dart (New file)
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/app_colors.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/keyboard_widget.dart';
import 'reset_password_screen.dart';

class ForgotPasswordOTPScreen extends StatefulWidget {
  final String contact;
  final bool isEmail;

  const ForgotPasswordOTPScreen({
    super.key,
    required this.contact,
    required this.isEmail,
  });

  @override
  State<ForgotPasswordOTPScreen> createState() =>
      _ForgotPasswordOTPScreenState();
}

class _ForgotPasswordOTPScreenState extends State<ForgotPasswordOTPScreen> {
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
          'Verify Code',
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
                    'Verification code has been sent to\n${widget.contact}',
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
                        "Didn't receive code? ",
                        style: GoogleFonts.inter(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // Resend OTP logic
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Verification code sent!'),
                              backgroundColor: AppColors.primaryGreen,
                            ),
                          );
                        },
                        child: Text(
                          'Resend',
                          style: GoogleFonts.inter(
                            color: AppColors.primaryGreen,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  // Verify button
                  CustomButton(
                    text: 'Verify Code',
                    onPressed: _otpDigits.every((digit) => digit.isNotEmpty)
                        ? () => _verifyOTP()
                        : () {},
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

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    // Close loading
    Navigator.pop(context);

    // Navigate to reset password screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResetPasswordScreen(
          contact: widget.contact,
        ),
      ),
    );
  }
}
