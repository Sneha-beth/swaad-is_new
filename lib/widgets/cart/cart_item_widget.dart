import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/cart_item_model.dart';
import '../../utils/app_colors.dart';
import 'quantity_selector_widget.dart';

class CartItemWidget extends StatelessWidget {
  final CartItemModel cartItem;
  final VoidCallback? onRemove;
  final ValueChanged<int>? onQuantityChanged;

  const CartItemWidget({
    super.key,
    required this.cartItem,
    this.onRemove,
    this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    final foodItem = cartItem.foodItem;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Food image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.backgroundColor,
                image: DecorationImage(
                  image: AssetImage(foodItem.image),
                  fit: BoxFit.cover,
                  onError: (exception, stackTrace) {},
                ),
              ),
              child: foodItem.image.startsWith('assets')
                  ? null
                  : Container(
                      color: AppColors.primaryGreen.withValues(alpha: 0.1),
                      child: const Icon(
                        Icons.fastfood,
                        color: AppColors.primaryGreen,
                        size: 40,
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 16),

          // Food details and quantity selector
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  foodItem.name,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  foodItem.description,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color:
                            foodItem.isVegetarian ? Colors.green : Colors.red,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '₹${foodItem.price.toStringAsFixed(0)}',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryGreen,
                      ),
                    ),
                    const Spacer(),
                    QuantitySelectorWidget(
                      quantity: cartItem.quantity,
                      onChanged: onQuantityChanged,
                    ),
                  ],
                ),
              ],
            ),
          ),

          IconButton(
            onPressed: onRemove,
            icon: const Icon(Icons.delete, color: Colors.red),
          ),
        ],
      ),
    );
  }
}
