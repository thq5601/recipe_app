import 'package:flutter/material.dart';
import 'package:food_recipes/core/theme/app_colors.dart';
import 'package:food_recipes/model/category.dart';
import 'package:food_recipes/model/meal.dart';
import 'package:food_recipes/routes.dart';
import 'package:food_recipes/services/meal_service.dart';

class CategorySection extends StatefulWidget {
  const CategorySection({super.key});

  @override
  _CategorySectionState createState() => _CategorySectionState();
}

class _CategorySectionState extends State<CategorySection> {
  List<Category> categories = [];
  List<Meal> meals = [];
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    loadCategories();
  }

  void loadCategories() async {
    final fetchedCategories = await MealService.fetchCategories();
    if (!mounted) return;
    setState(() {
      categories = fetchedCategories;
    });
    if (fetchedCategories.isNotEmpty) {
      loadMealsByCategory(fetchedCategories[0].name);
    }
  }

  void loadMealsByCategory(String category) async {
    final fetchedMeals = await MealService.fetchMealsByCategory(category);
    if (!mounted) return;
    setState(() {
      meals = fetchedMeals;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Sec title
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Danh muc',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text(
                'Xem tat ca',
                style: TextStyle(
                  color: AppColors.primary600,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),

        // Chip
        SizedBox(
          height: 36,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final isSelected = index == selectedIndex;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedIndex = index;
                  });
                  loadMealsByCategory(categories[index].name);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary600
                        : AppColors.neutral50,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    categories[index].name,
                    style: TextStyle(
                      color: isSelected
                          ? AppColors.neutral50
                          : AppColors.primary950,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 12),

        SizedBox(
          height: 260,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: meals.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final meal = meals[index];
              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.detail,
                    arguments: meal.id, // Pass the meal ID
                  );
                },
                child: Container(
                  width: 140,
                  decoration: BoxDecoration(
                    color: const Color(0xFFfdf3db),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 8),
                      ClipOval(
                        child: Image.network(
                          meal.thumbnail,
                          width: 64,
                          height: 64,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        meal.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF885d0b),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Tạo bởi\nTran Hoang Quan',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12),
                      ),
                      const SizedBox(height: 8),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          children: [
                            Text('20 phút', style: TextStyle(fontSize: 12)),
                            Spacer(),
                            Icon(Icons.copy, size: 16),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        )

        
      ],
    );
  }
}
