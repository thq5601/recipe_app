import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:food_recipes/core/theme/app_colors.dart';
import 'package:food_recipes/model/meal_detail.dart';
import 'package:food_recipes/services/meal_service.dart';
import 'package:food_recipes/widget/profile_action_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:url_launcher/url_launcher.dart';

class DetailScreen extends StatefulWidget {
  final String mealId;

  const DetailScreen({super.key, required this.mealId});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {

  int _selectedActionIndex = 0;

  bool isFavorited = false;

  Future<void> toggleFavorite(MealDetail meal) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'favorites';
    final List<String> currentFavorites = prefs.getStringList(key) ?? [];

    final mealJson = jsonEncode({
      'id': meal.id,
      'name': meal.name,
      'thumbnail': meal.thumbnail,
    });

    if (currentFavorites.contains(mealJson)) {
      currentFavorites.remove(mealJson);
      print('Removed from favorites: ${meal.name}');
    } else {
      currentFavorites.add(mealJson);
      print('Saved to favorites: ${meal.name} - ${meal.thumbnail}');
    }

    await prefs.setStringList(key, currentFavorites);
  }

  Future<bool> isMealFavorited(MealDetail meal) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> currentFavorites =
        prefs.getStringList('favorites') ?? [];

    return currentFavorites.contains(
      jsonEncode({
        'id': meal.id,
        'name': meal.name,
        'thumbnail': meal.thumbnail,
      }),
    );
  }

  void _launchYoutube() async {
    final url = mealDetail?.youtubeUrl;
    if (url == null || url.isEmpty) return;

    final uri = Uri.parse(url);

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Could not open video')));
    }
  }

  MealDetail? mealDetail;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadMealDetail();
  }

  void loadMealDetail() async {
    final detail = await MealService.fetchMealDetailById(widget.mealId);
    final favorited = await isMealFavorited(detail!);
    setState(() {
      mealDetail = detail;
      isFavorited = favorited;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (mealDetail == null) {
      return const Scaffold(body: Center(child: Text('No meal found')));
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Image with title overlay
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(24),
                  ),
                  child: Image.network(
                    mealDetail!.thumbnail,
                    width: double.infinity,
                    height: 260,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  left: 16,
                  top: 40,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Instructions and Ingredients
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        mealDetail!.name,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      IconButton(
                        onPressed: () async {
                          await toggleFavorite(mealDetail!);
                          final updatedFavorite = await isMealFavorited(
                            mealDetail!,
                          );
                          setState(() {
                            isFavorited = updatedFavorite;
                          });
                        },
                        icon: Icon(
                          isFavorited ? Icons.favorite : Icons.favorite_border,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.star, color: AppColors.primary500, size: 20),
                      const SizedBox(width: 4),
                      Text(
                        '4.2',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        height: 16,
                        width: 2,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '120 danh gia',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 16),
                  Row(
                    children: const [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(
                          'https://i.pravatar.cc/300',
                        ),
                      ),
                      SizedBox(width: 6),
                      Text(
                        'Tran Hoang Quan',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primary600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Divider(thickness: 2, color: AppColors.primary600),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ProfileActionButton(
                        label: 'Nguyen lieu',
                        isSelected: _selectedActionIndex == 0,
                        onTap: () {
                          setState(() {
                            _selectedActionIndex = 0;
                          });
                        },
                      ),
                      const SizedBox(width: 12),
                      ProfileActionButton(
                        label: 'Che bien',
                        isSelected: _selectedActionIndex == 1,
                        onTap: () {
                          setState(() {
                            _selectedActionIndex = 1;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  if (_selectedActionIndex == 1) ...[
                    Text(
                      'How to cook',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      mealDetail!.instructions,
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.justify,
                    ),
                  ] else ...[
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: mealDetail!.ingredients
                          .map(
                            (ingredient) => Chip(
                              label: Text(ingredient),
                              backgroundColor: AppColors.neutral50,
                              labelStyle: const TextStyle(
                                color: Colors.black87,
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minimumSize: const Size(double.infinity, 48),
                      backgroundColor: Colors.amber.shade100,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    onPressed: _launchYoutube,
                    label: const Text(
                      'Xem Video',
                      style: TextStyle(color: AppColors.primary700),
                    ),
                    icon: const Icon(
                      Icons.video_collection_outlined,
                      color: AppColors.primary700,
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
