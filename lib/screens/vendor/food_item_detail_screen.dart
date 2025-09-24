import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../utils/app_colors.dart';
import '../../utils/helpers.dart';
import '../../models/food_item_model.dart';
import '../../models/vendor_model.dart';
import '../../services/cart_service.dart';
import '../../widgets/common/custom_button.dart';

class FoodItemDetailScreen extends StatefulWidget {
  final FoodItemModel foodItem;
  final VendorModel vendor;

  const FoodItemDetailScreen({
    super.key,
    required this.foodItem,
    required this.vendor,
  });

  @override
  State<FoodItemDetailScreen> createState() => _FoodItemDetailScreenState();
}

class _FoodItemDetailScreenState extends State<FoodItemDetailScreen> {
  int _quantity = 1;
  String _selectedSize = 'Regular';
  final List<String> _sizes = ['Regular', 'Large', 'Extra Large'];
  final Map<String, double> _sizePrices = {
    'Regular': 0.0,
    'Large': 50.0,
    'Extra Large': 100.0,
  };

  final TextEditingController _instructionsController = TextEditingController();

  // Dummy reviews data
  final List<Map<String, dynamic>> _reviews = [
    {
      'name': 'Priya Sharma',
      'rating': 5.0,
      'comment': 'Absolutely delicious! Best pizza I\'ve had on campus.',
      'date': '2 days ago',
      'avatar': 'PS'
    },
    {
      'name': 'Raj Patel',
      'rating': 4.0,
      'comment':
          'Good taste but took a bit long to prepare. Overall satisfied.',
      'date': '1 week ago',
      'avatar': 'RP'
    },
    {
      'name': 'Anita Singh',
      'rating': 5.0,
      'comment': 'Perfect! Will definitely order again.',
      'date': '2 weeks ago',
      'avatar': 'AS'
    },
  ];

  double get _totalPrice =>
      (widget.foodItem.price + (_sizePrices[_selectedSize] ?? 0.0)) * _quantity;

