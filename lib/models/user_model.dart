// lib/models/user_model.dart
class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? profileImage;
  final double walletBalance;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.profileImage,
    this.walletBalance = 0.0,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'profileImage': profileImage,
      'walletBalance': walletBalance,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      profileImage: json['profileImage'],
      walletBalance: json['walletBalance']?.toDouble() ?? 0.0,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
