// lib/utils/constants.dart
class AppConstants {
  // App Info
  static const String appName = 'Swaad';
  static const String appVersion = '1.0.0';

  // API Endpoints (for future use)
  static const String baseUrl = 'https://api.swaad.com';
  static const String loginEndpoint = '/auth/login';
  static const String registerEndpoint = '/auth/register';

  // Pagination
  static const int pageSize = 20;

  // Order Status Messages
  static const Map<String, String> orderStatusMessages = {
    'placed': 'Your order has been placed successfully!',
    'accepted': 'Your order has been accepted by the vendor',
    'preparing': 'Your order is being prepared',
    'ready': 'Your order is ready for pickup',
    'completed': 'Order completed successfully',
    'cancelled': 'Your order has been cancelled',
  };

  // Payment Methods
  static const List<String> paymentMethods = [
    'Wallet',
    'UPI',
    'Credit Card',
    'Debit Card',
    'Net Banking',
  ];

  // Time Slots
  static const List<String> timeSlots = [
    '9:00 AM - 9:30 AM',
    '9:30 AM - 10:00 AM',
    '10:00 AM - 10:30 AM',
    '10:30 AM - 11:00 AM',
    '11:00 AM - 11:30 AM',
    '11:30 AM - 12:00 PM',
    '12:00 PM - 12:30 PM',
    '12:30 PM - 1:00 PM',
    '1:00 PM - 1:30 PM',
    '1:30 PM - 2:00 PM',
    '2:00 PM - 2:30 PM',
    '2:30 PM - 3:00 PM',
  ];

  // Cuisine Types
  static const List<String> cuisineTypes = [
    'Indian',
    'Chinese',
    'Italian',
    'American',
    'Continental',
    'Fast Food',
    'Healthy',
    'Traditional',
  ];

  // Food Categories
  static const List<String> foodCategories = [
    'All',
    'Breakfast',
    'Lunch',
    'Dinner',
    'Snacks',
    'Beverages',
    'Desserts',
    'Pizza',
    'Burger',
    'Sandwich',
  ];
}
