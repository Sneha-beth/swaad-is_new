import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../utils/app_colors.dart';
import '../../utils/helpers.dart';
import '../../widgets/common/custom_button.dart';
import '../../screens/main_navigation_screen.dart';

class OrderSummaryScreen extends StatefulWidget {
  final String orderId;
  final double totalAmount;
  final String paymentMethod;
  final String pickupTime;

  const OrderSummaryScreen({
    super.key,
    required this.orderId,
    required this.totalAmount,
    required this.paymentMethod,
    required this.pickupTime,
  });

  @override
  State<OrderSummaryScreen> createState() => _OrderSummaryScreenState();
}

class _OrderSummaryScreenState extends State<OrderSummaryScreen>
    with TickerProviderStateMixin {
  late AnimationController _checkmarkController;
  late AnimationController _contentController;
  late Animation<double> _checkmarkAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _checkmarkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _contentController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _checkmarkAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _checkmarkController, curve: Curves.elasticOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _contentController, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
        CurvedAnimation(parent: _contentController, curve: Curves.easeOut));

    // Start animations
    _checkmarkController.forward();
    Future.delayed(const Duration(milliseconds: 400), () {
      _contentController.forward();
    });
  }

  @override
  void dispose() {
    _checkmarkController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Header
              _buildHeader(),

              // Success Animation and Content
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Success Checkmark
                    _buildSuccessAnimation(),

                    const SizedBox(height: 32),

                    // Order Details
                    _buildOrderDetails(),

                    const SizedBox(height: 32),

                    // Timeline
                    _buildOrderTimeline(),
                  ],
                ),
              ),

              // Bottom Buttons
              _buildBottomButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => const MainNavigationScreen()),
              (route) => false,
            );
          },
          icon: const Icon(Icons.close, color: AppColors.textSecondary),
        ),
        const Spacer(),
        Text(
          'Order Confirmation',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const Spacer(),
        const SizedBox(width: 48), // Balance the close button
      ],
    );
  }

  Widget _buildSuccessAnimation() {
    return AnimatedBuilder(
      animation: _checkmarkController,
      builder: (context, child) {
        return Transform.scale(
          scale: _checkmarkAnimation.value,
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(60),
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: const Icon(
              Icons.check,
              color: Colors.white,
              size: 60,
            ),
          ),
        );
      },
    );
  }

  Widget _buildOrderDetails() {
    return SlideTransition(
      position: _slideAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Column(
          children: [
            Text(
              'Order Placed Successfully!',
              style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Your order has been confirmed and is being prepared',
              style: GoogleFonts.inter(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Order Info Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.backgroundColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.borderColor),
              ),
              child: Column(
                children: [
                  _buildOrderInfoRow('Order ID', widget.orderId),
                  const SizedBox(height: 12),
                  _buildOrderInfoRow('Total Amount',
                      AppHelpers.formatCurrency(widget.totalAmount)),
                  const SizedBox(height: 12),
                  _buildOrderInfoRow('Payment Method', widget.paymentMethod),
                  const SizedBox(height: 12),
                  _buildOrderInfoRow('Pickup Time', widget.pickupTime),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildOrderTimeline() {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
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
              'Order Status',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            AnimationLimiter(
              child: Column(
                children: [
                  AnimationConfiguration.staggeredList(
                    position: 0,
                    duration: const Duration(milliseconds: 500),
                    delay: const Duration(milliseconds: 800),
                    child: SlideAnimation(
                      horizontalOffset: -50,
                      child: FadeInAnimation(
                        child: _buildTimelineItem(
                          'Order Placed',
                          'Your order has been confirmed',
                          true,
                          isFirst: true,
                        ),
                      ),
                    ),
                  ),
                  AnimationConfiguration.staggeredList(
                    position: 1,
                    duration: const Duration(milliseconds: 500),
                    delay: const Duration(milliseconds: 1000),
                    child: SlideAnimation(
                      horizontalOffset: -50,
                      child: FadeInAnimation(
                        child: _buildTimelineItem(
                          'Being Prepared',
                          'Vendor is preparing your order',
                          false,
                        ),
                      ),
                    ),
                  ),
                  AnimationConfiguration.staggeredList(
                    position: 2,
                    duration: const Duration(milliseconds: 500),
                    delay: const Duration(milliseconds: 1200),
                    child: SlideAnimation(
                      horizontalOffset: -50,
                      child: FadeInAnimation(
                        child: _buildTimelineItem(
                          'Ready for Pickup',
                          'Your order will be ready soon',
                          false,
                          isLast: true,
                        ),
                      ),
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

  Widget _buildTimelineItem(
    String title,
    String subtitle,
    bool isCompleted, {
    bool isFirst = false,
    bool isLast = false,
  }) {
    return IntrinsicHeight(
      child: Row(
        children: [
          // Timeline indicator
          Column(
            children: [
              if (!isFirst)
                Container(
                  width: 2,
                  height: 16,
                  color: AppColors.borderColor,
                ),
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: isCompleted ? Colors.green : AppColors.backgroundColor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isCompleted ? Colors.green : AppColors.borderColor,
                    width: 2,
                  ),
                ),
                child: isCompleted
                    ? const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 12,
                      )
                    : null,
              ),
              if (!isLast)
                Container(
                  width: 2,
                  height: 16,
                  color: AppColors.borderColor,
                ),
            ],
          ),
          const SizedBox(width: 16),

          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isCompleted ? Colors.green : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButtons() {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Column(
        children: [
          CustomButton(
            text: 'Track Order',
            onPressed: () {
              // Navigate to order tracking
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => const MainNavigationScreen()),
                (route) => false,
              );
              // Switch to orders tab
              Future.delayed(const Duration(milliseconds: 100), () {
                DefaultTabController.of(context)?.animateTo(3);
              });
            },
          ),
          const SizedBox(height: 12),
          CustomButton(
            text: 'Continue Shopping',
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => const MainNavigationScreen()),
                (route) => false,
              );
              // Switch to vendors tab
              Future.delayed(const Duration(milliseconds: 100), () {
                DefaultTabController.of(context)?.animateTo(1);
              });
            },
            isOutlined: true,
          ),
        ],
      ),
    );
  }
}