  @override
  void dispose() {
    _instructionsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // App Bar with Food Image
          _buildSliverAppBar(),

          // Food Details
          SliverToBoxAdapter(
            child: Column(
              children: [
                _buildFoodInfo(),
                _buildSizeSelection(),
                _buildQuantitySelector(),
                _buildSpecialInstructions(),
                _buildNutritionalInfo(),
                _buildReviews(),
                const SizedBox(height: 100), // Space for bottom button
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: IconButton(
            icon: const Icon(Icons.favorite_border, color: Colors.white),
            onPressed: () => _toggleFavorite(),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              widget.foodItem.image,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: AppColors.primaryGreen.withValues(alpha: 0.1),
                  child: const Icon(
                    Icons.fastfood,
                    color: AppColors.primaryGreen,
                    size: 80,
                  ),
                );
              },
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.7),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (widget.foodItem.isVegetarian)
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Icon(
                            Icons.circle,
                            color: Colors.white,
                            size: 12,
                          ),
                        )
                      else
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Icon(
                            Icons.crop_square,
                            color: Colors.white,
                            size: 12,
                          ),
                        ),
                      const Spacer(),
                      if (widget.foodItem.rating > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.white,
                                size: 14,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                widget.foodItem.rating.toString(),
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.foodItem.name,
                    style: GoogleFonts.inter(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFoodInfo() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                widget.vendor.name,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: AppColors.primaryGreen,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                AppHelpers.formatCurrency(widget.foodItem.price),
                style: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryGreen,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            widget.foodItem.description,
            style: GoogleFonts.inter(
              fontSize: 16,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          if (widget.foodItem.tags.isNotEmpty) ...[
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: widget.foodItem.tags.map((tag) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    tag,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppColors.primaryGreen,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
          ],
          Row(
            children: [
              _buildInfoChip(
                icon: Icons.access_time,
                text: '${widget.vendor.preparationTime} min',
              ),
              const SizedBox(width: 12),
              _buildInfoChip(
                icon: Icons.local_fire_department,
                text: widget.foodItem.isVegetarian ? 'Vegetarian' : 'Non-Veg',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip({required IconData icon, required String text}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.textSecondary),
          const SizedBox(width: 6),
          Text(
            text,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSizeSelection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Size',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: _sizes.map((size) {
              final isSelected = _selectedSize == size;
              final additionalPrice = _sizePrices[size] ?? 0.0;

              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedSize = size;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primaryGreen : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primaryGreen
                            : AppColors.borderColor,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          size,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? Colors.white
                                : AppColors.textPrimary,
                          ),
                        ),
                        if (additionalPrice > 0)
                          Text(
                            '+${AppHelpers.formatCurrency(additionalPrice)}',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: isSelected
                                  ? Colors.white.withValues(alpha: 0.8)
                                  : AppColors.textSecondary,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantitySelector() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quantity',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  if (_quantity > 1) {
                    setState(() {
                      _quantity--;
                    });
                  }
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _quantity > 1
                        ? AppColors.primaryGreen
                        : AppColors.backgroundColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.remove,
                    color:
                        _quantity > 1 ? Colors.white : AppColors.textSecondary,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Text(
                _quantity.toString(),
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(width: 20),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _quantity++;
                  });
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                'Total: ${AppHelpers.formatCurrency(_totalPrice)}',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryGreen,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSpecialInstructions() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Special Instructions (Optional)',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _instructionsController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Any special requests? (e.g., extra spicy, no onions)',
              hintStyle: GoogleFonts.inter(color: AppColors.textSecondary),
              filled: true,
              fillColor: AppColors.backgroundColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.primaryGreen),
              ),
            ),
            style: GoogleFonts.inter(fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionalInfo() {
    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Nutritional Information (approx.)',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildNutritionItem('Calories', '450')),
              Expanded(child: _buildNutritionItem('Protein', '18g')),
              Expanded(child: _buildNutritionItem('Carbs', '42g')),
              Expanded(child: _buildNutritionItem('Fat', '22g')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildReviews() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Reviews',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star, color: Colors.green, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      widget.foodItem.rating.toString(),
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () => _showAllReviews(),
                child: Text(
                  'View All',
                  style: GoogleFonts.inter(
                    color: AppColors.primaryGreen,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ..._reviews
              .take(2)
              .map((review) => _buildReviewItem(review))
              .toList(),
        ],
      ),
    );
  }

  Widget _buildReviewItem(Map<String, dynamic> review) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.primaryGreen,
                radius: 16,
                child: Text(
                  review['avatar'],
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review['name'],
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        RatingBarIndicator(
                          rating: review['rating'].toDouble(),
                          itemBuilder: (context, index) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          itemCount: 5,
                          itemSize: 14.0,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          review['date'],
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            review['comment'],
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Consumer<CartService>(
          builder: (context, cartService, child) {
            return CustomButton(
              text: 'Add to Cart • ${AppHelpers.formatCurrency(_totalPrice)}',
              onPressed: () {
                // Add multiple items based on quantity
                for (int i = 0; i < _quantity; i++) {
                  cartService.addItem(widget.foodItem);
                }

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${widget.foodItem.name} added to cart'),
                    backgroundColor: AppColors.primaryGreen,
                    behavior: SnackBarBehavior.floating,
                    action: SnackBarAction(
                      label: 'View Cart',
                      textColor: Colors.white,
                      onPressed: () {
                        DefaultTabController.of(context)?.animateTo(2);
                        Navigator.pop(context);
                      },
                    ),
                  ),
                );

                Navigator.pop(context);
              },
            );
          },
        ),
      ),
    );
  }

  void _toggleFavorite() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added ${widget.foodItem.name} to favorites'),
        backgroundColor: AppColors.primaryGreen,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showAllReviews() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'All Reviews',
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _reviews.length,
                itemBuilder: (context, index) {
                  return _buildReviewItem(_reviews[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
