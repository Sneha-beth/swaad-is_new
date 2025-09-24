import 'package:flutter/foundation.dart';
import '../models/cart_item_model.dart';
import '../models/cart_model.dart';
import '../models/food_item_model.dart';

class CartService extends ChangeNotifier {
  final List<CartItemModel> _items = [];
  String? _promoCode;
  double _discount = 0.0;

  List<CartItemModel> get items => _items;
  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);
  double get subtotal => _items.fold(0.0, (sum, item) => sum + item.totalPrice);
  String? get promoCode => _promoCode;
  double get discount => _discount;
  double get deliveryFee => 0.0; // Free delivery for now
  double get total => subtotal - discount + deliveryFee;

  void addItem(FoodItemModel foodItem, {int quantity = 1}) {
    final existingIndex =
        _items.indexWhere((item) => item.foodItem.id == foodItem.id);

    if (existingIndex >= 0) {
      // Update quantity by creating a new CartItemModel
      final existingItem = _items[existingIndex];
      _items[existingIndex] = CartItemModel(
        id: existingItem.id,
        foodItem: existingItem.foodItem,
        quantity: existingItem.quantity + quantity,
        specialInstructions: existingItem.specialInstructions,
      );
    } else {
      // Add new item
      _items.add(CartItemModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        foodItem: foodItem,
        quantity: quantity,
      ));
    }
    notifyListeners();
  }

  void removeItem(String itemId) {
    _items.removeWhere((item) => item.id == itemId);
    notifyListeners();
  }

  void updateQuantity(String itemId, int quantity) {
    if (quantity <= 0) {
      removeItem(itemId);
      return;
    }

    final index = _items.indexWhere((item) => item.id == itemId);
    if (index >= 0) {
      final existingItem = _items[index];
      _items[index] = CartItemModel(
        id: existingItem.id,
        foodItem: existingItem.foodItem,
        quantity: quantity,
        specialInstructions: existingItem.specialInstructions,
      );
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    _promoCode = null;
    _discount = 0.0;
    notifyListeners();
  }

  void applyPromoCode(String code, double discountAmount) {
    _promoCode = code;
    _discount = discountAmount;
    notifyListeners();
  }

  void removePromoCode() {
    _promoCode = null;
    _discount = 0.0;
    notifyListeners();
  }

  bool get isEmpty => _items.isEmpty;
  bool get isNotEmpty => _items.isNotEmpty;

  CartModel getCart() {
    return CartModel(
      items: _items,
      subtotal: subtotal,
      discount: discount,
      deliveryFee: deliveryFee,
      total: total,
      promoCode: promoCode,
    );
  }
}
