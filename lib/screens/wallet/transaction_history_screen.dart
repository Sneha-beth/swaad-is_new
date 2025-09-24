import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/helpers.dart';
import '../../services/wallet_service.dart';
import '../../models/wallet_model.dart';

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  State<TransactionHistoryScreen> createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  String _selectedFilter = 'All';
  final List<String> _filterOptions = [
    'All',
    'Top-up',
    'Payment',
    'Refund',
    'Cashback'
  ];

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
          'Transaction History',
          style: GoogleFonts.inter(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Consumer<WalletService>(
        builder: (context, walletService, child) {
          return Column(
            children: [
              // Summary Card
              _buildSummaryCard(walletService),

              // Filter Chips
              _buildFilterChips(),

              // Transactions List
              Expanded(
                child: _buildTransactionsList(walletService),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSummaryCard(WalletService walletService) {
    final totalTopUp = walletService.transactions
        .where((t) => t.type == TransactionType.topup)
        .fold(0.0, (sum, t) => sum + t.amount);

    final totalSpent = walletService.transactions
        .where((t) => t.type == TransactionType.payment)
        .fold(0.0, (sum, t) => sum + t.amount.abs());

    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryGreen.withValues(alpha: 0.1),
            AppColors.lightGreen.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primaryGreen.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildSummaryItem(
              title: 'Total Added',
              amount: totalTopUp,
              color: Colors.green,
              icon: Icons.trending_up,
            ),
          ),
          Container(
            width: 1,
            height: 40,
            color: AppColors.borderColor,
          ),
          Expanded(
            child: _buildSummaryItem(
              title: 'Total Spent',
              amount: totalSpent,
              color: Colors.orange,
              icon: Icons.trending_down,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem({
    required String title,
    required double amount,
    required Color color,
    required IconData icon,
  }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 4),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          AppHelpers.formatCurrency(amount),
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChips() {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _filterOptions.length,
        itemBuilder: (context, index) {
          final option = _filterOptions[index];
          final isSelected = _selectedFilter == option;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedFilter = option;
              });
            },
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primaryGreen
                    : AppColors.backgroundColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primaryGreen
                      : AppColors.borderColor,
                ),
              ),
              child: Text(
                option,
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

  Widget _buildTransactionsList(WalletService walletService) {
    List<WalletTransactionModel> filteredTransactions =
        walletService.transactions;

    if (_selectedFilter != 'All') {
      final filterType = TransactionType.values.firstWhere(
        (type) =>
            type.toString().split('.').last.toLowerCase() ==
            _selectedFilter.toLowerCase().replaceAll('-', ''),
        orElse: () => TransactionType.payment,
      );
      filteredTransactions = walletService.transactions
          .where((t) => t.type == filterType)
          .toList();
    }

    if (filteredTransactions.isEmpty) {
      return _buildEmptyState();
    }

    // Group transactions by date
    final groupedTransactions = <String, List<WalletTransactionModel>>{};
    for (final transaction in filteredTransactions) {
      final dateKey = AppHelpers.formatDate(transaction.createdAt);
      if (!groupedTransactions.containsKey(dateKey)) {
        groupedTransactions[dateKey] = [];
      }
      groupedTransactions[dateKey]!.add(transaction);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: groupedTransactions.length,
      itemBuilder: (context, index) {
        final dateKey = groupedTransactions.keys.elementAt(index);
        final transactions = groupedTransactions[dateKey]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date Header
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                dateKey,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            // Transactions for this date
            ...transactions
                .map((transaction) => _buildTransactionItem(transaction))
                .toList(),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }

  Widget _buildTransactionItem(WalletTransactionModel transaction) {
    Color amountColor;
    IconData icon;
    String prefix = '';

    switch (transaction.type) {
      case TransactionType.topup:
        amountColor = Colors.green;
        icon = Icons.add_circle_outline;
        prefix = '+';
        break;
      case TransactionType.payment:
        amountColor = Colors.red;
        icon = Icons.remove_circle_outline;
        prefix = '-';
        break;
      case TransactionType.refund:
        amountColor = Colors.blue;
        icon = Icons.refresh;
        prefix = '+';
        break;
      case TransactionType.cashback:
        amountColor = Colors.orange;
        icon = Icons.card_giftcard;
        prefix = '+';
        break;
    }

    return Container(
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
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: amountColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: amountColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.description,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      AppHelpers.formatTime(transaction.createdAt),
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    if (transaction.orderId != null) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryGreen.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Order',
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            color: AppColors.primaryGreen,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          Text(
            '$prefix${AppHelpers.formatCurrency(transaction.amount.abs())}',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: amountColor,
            ),
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
              Icons.receipt_long,
              color: AppColors.primaryGreen,
              size: 40,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'No transactions found',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your transaction history for $_selectedFilter will appear here',
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
}
