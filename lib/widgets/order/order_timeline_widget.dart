import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/order_model.dart';
import '../../utils/app_colors.dart';

class OrderTimelineWidget extends StatelessWidget {
  final OrderStatus currentStatus;

  const OrderTimelineWidget({super.key, required this.currentStatus});

  // Helper to get the progress index for each status
  int _statusIndex(OrderStatus status) {
    switch (status) {
      case OrderStatus.placed:
        return 0;
      case OrderStatus.accepted:
        return 1;
      case OrderStatus.preparing:
        return 2;
      case OrderStatus.ready:
        return 3;
      case OrderStatus.completed:
        return 4;
      case OrderStatus.cancelled:
        return -1; // No timeline
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalSteps = 5;
    final currentStep = _statusIndex(currentStatus);

    if (currentStep == -1) {
      return Center(
        child: Text(
          'Order was cancelled',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            color: AppColors.errorRed,
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: Row(
        children: List.generate(totalSteps, (index) {
          bool isCompleted = index <= currentStep;
          String label;

          switch (index) {
            case 0:
              label = 'Placed';
              break;
            case 1:
              label = 'Accepted';
              break;
            case 2:
              label = 'Preparing';
              break;
            case 3:
              label = 'Ready';
              break;
            case 4:
              label = 'Completed';
              break;
            default:
              label = '';
          }

          return Expanded(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor: isCompleted
                      ? AppColors.primaryGreen
                      : AppColors.borderColor,
                  child: Icon(
                    isCompleted ? Icons.check : Icons.radio_button_unchecked,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: isCompleted
                        ? AppColors.primaryGreen
                        : AppColors.textSecondary,
                    fontWeight:
                        isCompleted ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                if (index < totalSteps - 1)
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(top: 14),
                      height: 3,
                      color: (index < currentStep)
                          ? AppColors.primaryGreen
                          : AppColors.borderColor,
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
