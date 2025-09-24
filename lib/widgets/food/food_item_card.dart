import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/food_item_model.dart';
import '../../utils/app_colors.dart';
import '../common/rating_widget.dart';

class FoodItemCard extends StatelessWidget {
  final FoodItemModel foodItem;
  final VoidCallback? onTap;

  const FoodItemCard({
    super.key,
    required this.foodItem,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 16),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image section
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
              child: Container(
                height: 100,
                width: double.infinity,
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
            // Text info
            Padding(
              padding: const EdgeInsets.all(12),
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
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
                      RatingWidget(rating: foodItem.rating, size: 16),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
