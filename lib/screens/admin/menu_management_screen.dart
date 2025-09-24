import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../utils/app_colors.dart';
import '../../utils/helpers.dart';
import '../../models/food_item_model.dart';
import '../../widgets/common/custom_button.dart';

class MenuManagementScreen extends StatefulWidget {
  const MenuManagementScreen({super.key});

  @override
  State<MenuManagementScreen> createState() => _MenuManagementScreenState();
}

class _MenuManagementScreenState extends State<MenuManagementScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedCategory = 'All';

  // Mock menu items
  List<FoodItemModel> _menuItems = [
    FoodItemModel(
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
      tags: ['Popular', 'Cheesy'],
    ),
    FoodItemModel(
      id: '2',
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
      tags: ['Spicy', 'Non-veg'],
    ),
    FoodItemModel(
      id: '3',
      vendorId: '1',
      name: 'Garlic Bread',
      description: 'Crispy bread with garlic butter and herbs',
      price: 149.0,
      image: 'assets/images/food/garlic_bread.jpg',
      category: 'Sides',
      isVegetarian: true,
      isAvailable: false,
      preparationTime: 8,
      rating: 4.1,
      tags: ['Side dish'],
    ),
  ];

  final List<String> _categories = [
    'All',
    'Pizza',
    'Sides',
    'Beverages',
    'Desserts'
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

  List<FoodItemModel> get _filteredItems {
    if (_selectedCategory == 'All') {
      return _menuItems;
    }
    return _menuItems
        .where((item) => item.category == _selectedCategory)
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
          'Menu Management',
          style: GoogleFonts.inter(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => _addNewItem(),
            icon: const Icon(Icons.add, color: AppColors.primaryGreen),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primaryGreen,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primaryGreen,
          labelStyle: GoogleFonts.inter(fontWeight: FontWeight.w600),
          unselectedLabelStyle: GoogleFonts.inter(),
          tabs: const [
            Tab(text: 'Menu Items'),
            Tab(text: 'Categories'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildMenuItemsTab(),
          _buildCategoriesTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addNewItem(),
        backgroundColor: AppColors.primaryGreen,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildMenuItemsTab() {
    return Column(
      children: [
        // Category Filter
        _buildCategoryFilter(),

        // Menu Items List
        Expanded(
          child: _buildMenuItemsList(),
        ),
      ],
    );
  }

  Widget _buildCategoryFilter() {
    return Container(
      height: 50,
      margin: const EdgeInsets.all(16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = _selectedCategory == category;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedCategory = category;
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
              child: Text(
                category,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isSelected ? Colors.white : AppColors.textPrimary,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMenuItemsList() {
    final items = _filteredItems;

    if (items.isEmpty) {
      return _buildEmptyState();
    }

    return AnimationLimiter(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: items.length,
        itemBuilder: (context, index) {
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 375),
            child: SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: _buildMenuItemCard(items[index]),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMenuItemCard(FoodItemModel item) {
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
          Row(
            children: [
              // Item Image
              ClipRRect(
                borderRadius:
                    const BorderRadius.horizontal(left: Radius.circular(12)),
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppColors.backgroundColor,
                    image: DecorationImage(
                      image: AssetImage(item.image),
                      fit: BoxFit.cover,
                      onError: (exception, stackTrace) {},
                    ),
                  ),
                  child: item.image.startsWith('assets')
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

              // Item Details
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              item.name,
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          Switch(
                            value: item.isAvailable,
                            onChanged: (value) =>
                                _toggleAvailability(item.id, value),
                            activeColor: AppColors.primaryGreen,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.description,
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
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color:
                                  item.isVegetarian ? Colors.green : Colors.red,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            AppHelpers.formatCurrency(item.price),
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryGreen,
                            ),
                          ),
                          const Spacer(),
                          if (item.rating > 0) ...[
                            const Icon(Icons.star,
                                color: Colors.amber, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              item.rating.toString(),
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
              ),
            ],
          ),

          // Action Buttons
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: AppColors.backgroundColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _editItem(item),
                    icon: const Icon(Icons.edit, size: 16),
                    label: const Text('Edit'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primaryGreen,
                      side: const BorderSide(color: AppColors.primaryGreen),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _deleteItem(item.id),
                    icon: const Icon(Icons.delete, size: 16),
                    label: const Text('Delete'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesTab() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Manage Categories',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: _categories.length - 1, // Exclude 'All'
              itemBuilder: (context, index) {
                final category = _categories[index + 1];
                final itemCount = _menuItems
                    .where((item) => item.category == category)
                    .length;

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.borderColor),
                  ),
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
                          Icons.category,
                          color: AppColors.primaryGreen,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              category,
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            Text(
                              '$itemCount items',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => _editCategory(category),
                        icon: const Icon(Icons.edit,
                            color: AppColors.primaryGreen),
                      ),
                      IconButton(
                        onPressed: () => _deleteCategory(category),
                        icon: const Icon(Icons.delete, color: Colors.red),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          CustomButton(
            text: 'Add New Category',
            onPressed: () => _addNewCategory(),
            isOutlined: true,
          ),
        ],
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
              Icons.restaurant_menu,
              color: AppColors.primaryGreen,
              size: 40,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'No items in this category',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add items to your menu to get started',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => _addNewItem(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Add Item',
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

  void _toggleAvailability(String itemId, bool isAvailable) {
    setState(() {
      final itemIndex = _menuItems.indexWhere((item) => item.id == itemId);
      if (itemIndex != -1) {
        _menuItems[itemIndex] =
            _menuItems[itemIndex].copyWith(isAvailable: isAvailable);
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isAvailable
            ? 'Item marked as available'
            : 'Item marked as unavailable'),
        backgroundColor: AppColors.primaryGreen,
      ),
    );
  }

  void _addNewItem() {
    _showItemDialog(null);
  }

  void _editItem(FoodItemModel item) {
    _showItemDialog(item);
  }

  void _showItemDialog(FoodItemModel? item) {
    final nameController = TextEditingController(text: item?.name ?? '');
    final descriptionController =
        TextEditingController(text: item?.description ?? '');
    final priceController =
        TextEditingController(text: item?.price.toString() ?? '');
    String selectedCategory = item?.category ?? _categories[1];
    bool isVegetarian = item?.isVegetarian ?? true;
    bool isAvailable = item?.isAvailable ?? true;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Text(
            item == null ? 'Add New Item' : 'Edit Item',
            style: GoogleFonts.inter(fontWeight: FontWeight.bold),
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Item Name',
                      labelStyle: GoogleFonts.inter(),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: descriptionController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'Description',
                      labelStyle: GoogleFonts.inter(),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: priceController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Price',
                      labelStyle: GoogleFonts.inter(),
                      prefixText: '₹ ',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: selectedCategory,
                    decoration: InputDecoration(
                      labelText: 'Category',
                      labelStyle: GoogleFonts.inter(),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    items: _categories.skip(1).map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(category, style: GoogleFonts.inter()),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setDialogState(() {
                        selectedCategory = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: CheckboxListTile(
                          title: Text('Vegetarian',
                              style: GoogleFonts.inter(fontSize: 14)),
                          value: isVegetarian,
                          onChanged: (value) {
                            setDialogState(() {
                              isVegetarian = value!;
                            });
                          },
                          activeColor: AppColors.primaryGreen,
                        ),
                      ),
                      Expanded(
                        child: CheckboxListTile(
                          title: Text('Available',
                              style: GoogleFonts.inter(fontSize: 14)),
                          value: isAvailable,
                          onChanged: (value) {
                            setDialogState(() {
                              isAvailable = value!;
                            });
                          },
                          activeColor: AppColors.primaryGreen,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel',
                  style: GoogleFonts.inter(color: AppColors.textSecondary)),
            ),
            TextButton(
              onPressed: () {
                if (nameController.text.trim().isEmpty ||
                    descriptionController.text.trim().isEmpty ||
                    priceController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please fill all fields'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                final price = double.tryParse(priceController.text) ?? 0.0;
                if (price <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter a valid price'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                setState(() {
                  if (item == null) {
                    // Add new item
                    final newItem = FoodItemModel(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      vendorId: '1',
                      name: nameController.text.trim(),
                      description: descriptionController.text.trim(),
                      price: price,
                      image: 'assets/images/food/default.jpg',
                      category: selectedCategory,
                      isVegetarian: isVegetarian,
                      isAvailable: isAvailable,
                      preparationTime: 15,
                      rating: 0.0,
                      tags: [],
                    );
                    _menuItems.add(newItem);
                  } else {
                    // Update existing item
                    final itemIndex =
                        _menuItems.indexWhere((i) => i.id == item.id);
                    if (itemIndex != -1) {
                      _menuItems[itemIndex] = item.copyWith(
                        name: nameController.text.trim(),
                        description: descriptionController.text.trim(),
                        price: price,
                        category: selectedCategory,
                        isVegetarian: isVegetarian,
                        isAvailable: isAvailable,
                      );
                    }
                  }
                });

                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(item == null
                        ? 'Item added successfully'
                        : 'Item updated successfully'),
                    backgroundColor: AppColors.primaryGreen,
                  ),
                );
              },
              child: Text(
                item == null ? 'Add' : 'Update',
                style: GoogleFonts.inter(
                  color: AppColors.primaryGreen,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _deleteItem(String itemId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text('Delete Item',
            style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
        content: Text(
          'Are you sure you want to delete this item? This action cannot be undone.',
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
                _menuItems.removeWhere((item) => item.id == itemId);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Item deleted successfully'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: Text(
              'Delete',
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

  void _addNewCategory() {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text('Add New Category',
            style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: 'Category Name',
            labelStyle: GoogleFonts.inter(),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel',
                style: GoogleFonts.inter(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              final categoryName = controller.text.trim();
              if (categoryName.isEmpty) return;

              if (!_categories.contains(categoryName)) {
                setState(() {
                  _categories.add(categoryName);
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Category added successfully'),
                    backgroundColor: AppColors.primaryGreen,
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Category already exists'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: Text(
              'Add',
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

  void _editCategory(String category) {
    final controller = TextEditingController(text: category);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text('Edit Category',
            style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: 'Category Name',
            labelStyle: GoogleFonts.inter(),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel',
                style: GoogleFonts.inter(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              final newCategoryName = controller.text.trim();
              if (newCategoryName.isEmpty || newCategoryName == category)
                return;

              setState(() {
                final categoryIndex = _categories.indexOf(category);
                if (categoryIndex != -1) {
                  _categories[categoryIndex] = newCategoryName;
                  // Update all items with this category
                  for (int i = 0; i < _menuItems.length; i++) {
                    if (_menuItems[i].category == category) {
                      _menuItems[i] =
                          _menuItems[i].copyWith(category: newCategoryName);
                    }
                  }
                }
              });

              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Category updated successfully'),
                  backgroundColor: AppColors.primaryGreen,
                ),
              );
            },
            child: Text(
              'Update',
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

  void _deleteCategory(String category) {
    final itemsInCategory =
        _menuItems.where((item) => item.category == category).length;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text('Delete Category',
            style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
        content: Text(
          itemsInCategory > 0
              ? 'This category has $itemsInCategory items. Deleting it will move all items to "Pizza" category. Continue?'
              : 'Are you sure you want to delete this category?',
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
                // Move items to default category
                for (int i = 0; i < _menuItems.length; i++) {
                  if (_menuItems[i].category == category) {
                    _menuItems[i] = _menuItems[i].copyWith(category: 'Pizza');
                  }
                }
                _categories.remove(category);
                if (_selectedCategory == category) {
                  _selectedCategory = 'All';
                }
              });

              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Category deleted successfully'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: Text(
              'Delete',
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
