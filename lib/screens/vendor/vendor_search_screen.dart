import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../utils/app_colors.dart';
import '../../utils/helpers.dart';
import '../../services/vendor_service.dart';
import '../../models/vendor_model.dart';
import '../../models/food_item_model.dart';
import 'vendor_detail_screen.dart';
import 'food_item_detail_screen.dart';

class VendorSearchScreen extends StatefulWidget {
  const VendorSearchScreen({super.key});

  @override
  State<VendorSearchScreen> createState() => _VendorSearchScreenState();
}

class _VendorSearchScreenState extends State<VendorSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  List<VendorModel> _vendors = [];
  List<FoodItemModel> _allFoodItems = [];
  List<dynamic> _searchResults = [];
  List<String> _recentSearches = ['Pizza', 'Burger', 'Biryani', 'Sandwich'];
  List<String> _popularSearches = [
    'Pizza Corner',
    'Healthy Bowls',
    'Chinese',
    'Fast Food'
  ];

  bool _isSearching = false;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadData();
    _searchFocusNode.requestFocus();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _loadData() {
    _vendors = VendorService.getDummyVendors();

    // Load all food items from all vendors
    for (final vendor in _vendors) {
      _allFoodItems.addAll(VendorService.getDummyFoodItems(vendor.id));
    }
  }

  void _performSearch(String query) {
    setState(() {
      _searchQuery = query;
      _isSearching = query.isNotEmpty;

      if (query.isEmpty) {
        _searchResults.clear();
        return;
      }

      _searchResults.clear();

      // Search in vendors
      final matchingVendors = _vendors
          .where((vendor) =>
              vendor.name.toLowerCase().contains(query.toLowerCase()) ||
              vendor.description.toLowerCase().contains(query.toLowerCase()) ||
              vendor.cuisineTypes.any((cuisine) =>
                  cuisine.toLowerCase().contains(query.toLowerCase())))
          .toList();

      // Search in food items
      final matchingFoodItems = _allFoodItems
          .where((item) =>
              item.name.toLowerCase().contains(query.toLowerCase()) ||
              item.description.toLowerCase().contains(query.toLowerCase()) ||
              item.category.toLowerCase().contains(query.toLowerCase()) ||
              item.tags.any(
                  (tag) => tag.toLowerCase().contains(query.toLowerCase())))
          .toList();

      _searchResults.addAll(matchingVendors);
      _searchResults.addAll(matchingFoodItems);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Search Header
            _buildSearchHeader(),

            // Search Results or Suggestions
            Expanded(
              child: _isSearching
                  ? _buildSearchResults()
                  : _buildSearchSuggestions(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          // Back Button
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.backgroundColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.arrow_back_ios,
                color: AppColors.textPrimary,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 16),

          // Search Field
          Expanded(
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              onChanged: _performSearch,
              style: GoogleFonts.inter(
                fontSize: 16,
                color: AppColors.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: 'Search vendors, food items...',
                hintStyle: GoogleFonts.inter(
                  color: AppColors.textSecondary,
                ),
                filled: true,
                fillColor: AppColors.backgroundColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AppColors.primaryGreen,
                    width: 2,
                  ),
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  color: AppColors.textSecondary,
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(
                          Icons.clear,
                          color: AppColors.textSecondary,
                        ),
                        onPressed: () {
                          _searchController.clear();
                          _performSearch('');
                        },
                      )
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchSuggestions() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Recent Searches
          if (_recentSearches.isNotEmpty) ...[
            _buildSectionHeader('Recent Searches', () {
              setState(() {
                _recentSearches.clear();
              });
            }),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _recentSearches.map((search) {
                return _buildSearchChip(
                  search,
                  Icons.access_time,
                  () => _performSearch(search),
                );
              }).toList(),
            ),
            const SizedBox(height: 32),
          ],

          // Popular Searches
          _buildSectionHeader('Popular Searches', null),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _popularSearches.map((search) {
              return _buildSearchChip(
                search,
                Icons.trending_up,
                () => _performSearch(search),
              );
            }).toList(),
          ),
          const SizedBox(height: 32),

          // Categories
          _buildSectionHeader('Browse Categories', null),
          const SizedBox(height: 12),
          _buildCategoriesGrid(),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, VoidCallback? onAction) {
    return Row(
      children: [
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const Spacer(),
        if (onAction != null)
          TextButton(
            onPressed: onAction,
            child: Text(
              'Clear',
              style: GoogleFonts.inter(
                color: AppColors.primaryGreen,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSearchChip(String text, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.backgroundColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.borderColor),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: AppColors.textSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoriesGrid() {
    final categories = [
      {'name': 'Pizza', 'icon': Icons.local_pizza, 'color': Colors.red},
      {'name': 'Burger', 'icon': Icons.lunch_dining, 'color': Colors.orange},
      {'name': 'Indian', 'icon': Icons.restaurant, 'color': Colors.green},
      {
        'name': 'Chinese',
        'icon': Icons.rice_bowl,
        'color': Colors.yellow.shade700
      },
      {'name': 'Beverages', 'icon': Icons.local_drink, 'color': Colors.blue},
      {'name': 'Desserts', 'icon': Icons.cake, 'color': Colors.pink},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return GestureDetector(
          onTap: () => _performSearch(category['name'] as String),
          child: Container(
            decoration: BoxDecoration(
              color: (category['color'] as Color).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: (category['color'] as Color).withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  category['icon'] as IconData,
                  size: 32,
                  color: category['color'] as Color,
                ),
                const SizedBox(height: 8),
                Text(
                  category['name'] as String,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSearchResults() {
    if (_searchResults.isEmpty) {
      return _buildNoResults();
    }

    // Group results by type
    final vendors = _searchResults.whereType<VendorModel>().toList();
    final foodItems = _searchResults.whereType<FoodItemModel>().toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Results count
          Text(
            'Found ${_searchResults.length} results for "$_searchQuery"',
            style: GoogleFonts.inter(
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 20),

          // Vendors
          if (vendors.isNotEmpty) ...[
            Text(
              'Vendors (${vendors.length})',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            AnimationLimiter(
              child: Column(
                children: vendors.map((vendor) {
                  final index = vendors.indexOf(vendor);
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 375),
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child: _buildVendorSearchResult(vendor),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),
          ],

          // Food Items
          if (foodItems.isNotEmpty) ...[
            Text(
              'Food Items (${foodItems.length})',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            AnimationLimiter(
              child: Column(
                children: foodItems.map((foodItem) {
                  final index = foodItems.indexOf(foodItem);
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 375),
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child: _buildFoodItemSearchResult(foodItem),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildVendorSearchResult(VendorModel vendor) {
    return GestureDetector(
      onTap: () {
        // Add to recent searches
        if (!_recentSearches.contains(vendor.name)) {
          setState(() {
            _recentSearches.insert(0, vendor.name);
            if (_recentSearches.length > 5) {
              _recentSearches = _recentSearches.take(5).toList();
            }
          });
        }

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VendorDetailScreen(vendor: vendor),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
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
                width: 60,
                height: 60,
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
                        color: AppColors.primaryGreen.withValues(alpha: 0.1),
                        child: const Icon(
                          Icons.restaurant,
                          color: AppColors.primaryGreen,
                          size: 30,
                        ),
                      ),
              ),
            ),
            const SizedBox(width: 16),

            // Vendor Info
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
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: vendor.isOpen ? Colors.green : Colors.red,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          vendor.isOpen ? 'OPEN' : 'CLOSED',
                          style: GoogleFonts.inter(
                            fontSize: 8,
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
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Colors.orange,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        vendor.rating.toString(),
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Icon(
                        Icons.access_time,
                        color: AppColors.textSecondary,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${vendor.preparationTime} min',
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
      ),
    );
  }

  Widget _buildFoodItemSearchResult(FoodItemModel foodItem) {
    final vendor = _vendors.firstWhere((v) => v.id == foodItem.vendorId);

    return GestureDetector(
      onTap: () {
        // Add to recent searches
        if (!_recentSearches.contains(foodItem.name)) {
          setState(() {
            _recentSearches.insert(0, foodItem.name);
            if (_recentSearches.length > 5) {
              _recentSearches = _recentSearches.take(5).toList();
            }
          });
        }

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FoodItemDetailScreen(
              foodItem: foodItem,
              vendor: vendor,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
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
                width: 60,
                height: 60,
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

            // Food Info
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
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'From ${vendor.name}',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppColors.primaryGreen,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    foodItem.description,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        AppHelpers.formatCurrency(foodItem.price),
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryGreen,
                        ),
                      ),
                      const Spacer(),
                      if (foodItem.rating > 0) ...[
                        const Icon(
                          Icons.star,
                          color: Colors.orange,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          foodItem.rating.toString(),
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoResults() {
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
              Icons.search_off,
              color: AppColors.primaryGreen,
              size: 40,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'No results found',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try searching with different keywords or\nbrowse our categories',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              _searchController.clear();
              _performSearch('');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Clear Search',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
