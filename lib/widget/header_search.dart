import 'package:flutter/material.dart';
import 'package:food_recipes/core/theme/app_colors.dart';

class HeaderSearch extends StatefulWidget {
  final Future<void> Function(String)? onSearch;
  final VoidCallback? onFilterTap;

  final bool showFilter;
  const HeaderSearch({
    super.key,
    this.onSearch,
    this.showFilter = false,
    this.onFilterTap
  });

  @override
  State<HeaderSearch> createState() => _HeaderSearchState();
}

class _HeaderSearchState extends State<HeaderSearch> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _controller = TextEditingController();
  
  bool _isFocused = false;

  @override
  void initState() {
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.neutral100,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Search Box
          Expanded(
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              onChanged: (value) async {
                if (widget.onSearch != null) {
                  await widget.onSearch!(value);
                }
              },
              decoration: InputDecoration(
                hintText: 'Tim kiem mon an',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: _isFocused
                    ? AppColors.neutral200
                    : AppColors.neutral50,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          const SizedBox(width: 8),

          if (widget.showFilter) const SizedBox(width: 8),
          if (widget.showFilter)
            GestureDetector(
              onTap: widget.onFilterTap, // <-- use this instead
              child: Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  color: AppColors.neutral100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.filter_alt,
                  size: 24,
                  color: AppColors.primary600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
