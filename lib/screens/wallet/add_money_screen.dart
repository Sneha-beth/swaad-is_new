import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/helpers.dart';
import '../../services/wallet_service.dart';
import '../../widgets/common/custom_button.dart';

class AddMoneyScreen extends StatefulWidget {
  const AddMoneyScreen({super.key});

  @override
  State<AddMoneyScreen> createState() => _AddMoneyScreenState();
}

class _AddMoneyScreenState extends State<AddMoneyScreen> {
  final TextEditingController _amountController = TextEditingController();
  String _selectedPaymentMethod = 'UPI';
  bool _isLoading = false;

  final List<double> quickAmounts = [100, 200, 500, 1000, 2000];

  final List<Map<String, dynamic>> paymentMethods = [
    {
      'name': 'UPI',
      'icon': Icons.account_balance,
      'subtitle': 'Pay using UPI apps'
    },
    {
      'name': 'Credit Card',
      'icon': Icons.credit_card,
      'subtitle': 'Visa, Mastercard, Amex'
    },
    {
      'name': 'Debit Card',
      'icon': Icons.credit_card,
      'subtitle': 'Bank debit cards'
    },
    {
      'name': 'Net Banking',
      'icon': Icons.account_balance,
      'subtitle': 'All major banks'
    },
  ];

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
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
          'Add Money',
          style: GoogleFonts.inter(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current Balance
            _buildCurrentBalance(),
            const SizedBox(height: 32),

            // Amount Input
            _buildAmountInput(),
            const SizedBox(height: 24),

            // Quick Amount Selection
            _buildQuickAmounts(),
            const SizedBox(height: 32),

            // Payment Methods
            _buildPaymentMethods(),
            const SizedBox(height: 32),

            // Add Money Button
            _buildAddMoneyButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentBalance() {
    return Consumer<WalletService>(
      builder: (context, walletService, child) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.primaryGreen.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.primaryGreen.withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.account_balance_wallet,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Current Balance',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    AppHelpers.formatCurrency(walletService.balance),
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAmountInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Enter Amount',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _amountController,
          keyboardType: TextInputType.number,
          style: GoogleFonts.inter(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: '₹ 0',
            hintStyle: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary.withValues(alpha: 0.5),
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
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 20,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickAmounts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Add',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: quickAmounts.map((amount) {
            return GestureDetector(
              onTap: () {
                _amountController.text = amount.toStringAsFixed(0);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: AppColors.backgroundColor,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: AppColors.borderColor),
                ),
                child: Text(
                  '₹${amount.toStringAsFixed(0)}',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPaymentMethods() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Payment Method',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        ...paymentMethods.map((method) {
          final isSelected = _selectedPaymentMethod == method['name'];
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedPaymentMethod = method['name'];
              });
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primaryGreen.withValues(alpha: 0.1)
                    : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primaryGreen
                      : AppColors.borderColor,
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primaryGreen
                          : AppColors.textSecondary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      method['icon'],
                      color:
                          isSelected ? Colors.white : AppColors.textSecondary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          method['name'],
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          method['subtitle'],
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isSelected)
                    const Icon(
                      Icons.check_circle,
                      color: AppColors.primaryGreen,
                      size: 24,
                    ),
                ],
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildAddMoneyButton() {
    return CustomButton(
      text: _isLoading ? 'Processing...' : 'Add Money',
      onPressed: _isLoading ? () {} : _addMoney,
    );
  }

  void _addMoney() async {
    final amountText = _amountController.text.trim();
    if (amountText.isEmpty) {
      _showError('Please enter an amount');
      return;
    }

    final amount = double.tryParse(amountText);
    if (amount == null || amount <= 0) {
      _showError('Please enter a valid amount');
      return;
    }

    if (amount < 10) {
      _showError('Minimum amount is ₹10');
      return;
    }

    if (amount > 10000) {
      _showError('Maximum amount is ₹10,000');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final walletService = Provider.of<WalletService>(context, listen: false);
      final success =
          await walletService.addMoney(amount, _selectedPaymentMethod);

      if (success) {
        _showSuccess(
            '₹${amount.toStringAsFixed(0)} added to wallet successfully!');
        Navigator.pop(context);
      } else {
        _showError('Failed to add money. Please try again.');
      }
    } catch (e) {
      _showError('An error occurred. Please try again.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.primaryGreen,
      ),
    );
  }
}
