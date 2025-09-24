import '../models/vendor_model.dart';
import '../models/food_item_model.dart';

class VendorService {
  static List<VendorModel> getDummyVendors() {
    return [
      VendorModel(
        id: '1',
        name: 'Pizza Corner',
        description: 'Authentic Italian pizzas with fresh ingredients',
        image: 'assets/images/vendors/pizza_corner.jpg',
        rating: 4.5,
        deliveryTime: '15-20',
        preparationTime: 15,
        location: 'Food Court, Campus',
        cuisineTypes: ['Italian', 'Fast Food'],
        isOpen: true,
        priceRange: '\$',
        distance: 0.2,
        openTime: '9:00 AM',
        closeTime: '10:00 PM',
        reviewCount: 245,
      ),
      VendorModel(
        id: '2',
        name: 'Burger Hub',
        description: 'Juicy burgers and crispy fries',
        image: 'assets/images/vendors/burger_hub.jpg',
        rating: 4.3,
        deliveryTime: '20-25',
        preparationTime: 20,
        location: 'Main Street, Campus',
        cuisineTypes: ['American', 'Fast Food'],
        isOpen: true,
        priceRange: '\$',
        distance: 0.3,
        openTime: '10:00 AM',
        closeTime: '11:00 PM',
        reviewCount: 189,
      ),
      VendorModel(
        id: '3',
        name: 'Healthy Bowls',
        description: 'Fresh and nutritious bowl meals',
        image: 'assets/images/vendors/healthy_bowls.jpg',
        rating: 4.7,
        deliveryTime: '25-30',
        preparationTime: 25,
        location: 'Health Center, Campus',
        cuisineTypes: ['Healthy', 'Salads'],
        isOpen: true,
        priceRange: '\$\$',
        distance: 0.5,
        openTime: '8:00 AM',
        closeTime: '9:00 PM',
        reviewCount: 156,
      ),
      VendorModel(
        id: '4',
        name: 'Desi Tadka',
        description: 'Authentic Indian cuisine with traditional flavors',
        image: 'assets/images/vendors/desi_tadka.jpg',
        rating: 4.4,
        deliveryTime: '30-35',
        preparationTime: 30,
        location: 'Hostel Area, Campus',
        cuisineTypes: ['Indian', 'Spicy'],
        isOpen: false,
        priceRange: '\$',
        distance: 0.7,
        openTime: '11:00 AM',
        closeTime: '10:00 PM',
        reviewCount: 201,
      ),
    ];
  }

  static List<FoodItemModel> getDummyFoodItems(String vendorId) {
    switch (vendorId) {
      case '1': // Pizza Corner
        return [
          FoodItemModel(
            id: '1',
            vendorId: vendorId,
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
            vendorId: vendorId,
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
        ];
      case '2': // Burger Hub
        return [
          FoodItemModel(
            id: '3',
            vendorId: vendorId,
            name: 'Classic Burger',
            description: 'Juicy beef patty with lettuce and tomato',
            price: 199.0,
            image: 'assets/images/food/classic_burger.jpg',
            category: 'Burger',
            isVegetarian: false,
            isAvailable: true,
            preparationTime: 12,
            rating: 4.2,
            tags: ['Classic', 'Juicy'],
          ),
        ];
      default:
        return [];
    }
  }
}
