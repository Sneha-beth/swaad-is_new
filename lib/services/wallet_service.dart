// lib/services/wallet_service.dart
import 'package:flutter/foundation.dart';
import '../models/wallet_model.dart';
import '../models/user_model.dart';

class WalletService extends ChangeNotifier {
  double _balance = 500.0; // Default balance
  final List<WalletTransactionModel> _transactions = [];

  double get balance => _balance;
  List<WalletTransactionModel> get transactions => _transactions;

  // Initialize with some dummy data
  WalletService() {
    _initializeDummyData();
  }

  void _initializeDummyData() {
    _transactions.addAll([
      WalletTransactionModel(
        id: '1',
        userId: 'user1',
        amount: 500.0,
        type: TransactionType.topup,
        description: 'Wallet Top-up via UPI',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        paymentMethod: 'UPI',
      ),
      WalletTransactionModel(
        id: '2',
        userId: 'user1',
        amount: -150.0,
        type: TransactionType.payment,
        description: 'Order Payment - Pizza Corner',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        orderId: 'ORD123',
      ),
      WalletTransactionModel(
        id: '3',
        userId: 'user1',
        amount: 25.0,
        type: TransactionType.cashback,
        description: 'Cashback on order',
        createdAt: DateTime.now().subtract(const Duration(hours: 12)),
        orderId: 'ORD123',
      ),
    ]);
  }

  Future<bool> addMoney(double amount, String paymentMethod) async {
    try {
      // Simulate payment processing
      await Future.delayed(const Duration(seconds: 2));

      _balance += amount;

      final transaction = WalletTransactionModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: 'current_user',
        amount: amount,
        type: TransactionType.topup,
        description: 'Wallet Top-up via $paymentMethod',
        createdAt: DateTime.now(),
        paymentMethod: paymentMethod,
      );

      _transactions.insert(0, transaction);
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deductMoney(double amount, String description,
      {String? orderId}) async {
    if (_balance < amount) {
      return false; // Insufficient balance
    }

    _balance -= amount;

    final transaction = WalletTransactionModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: 'current_user',
      amount: -amount,
      type: TransactionType.payment,
      description: description,
      createdAt: DateTime.now(),
      orderId: orderId,
    );

    _transactions.insert(0, transaction);
    notifyListeners();
    return true;
  }

  Future<void> addRefund(double amount, String orderId) async {
    _balance += amount;

    final transaction = WalletTransactionModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: 'current_user',
      amount: amount,
      type: TransactionType.refund,
      description: 'Order refund',
      createdAt: DateTime.now(),
      orderId: orderId,
    );

    _transactions.insert(0, transaction);
    notifyListeners();
  }

  Future<void> addCashback(double amount, String orderId) async {
    _balance += amount;

    final transaction = WalletTransactionModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: 'current_user',
      amount: amount,
      type: TransactionType.cashback,
      description: 'Cashback on order',
      createdAt: DateTime.now(),
      orderId: orderId,
    );

    _transactions.insert(0, transaction);
    notifyListeners();
  }
}
