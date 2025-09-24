// lib/widgets/phone_input_field.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/app_colors.dart';

class PhoneInputField extends StatelessWidget {
  final TextEditingController controller;

  const PhoneInputField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Country code section
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 24,
                  height: 18,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: Colors.orange,
                  ),
                  child: const Center(
                    child: Text('🇮🇳', style: TextStyle(fontSize: 12)),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '+91',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_down,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
          // Vertical divider
          Container(width: 1, height: 24, color: AppColors.borderColor),
          // Phone number input
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              maxLength: 10, // ← Limit to 10 digits
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly, // ← Only allow digits
              ],
              style: GoogleFonts.inter(fontSize: 16),
              decoration: InputDecoration(
                hintText: 'Phone Number (10 digits)',
                hintStyle: GoogleFonts.inter(
                  color: AppColors.textSecondary,
                  fontSize: 16,
                ),
                border: InputBorder.none,
                counterText: '', // Hide character counter
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
