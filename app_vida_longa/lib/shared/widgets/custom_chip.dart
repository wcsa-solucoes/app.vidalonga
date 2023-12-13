import 'package:app_vida_longa/domain/contants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class IconChoiceChip extends StatefulWidget {
  final String label;
  // final IconData icon;
  final bool isSelected;
  final Function(bool selected) onSelected;
  final TextStyle? textStyle;
  final TextStyle? textStyleSelected;
  final Color? backgroundColor;

  const IconChoiceChip({
    super.key,
    required this.label,
    // required this.icon,
    this.isSelected = false,
    required this.onSelected,
    this.textStyle,
    this.textStyleSelected,
    this.backgroundColor,
  });

  @override
  _IconChoiceChipState createState() => _IconChoiceChipState();
}

class _IconChoiceChipState extends State<IconChoiceChip> {
  bool _isSelected = false;

  @override
  void initState() {
    super.initState();
    _isSelected = widget.isSelected;
  }

  void _handleTap() {
    setState(() {
      _isSelected = !_isSelected;
      widget.onSelected(_isSelected);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      disabledColor: AppColors.unselectedTextStyleColor,
      selectedColor: AppColors.selectedTextStyleColor,
      backgroundColor: AppColors.unselectedTextStyleColor,
      pressElevation: 4.0,
      elevation: 2.0,
      side: const BorderSide(
        width: 0.5,
        style: BorderStyle.none,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      label: Text(
        widget.label,
        style: GoogleFonts.getFont(
          'Urbanist',
          color: AppColors.white,
        ),
      ),
      selected: _isSelected,
      onSelected: (selected) => _handleTap(),
    );
  }
}
