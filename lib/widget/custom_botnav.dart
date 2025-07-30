// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:food_recipes/core/theme/app_colors.dart';
import 'package:food_recipes/widget/custom_iconbutton.dart';

class CustomBotnav extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;
  const CustomBotnav({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  State<CustomBotnav> createState() => _CustomBotnavState();
}

class _CustomBotnavState extends State<CustomBotnav> {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: AppColors.neutral50,
      shape: AutomaticNotchedShape(
        RoundedRectangleBorder(
          // Custom the radius on top left and right of the botnavbar
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        StadiumBorder(),
      ),
      notchMargin: 16,
      child: SizedBox(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        CustomIconButton(
                          iconData: Icons.home,
                          index: 0,
                          selectedIndex: widget.selectedIndex,
                          onItemTapped: widget.onItemTapped,
                        ),
                        CustomIconButton(
                          iconData: Icons.search,
                          index: 1,
                          selectedIndex: widget.selectedIndex,
                          onItemTapped: widget.onItemTapped,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 48),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        CustomIconButton(
                          iconData: Icons.bookmark,
                          index: 2,
                          selectedIndex: widget.selectedIndex,
                          onItemTapped: widget.onItemTapped,
                        ),
                        CustomIconButton(
                          iconData: Icons.person,
                          index: 3,
                          selectedIndex: widget.selectedIndex,
                          onItemTapped: widget.onItemTapped,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
