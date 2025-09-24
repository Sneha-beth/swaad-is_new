import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/order_model.dart';
import '../../utils/app_colors.dart';
import 'order_status_widget.dart';

class OrderCardWidget extends StatelessWidget {
  final OrderModel order;
  final VoidCallback? onTap;

  const OrderCardWidget({
    super.key,
    required this.order,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final vendor = order.vendor;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 1.5),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Order ID and Status
            Row(
              children: [
                Text(
                  'Order #${order.id}',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Spacer(),
                OrderStatusWidget(status: order.status),
              ],
            ),
            const SizedBox(height: 8),

            // Vendor info
            Text(
              vendor.name,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),

            const SizedBox(height: 6),

            // Order summary (number of items and total)
            Text(
              '${order.items.length} items - ₹${order.total.toStringAsFixed(0)}',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),

            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
