import 'package:flutter/material.dart';
import 'package:food_recipes/core/theme/app_colors.dart';
import 'package:food_recipes/model/meal.dart';
import 'package:food_recipes/routes.dart';
import 'package:food_recipes/services/meal_service.dart';

class AreaMealSection extends StatefulWidget {
  final String area;

  const AreaMealSection({required this.area, super.key});

  @override
  State<AreaMealSection> createState() => _AreaMealSectionState();
}

class _AreaMealSectionState extends State<AreaMealSection> {
  late Future<List<Meal>> _mealsFuture;

  @override
  void initState() {
    super.initState();
    _mealsFuture = MealService.fetchMealsByArea(widget.area);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Meal>>(
      future: _mealsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Loi khi lay du lieu'),
          );
        }

        final meals = snapshot.data ?? [];
        if (meals.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Khong co mon an o khu vuc nay.'),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Ten quoc gia
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.area,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'Xem tat ca',
                    style: TextStyle(
                      color: AppColors.primary600,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            //Ds mon
            SizedBox(
              height: 260,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: meals.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  return MealCard(meal: meals[index]);
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class MealCard extends StatelessWidget {
  final Meal meal;

  const MealCard({required this.meal, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.detail,
          arguments: meal.id, // Pass the meal ID
        );
      },
      child: SizedBox(
        width: 180,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    meal.thumbnail,
                    height: 120,
                    width: 180,
                    fit: BoxFit.cover,
                  ),
                ),
                //Danh gia
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary600,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.star, size: 12, color: AppColors.neutral50),
                        SizedBox(width: 2),
                        Text(
                          '5',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.neutral50,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                //Nut play
                const Positioned.fill(
                  child: Center(
                    child: Icon(
                      Icons.play_circle_fill,
                      size: 40,
                      color: AppColors.neutral100,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            const Text(
              '1 tieng 20 phut',
              style: TextStyle(
                color: AppColors.secondary700,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              meal.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Row(
              children: const [
                CircleAvatar(
                  radius: 10,
                  backgroundImage: NetworkImage('https://i.pravatar.cc/300'),
                ),
                SizedBox(width: 6),
                Text('Tran Hoang Quan', style: TextStyle(fontSize: 12)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
