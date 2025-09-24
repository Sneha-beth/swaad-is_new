import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/app_colors.dart';

class KeyboardWidget extends StatelessWidget {
  final Function(String) onNumberPressed;
  final VoidCallback onBackspacePressed;

  const KeyboardWidget({
    super.key,
    required this.onNumberPressed,
    required this.onBackspacePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // First row: 1, 2, 3
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildKeyButton('1'),
              _buildKeyButton('2'),
              _buildKeyButton('3'),
            ],
          ),
          const SizedBox(height: 16),
          // Second row: 4, 5, 6
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildKeyButton('4'),
              _buildKeyButton('5'),
              _buildKeyButton('6'),
            ],
          ),
          const SizedBox(height: 16),
          // Third row: 7, 8, 9
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildKeyButton('7'),
              _buildKeyButton('8'),
              _buildKeyButton('9'),
            ],
          ),
          const SizedBox(height: 16),
          // Fourth row: empty, 0, backspace
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(width: 80), // Empty space
              _buildKeyButton('0'),
              _buildBackspaceButton(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKeyButton(String number) {
    return GestureDetector(
      onTap: () => onNumberPressed(number),
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: AppColors.backgroundColor,
          borderRadius: BorderRadius.circular(40),
          border: Border.all(color: AppColors.borderColor),
        ),
        child: Center(
          child: Text(
            number,
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackspaceButton() {
    return GestureDetector(
      onTap: onBackspacePressed,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: AppColors.backgroundColor,
          borderRadius: BorderRadius.circular(40),
          border: Border.all(color: AppColors.borderColor),
        ),
        child: const Center(
          child: Icon(
            Icons.backspace,
            size: 24,
            color: AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}
