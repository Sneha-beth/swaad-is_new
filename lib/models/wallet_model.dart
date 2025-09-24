// lib/models/wallet_model.dart
enum TransactionType { topup, payment, refund, cashback }

class WalletTransactionModel {
  final String id;
  final String userId;
  final double amount;
  final TransactionType type;
  final String description;
  final DateTime createdAt;
  final String? orderId;
  final String? paymentMethod;

  WalletTransactionModel({
    required this.id,
    required this.userId,
    required this.amount,
    required this.type,
    required this.description,
    required this.createdAt,
    this.orderId,
    this.paymentMethod,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'amount': amount,
      'type': type.toString().split('.').last,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'orderId': orderId,
      'paymentMethod': paymentMethod,
    };
  }

  factory WalletTransactionModel.fromJson(Map<String, dynamic> json) {
    return WalletTransactionModel(
      id: json['id'],
      userId: json['userId'],
      amount: json['amount']?.toDouble() ?? 0.0,
      type: TransactionType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => TransactionType.payment,
      ),
      description: json['description'],
      createdAt: DateTime.parse(json['createdAt']),
      orderId: json['orderId'],
      paymentMethod: json['paymentMethod'],
    );
  }
}
