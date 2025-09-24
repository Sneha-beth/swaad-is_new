import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../utils/app_colors.dart';
import '../widgets/common/custom_button.dart';
import '../services/auth_service.dart';
import '../services/vendor_service.dart';
import '../models/vendor_model.dart';
import '../models/food_item_model.dart';
import 'welcome_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _userName = 'John Doe';
  String _userPhone = '+91 98765 43210';
  List<VendorModel> _vendors = [];
  List<VendorModel> _featuredVendors = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadVendors();
  }

  void _loadUserData() async {
    try {
      final userData = await AuthService.getUserData();
      if (userData != null) {
        setState(() {
          _userName = userData['name'] ?? 'User';
          _userPhone = userData['phone'] ?? '';
        });
      }
    } catch (e) {
      // Handle error silently or show message
      setState(() {
        _userName = 'User';
        _userPhone = '';
      });
    }
  }

  void _loadVendors() async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate loading

    setState(() {
      _vendors = VendorService.getDummyVendors();
      _featuredVendors =
          _vendors.where((vendor) => vendor.rating >= 4.4).toList();
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: AppColors.primaryGreen,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: AnimationLimiter(
            child: Column(
              children: AnimationConfiguration.toStaggeredList(
                duration: const Duration(milliseconds: 375),
                childAnimationBuilder: (widget) => SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(child: widget),
                ),
                children: [
                  // Header with user info
                  _buildHeader(),

                  // Search bar
                  _buildSearchBar(),

                  // Quick categories
                  _buildQuickCategories(),

                  // Featured vendors
                  _buildFeaturedVendors(),

                  // All vendors section
                  _buildAllVendors(),

                  const SizedBox(height: 100), // Space for bottom nav
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          // User info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello ${_userName.split(' ')[0]} 👋',
                  style: GoogleFonts.inter(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'What would you like to eat today?',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // Profile/Menu button
          GestureDetector(
            onTap: () => _showUserMenu(),
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: AppColors.primaryGreen.withValues(alpha: 0.2),
                ),
              ),
              child: const Icon(
                Icons.person,
                color: AppColors.primaryGreen,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: GestureDetector(
        onTap: () {
          _showComingSoon('Search');
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.backgroundColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.borderColor),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.search,
                color: AppColors.textSecondary,
                size: 20,
              ),
              const SizedBox(width: 12),
              Text(
                'Search for food, vendors...',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickCategories() {
    final categories = [
      {'name': 'Pizza', 'icon': Icons.local_pizza, 'color': Colors.red},
      {'name': 'Burgers', 'icon': Icons.lunch_dining, 'color': Colors.orange},
      {'name': 'Healthy', 'icon': Icons.eco, 'color': Colors.green},
      {'name': 'Indian', 'icon': Icons.restaurant, 'color': Colors.purple},
    ];

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              'Categories',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return GestureDetector(
                  onTap: () => _navigateToCategory(category['name'] as String),
                  child: Container(
                    width: 80,
                    margin: const EdgeInsets.only(right: 16),
                    child: Column(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: (category['color'] as Color)
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: (category['color'] as Color)
                                  .withValues(alpha: 0.2),
                            ),
                          ),
                          child: Icon(
                            category['icon'] as IconData,
                            color: category['color'] as Color,
                            size: 28,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          category['name'] as String,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedVendors() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Featured Vendors',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    _showComingSoon('Vendor List');
                  },
                  child: Text(
                    'View All',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryGreen,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: _featuredVendors.length,
              itemBuilder: (context, index) {
                final vendor = _featuredVendors[index];
                return GestureDetector(
                  onTap: () => _navigateToVendor(vendor),
                  child: Container(
                    width: 160,
                    margin: const EdgeInsets.only(right: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.borderColor),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Vendor image
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(12)),
                          child: Container(
                            height: 100,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: AppColors.backgroundColor,
                              image: DecorationImage(
                                image: AssetImage(vendor.image),
                                fit: BoxFit.cover,
                                onError: (exception, stackTrace) {},
                              ),
                            ),
                            child: vendor.image.startsWith('assets')
                                ? null
                                : Container(
                                    color: AppColors.primaryGreen
                                        .withValues(alpha: 0.1),
                                    child: const Icon(
                                      Icons.restaurant,
                                      color: AppColors.primaryGreen,
                                      size: 40,
                                    ),
                                  ),
                          ),
                        ),

                        // Vendor info
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                vendor.name,
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.star,
                                    color: AppColors.starYellow,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    vendor.rating.toString(),
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '${vendor.preparationTime} min',
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                vendor.cuisineTypes.join(', '),
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  color: AppColors.textSecondary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAllVendors() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              'All Vendors',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: _vendors.length,
            itemBuilder: (context, index) {
              final vendor = _vendors[index];
              return GestureDetector(
                onTap: () => _navigateToVendor(vendor),
                child: Container(
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
                      // Vendor image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: AppColors.backgroundColor,
                            image: DecorationImage(
                              image: AssetImage(vendor.image),
                              fit: BoxFit.cover,
                              onError: (exception, stackTrace) {},
                            ),
                          ),
                          child: vendor.image.startsWith('assets')
                              ? null
                              : Container(
                                  color: AppColors.primaryGreen
                                      .withValues(alpha: 0.1),
                                  child: const Icon(
                                    Icons.restaurant,
                                    color: AppColors.primaryGreen,
                                    size: 30,
                                  ),
                                ),
                        ),
                      ),

                      const SizedBox(width: 16),

                      // Vendor info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    vendor.name,
                                    style: GoogleFonts.inter(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: vendor.isOpen
                                        ? Colors.green
                                        : Colors.red,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    vendor.isOpen ? 'OPEN' : 'CLOSED',
                                    style: GoogleFonts.inter(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              vendor.description,
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
                                const Icon(
                                  Icons.star,
                                  color: AppColors.starYellow,
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  vendor.rating.toString(),
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                const Icon(
                                  Icons.access_time,
                                  color: AppColors.textSecondary,
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${vendor.preparationTime} min',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                const Icon(
                                  Icons.location_on,
                                  color: AppColors.textSecondary,
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    '${vendor.distance} km',
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _navigateToVendor(VendorModel vendor) {
    _showComingSoon('Vendor Details for ${vendor.name}');
  }

  void _navigateToCategory(String category) {
    _showComingSoon('$category Category');
  }

  void _showUserMenu() {
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
            ListTile(
              leading: const Icon(Icons.person, color: AppColors.primaryGreen),
              title: Text(
                'Profile',
                style: GoogleFonts.inter(fontWeight: FontWeight.w600),
              ),
              onTap: () {
                Navigator.pop(context);
                _showComingSoon('Profile');
              },
            ),
            ListTile(
              leading:
                  const Icon(Icons.settings, color: AppColors.primaryGreen),
              title: Text(
                'Settings',
                style: GoogleFonts.inter(fontWeight: FontWeight.w600),
              ),
              onTap: () {
                Navigator.pop(context);
                _showComingSoon('Settings');
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: Text(
                'Logout',
                style: GoogleFonts.inter(fontWeight: FontWeight.w600),
              ),
              onTap: () {
                Navigator.pop(context);
                _showLogoutDialog();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text(
            'Logout',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Are you sure you want to logout?',
            style: GoogleFonts.inter(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: GoogleFonts.inter(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                try {
                  // Use instance method instead of static
                  final authService =
                      Provider.of<AuthService>(context, listen: false);
                  await authService.logout();

                  if (mounted) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WelcomeScreen(),
                      ),
                      (route) => false,
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    _showError('Logout failed. Please try again.');
                  }
                }
              },
              child: Text(
                'Logout',
                style: GoogleFonts.inter(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$feature feature is coming soon!',
          style: GoogleFonts.inter(),
        ),
        backgroundColor: AppColors.primaryGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.inter(),
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
