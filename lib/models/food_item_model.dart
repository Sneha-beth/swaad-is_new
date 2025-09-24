class FoodItemModel {
  final String id;
  final String vendorId;
  final String name;
  final String description;
  final double price;
  final String image;
  final String category;
  final bool isVegetarian;
  final bool isAvailable;
  final int preparationTime;
  final double rating;
  final List<String> tags;

  FoodItemModel({
    required this.id,
    required this.vendorId,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    required this.category,
    required this.isVegetarian,
    required this.isAvailable,
    required this.preparationTime,
    required this.rating,
    required this.tags,
  });

  FoodItemModel copyWith({
    String? id,
    String? vendorId,
    String? name,
    String? description,
    double? price,
    String? image,
    String? category,
    bool? isVegetarian,
    bool? isAvailable,
    int? preparationTime,
    double? rating,
    List<String>? tags,
  }) {
    return FoodItemModel(
      id: id ?? this.id,
      vendorId: vendorId ?? this.vendorId,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      image: image ?? this.image,
      category: category ?? this.category,
      isVegetarian: isVegetarian ?? this.isVegetarian,
      isAvailable: isAvailable ?? this.isAvailable,
      preparationTime: preparationTime ?? this.preparationTime,
      rating: rating ?? this.rating,
      tags: tags ?? this.tags,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vendorId': vendorId,
      'name': name,
      'description': description,
      'price': price,
      'image': image,
      'category': category,
      'isVegetarian': isVegetarian,
      'isAvailable': isAvailable,
      'preparationTime': preparationTime,
      'rating': rating,
      'tags': tags,
    };
  }

  factory FoodItemModel.fromJson(Map<String, dynamic> json) {
    return FoodItemModel(
      id: json['id'],
      vendorId: json['vendorId'],
      name: json['name'],
      description: json['description'],
      price: json['price'].toDouble(),
      image: json['image'],
      category: json['category'],
      isVegetarian: json['isVegetarian'],
      isAvailable: json['isAvailable'],
      preparationTime: json['preparationTime'],
      rating: json['rating'].toDouble(),
      tags: List<String>.from(json['tags']),
    );
  }
}
