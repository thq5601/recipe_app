// floating action button
import 'package:flutter/material.dart';
import 'package:food_recipes/core/theme/app_colors.dart';

class CustomFloatingActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color foregroundColor;
  final IconData icon;
  final double iconSize;

  const CustomFloatingActionButton({
    super.key,
    required this.onPressed,
    this.backgroundColor = AppColors.primary500,
    this.foregroundColor = AppColors.neutral50,
    this.icon = Icons.add,
    this.iconSize = 30,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      shape: const CircleBorder(),
      child: Icon(icon, size: iconSize),
    );
  }
}
