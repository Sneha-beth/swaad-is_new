import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../utils/app_colors.dart';
import '../../utils/helpers.dart';
import '../../models/order_model.dart';
import '../../services/order_service.dart';
import '../../widgets/common/custom_button.dart';

class OrderTrackingScreen extends StatefulWidget {
  final OrderModel order;

  const OrderTrackingScreen({
    super.key,
    required this.order,
  });

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _progressController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _progressAnimation;

  OrderModel? _currentOrder;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _currentOrder = widget.order;

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeOut),
    );

    _progressController.forward();

    // Simulate real-time updates
    _startOrderTracking();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  void _startOrderTracking() {
    // Simulate order status updates every 30 seconds
    if (_currentOrder!.status != OrderStatus.completed &&
        _currentOrder!.status != OrderStatus.cancelled) {
      Future.delayed(const Duration(seconds: 30), () {
        if (mounted) {
          _updateOrderStatus();
        }
      });
    }
  }

  void _updateOrderStatus() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate status progression
    OrderStatus nextStatus;
    switch (_currentOrder!.status) {
      case OrderStatus.placed:
        nextStatus = OrderStatus.accepted;
        break;
      case OrderStatus.accepted:
        nextStatus = OrderStatus.preparing;
        break;
      case OrderStatus.preparing:
        nextStatus = OrderStatus.ready;
        break;
      case OrderStatus.ready:
        nextStatus = OrderStatus.completed;
        break;
      default:
        return;
    }

    await Future.delayed(const Duration(seconds: 1));
    await OrderService.updateOrderStatus(_currentOrder!.id, nextStatus);

    _currentOrder = OrderService.getOrderById(_currentOrder!.id);

    setState(() {
      _isLoading = false;
    });

    // Continue tracking if not completed
    if (_currentOrder!.status != OrderStatus.completed) {
      _startOrderTracking();
    }
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
          'Track Order',
          style: GoogleFonts.inter(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => _refreshOrder(),
            icon: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.primaryGreen,
                    ),
                  )
                : const Icon(Icons.refresh, color: AppColors.textSecondary),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: AnimationLimiter(
          child: Column(
            children: AnimationConfiguration.toStaggeredList(
              duration: const Duration(milliseconds: 375),
              childAnimationBuilder: (widget) => SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(child: widget),
              ),
              children: [
                // Order Header
                _buildOrderHeader(),

                // Live Tracking
                _buildLiveTracking(),

                // Order Timeline
                _buildOrderTimeline(),

                // Vendor Info
                _buildVendorInfo(),

                // Order Items Summary
                _buildOrderSummary(),

                const SizedBox(height: 100), // Space for bottom button
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomActions(),
    );
  }

  Widget _buildOrderHeader() {
    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryGreen,
            AppColors.darkGreen,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryGreen.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order #${_currentOrder!.id}',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _currentOrder!.vendor.name,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  AppHelpers.getOrderStatusText(_currentOrder!.status),
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Estimated time
          if (_currentOrder!.estimatedPickupTime != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.access_time,
                  color: Colors.white,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  'Estimated pickup: ${AppHelpers.formatTime(_currentOrder!.estimatedPickupTime!)}',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildLiveTracking() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
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
        children: [
          Row(
            children: [
              AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _pulseAnimation.value,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: _getStatusColor(_currentOrder!.status),
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(width: 12),
              Text(
                'Live Tracking',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              Text(
                'Updated ${AppHelpers.getTimeAgo(_currentOrder!.createdAt)}',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Progress indicator
          AnimatedBuilder(
            animation: _progressAnimation,
            builder: (context, child) {
              final progress =
                  AppHelpers.getOrderStatusProgress(_currentOrder!.status);
              return Column(
                children: [
                  LinearProgressIndicator(
                    value: progress * _progressAnimation.value,
                    backgroundColor: AppColors.backgroundColor,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _getStatusColor(_currentOrder!.status),
                    ),
                    minHeight: 8,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${(progress * 100).toInt()}% Complete',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        _getStatusMessage(_currentOrder!.status),
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOrderTimeline() {
    final steps = [
      {
        'status': OrderStatus.placed,
        'title': 'Order Placed',
        'subtitle': 'Your order has been confirmed'
      },
      {
        'status': OrderStatus.accepted,
        'title': 'Order Accepted',
        'subtitle': 'Vendor has accepted your order'
      },
      {
        'status': OrderStatus.preparing,
        'title': 'Being Prepared',
        'subtitle': 'Your food is being prepared'
      },
      {
        'status': OrderStatus.ready,
        'title': 'Ready for Pickup',
        'subtitle': 'Your order is ready'
      },
      {
        'status': OrderStatus.completed,
        'title': 'Order Complete',
        'subtitle': 'Enjoy your meal!'
      },
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
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
            'Order Timeline',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 20),
          ...steps.map((step) {
            final status = step['status'] as OrderStatus;
            final isCompleted = _isStepCompleted(status);
            final isCurrent = _isCurrentStep(status);
            final isLast = status == OrderStatus.completed;

            return AnimationConfiguration.staggeredList(
              position: steps.indexOf(step),
              duration: const Duration(milliseconds: 400),
              delay: Duration(milliseconds: steps.indexOf(step) * 100),
              child: SlideAnimation(
                horizontalOffset: -30,
                child: FadeInAnimation(
                  child: _buildTimelineStep(
                    step['title'] as String,
                    step['subtitle'] as String,
                    isCompleted,
                    isCurrent,
                    isLast,
                  ),
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildTimelineStep(
    String title,
    String subtitle,
    bool isCompleted,
    bool isCurrent,
    bool isLast,
  ) {
    return IntrinsicHeight(
      child: Row(
        children: [
          // Timeline indicator
          Column(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: isCompleted
                      ? AppColors.primaryGreen
                      : (isCurrent ? Colors.orange : AppColors.backgroundColor),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isCompleted
                        ? AppColors.primaryGreen
                        : (isCurrent ? Colors.orange : AppColors.borderColor),
                    width: 2,
                  ),
                ),
                child: isCompleted
                    ? const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 12,
                      )
                    : (isCurrent
                        ? Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          )
                        : null),
              ),
              if (!isLast)
                Container(
                  width: 2,
                  height: 40,
                  color: isCompleted
                      ? AppColors.primaryGreen
                      : AppColors.borderColor,
                ),
            ],
          ),
          const SizedBox(width: 16),

          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isCompleted || isCurrent
                                ? AppColors.textPrimary
                                : AppColors.textSecondary,
                          ),
                        ),
                      ),
                      if (isCompleted && !isCurrent)
                        Text(
                          AppHelpers.formatTime(DateTime.now()),
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            color: AppColors.textSecondary,
                          ),
                        ),
                    ],
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

  Widget _buildVendorInfo() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
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
      child: Row(
        children: [
          // Vendor Image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.backgroundColor,
                image: DecorationImage(
                  image: AssetImage(_currentOrder!.vendor.image),
                  fit: BoxFit.cover,
                  onError: (exception, stackTrace) {},
                ),
              ),
              child: _currentOrder!.vendor.image.startsWith('assets')
                  ? null
                  : Container(
                      color: AppColors.primaryGreen.withValues(alpha: 0.1),
                      child: const Icon(
                        Icons.restaurant,
                        color: AppColors.primaryGreen,
                        size: 25,
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 16),

          // Vendor Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _currentOrder!.vendor.name,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _currentOrder!.vendor.location,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // Contact Button
          Container(
            decoration: BoxDecoration(
              color: AppColors.primaryGreen.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              onPressed: () => _contactVendor(),
              icon: const Icon(
                Icons.phone,
                color: AppColors.primaryGreen,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummary() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
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
            'Order Summary',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          ..._currentOrder!.items.take(2).map((item) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: item.foodItem.isVegetarian
                          ? Colors.green
                          : Colors.red,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${item.quantity}x ${item.foodItem.name}',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  Text(
                    AppHelpers.formatCurrency(item.totalPrice),
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
          if (_currentOrder!.items.length > 2)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(
                '+${_currentOrder!.items.length - 2} more items',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Amount',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                AppHelpers.formatCurrency(_currentOrder!.total),
                style: GoogleFonts.inter(
                  fontSize: 16,
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

  Widget _buildBottomActions() {
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
        child: Row(
          children: [
            Expanded(
              child: CustomButton(
                text: 'Contact Vendor',
                onPressed: () => _contactVendor(),
                isOutlined: true,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: CustomButton(
                text: _currentOrder!.status == OrderStatus.ready
                    ? 'Mark as Picked Up'
                    : 'View Details',
                onPressed: () {
                  if (_currentOrder!.status == OrderStatus.ready) {
                    _markAsPickedUp();
                  } else {
                    Navigator.pop(context);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.placed:
      case OrderStatus.accepted:
        return Colors.blue;
      case OrderStatus.preparing:
        return Colors.orange;
      case OrderStatus.ready:
        return AppColors.primaryGreen;
      case OrderStatus.completed:
        return Colors.green;
      case OrderStatus.cancelled:
        return Colors.red;
    }
  }

  String _getStatusMessage(OrderStatus status) {
    switch (status) {
      case OrderStatus.placed:
        return 'Waiting for confirmation';
      case OrderStatus.accepted:
        return 'Order confirmed';
      case OrderStatus.preparing:
        return 'Cooking in progress';
      case OrderStatus.ready:
        return 'Ready for pickup';
      case OrderStatus.completed:
        return 'Order completed';
      case OrderStatus.cancelled:
        return 'Order cancelled';
    }
  }

  bool _isStepCompleted(OrderStatus stepStatus) {
    final currentIndex = OrderStatus.values.indexOf(_currentOrder!.status);
    final stepIndex = OrderStatus.values.indexOf(stepStatus);
    return stepIndex <= currentIndex &&
        _currentOrder!.status != OrderStatus.cancelled;
  }

  bool _isCurrentStep(OrderStatus stepStatus) {
    return stepStatus == _currentOrder!.status;
  }

  void _refreshOrder() async {
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    // In a real app, this would fetch latest order data from server
    _currentOrder = OrderService.getOrderById(_currentOrder!.id);

    setState(() {
      _isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Order status updated'),
        backgroundColor: AppColors.primaryGreen,
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _contactVendor() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Contact ${_currentOrder!.vendor.name}',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.phone, color: AppColors.primaryGreen),
              title: Text(
                'Call Vendor',
                style: GoogleFonts.inter(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                'Get updates about your order',
                style: GoogleFonts.inter(fontSize: 12),
              ),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Calling vendor...'),
                    backgroundColor: AppColors.primaryGreen,
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.message, color: AppColors.primaryGreen),
              title: Text(
                'Send Message',
                style: GoogleFonts.inter(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                'Chat with the vendor',
                style: GoogleFonts.inter(fontSize: 12),
              ),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Chat feature coming soon!'),
                    backgroundColor: AppColors.primaryGreen,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _markAsPickedUp() async {
    await OrderService.updateOrderStatus(
        _currentOrder!.id, OrderStatus.completed);

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Order marked as completed!'),
          backgroundColor: AppColors.primaryGreen,
        ),
      );
    }
  }
}
