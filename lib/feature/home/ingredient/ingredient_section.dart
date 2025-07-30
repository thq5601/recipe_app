import 'package:flutter/material.dart';
import 'package:food_recipes/core/theme/app_colors.dart';
import 'package:food_recipes/model/ingredient.dart';
import 'package:food_recipes/services/meal_service.dart';

class IngredientSection extends StatefulWidget {
  const IngredientSection({super.key});

  @override
  State<IngredientSection> createState() => _IngredientSectionState();
}

class _IngredientSectionState extends State<IngredientSection> {
  List<Ingredient> ingredients = [];
  int? selectedIndex;

  @override
  void initState() {
    super.initState();
    loadIngredients();
  }

  void loadIngredients() async {
    try {
      final fetched = await MealService.fetchAllIngredients();
      setState(() {
        ingredients = fetched.take(20).toList();
      });
    } catch (e) {
      debugPrint('Error fetching ingredients: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ingredients.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : Column(
            children: [
              // Sec title
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Nguyen lieu',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),

              //Chip
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 32,
                  horizontal: 16,
                ),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 12,
                  children: List.generate(ingredients.length, (index) {
                    final isSelected = selectedIndex == index;
                    final name = ingredients[index].name;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex = index;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary600
                              : AppColors.neutral50,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          name,
                          style: TextStyle(
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: isSelected ? Colors.white : Colors.black87,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          );
  }
}
