import 'package:flutter/material.dart';
import 'package:food_recipes/core/theme/app_colors.dart';

class RecentRecipesSection extends StatelessWidget {
  const RecentRecipesSection({super.key});

  // List<Meal> recentMeals = [];

  // @override
  @override
  Widget build(BuildContext context) {
    // if (recentMeals.isEmpty) {
    //   return const Center(child: CircularProgressIndicator());
    // }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //Ten danh muc
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Cong thuc gan day',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),

        const SizedBox(height: 12),

        //Danh sach cong thuc
        SizedBox(
          height: 260,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: 10,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              // final meal = recentMeals[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Hinh anh
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      'https://www.themealdb.com/images/media/meals/llcbn01574260722.jpg',
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  ),

                  const SizedBox(height: 8),

                  //Ten cong thuc
                  const Text(
                    'Khong co API premium',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary950,
                    ),
                  ),

                  const SizedBox(height: 4),

                  //Nguoi tao
                  Row(
                    children: const [
                      CircleAvatar(
                        radius: 10,
                        backgroundImage: NetworkImage(
                          'https://i.pravatar.cc/300',
                        ),
                      ),
                      SizedBox(width: 6),
                      Text('Tran Hoang Quan', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
