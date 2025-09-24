import 'vendor_model.dart';
import 'cart_item_model.dart';

enum OrderStatus {
  placed,
  accepted,
  preparing,
  ready,
  completed,
  cancelled,
}

class OrderModel {
  final String id;
  final String customerId;
  final String customerName;
  final String customerPhone;
  final VendorModel vendor;
  final List<CartItemModel> items;
  final OrderStatus status;
  final double subtotal;
  final double discount;
  final double deliveryFee;
  final double total;
  final String paymentMethod;
  final DateTime createdAt;
  final DateTime? estimatedPickupTime;
  final String? promoCode;
  final String? specialInstructions;

  OrderModel({
    required this.id,
    required this.customerId,
    required this.customerName,
    required this.customerPhone,
    required this.vendor,
    required this.items,
    required this.status,
    required this.subtotal,
    required this.discount,
    required this.deliveryFee,
    required this.total,
    required this.paymentMethod,
    required this.createdAt,
    this.estimatedPickupTime,
    this.promoCode,
    this.specialInstructions,
  });

  OrderModel copyWith({
    String? id,
    String? customerId,
    String? customerName,
    String? customerPhone,
    VendorModel? vendor,
    List<CartItemModel>? items,
    OrderStatus? status,
    double? subtotal,
    double? discount,
    double? deliveryFee,
    double? total,
    String? paymentMethod,
    DateTime? createdAt,
    DateTime? estimatedPickupTime,
    String? promoCode,
    String? specialInstructions,
  }) {
    return OrderModel(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      vendor: vendor ?? this.vendor,
      items: items ?? this.items,
      status: status ?? this.status,
      subtotal: subtotal ?? this.subtotal,
      discount: discount ?? this.discount,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      total: total ?? this.total,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      createdAt: createdAt ?? this.createdAt,
      estimatedPickupTime: estimatedPickupTime ?? this.estimatedPickupTime,
      promoCode: promoCode ?? this.promoCode,
      specialInstructions: specialInstructions ?? this.specialInstructions,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerId': customerId,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'vendor': vendor.toJson(),
      'items': items.map((item) => item.toJson()).toList(),
      'status': status.toString(),
      'subtotal': subtotal,
      'discount': discount,
      'deliveryFee': deliveryFee,
      'total': total,
      'paymentMethod': paymentMethod,
      'createdAt': createdAt.toIso8601String(),
      'estimatedPickupTime': estimatedPickupTime?.toIso8601String(),
      'promoCode': promoCode,
      'specialInstructions': specialInstructions,
    };
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      customerId: json['customerId'],
      customerName: json['customerName'],
      customerPhone: json['customerPhone'],
      vendor: VendorModel.fromJson(json['vendor']),
      items: (json['items'] as List)
          .map((item) => CartItemModel.fromJson(item))
          .toList(),
      status: OrderStatus.values.firstWhere(
        (e) => e.toString() == json['status'],
      ),
      subtotal: json['subtotal'].toDouble(),
      discount: json['discount'].toDouble(),
      deliveryFee: json['deliveryFee'].toDouble(),
      total: json['total'].toDouble(),
      paymentMethod: json['paymentMethod'],
      createdAt: DateTime.parse(json['createdAt']),
      estimatedPickupTime: json['estimatedPickupTime'] != null
          ? DateTime.parse(json['estimatedPickupTime'])
          : null,
      promoCode: json['promoCode'],
      specialInstructions: json['specialInstructions'],
    );
  }
}
