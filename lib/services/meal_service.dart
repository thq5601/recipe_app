import 'dart:convert';

import 'package:food_recipes/model/category.dart';
import 'package:food_recipes/model/meal.dart';
import 'package:food_recipes/model/ingredient.dart';
import 'package:food_recipes/model/meal_detail.dart';
import 'package:http/http.dart' as http;

class MealService {
  //API lay ra danh sach mon an theo quoc gia (Canadian)
  static Future<List<Meal>> fetchMealsByArea(String area) async {
    final url = Uri.parse(
      'https://www.themealdb.com/api/json/v1/1/filter.php?a=$area',
    );
    print('Fetching meals for area: $area');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      if (jsonData['meals'] == null) {
        print('No meals found for area: $area');
        return [];
      }
      final List<dynamic> mealsJson = jsonData['meals'];
      return mealsJson.map((mealJson) => Meal.fromJson(mealJson)).toList();
    } else {
      print('Failed response: ${response.statusCode}');
      throw Exception('Failed to load meals');
    }
  }

  //API lay ra danh muc mon an
  static Future<List<Category>> fetchCategories() async {
    final res = await http.get(
      Uri.parse('https://www.themealdb.com/api/json/v1/1/categories.php'),
    );
    final data = json.decode(res.body);
    return (data['categories'] as List)
        .map((json) => Category.fromJson(json))
        .toList();
  }

  //API lay ra mon an theo danh muc
  static Future<List<Meal>> fetchMealsByCategory(String category) async {
    final response = await http.get(
      Uri.parse(
        'https://www.themealdb.com/api/json/v1/1/filter.php?c=$category',
      ),
    );

    final data = json.decode(response.body);
    final mealsJson = data['meals'];

    if (mealsJson == null) {
      return [];
    }

    return (mealsJson as List)
        .map((mealJson) => Meal.fromJson(mealJson))
        .toList();
  }

  //API lay ra cong thuc gan day nhat
  static Future<List<Meal>> fetchLatestMeals() async {
    final response = await http.get(
      Uri.parse('https://www.themealdb.com/api/json/v1/1/latest.php'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> mealsJson = json.decode(response.body)['meals'];
      return mealsJson.map((json) => Meal.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load latest meals');
    }
  }

  //API lay ra danh muc mon an
  static Future<List<Ingredient>> fetchAllIngredients() async {
    final url = Uri.parse(
      'https://www.themealdb.com/api/json/v1/1/list.php?i=list',
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final ingredientsJson = jsonData['meals'] as List;

      return ingredientsJson.map((json) => Ingredient.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch ingredients');
    }
  }

  //API lay ra chi tiet mon an
  static Future<MealDetail?> fetchMealDetailById(String id) async {
    final response = await http.get(
      Uri.parse('https://www.themealdb.com/api/json/v1/1/lookup.php?i=$id'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final meals = data['meals'];
      if (meals != null && meals.isNotEmpty) {
        return MealDetail.fromJson(meals[0]);
      }
    }
    return null;
  }

  //API search
  static Future<List<Meal>> searchMealsByName(String query) async {
    final url = Uri.parse(
      'https://www.themealdb.com/api/json/v1/1/search.php?s=$query',
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final mealsJson = data['meals'];
      if (mealsJson != null) {
        return (mealsJson as List).map((e) => Meal.fromJson(e)).toList();
      }
    }
    return [];
  }

  // API: Lay danh sach khu vuc (area)
  static Future<List<String>> fetchAreas() async {
    final response = await http.get(
      Uri.parse('https://www.themealdb.com/api/json/v1/1/list.php?a=list'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final areas = data['meals'] as List;
      return areas.map((json) => json['strArea'] as String).toList();
    } else {
      throw Exception('Failed to fetch areas');
    }
  }
 
}
