import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/app_colors.dart';
import '../../models/order_model.dart';

class OrderStatusWidget extends StatelessWidget {
  final OrderStatus status;

  const OrderStatusWidget({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;
    String statusText;

    switch (status) {
      case OrderStatus.placed:
        bgColor = Colors.orange.shade100;
        textColor = Colors.orange;
        statusText = 'PLACED';
        break;
      case OrderStatus.accepted:
        bgColor = Colors.blue.shade100;
        textColor = Colors.blue;
        statusText = 'ACCEPTED';
        break;
      case OrderStatus.preparing:
        bgColor = Colors.blue.shade200;
        textColor = Colors.blue.shade800;
        statusText = 'PREPARING';
        break;
      case OrderStatus.ready:
        bgColor = Colors.green.shade100;
        textColor = Colors.green;
        statusText = 'READY';
        break;
      case OrderStatus.completed:
        bgColor = Colors.green.shade200;
        textColor = Colors.green.shade800;
        statusText = 'COMPLETED';
        break;
      case OrderStatus.cancelled:
        bgColor = Colors.red.shade100;
        textColor = Colors.red;
        statusText = 'CANCELLED';
        break;
      default:
        bgColor = Colors.grey.shade200;
        textColor = Colors.grey;
        statusText = 'UNKNOWN';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        statusText,
        style: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }
}
