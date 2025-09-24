class VendorModel {
  final String id;
  final String name;
  final String description;
  final String image;
  final double rating;
  final String deliveryTime;
  final int preparationTime;
  final String location;
  final List<String> cuisineTypes;
  final bool isOpen;
  final String priceRange;
  final double distance;
  final String? openTime;
  final String? closeTime;
  final int? reviewCount;

  VendorModel({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.rating,
    required this.deliveryTime,
    required this.preparationTime,
    required this.location,
    required this.cuisineTypes,
    required this.isOpen,
    required this.priceRange,
    required this.distance,
    this.openTime,
    this.closeTime,
    this.reviewCount,
  });

  VendorModel copyWith({
    String? id,
    String? name,
    String? description,
    String? image,
    double? rating,
    String? deliveryTime,
    int? preparationTime,
    String? location,
    List<String>? cuisineTypes,
    bool? isOpen,
    String? priceRange,
    double? distance,
    String? openTime,
    String? closeTime,
    int? reviewCount,
  }) {
    return VendorModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      image: image ?? this.image,
      rating: rating ?? this.rating,
      deliveryTime: deliveryTime ?? this.deliveryTime,
      preparationTime: preparationTime ?? this.preparationTime,
      location: location ?? this.location,
      cuisineTypes: cuisineTypes ?? this.cuisineTypes,
      isOpen: isOpen ?? this.isOpen,
      priceRange: priceRange ?? this.priceRange,
      distance: distance ?? this.distance,
      openTime: openTime ?? this.openTime,
      closeTime: closeTime ?? this.closeTime,
      reviewCount: reviewCount ?? this.reviewCount,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image': image,
      'rating': rating,
      'deliveryTime': deliveryTime,
      'preparationTime': preparationTime,
      'location': location,
      'cuisineTypes': cuisineTypes,
      'isOpen': isOpen,
      'priceRange': priceRange,
      'distance': distance,
      'openTime': openTime,
      'closeTime': closeTime,
      'reviewCount': reviewCount,
    };
  }

  factory VendorModel.fromJson(Map<String, dynamic> json) {
    return VendorModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      image: json['image'],
      rating: json['rating'].toDouble(),
      deliveryTime: json['deliveryTime'],
      preparationTime: json['preparationTime'],
      location: json['location'],
      cuisineTypes: List<String>.from(json['cuisineTypes']),
      isOpen: json['isOpen'],
      priceRange: json['priceRange'],
      distance: json['distance'].toDouble(),
      openTime: json['openTime'],
      closeTime: json['closeTime'],
      reviewCount: json['reviewCount'],
    );
  }
}
