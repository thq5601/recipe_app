import 'package:flutter/material.dart';
import 'package:food_recipes/core/theme/app_colors.dart';
import 'package:food_recipes/feature/detail/detail_screen.dart';
import 'package:food_recipes/feature/home/area_section/area_meal_section.dart';
import 'package:food_recipes/feature/home/category_section/category_section.dart';
import 'package:food_recipes/feature/home/ingredient/ingredient_section.dart';
import 'package:food_recipes/feature/home/recent_recipe/recent_recipes.section.dart';
import 'package:food_recipes/feature/profile/profile_screen.dart';
import 'package:food_recipes/feature/saved_recipes/saved_recipes.dart';
import 'package:food_recipes/feature/search/search_screen.dart';
import 'package:food_recipes/services/meal_service.dart';
import 'package:food_recipes/widget/custom_botnav.dart';
import 'package:food_recipes/widget/custom_fab.dart';
import 'package:food_recipes/widget/header_search.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List _meals = [];
  int _selectedIndex = 0;
  String _searchQuery = '';

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _getBody(int index) {
    switch (index) {
      case 0:
        return SingleChildScrollView(
          child: Column(
            children: [
              HeaderSearch(
                onSearch: (query) async {
                  setState(() {
                    _searchQuery = query;
                  });

                  if (query.isEmpty) {
                    setState(() {
                      _meals = [];
                    });
                    return;
                  }

                  final results = await MealService.searchMealsByName(query);
                  setState(() {
                    _meals = results;
                  });
                },
              ),
              if (_searchQuery.isNotEmpty && _meals.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: _meals.length,
                      itemBuilder: (context, index) {
                        final meal = _meals[index];
                        return ListTile(
                          title: Text(meal.name),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: AppColors.primary600,
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DetailScreen(mealId: meal.id),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                )
              else if (_searchQuery.isNotEmpty && _meals.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(top: 32),
                  child: Center(
                    child: Text(
                      'No meals found.',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                )
              else
                Column(
                  children: const [
                    AreaMealSection(area: 'Canadian'),
                    SizedBox(height: 16),
                    CategorySection(),
                    SizedBox(height: 16),
                    RecentRecipesSection(),
                    SizedBox(height: 16),
                    IngredientSection(),
                  ],
                ),
            ],
          ),
        );
      case 1:
        return const SearchScreen();
      case 2:
        return const SavedRecipesScreen();
      case 3:
        return const ProfileScreen();
      default:
        return const Center(child: Text('Page not found'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _getBody(_selectedIndex)),
      floatingActionButton: CustomFloatingActionButton(onPressed: () {}),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: CustomBotnav(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
