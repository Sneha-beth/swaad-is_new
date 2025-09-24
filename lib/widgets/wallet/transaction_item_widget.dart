import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/app_colors.dart';

class TransactionItemWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final double amount;
  final DateTime date;
  final bool isCredit;

  const TransactionItemWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.date,
    this.isCredit = true,
  });

  String get formattedDate {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final amountColor = isCredit ? Colors.green : Colors.red;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.borderColor)),
      ),
      child: Row(
        children: [
          Icon(
            isCredit ? Icons.arrow_downward : Icons.arrow_upward,
            color: amountColor,
            size: 28,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Text(
            '${isCredit ? '+' : '-'}₹${amount.toStringAsFixed(0)}',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: amountColor,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            formattedDate,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
