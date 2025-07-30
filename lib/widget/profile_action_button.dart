import 'package:flutter/material.dart';
import 'package:food_recipes/core/theme/app_colors.dart';

class ProfileActionButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const ProfileActionButton({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isSelected
        ? AppColors.primary600
        : const Color(0xFFfdf3db);
    final textColor = isSelected ? AppColors.neutral50 : AppColors.primary600;

    return SizedBox(
      width: 160,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          elevation: 0,
        ),
        child: Text(label, style: TextStyle(color: textColor)),
      ),
    );
  }
}
