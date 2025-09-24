import 'package:flutter/foundation.dart';
import '../models/cart_model.dart';
import '../models/order_model.dart';
import '../models/vendor_model.dart';
import '../services/vendor_service.dart';

class OrderService extends ChangeNotifier {
  static final List<OrderModel> _orders = [];

  static List<OrderModel> get orders => _orders;

  static Future<String> placeOrder(
      CartModel cart, VendorModel vendor, String paymentMethod) async {
    await Future.delayed(const Duration(seconds: 2));

    final orderId = 'SW${DateTime.now().millisecondsSinceEpoch}';
    final newOrder = OrderModel(
      id: orderId,
      customerId: 'current_user', // Changed from userId
      customerName: 'John Doe',
      customerPhone: '+91 98765 43210',
      vendor: vendor,
      items: cart.items,
      status: OrderStatus.placed,
      subtotal: cart.subtotal,
      discount: cart.discount,
      deliveryFee: cart.deliveryFee,
      total: cart.total,
      paymentMethod: paymentMethod,
      createdAt: DateTime.now(),
      estimatedPickupTime: DateTime.now().add(
        Duration(minutes: vendor.preparationTime + 5),
      ),
      promoCode: cart.promoCode,
    );

    _orders.insert(0, newOrder);
    return orderId;
  }

  static Future<void> updateOrderStatus(
      String orderId, OrderStatus status) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final orderIndex = _orders.indexWhere((order) => order.id == orderId);
    if (orderIndex != -1) {
      final oldOrder = _orders[orderIndex];
      _orders[orderIndex] = oldOrder.copyWith(status: status);
    }
  }

  static OrderModel? getOrderById(String orderId) {
    try {
      return _orders.firstWhere((order) => order.id == orderId);
    } catch (e) {
      return null;
    }
  }

  static List<OrderModel> getOrdersByStatus(OrderStatus status) {
    return _orders.where((order) => order.status == status).toList();
  }

  static List<OrderModel> getOrderHistory() {
    return _orders;
  }

  static Future<String> reorderItems(String originalOrderId) async {
    final originalOrder = getOrderById(originalOrderId);
    if (originalOrder == null) {
      throw Exception('Original order not found');
    }

    await Future.delayed(const Duration(seconds: 1));

    final newOrderId = 'SW${DateTime.now().millisecondsSinceEpoch}';
    final newOrder = OrderModel(
      id: newOrderId,
      customerId: originalOrder.customerId,
      customerName: originalOrder.customerName,
      customerPhone: originalOrder.customerPhone,
      vendor: originalOrder.vendor,
      items: originalOrder.items,
      status: OrderStatus.placed,
      subtotal: originalOrder.subtotal,
      discount: 0.0,
      deliveryFee: originalOrder.deliveryFee,
      total: originalOrder.subtotal + originalOrder.deliveryFee,
      paymentMethod: originalOrder.paymentMethod,
      createdAt: DateTime.now(),
      estimatedPickupTime: DateTime.now().add(
        Duration(minutes: originalOrder.vendor.preparationTime + 5),
      ),
    );

    _orders.insert(0, newOrder);
    return newOrderId;
  }

  static Future<String> reorder(OrderModel order) async {
    await Future.delayed(const Duration(seconds: 1));

    final newOrderId = 'SW${DateTime.now().millisecondsSinceEpoch}';
    final newOrder = OrderModel(
      id: newOrderId,
      customerId: 'current_user', // Changed from userId
      customerName: order.customerName,
      customerPhone: order.customerPhone,
      vendor: VendorService.getDummyVendors().first,
      items: order.items,
      status: OrderStatus.placed,
      subtotal: order.subtotal,
      discount: 0.0,
      deliveryFee: order.deliveryFee,
      total: order.subtotal + order.deliveryFee,
      paymentMethod: order.paymentMethod,
      createdAt: DateTime.now(),
      estimatedPickupTime: DateTime.now().add(
        Duration(minutes: order.vendor.preparationTime + 5),
      ),
    );

    _orders.insert(0, newOrder);
    return newOrderId;
  }

  static void initializeDummyOrders() {
    if (_orders.isNotEmpty) return;

    final dummyOrder = OrderModel(
      id: 'SW1001',
      customerId: 'current_user', // Changed from userId
      customerName: 'John Doe',
      customerPhone: '+91 98765 43210',
      vendor: VendorService.getDummyVendors().first,
      items: [],
      status: OrderStatus.completed,
      subtotal: 299.0,
      discount: 0.0,
      deliveryFee: 0.0,
      total: 299.0,
      paymentMethod: 'Wallet',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    );

    _orders.add(dummyOrder);
  }
}
