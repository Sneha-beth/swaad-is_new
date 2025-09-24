import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/app_colors.dart';

class QuantitySelectorWidget extends StatelessWidget {
  final int quantity;
  final ValueChanged<int>? onChanged;
  final int minQuantity;
  final int maxQuantity;

  const QuantitySelectorWidget({
    super.key,
    required this.quantity,
    this.onChanged,
    this.minQuantity = 1,
    this.maxQuantity = 99,
  });

  void _increment() {
    if (onChanged != null && quantity < maxQuantity) {
      onChanged!(quantity + 1);
    }
  }

  void _decrement() {
    if (onChanged != null && quantity > minQuantity) {
      onChanged!(quantity - 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Row(
        children: [
          IconButton(
            splashRadius: 20,
            iconSize: 20,
            padding: EdgeInsets.zero,
            onPressed: _decrement,
            icon: const Icon(Icons.remove, color: AppColors.primaryGreen),
          ),
          Text(
            quantity.toString(),
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          IconButton(
            splashRadius: 20,
            iconSize: 20,
            padding: EdgeInsets.zero,
            onPressed: _increment,
            icon: const Icon(Icons.add, color: AppColors.primaryGreen),
          ),
        ],
      ),
    );
  }
}
