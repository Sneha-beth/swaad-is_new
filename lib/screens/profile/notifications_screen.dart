import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../utils/app_colors.dart';
import '../../utils/helpers.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  bool _pushNotifications = true;
  bool _orderUpdates = true;
  bool _promotions = true;
  bool _newVendors = false;
  bool _emailNotifications = true;
  bool _smsNotifications = false;

  // Mock notifications data
  final List<Map<String, dynamic>> _allNotifications = [
    {
      'id': 1,
      'title': 'Order Delivered Successfully',
      'message':
          'Your order from Pizza Corner has been delivered. Enjoy your meal!',
      'type': 'order',
      'time': DateTime.now().subtract(const Duration(minutes: 15)),
      'isRead': false,
      'icon': Icons.check_circle,
      'color': Colors.green,
    },
    {
      'id': 2,
      'title': 'Special Offer Alert',
      'message': '20% off on all burgers at Burger Hub. Use code SAVE20',
      'type': 'promotion',
      'time': DateTime.now().subtract(const Duration(hours: 2)),
      'isRead': false,
      'icon': Icons.local_offer,
      'color': Colors.orange,
    },
    {
      'id': 3,
      'title': 'Order Being Prepared',
      'message': 'Your order #SW123 from Healthy Bowls is being prepared',
      'type': 'order',
      'time': DateTime.now().subtract(const Duration(hours: 3)),
      'isRead': true,
      'icon': Icons.restaurant,
      'color': Colors.blue,
    },
    {
      'id': 4,
      'title': 'New Vendor Alert',
      'message':
          'Thai Delights just joined Swaad! Try their authentic Thai cuisine',
      'type': 'vendor',
      'time': DateTime.now().subtract(const Duration(days: 1)),
      'isRead': true,
      'icon': Icons.store,
      'color': Colors.purple,
    },
    {
      'id': 5,
      'title': 'Payment Successful',
      'message': '₹250 added to your wallet successfully',
      'type': 'payment',
      'time': DateTime.now().subtract(const Duration(days: 2)),
      'isRead': true,
      'icon': Icons.account_balance_wallet,
      'color': Colors.green,
    },
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

  List<Map<String, dynamic>> get _unreadNotifications {
    return _allNotifications
        .where((notification) => !notification['isRead'])
        .toList();
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
          'Notifications',
          style: GoogleFonts.inter(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => _markAllAsRead(),
            icon: const Icon(Icons.done_all, color: AppColors.textSecondary),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primaryGreen,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primaryGreen,
          labelStyle: GoogleFonts.inter(fontWeight: FontWeight.w600),
          unselectedLabelStyle: GoogleFonts.inter(),
          tabs: [
            Tab(text: 'All (${_allNotifications.length})'),
            Tab(text: 'Unread (${_unreadNotifications.length})'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Notification Settings
          _buildNotificationSettings(),

          // Notifications List
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildNotificationsList(_allNotifications),
                _buildNotificationsList(_unreadNotifications),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationSettings() {
    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(16),
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
                Icons.settings,
                color: AppColors.primaryGreen,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Notification Preferences',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () => _showSettingsBottomSheet(),
                child: Text(
                  'Manage',
                  style: GoogleFonts.inter(
                    color: AppColors.primaryGreen,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildQuickToggle('Orders', _orderUpdates, (value) {
                setState(() => _orderUpdates = value);
              }),
              const SizedBox(width: 12),
              _buildQuickToggle('Offers', _promotions, (value) {
                setState(() => _promotions = value);
              }),
              const SizedBox(width: 12),
              _buildQuickToggle('Push', _pushNotifications, (value) {
                setState(() => _pushNotifications = value);
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickToggle(String label, bool value, Function(bool) onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: value
            ? AppColors.primaryGreen.withValues(alpha: 0.1)
            : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: value ? AppColors.primaryGreen : AppColors.borderColor,
        ),
      ),
      child: GestureDetector(
        onTap: () => onChanged(!value),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              value ? Icons.check : Icons.close,
              size: 16,
              color: value ? AppColors.primaryGreen : AppColors.textSecondary,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: value ? AppColors.primaryGreen : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationsList(List<Map<String, dynamic>> notifications) {
    if (notifications.isEmpty) {
      return _buildEmptyState();
    }

    return AnimationLimiter(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 375),
            child: SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: _buildNotificationCard(notification),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> notification) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: notification['isRead']
            ? Colors.white
            : AppColors.primaryGreen.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: notification['isRead']
              ? AppColors.borderColor
              : AppColors.primaryGreen.withValues(alpha: 0.2),
        ),
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: notification['color'].withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            notification['icon'],
            color: notification['color'],
            size: 20,
          ),
        ),
        title: Text(
          notification['title'],
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight:
                notification['isRead'] ? FontWeight.w500 : FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              notification['message'],
              style: GoogleFonts.inter(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              AppHelpers.getTimeAgo(notification['time']),
              style: GoogleFonts.inter(
                fontSize: 10,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        trailing: notification['isRead']
            ? null
            : Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
        onTap: () => _markAsRead(notification['id']),
      ),
    );
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
              Icons.notifications_none,
              color: AppColors.primaryGreen,
              size: 40,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'No notifications',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'You\'re all caught up! New notifications will appear here.',
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

  void _showSettingsBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: const EdgeInsets.all(24),
          height: MediaQuery.of(context).size.height * 0.7,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Notification Settings',
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
              _buildSettingsSection(
                'Push Notifications',
                [
                  _buildSettingsTile(
                      'Push Notifications',
                      'Receive push notifications',
                      _pushNotifications, (value) {
                    setState(() => _pushNotifications = value);
                    setModalState(() {});
                  }),
                  _buildSettingsTile(
                      'Order Updates',
                      'Get notified about order status',
                      _orderUpdates, (value) {
                    setState(() => _orderUpdates = value);
                    setModalState(() {});
                  }),
                  _buildSettingsTile(
                      'Promotions & Offers',
                      'Receive promotional notifications',
                      _promotions, (value) {
                    setState(() => _promotions = value);
                    setModalState(() {});
                  }),
                  _buildSettingsTile('New Vendors',
                      'Get notified about new vendors', _newVendors, (value) {
                    setState(() => _newVendors = value);
                    setModalState(() {});
                  }),
                ],
              ),
              const SizedBox(height: 20),
              _buildSettingsSection(
                'Other Channels',
                [
                  _buildSettingsTile('Email Notifications',
                      'Receive email updates', _emailNotifications, (value) {
                    setState(() => _emailNotifications = value);
                    setModalState(() {});
                  }),
                  _buildSettingsTile('SMS Notifications', 'Receive SMS updates',
                      _smsNotifications, (value) {
                    setState(() => _smsNotifications = value);
                    setModalState(() {});
                  }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }

  Widget _buildSettingsTile(
      String title, String subtitle, bool value, Function(bool) onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: SwitchListTile(
        title: Text(
          title,
          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          subtitle,
          style:
              GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary),
        ),
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.primaryGreen,
      ),
    );
  }

  void _markAsRead(int notificationId) {
    setState(() {
      final notificationIndex =
          _allNotifications.indexWhere((n) => n['id'] == notificationId);
      if (notificationIndex != -1) {
        _allNotifications[notificationIndex]['isRead'] = true;
      }
    });
  }

  void _markAllAsRead() {
    setState(() {
      for (var notification in _allNotifications) {
        notification['isRead'] = true;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('All notifications marked as read'),
        backgroundColor: AppColors.primaryGreen,
      ),
    );
  }
}
