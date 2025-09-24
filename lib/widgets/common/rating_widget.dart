import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

class RatingWidget extends StatelessWidget {
  final double rating;
  final int maxRating;
  final double size;
  final bool allowHalfStars;

  const RatingWidget({
    super.key,
    required this.rating,
    this.maxRating = 5,
    this.size = 20,
    this.allowHalfStars = true,
  });

  @override
  Widget build(BuildContext context) {
    int fullStars = rating.floor();
    bool hasHalfStar = allowHalfStars && (rating - fullStars) >= 0.5;
    int emptyStars = maxRating - fullStars - (hasHalfStar ? 1 : 0);

    List<Widget> stars = [];

    for (int i = 0; i < fullStars; i++) {
      stars.add(Icon(Icons.star, color: AppColors.starYellow, size: size));
    }

    if (hasHalfStar) {
      stars.add(Icon(Icons.star_half, color: AppColors.starYellow, size: size));
    }

    for (int i = 0; i < emptyStars; i++) {
      stars.add(Icon(Icons.star_border, color: AppColors.starGrey, size: size));
    }

    return Row(children: stars);
  }
}
