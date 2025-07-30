import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:food_recipes/core/theme/app_colors.dart';
import 'package:food_recipes/feature/saved_recipes/saved_recipe_card.dart';
import 'package:food_recipes/services/favorite_service.dart';
import 'package:food_recipes/widget/profile_action_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SavedRecipesScreen extends StatefulWidget {
  const SavedRecipesScreen({super.key});

  @override
  State<SavedRecipesScreen> createState() => _SavedRecipesScreenState();
}

class _SavedRecipesScreenState extends State<SavedRecipesScreen> {
  int _selectedActionIndex = 0;
  List<Map<String, dynamic>> favoriteMeals = [];
  bool isLoadingFavorites = true;

   @override
  void initState() {
    super.initState();
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList('favorites') ?? [];

    final decodedFavorites = favorites.map((item) {
      return jsonDecode(item) as Map<String, dynamic>;
    }).toList();

    setState(() {
      favoriteMeals = decodedFavorites;
      isLoadingFavorites = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColors.primary700),
        title: Center(
          child: const Text(
            'Da luu',
            style: TextStyle(
              color: AppColors.primary700,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.more_vert, color: Colors.white),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ProfileActionButton(
                  label: 'Video',
                  isSelected: _selectedActionIndex == 0,
                  onTap: () {
                    setState(() {
                      _selectedActionIndex = 0;
                    });
                  },
                ),
                ProfileActionButton(
                  label: 'Cong thuc',
                  isSelected: _selectedActionIndex == 1,
                  onTap: () {
                    setState(() {
                      _selectedActionIndex = 1;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (isLoadingFavorites)
              const Center(child: CircularProgressIndicator())
            else if (favoriteMeals.isEmpty)
              const Text('Chưa có món ăn yêu thích nào.')
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: favoriteMeals.length,
                itemBuilder: (context, index) {
                  final meal = favoriteMeals[index];
                  return SavedRecipeCard(
                    imageUrl: meal['thumbnail']!,
                    title: meal['name']!, 
                    duration: '30 phút',
                    user: 'Người đăng',
                    userAvatar: 'https://i.pravatar.cc/150?img=$index',
                  );
                },
              ),

            //
          ],
        ),
      ),
    );
  }
}
