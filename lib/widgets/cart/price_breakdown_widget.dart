import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/app_colors.dart';

class PriceBreakdownWidget extends StatelessWidget {
  final double subtotal;
  final double discount;
  final double deliveryFee;
  final double total;

  const PriceBreakdownWidget({
    super.key,
    required this.subtotal,
    this.discount = 0,
    this.deliveryFee = 0,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    TextStyle labelStyle = GoogleFonts.inter(
      fontSize: 14,
      color: AppColors.textSecondary,
    );

    TextStyle valueStyle = GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
    );

    TextStyle totalStyle = GoogleFonts.inter(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: AppColors.primaryGreen,
    );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        children: [
          _buildRow('Subtotal', subtotal, labelStyle, valueStyle),
          const SizedBox(height: 8),
          _buildRow('Discount', -discount, labelStyle, valueStyle),
          const SizedBox(height: 8),
          _buildRow('Delivery Fee', deliveryFee, labelStyle, valueStyle),
          const Divider(color: AppColors.borderColor, height: 32, thickness: 1),
          _buildRow('Total', total, labelStyle, totalStyle),
        ],
      ),
    );
  }

  Widget _buildRow(
      String label, double amount, TextStyle labelStyle, TextStyle valueStyle) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: labelStyle),
        Text('₹${amount.toStringAsFixed(0)}', style: valueStyle),
      ],
    );
  }
}
