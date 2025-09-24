import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../utils/app_colors.dart';
import '../../utils/helpers.dart';
import '../../models/order_model.dart';
import '../../models/cart_item_model.dart';
import '../../models/food_item_model.dart';
import '../../models/vendor_model.dart';

class OrderManagementScreen extends StatefulWidget {
  const OrderManagementScreen({super.key});

  @override
  State<OrderManagementScreen> createState() => _OrderManagementScreenState();
}

class _OrderManagementScreenState extends State<OrderManagementScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedFilter = 'All';

  // Mock orders data
  List<OrderModel> _orders = [
    OrderModel(
      id: 'SW1001',
      customerId: 'user1',
      customerName: 'John Doe',
      customerPhone: '+91 98765 43210',
      vendor: VendorModel(
        id: '1',
        name: 'Pizza Corner',
        description: 'Best pizzas in town',
        image: 'assets/images/vendors/pizza_corner.jpg',
        rating: 4.5,
        deliveryTime: '15-20',
        preparationTime: 15,
        location: 'Food Court, Campus',
        cuisineTypes: ['Italian', 'Fast Food'],
        isOpen: true,
        priceRange: '\$',
        distance: 0.2,
      ),
      items: [
        CartItemModel(
          id: '1',
          foodItem: FoodItemModel(
            id: '1',
            vendorId: '1',
            name: 'Margherita Pizza',
            description: 'Fresh tomatoes, mozzarella cheese, basil',
            price: 299.0,
            image: 'assets/images/food/margherita_pizza.jpg',
            category: 'Pizza',
            isVegetarian: true,
            isAvailable: true,
            preparationTime: 15,
            rating: 4.5,
            tags: ['Popular'],
          ),
          quantity: 1,
        ),
        CartItemModel(
          id: '2',
          foodItem: FoodItemModel(
            id: '2',
            vendorId: '1',
            name: 'Coca Cola',
            description: 'Cold refreshing drink',
            price: 50.0,
            image: 'assets/images/food/coke.jpg',
            category: 'Beverages',
            isVegetarian: true,
            isAvailable: true,
            preparationTime: 2,
            rating: 4.0,
            tags: [],
          ),
          quantity: 1,
        ),
      ],
      status: OrderStatus.placed,
      subtotal: 349.0,
      discount: 0.0,
      deliveryFee: 0.0,
      total: 349.0,
      paymentMethod: 'Wallet',
      createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
      estimatedPickupTime: DateTime.now().add(const Duration(minutes: 15)),
    ),
    OrderModel(
      id: 'SW1002',
      customerId: 'user2',
      customerName: 'Sarah Smith',
      customerPhone: '+91 87654 32109',
      vendor: VendorModel(
        id: '1',
        name: 'Pizza Corner',
        description: 'Best pizzas in town',
        image: 'assets/images/vendors/pizza_corner.jpg',
        rating: 4.5,
        deliveryTime: '15-20',
        preparationTime: 15,
        location: 'Food Court, Campus',
        cuisineTypes: ['Italian', 'Fast Food'],
        isOpen: true,
        priceRange: '\$',
        distance: 0.2,
      ),
      items: [
        CartItemModel(
          id: '3',
          foodItem: FoodItemModel(
            id: '3',
            vendorId: '1',
            name: 'Pepperoni Pizza',
            description: 'Spicy pepperoni with mozzarella cheese',
            price: 349.0,
            image: 'assets/images/food/pepperoni_pizza.jpg',
            category: 'Pizza',
            isVegetarian: false,
            isAvailable: true,
            preparationTime: 18,
            rating: 4.3,
            tags: ['Spicy'],
          ),
          quantity: 1,
        ),
      ],
      status: OrderStatus.preparing,
      subtotal: 349.0,
      discount: 20.0,
      deliveryFee: 0.0,
      total: 329.0,
      paymentMethod: 'UPI',
      createdAt: DateTime.now().subtract(const Duration(minutes: 12)),
      estimatedPickupTime: DateTime.now().add(const Duration(minutes: 8)),
    ),
    OrderModel(
      id: 'SW1003',
      customerId: 'user3',
      customerName: 'Mike Johnson',
      customerPhone: '+91 76543 21098',
      vendor: VendorModel(
        id: '1',
        name: 'Pizza Corner',
        description: 'Best pizzas in town',
        image: 'assets/images/vendors/pizza_corner.jpg',
        rating: 4.5,
        deliveryTime: '15-20',
        preparationTime: 15,
        location: 'Food Court, Campus',
        cuisineTypes: ['Italian', 'Fast Food'],
        isOpen: true,
        priceRange: '\$',
        distance: 0.2,
      ),
      items: [
        CartItemModel(
          id: '4',
          foodItem: FoodItemModel(
            id: '4',
            vendorId: '1',
            name: 'Veggie Pizza',
            description: 'Fresh vegetables with mozzarella cheese',
            price: 320.0,
            image: 'assets/images/food/veggie_pizza.jpg',
            category: 'Pizza',
            isVegetarian: true,
            isAvailable: true,
            preparationTime: 16,
            rating: 4.2,
            tags: ['Healthy'],
          ),
          quantity: 1,
        ),
      ],
      status: OrderStatus.ready,
      subtotal: 320.0,
      discount: 0.0,
      deliveryFee: 0.0,
      total: 320.0,
      paymentMethod: 'Cash on Pickup',
      createdAt: DateTime.now().subtract(const Duration(minutes: 25)),
      estimatedPickupTime: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
  ];

  final List<String> _filters = [
    'All',
    'New',
    'Preparing',
    'Ready',
    'Completed'
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<OrderModel> get _filteredOrders {
    switch (_selectedFilter) {
      case 'New':
        return _orders
            .where((order) => order.status == OrderStatus.placed)
            .toList();
      case 'Preparing':
        return _orders
            .where((order) => order.status == OrderStatus.preparing)
            .toList();
      case 'Ready':
        return _orders
            .where((order) => order.status == OrderStatus.ready)
            .toList();
      case 'Completed':
        return _orders
            .where((order) => order.status == OrderStatus.completed)
            .toList();
      default:
        return _orders;
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
          'Order Management',
          style: GoogleFonts.inter(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primaryGreen,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primaryGreen,
          labelStyle: GoogleFonts.inter(fontWeight: FontWeight.w600),
          unselectedLabelStyle: GoogleFonts.inter(),
          tabs: const [
            Tab(text: 'Active Orders'),
            Tab(text: 'Order History'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildActiveOrdersTab(),
          _buildOrderHistoryTab(),
        ],
      ),
    );
  }

  Widget _buildActiveOrdersTab() {
    final activeOrders = _orders
        .where((order) =>
            order.status != OrderStatus.completed &&
            order.status != OrderStatus.cancelled)
        .toList();

    return Column(
      children: [
        // Order Stats
        _buildOrderStats(),

        // Active Orders List
        Expanded(
          child: _buildOrdersList(activeOrders),
        ),
      ],
    );
  }

  Widget _buildOrderHistoryTab() {
    return Column(
      children: [
        // Filter Buttons
        _buildFilterButtons(),

        // Orders List
        Expanded(
          child: _buildOrdersList(_filteredOrders),
        ),
      ],
    );
  }

  Widget _buildOrderStats() {
    final newOrders =
        _orders.where((o) => o.status == OrderStatus.placed).length;
    final preparingOrders =
        _orders.where((o) => o.status == OrderStatus.preparing).length;
    final readyOrders =
        _orders.where((o) => o.status == OrderStatus.ready).length;

    return Container(
      margin: const EdgeInsets.all(24),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
                'New', newOrders, Colors.orange, Icons.fiber_new),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
                'Preparing', preparingOrders, Colors.blue, Icons.restaurant),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
                'Ready', readyOrders, Colors.green, Icons.check_circle),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, int count, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            count.toString(),
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButtons() {
    return Container(
      height: 50,
      margin: const EdgeInsets.all(16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _filters.length,
        itemBuilder: (context, index) {
          final filter = _filters[index];
          final isSelected = _selectedFilter == filter;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedFilter = filter;
              });
            },
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryGreen : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primaryGreen
                      : AppColors.borderColor,
                ),
              ),
              child: Center(
                child: Text(
                  filter,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? Colors.white : AppColors.textPrimary,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildOrdersList(List<OrderModel> orders) {
    if (orders.isEmpty) {
      return _buildEmptyState();
    }

    return AnimationLimiter(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 375),
            child: SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: _buildOrderCard(orders[index]),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildOrderCard(OrderModel order) {
    return Container(
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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order #${order.id}',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        order.customerName,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.access_time,
                              size: 16, color: AppColors.textSecondary),
                          const SizedBox(width: 4),
                          Text(
                            AppHelpers.getTimeAgo(order.createdAt),
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _buildStatusBadge(order.status),
                    const SizedBox(height: 8),
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
              ],
            ),
          ),

          // Order Items
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Items (${order.items.length})',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
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
                        Text(
                          AppHelpers.formatCurrency(item.totalPrice),
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                if (order.items.length > 2)
                  Text(
                    '+${order.items.length - 2} more items',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Customer Info
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Icon(Icons.person,
                    size: 16, color: AppColors.textSecondary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    order.customerPhone,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => _callCustomer(order.customerPhone),
                  icon: const Icon(Icons.phone, color: AppColors.primaryGreen),
                ),
              ],
            ),
          ),

          // Action Buttons
          _buildActionButtons(order),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(OrderStatus status) {
    Color backgroundColor;
    Color textColor;
    String text = AppHelpers.getOrderStatusText(status);

    switch (status) {
      case OrderStatus.placed:
        backgroundColor = Colors.orange.withValues(alpha: 0.1);
        textColor = Colors.orange;
        break;
      case OrderStatus.accepted:
        backgroundColor = Colors.blue.withValues(alpha: 0.1);
        textColor = Colors.blue;
        break;
      case OrderStatus.preparing:
        backgroundColor = Colors.blue.withValues(alpha: 0.1);
        textColor = Colors.blue;
        break;
      case OrderStatus.ready:
        backgroundColor = Colors.green.withValues(alpha: 0.1);
        textColor = Colors.green;
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
        text.toUpperCase(),
        style: GoogleFonts.inter(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }

  Widget _buildActionButtons(OrderModel order) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      child: _getActionButtonsForStatus(order),
    );
  }

  Widget _getActionButtonsForStatus(OrderModel order) {
    switch (order.status) {
      case OrderStatus.placed:
        return Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () =>
                    _updateOrderStatus(order.id, OrderStatus.accepted),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Accept',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton(
                onPressed: () => _rejectOrder(order.id),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.red),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Reject',
                  style: GoogleFonts.inter(
                    color: Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        );

      case OrderStatus.accepted:
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () =>
                _updateOrderStatus(order.id, OrderStatus.preparing),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Start Preparing',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );

      case OrderStatus.preparing:
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => _updateOrderStatus(order.id, OrderStatus.ready),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Mark as Ready',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );

      case OrderStatus.ready:
        return Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () =>
                    _updateOrderStatus(order.id, OrderStatus.completed),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Mark as Picked Up',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            OutlinedButton(
              onPressed: () => _callCustomer(order.customerPhone),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.primaryGreen),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Icon(Icons.phone, color: AppColors.primaryGreen),
            ),
          ],
        );

      default:
        return Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => _showOrderDetails(order),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.primaryGreen),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'View Details',
                  style: GoogleFonts.inter(
                    color: AppColors.primaryGreen,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        );
    }
  }

  Widget _buildEmptyState() {
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
            child: const Icon(
              Icons.receipt_long,
              color: AppColors.primaryGreen,
              size: 40,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'No orders found',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Orders will appear here when customers place them',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _updateOrderStatus(String orderId, OrderStatus newStatus) {
    setState(() {
      final orderIndex = _orders.indexWhere((order) => order.id == orderId);
      if (orderIndex != -1) {
        _orders[orderIndex] = _orders[orderIndex].copyWith(status: newStatus);
      }
    });

    String message;
    switch (newStatus) {
      case OrderStatus.accepted:
        message = 'Order accepted';
        break;
      case OrderStatus.preparing:
        message = 'Order marked as preparing';
        break;
      case OrderStatus.ready:
        message = 'Order marked as ready for pickup';
        break;
      case OrderStatus.completed:
        message = 'Order completed';
        break;
      default:
        message = 'Order status updated';
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.primaryGreen,
      ),
    );
  }

  void _rejectOrder(String orderId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text('Reject Order',
            style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
        content: Text(
          'Are you sure you want to reject this order? This action cannot be undone.',
          style: GoogleFonts.inter(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel',
                style: GoogleFonts.inter(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                final orderIndex =
                    _orders.indexWhere((order) => order.id == orderId);
                if (orderIndex != -1) {
                  _orders[orderIndex] = _orders[orderIndex]
                      .copyWith(status: OrderStatus.cancelled);
                }
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Order rejected'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: Text(
              'Reject',
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

  void _callCustomer(String phoneNumber) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Calling $phoneNumber...'),
        backgroundColor: AppColors.primaryGreen,
      ),
    );
  }

  void _showOrderDetails(OrderModel order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        height: MediaQuery.of(context).size.height * 0.8,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Order Details',
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

            // Order Info
            Text(
              'Order #${order.id}',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Customer: ${order.customerName}',
              style: GoogleFonts.inter(fontSize: 14),
            ),
            Text(
              'Phone: ${order.customerPhone}',
              style: GoogleFonts.inter(fontSize: 14),
            ),
            Text(
              'Order Time: ${AppHelpers.formatDateTime(order.createdAt)}',
              style: GoogleFonts.inter(fontSize: 14),
            ),
            Text(
              'Payment: ${order.paymentMethod}',
              style: GoogleFonts.inter(fontSize: 14),
            ),

            const SizedBox(height: 20),

            // Items List
            Text(
              'Items',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: order.items.length,
                itemBuilder: (context, index) {
                  final item = order.items[index];
                  return ListTile(
                    leading: Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: item.foodItem.isVegetarian
                            ? Colors.green
                            : Colors.red,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    title: Text(item.foodItem.name, style: GoogleFonts.inter()),
                    subtitle: Text(
                      'Qty: ${item.quantity} × ${AppHelpers.formatCurrency(item.foodItem.price)}',
                      style: GoogleFonts.inter(fontSize: 12),
                    ),
                    trailing: Text(
                      AppHelpers.formatCurrency(item.totalPrice),
                      style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                    ),
                  );
                },
              ),
            ),

            // Total
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.backgroundColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Amount',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
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
          ],
        ),
      ),
    );
  }
}
