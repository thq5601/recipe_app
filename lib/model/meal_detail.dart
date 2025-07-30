class MealDetail {
  final String id;
  final String name;
  final String thumbnail;
  final String instructions;
  final List<String> ingredients;
  String get youtubeVideoId {
    final uri = Uri.tryParse(youtubeUrl);
    if (uri == null || uri.queryParameters['v'] == null) return '';
    return uri.queryParameters['v']!;
  }

  final String youtubeUrl;

  MealDetail({
    required this.id,
    required this.name,
    required this.thumbnail,
    required this.instructions,
    required this.ingredients,
    required this.youtubeUrl,
  });

  factory MealDetail.fromJson(Map<String, dynamic> json) {
    List<String> ingredients = [];

    for (int i = 1; i <= 20; i++) {
      final ingredient = json['strIngredient$i'];
      if (ingredient != null && ingredient.toString().trim().isNotEmpty) {
        ingredients.add(ingredient);
      }
    }

    return MealDetail(
      id: json['idMeal'],
      name: json['strMeal'],
      thumbnail: json['strMealThumb'],
      instructions: json['strInstructions'] ?? '',
      ingredients: ingredients,
      youtubeUrl: json['strYoutube'] ?? '',
    );
  }
}
