import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../utils/app_colors.dart';
import '../../utils/helpers.dart';
import '../../services/order_service.dart';
import '../../models/order_model.dart';
import 'order_detail_screen.dart';
import 'order_tracking_screen.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<OrderModel> _orders = [];
  bool _isLoading = true;

  final List<String> _tabs = ['All', 'Active', 'Completed', 'Cancelled'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _loadOrders();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadOrders() async {
    setState(() {
      _isLoading = true;
    });

    // Initialize dummy orders if needed
    OrderService.initializeDummyOrders();

    // Simulate loading delay
    await Future.delayed(const Duration(milliseconds: 800));

    _orders = OrderService.orders;

    setState(() {
      _isLoading = false;
    });
  }

  List<OrderModel> _getFilteredOrders(String filter) {
    switch (filter) {
      case 'Active':
        return _orders
            .where((order) =>
                order.status == OrderStatus.placed ||
                order.status == OrderStatus.accepted ||
                order.status == OrderStatus.preparing ||
                order.status == OrderStatus.ready)
            .toList();
      case 'Completed':
        return _orders
            .where((order) => order.status == OrderStatus.completed)
            .toList();
      case 'Cancelled':
        return _orders
            .where((order) => order.status == OrderStatus.cancelled)
            .toList();
      default:
        return _orders;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),

            // Tab Bar
            _buildTabBar(),

            // Content
            Expanded(
              child: _isLoading ? _buildLoadingState() : _buildOrdersList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
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
              Icons.receipt_long,
              color: AppColors.primaryGreen,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'My Orders',
                style: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              if (_orders.isNotEmpty)
                Text(
                  '${_orders.length} orders',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
            ],
          ),
          const Spacer(),
          IconButton(
            onPressed: _loadOrders,
            icon: const Icon(
              Icons.refresh,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: AppColors.primaryGreen,
          borderRadius: BorderRadius.circular(12),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: Colors.white,
        unselectedLabelColor: AppColors.textSecondary,
        labelStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
      ),
    );
  }

  Widget _buildOrdersList() {
    return TabBarView(
      controller: _tabController,
      children: _tabs.map((tab) {
        final filteredOrders = _getFilteredOrders(tab);

        if (filteredOrders.isEmpty) {
          return _buildEmptyState(tab);
        }

        return AnimationLimiter(
          child: ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: filteredOrders.length,
            itemBuilder: (context, index) {
              return AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 375),
                child: SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(
                    child: _buildOrderCard(filteredOrders[index]),
                  ),
                ),
              );
            },
          ),
        );
      }).toList(),
    );
  }

  Widget _buildOrderCard(OrderModel order) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrderDetailScreen(order: order),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
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
            // Order Header
            Container(
              padding: const EdgeInsets.all(16),
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
                          image: AssetImage(order.vendor.image),
                          fit: BoxFit.cover,
                          onError: (exception, stackTrace) {},
                        ),
                      ),
                      child: order.vendor.image.startsWith('assets')
                          ? null
                          : Container(
                              color:
                                  AppColors.primaryGreen.withValues(alpha: 0.1),
                              child: const Icon(
                                Icons.restaurant,
                                color: AppColors.primaryGreen,
                                size: 25,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Vendor Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order.vendor.name,
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          AppHelpers.formatDateTime(order.createdAt),
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Status Badge
                  _buildStatusBadge(order.status),
                ],
              ),
            ),

            // Order Items
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...order.items.take(2).map((item) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
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
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  if (order.items.length > 2)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Text(
                        '+${order.items.length - 2} more items',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Footer
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.backgroundColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Amount',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Text(
                          AppHelpers.formatCurrency(order.total),
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryGreen,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Action Buttons
                  _buildActionButtons(order),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(OrderStatus status) {
    Color backgroundColor;
    Color textColor;
    String text = AppHelpers.getOrderStatusText(status);

    switch (status) {
      case OrderStatus.placed:
      case OrderStatus.accepted:
        backgroundColor = Colors.blue.withValues(alpha: 0.1);
        textColor = Colors.blue;
        break;
      case OrderStatus.preparing:
        backgroundColor = Colors.orange.withValues(alpha: 0.1);
        textColor = Colors.orange;
        break;
      case OrderStatus.ready:
        backgroundColor = AppColors.primaryGreen.withValues(alpha: 0.1);
        textColor = AppColors.primaryGreen;
        break;
      case OrderStatus.completed:
        backgroundColor = Colors.green.withValues(alpha: 0.1);
        textColor = Colors.green;
        break;
      case OrderStatus.cancelled:
        backgroundColor = Colors.red.withValues(alpha: 0.1);
        textColor = Colors.red;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }

  Widget _buildActionButtons(OrderModel order) {
    switch (order.status) {
      case OrderStatus.placed:
      case OrderStatus.accepted:
      case OrderStatus.preparing:
      case OrderStatus.ready:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrderTrackingScreen(order: order),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: Text(
                'Track',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      case OrderStatus.completed:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            OutlinedButton(
              onPressed: () => _reorderItems(order),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.primaryGreen),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              ),
              child: Text(
                'Reorder',
                style: GoogleFonts.inter(
                  color: AppColors.primaryGreen,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 8),
            OutlinedButton(
              onPressed: () => _showRatingDialog(order),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.textSecondary),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              ),
              child: Text(
                'Rate',
                style: GoogleFonts.inter(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      case OrderStatus.cancelled:
        return OutlinedButton(
          onPressed: () => _reorderItems(order),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: AppColors.primaryGreen),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          ),
          child: Text(
            'Reorder',
            style: GoogleFonts.inter(
              color: AppColors.primaryGreen,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
    }
  }

  Widget _buildLoadingState() {
    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          height: 160,
          decoration: BoxDecoration(
            color: AppColors.backgroundColor,
            borderRadius: BorderRadius.circular(12),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(String tab) {
    String message;
    String subtitle;
    IconData icon;

    switch (tab) {
      case 'Active':
        icon = Icons.pending_actions;
        message = 'No active orders';
        subtitle = 'Your active orders will appear here';
        break;
      case 'Completed':
        icon = Icons.check_circle;
        message = 'No completed orders';
        subtitle = 'Your completed orders will appear here';
        break;
      case 'Cancelled':
        icon = Icons.cancel;
        message = 'No cancelled orders';
        subtitle = 'Your cancelled orders will appear here';
        break;
      default:
        icon = Icons.receipt_long;
        message = 'No orders yet';
        subtitle = 'Start ordering from your favorite vendors';
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.primaryGreen.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(40),
            ),
            child: Icon(
              icon,
              color: AppColors.primaryGreen,
              size: 40,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          if (tab == 'All') ...[
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                DefaultTabController.of(context)?.animateTo(1);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Browse Vendors',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _reorderItems(OrderModel order) async {
    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: AppColors.primaryGreen),
      ),
    );

    try {
      await OrderService.reorder(order);
      Navigator.pop(context); // Close loading

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Order placed successfully!'),
          backgroundColor: AppColors.primaryGreen,
          action: SnackBarAction(
            label: 'View',
            textColor: Colors.white,
            onPressed: () {
              _tabController.animateTo(1); // Switch to Active tab
            },
          ),
        ),
      );

      _loadOrders(); // Refresh orders
    } catch (e) {
      Navigator.pop(context); // Close loading

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to place order. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showRatingDialog(OrderModel order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: Text(
          'Rate Your Order',
          style: GoogleFonts.inter(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'How was your experience with ${order.vendor.name}?',
              style: GoogleFonts.inter(),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.star,
                    color: index < 4 ? Colors.amber : Colors.grey,
                    size: 30,
                  ),
                );
              }),
            ),
          ],
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
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Thank you for your feedback!'),
                  backgroundColor: AppColors.primaryGreen,
                ),
              );
            },
            child: Text(
              'Submit',
              style: GoogleFonts.inter(
                color: AppColors.primaryGreen,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
