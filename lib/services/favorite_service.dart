import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteService {
  static const String _key = 'favorite_meals';

  static Future<void> toggleFavorite({
    required String mealId,
    required String imageUrl,
    required String name,
    required String duration,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getStringList(_key) ?? [];

    // Check if the meal is already in the list
    final index = current.indexWhere((item) {
      final decoded = jsonDecode(item);
      return decoded['id'] == mealId;
    });

    if (index != -1) {
      // Remove existing item
      current.removeAt(index);
    } else {
      // Add new item with full info
      final encoded = jsonEncode({
        'id': mealId,
        'image': imageUrl,
        'name': name,
        'duration': duration,
      });
      current.add(encoded);
    }

    await prefs.setStringList(_key, current);
  }

  static Future<List<Map<String, String>>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getStringList(_key) ?? [];

    return current.map((e) {
      final decoded = jsonDecode(e) as Map<String, dynamic>;
      return {
        'id': decoded['id']?.toString() ?? '',
        'image': decoded['image']?.toString() ?? '',
        'name': decoded['name']?.toString() ?? '',
        'duration': decoded['duration']?.toString() ?? '',
      };
    }).toList();
  }

  static Future<bool> isFavorite(String mealId) async {
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getStringList(_key) ?? [];

    return current.any((item) {
      final decoded = jsonDecode(item);
      return decoded['id'] == mealId;
    });
  }
}
