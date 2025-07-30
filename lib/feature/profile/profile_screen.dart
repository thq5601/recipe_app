import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:food_recipes/core/theme/app_colors.dart';
import 'package:food_recipes/widget/profile_action_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<Map<String, dynamic>> favoriteMeals = [];
  bool isLoadingFavorites = true;
  int _selectedActionIndex = 0;

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
            'Trang ca nhan',
            style: TextStyle(
              color: AppColors.primary700,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.more_vert, color: AppColors.primary700),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage('https://i.pravatar.cc/300'),
              ),
              const SizedBox(height: 16),
              const Text(
                'User Name',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary700,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _ProfileStat(title: 'Bai viet', value: '100'),
                  _VerticalDivider(),
                  _ProfileStat(title: 'Nguoi theo doi', value: '100'),
                  _VerticalDivider(),
                  _ProfileStat(title: 'Theo doi', value: '100'),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ProfileActionButton(
                    label: 'Follow',
                    isSelected: _selectedActionIndex == 0,
                    onTap: () {
                      setState(() {
                        _selectedActionIndex = 0;
                      });
                    },
                  ),
                  const SizedBox(width: 12),
                  ProfileActionButton(
                    label: 'Message',
                    isSelected: _selectedActionIndex == 1,
                    onTap: () {
                      setState(() {
                        _selectedActionIndex = 1;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24,),
              //Danh sach yeu thich
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Yêu thích',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary700,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (isLoadingFavorites)
                    const Center(child: CircularProgressIndicator())
                  else if (favoriteMeals.isEmpty)
                    const Text('Chưa có món ăn yêu thích nào.')
                  else
                    GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: favoriteMeals.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                            childAspectRatio: 1,
                          ),
                      itemBuilder: (context, index) {
                        final meal = favoriteMeals[index];
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            meal['thumbnail'],
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileStat extends StatelessWidget {
  final String title;
  final String value;

  const _ProfileStat({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 3,
      height: 60,
      color: Colors.grey.shade300,
      margin: EdgeInsets.symmetric(horizontal: 8),
    );
  }
}
