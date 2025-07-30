class Meal {
  final String id;
  final String name;
  final String thumbnail;
  final List<String> ingredients;
  final String? category;

  Meal({
    required this.id,
    required this.name,
    required this.thumbnail,
    required this.ingredients,
    this.category
  });


  factory Meal.fromJson(Map<String, dynamic> json) {
    List<String> extractedIngredients = [];
    for (int i = 1; i <= 20; i++) {
      final ingredient = json['strIngredient$i'];
      if (ingredient != null && ingredient.toString().trim().isNotEmpty) {
        extractedIngredients.add(ingredient.toString().trim());
      }
    }
    return Meal(
      id: json['idMeal'] ?? '',
      name: json['strMeal'] ?? '',
      thumbnail: json['strMealThumb'] ?? '',
      ingredients: extractedIngredients,
      category: json['strCategory']
    );
  }
}
