import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/helpers.dart';
import '../../services/cart_service.dart';
import '../../services/wallet_service.dart';
import '../../services/order_service.dart';
import '../../services/vendor_service.dart';
import '../../widgets/common/custom_button.dart';
import 'order_summary_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _selectedPaymentMethod = 'Wallet';
  String _selectedTimeSlot = '';
  final TextEditingController _instructionsController = TextEditingController();
  bool _isPlacingOrder = false;

  final List<String> _paymentMethods = [
    'Wallet',
    'UPI',
    'Credit Card',
    'Debit Card',
    'Cash on Pickup',
  ];

  final List<String> _timeSlots = [
    'ASAP (15-20 min)',
    '12:00 PM - 12:30 PM',
    '12:30 PM - 1:00 PM',
    '1:00 PM - 1:30 PM',
    '1:30 PM - 2:00 PM',
    '2:00 PM - 2:30 PM',
    '2:30 PM - 3:00 PM',
    '3:00 PM - 3:30 PM',
  ];

  @override
  void initState() {
    super.initState();
    _selectedTimeSlot = _timeSlots.first;
  }

  @override
  void dispose() {
    _instructionsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Checkout',
          style: GoogleFonts.inter(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Consumer2<CartService, WalletService>(
        builder: (context, cartService, walletService, child) {
          return Column(
            children: [
              // Checkout Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Order Summary
                      _buildOrderSummary(cartService),
                      const SizedBox(height: 24),

                      // Pickup Time
                      _buildTimeSlotSelection(),
                      const SizedBox(height: 24),

                      // Payment Method
                      _buildPaymentMethod(walletService),
                      const SizedBox(height: 24),

                      // Special Instructions
                      _buildSpecialInstructions(),
                      const SizedBox(height: 24),

                      // Bill Summary
                      _buildBillSummary(cartService),

                      const SizedBox(height: 100), // Space for bottom button
                    ],
                  ),
                ),
              ),

              // Bottom Section
              _buildBottomSection(cartService, walletService),
            ],
          );
        },
      ),
    );
  }

  Widget _buildOrderSummary(CartService cartService) {
    return Container(
      padding: const EdgeInsets.all(20),
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
          Row(
            children: [
              const Icon(
                Icons.receipt_long,
                color: AppColors.primaryGreen,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Order Summary',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              Text(
                '${cartService.itemCount} items',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...cartService.items.take(3).map((cartItem) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: cartItem.foodItem.isVegetarian
                          ? Colors.green
                          : Colors.red,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '${cartItem.quantity}x ${cartItem.foodItem.name}',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  Text(
                    AppHelpers.formatCurrency(cartItem.totalPrice),
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          if (cartService.items.length > 3) ...[
            const SizedBox(height: 8),
            Text(
              '+${cartService.items.length - 3} more items',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTimeSlotSelection() {
    return Container(
      padding: const EdgeInsets.all(20),
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
          Row(
            children: [
              const Icon(
                Icons.access_time,
                color: AppColors.primaryGreen,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Pickup Time',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _timeSlots.map((slot) {
              final isSelected = _selectedTimeSlot == slot;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedTimeSlot = slot;
                  });
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primaryGreen
                        : AppColors.backgroundColor,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primaryGreen
                          : AppColors.borderColor,
                    ),
                  ),
                  child: Text(
                    slot,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isSelected ? Colors.white : AppColors.textPrimary,
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

  Widget _buildPaymentMethod(WalletService walletService) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderColor),
          boxShadow: [
            BoxShadow(
              // Change from BoxShadBox to BoxShadow
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.payment,
                color: AppColors.primaryGreen,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Payment Method',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ..._paymentMethods.map((method) {
            final isSelected = _selectedPaymentMethod == method;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedPaymentMethod = method;
                });
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primaryGreen.withValues(alpha: 0.1)
                      : AppColors.backgroundColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primaryGreen
                        : AppColors.borderColor,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      _getPaymentIcon(method),
                      color: isSelected
                          ? AppColors.primaryGreen
                          : AppColors.textSecondary,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            method,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          if (method == 'Wallet')
                            Text(
                              'Balance: ${AppHelpers.formatCurrency(walletService.balance)}',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                        ],
                      ),
                    ),
                    if (isSelected)
                      const Icon(
                        Icons.check_circle,
                        color: AppColors.primaryGreen,
                        size: 20,
                      ),
                  ],
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildSpecialInstructions() {
    return Container(
      padding: const EdgeInsets.all(20),
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
          Row(
            children: [
              const Icon(
                Icons.note_add,
                color: AppColors.primaryGreen,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Special Instructions',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _instructionsController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Any special requests for the vendor? (Optional)',
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

  Widget _buildBillSummary(CartService cartService) {
    final taxes = cartService.subtotal * 0.05;
    final finalTotal = cartService.total + taxes;

    return Container(
      padding: const EdgeInsets.all(20),
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
          Text(
            'Bill Summary',
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
          _buildBillRow('Taxes & Charges', AppHelpers.formatCurrency(taxes)),
          const Divider(height: 24),
          _buildBillRow(
            'Total Amount',
            AppHelpers.formatCurrency(finalTotal),
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

  Widget _buildBottomSection(
      CartService cartService, WalletService walletService) {
    final taxes = cartService.subtotal * 0.05;
    final finalTotal = cartService.total + taxes;

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
                    text: _isPlacingOrder ? 'Placing Order...' : 'Place Order',
                    onPressed: _isPlacingOrder
                        ? () {}
                        : () =>
                            _placeOrder(cartService, walletService, finalTotal),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getPaymentIcon(String method) {
    switch (method) {
      case 'Wallet':
        return Icons.account_balance_wallet;
      case 'UPI':
        return Icons.account_balance;
      case 'Credit Card':
      case 'Debit Card':
        return Icons.credit_card;
      case 'Cash on Pickup':
        return Icons.money;
      default:
        return Icons.payment;
    }
  }

  void _placeOrder(CartService cartService, WalletService walletService,
      double totalAmount) async {
    // Validate payment method
    if (_selectedPaymentMethod == 'Wallet' &&
        walletService.balance < totalAmount) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Insufficient wallet balance. Please add money or choose another payment method.'),
          backgroundColor: Colors.red,
          action: SnackBarAction(
            label: 'Add Money',
            textColor: Colors.white,
            onPressed: () {
              // Navigate to add money screen
              DefaultTabController.of(context)?.animateTo(4); // Profile tab
              Navigator.pop(context);
            },
          ),
        ),
      );
      return;
    }

    setState(() {
      _isPlacingOrder = true;
    });

    try {
      // Get vendor info (assuming all items are from the same vendor)
      final firstItem = cartService.items.first;
      final vendor = VendorService.getDummyVendors()
          .firstWhere((v) => v.id == firstItem.foodItem.vendorId);

      // Place order
      final orderId = await OrderService.placeOrder(
        cartService.getCart(),
        vendor,
        _selectedPaymentMethod,
      );

      // Deduct from wallet if wallet payment
      if (_selectedPaymentMethod == 'Wallet') {
        await walletService.deductMoney(
          totalAmount,
          'Order Payment - ${vendor.name}',
          orderId: orderId,
        );
      }

      // Clear cart
      cartService.clearCart();

      // Navigate to order summary
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => OrderSummaryScreen(
            orderId: orderId,
            totalAmount: totalAmount,
            paymentMethod: _selectedPaymentMethod,
            pickupTime: _selectedTimeSlot,
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to place order. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isPlacingOrder = false;
      });
    }
  }
}
