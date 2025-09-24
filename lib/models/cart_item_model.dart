import 'food_item_model.dart';

class CartItemModel {
  final String id;
  final FoodItemModel foodItem;
  final int quantity;
  final String? specialInstructions;

  CartItemModel({
    required this.id,
    required this.foodItem,
    required this.quantity,
    this.specialInstructions,
  });

  double get totalPrice => foodItem.price * quantity;

  CartItemModel copyWith({
    String? id,
    FoodItemModel? foodItem,
    int? quantity,
    String? specialInstructions,
  }) {
    return CartItemModel(
      id: id ?? this.id,
      foodItem: foodItem ?? this.foodItem,
      quantity: quantity ?? this.quantity,
      specialInstructions: specialInstructions ?? this.specialInstructions,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'foodItem': foodItem.toJson(),
      'quantity': quantity,
      'specialInstructions': specialInstructions,
    };
  }

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json['id'],
      foodItem: FoodItemModel.fromJson(json['foodItem']),
      quantity: json['quantity'],
      specialInstructions: json['specialInstructions'],
    );
  }
}
