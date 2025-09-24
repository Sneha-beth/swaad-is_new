import 'package:intl/intl.dart';

class AppHelpers {
  static String formatCurrency(double amount) {
    return '₹${amount.toStringAsFixed(0)}';
  }

  static String formatDateTime(DateTime dateTime) {
    return DateFormat('dd MMM yyyy, hh:mm a').format(dateTime);
  }

  static String formatDate(DateTime dateTime) {
    return DateFormat('dd MMM yyyy').format(dateTime);
  }

  static String formatTime(DateTime dateTime) {
    return DateFormat('hh:mm a').format(dateTime);
  }

  static String formatMonthYear(DateTime dateTime) {
    return DateFormat('MMM yyyy').format(dateTime);
  }

  static String getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} year${(difference.inDays / 365).floor() == 1 ? '' : 's'} ago';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} month${(difference.inDays / 30).floor() == 1 ? '' : 's'} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else {
      return 'Just now';
    }
  }

  static String getOrderStatusText(dynamic status) {
    if (status is String) {
      switch (status.toLowerCase()) {
        case 'placed':
          return 'Placed';
        case 'accepted':
          return 'Accepted';
        case 'preparing':
          return 'Preparing';
        case 'ready':
          return 'Ready';
        case 'completed':
          return 'Completed';
        case 'cancelled':
          return 'Cancelled';
        default:
          return 'Unknown';
      }
    }
    // Handle enum type
    switch (status.toString().split('.').last) {
      case 'placed':
        return 'Placed';
      case 'accepted':
        return 'Accepted';
      case 'preparing':
        return 'Preparing';
      case 'ready':
        return 'Ready';
      case 'completed':
        return 'Completed';
      case 'cancelled':
        return 'Cancelled';
      default:
        return 'Unknown';
    }
  }

  static double getOrderStatusProgress(dynamic status) {
    switch (status.toString().split('.').last) {
      case 'placed':
        return 0.25;
      case 'accepted':
        return 0.5;
      case 'preparing':
        return 0.75;
      case 'ready':
        return 0.9;
      case 'completed':
        return 1.0;
      case 'cancelled':
        return 0.0;
      default:
        return 0.0;
    }
  }

  static String capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  static bool isValidPhone(String phone) {
    return RegExp(r'^\+?[\d\s-()]{10,}$').hasMatch(phone);
  }
}
