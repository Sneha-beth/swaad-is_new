import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/app_colors.dart';

class PickupSlotWidget extends StatelessWidget {
  final DateTime slotTime;
  final bool isSelected;
  final VoidCallback? onSelect;

  const PickupSlotWidget({
    super.key,
    required this.slotTime,
    this.isSelected = false,
    this.onSelect,
  });

  String _formatTime(DateTime time) {
    final hour = time.hour;
    final minute = time.minute.toString().padLeft(2, '0');
    final suffix = hour >= 12 ? 'PM' : 'AM';
    final hourFormatted = hour % 12 == 0 ? 12 : hour % 12;
    return '$hourFormatted:$minute $suffix';
  }

  @override
  Widget build(BuildContext context) {
    final bgColor =
        isSelected ? AppColors.primaryGreen : AppColors.backgroundColor;
    final textColor = isSelected ? Colors.white : AppColors.textPrimary;

    return GestureDetector(
      onTap: onSelect,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.borderColor),
        ),
        child: Text(
          _formatTime(slotTime),
          style: GoogleFonts.inter(
            color: textColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
