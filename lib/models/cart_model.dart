import 'cart_item_model.dart';

class CartModel {
  final List<CartItemModel> items;
  final double subtotal;
  final double discount;
  final double deliveryFee;
  final double total;
  final String? promoCode;

  CartModel({
    required this.items,
    required this.subtotal,
    this.discount = 0.0,
    this.deliveryFee = 0.0,
    required this.total,
    this.promoCode,
  });

  CartModel copyWith({
    List<CartItemModel>? items,
    double? subtotal,
    double? discount,
    double? deliveryFee,
    double? total,
    String? promoCode,
  }) {
    return CartModel(
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      discount: discount ?? this.discount,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      total: total ?? this.total,
      promoCode: promoCode ?? this.promoCode,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((item) => item.toJson()).toList(),
      'subtotal': subtotal,
      'discount': discount,
      'deliveryFee': deliveryFee,
      'total': total,
      'promoCode': promoCode,
    };
  }

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      items: (json['items'] as List)
          .map((item) => CartItemModel.fromJson(item))
          .toList(),
      subtotal: json['subtotal'].toDouble(),
      discount: json['discount'].toDouble(),
      deliveryFee: json['deliveryFee'].toDouble(),
      total: json['total'].toDouble(),
      promoCode: json['promoCode'],
    );
  }
}
