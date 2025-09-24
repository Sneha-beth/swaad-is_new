import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/app_colors.dart';

typedef CuisineFilterChanged = void Function(List<String> selectedCuisines);

class CuisineFilterWidget extends StatefulWidget {
  final List<String> allCuisines;
  final List<String> selectedCuisines;
  final CuisineFilterChanged onFilterChanged;

  const CuisineFilterWidget({
    super.key,
    required this.allCuisines,
    required this.selectedCuisines,
    required this.onFilterChanged,
  });

  @override
  State<CuisineFilterWidget> createState() => _CuisineFilterWidgetState();
}

class _CuisineFilterWidgetState extends State<CuisineFilterWidget> {
  late List<String> _selectedCuisines;

  @override
  void initState() {
    super.initState();
    _selectedCuisines = List<String>.from(widget.selectedCuisines);
  }

  void _onChipTapped(String cuisine) {
    setState(() {
      if (_selectedCuisines.contains(cuisine)) {
        _selectedCuisines.remove(cuisine);
      } else {
        _selectedCuisines.add(cuisine);
      }
      widget.onFilterChanged(_selectedCuisines);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: widget.allCuisines.map((cuisine) {
        final isSelected = _selectedCuisines.contains(cuisine);
        return FilterChip(
          label: Text(
            cuisine,
            style: GoogleFonts.inter(
              color: isSelected ? Colors.white : AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          selected: isSelected,
          selectedColor: AppColors.primaryGreen,
          backgroundColor: AppColors.backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color:
                  isSelected ? AppColors.primaryGreen : AppColors.borderColor,
            ),
          ),
          onSelected: (_) => _onChipTapped(cuisine),
        );
      }).toList(),
    );
  }
}
