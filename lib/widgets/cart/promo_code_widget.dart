import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/app_colors.dart';

class PromoCodeWidget extends StatefulWidget {
  final String? appliedCode;
  final ValueChanged<String>? onApply;
  final VoidCallback? onRemove;

  const PromoCodeWidget({
    super.key,
    this.appliedCode,
    this.onApply,
    this.onRemove,
  });

  @override
  State<PromoCodeWidget> createState() => _PromoCodeWidgetState();
}

class _PromoCodeWidgetState extends State<PromoCodeWidget> {
  final TextEditingController _promoController = TextEditingController();
  bool _isValid = true;

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  void _applyPromo() {
    final code = _promoController.text.trim();
    if (code.isEmpty) {
      setState(() {
        _isValid = false;
      });
      return;
    }
    setState(() {
      _isValid = true;
    });
    if (widget.onApply != null) {
      widget.onApply!(code);
    }
  }

  @override
  Widget build(BuildContext context) {
    final appliedCode = widget.appliedCode;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: appliedCode == null
          ? Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _promoController,
                    decoration: InputDecoration(
                      hintText: 'Enter promo code',
                      errorText: _isValid ? null : 'Enter a promo code',
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _applyPromo,
                  child: const Text('Apply'),
                ),
              ],
            )
          : Row(
              children: [
                Expanded(
                  child: Text(
                    'Applied: $appliedCode',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryGreen,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: widget.onRemove,
                  child: Text(
                    'Remove',
                    style: GoogleFonts.inter(
                      fontSize: 14,
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
