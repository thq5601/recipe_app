import 'package:flutter/material.dart';
import 'package:food_recipes/core/theme/app_colors.dart';

class CustomIconButton extends StatelessWidget {
  final IconData iconData;
  final int index;
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomIconButton({
    super.key,
    required this.iconData,
    required this.index,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => onItemTapped(index),
      icon: Icon(
        iconData,
        size: 30,
        color: selectedIndex == index
            ? AppColors.primary500
            : AppColors.neutral500,
      ),
    );
  }
}
