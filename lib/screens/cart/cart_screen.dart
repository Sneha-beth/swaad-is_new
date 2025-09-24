import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../utils/app_colors.dart';
import '../../utils/helpers.dart';
import '../../services/cart_service.dart';
import '../../services/vendor_service.dart';
import '../../widgets/common/custom_button.dart';
import 'checkout_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final TextEditingController _promoController = TextEditingController();
  bool _isApplyingPromo = false;

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Consumer<CartService>(
          builder: (context, cartService, child) {
            return Column(
              children: [
                // Header
                _buildHeader(cartService),

                // Cart Content
                Expanded(
                  child: cartService.items.isEmpty
                      ? _buildEmptyCart()
                      : _buildCartContent(cartService),
                ),

                // Bottom Section with Total and Checkout
                if (cartService.items.isNotEmpty)
                  _buildBottomSection(cartService),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(CartService cartService) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primaryGreen.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.shopping_cart,
              color: AppColors.primaryGreen,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'My Cart',
                style: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              if (cartService.items.isNotEmpty)
                Text(
                  '${cartService.itemCount} items',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
            ],
          ),
          const Spacer(),
          if (cartService.items.isNotEmpty)
            TextButton(
              onPressed: () => _showClearCartDialog(cartService),
              child: Text(
                'Clear All',
                style: GoogleFonts.inter(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.primaryGreen.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(60),
            ),
            child: const Icon(
              Icons.shopping_cart_outlined,
              color: AppColors.primaryGreen,
              size: 60,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Your cart is empty',
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Add items from vendors to get started',
            style: GoogleFonts.inter(
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: CustomButton(
              text: 'Browse Vendors',
              onPressed: () {
                // Navigate to vendors tab
                DefaultTabController.of(context)?.animateTo(1);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartContent(CartService cartService) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Cart Items
          _buildCartItems(cartService),

          // Promo Code Section
          _buildPromoCodeSection(cartService),

          // Bill Details
          _buildBillDetails(cartService),

          const SizedBox(height: 100), // Space for bottom bar
        ],
      ),
    );
  }

  Widget _buildCartItems(CartService cartService) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Items in Cart',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          AnimationLimiter(
            child: Column(
              children: cartService.items
                  .map((cartItem) {
                    final index = cartService.items.indexOf(cartItem);
                    return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 375),
                      child: SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(
                          child: _buildCartItemCard(cartItem, cartService),
                        ),
                      ),
                    );
                  })
                  .toList()
                  .cast<Widget>(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItemCard(cartItem, CartService cartService) {
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
        children: [
          // Food Image
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
                        size: 30,
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 16),

          // Food Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (foodItem.isVegetarian)
                      Container(
                        width: 12,
                        height: 12,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: const Icon(
                          Icons.circle,
                          color: Colors.white,
                          size: 8,
                        ),
                      ),
                    Expanded(
                      child: Text(
                        foodItem.name,
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  AppHelpers.formatCurrency(foodItem.price),
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryGreen,
                  ),
                ),
                const SizedBox(height: 12),

                // Quantity Controls
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (cartItem.quantity > 1) {
                          cartService.updateQuantity(
                              cartItem.id, cartItem.quantity - 1);
                        } else {
                          cartService.removeItem(cartItem.id);
                        }
                      },
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: AppColors.backgroundColor,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.borderColor),
                        ),
                        child: const Icon(
                          Icons.remove,
                          size: 16,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      cartItem.quantity.toString(),
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 16),
                    GestureDetector(
                      onTap: () {
                        cartService.updateQuantity(
                            cartItem.id, cartItem.quantity + 1);
                      },
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: AppColors.primaryGreen,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.add,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      AppHelpers.formatCurrency(cartItem.totalPrice),
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromoCodeSection(CartService cartService) {
    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.local_offer,
                color: AppColors.primaryGreen,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Apply Promo Code',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (cartService.promoCode != null) ...[
            // Applied Promo Code
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.green, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          cartService.promoCode!,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.green,
                          ),
                        ),
                        Text(
                          'You saved ${AppHelpers.formatCurrency(cartService.discount)}',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      cartService.removePromoCode();
                      _promoController.clear();
                    },
                    child: Text(
                      'Remove',
                      style: GoogleFonts.inter(
                        color: Colors.red,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            // Promo Code Input
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _promoController,
                    decoration: InputDecoration(
                      hintText: 'Enter promo code',
                      hintStyle:
                          GoogleFonts.inter(color: AppColors.textSecondary),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide:
                            const BorderSide(color: AppColors.borderColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide:
                            const BorderSide(color: AppColors.primaryGreen),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    style: GoogleFonts.inter(fontSize: 14),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _isApplyingPromo
                      ? null
                      : () => _applyPromoCode(cartService),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                  ),
                  child: _isApplyingPromo
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          'Apply',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ],
            ),

            // Available Offers
            const SizedBox(height: 16),
            Text(
              'Available Offers',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            _buildOfferChip('SAVE20', 'Get 20% off on orders above ₹500'),
            _buildOfferChip('FIRST50', 'Flat ₹50 off on first order'),
          ],
        ],
      ),
    );
  }

  Widget _buildOfferChip(String code, String description) {
    return GestureDetector(
      onTap: () {
        _promoController.text = code;
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.borderColor),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                code,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryGreen,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                description,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 12,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBillDetails(CartService cartService) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bill Details',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _buildBillRow(
              'Item Total', AppHelpers.formatCurrency(cartService.subtotal)),
          if (cartService.discount > 0)
            _buildBillRow(
              'Discount',
              '- ${AppHelpers.formatCurrency(cartService.discount)}',
              color: Colors.green,
            ),
          _buildBillRow('Delivery Fee', 'FREE', color: Colors.green),
          _buildBillRow('Taxes & Charges',
              AppHelpers.formatCurrency(cartService.subtotal * 0.05)),
          const Divider(height: 24),
          _buildBillRow(
            'Total Amount',
            AppHelpers.formatCurrency(
                cartService.total + (cartService.subtotal * 0.05)),
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildBillRow(String label, String amount,
      {Color? color, bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: color ?? AppColors.textSecondary,
            ),
          ),
          Text(
            amount,
            style: GoogleFonts.inter(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
              color: color ??
                  (isTotal ? AppColors.textPrimary : AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSection(CartService cartService) {
    final finalTotal = cartService.total + (cartService.subtotal * 0.05);

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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Amount',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      AppHelpers.formatCurrency(finalTotal),
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryGreen,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Expanded(
                  child: CustomButton(
                    text: 'Proceed to Checkout',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CheckoutScreen(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _applyPromoCode(CartService cartService) async {
    final code = _promoController.text.trim().toUpperCase();
    if (code.isEmpty) return;

    setState(() {
      _isApplyingPromo = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isApplyingPromo = false;
    });

    // Mock promo code logic
    double discount = 0.0;
    String message = '';
    bool isValid = false;

    switch (code) {
      case 'SAVE20':
        if (cartService.subtotal >= 500) {
          discount = cartService.subtotal * 0.20;
          message = 'Promo code applied successfully!';
          isValid = true;
        } else {
          message = 'Minimum order amount should be ₹500';
        }
        break;
      case 'FIRST50':
        discount = 50.0;
        message = 'Promo code applied successfully!';
        isValid = true;
        break;
      default:
        message = 'Invalid promo code';
    }

    if (isValid) {
      cartService.applyPromoCode(code, discount);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: AppColors.primaryGreen,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showClearCartDialog(CartService cartService) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: Text(
          'Clear Cart',
          style: GoogleFonts.inter(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Are you sure you want to remove all items from your cart?',
          style: GoogleFonts.inter(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.inter(color: AppColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              cartService.clearCart();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Cart cleared successfully'),
                  backgroundColor: AppColors.primaryGreen,
                ),
              );
            },
            child: Text(
              'Clear',
              style: GoogleFonts.inter(
                color: Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
