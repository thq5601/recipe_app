import 'package:flutter/material.dart';
import 'package:food_recipes/feature/detail/detail_screen.dart';
import 'package:food_recipes/feature/home/home_screen.dart';
import 'package:food_recipes/feature/profile/profile_screen.dart';
import 'package:food_recipes/feature/saved_recipes/saved_recipes.dart';
import 'package:food_recipes/feature/search/search_screen.dart';
import 'package:food_recipes/feature/splash/splash_screen.dart';

class AppRoutes {
  static const String home = '/';
  static const String splash = '/splash';
  static const String search = '/search';
  static const String detail = '/detail';
  static const String profile = '/profile';
  static const String savedRecipes = '/saved_recipes';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case search:
        return MaterialPageRoute(builder: (_) => const SearchScreen());
      case detail:
        final mealId = settings.arguments as String;
        return MaterialPageRoute(builder: (_) => DetailScreen(mealId: mealId));
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case savedRecipes:
        return MaterialPageRoute(builder: (_) => const SavedRecipesScreen());
      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Page not found'))),
        );
    }
  }
}
