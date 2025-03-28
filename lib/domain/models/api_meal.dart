class ApiMeal {
  final String id;
  final String name;
  final String thumbnail;
  final String? category;
  final String? instructions;
  final List<String>? ingredients;

  ApiMeal({
    required this.id,
    required this.name,
    required this.thumbnail,
    this.category,
    this.instructions,
    this.ingredients,
  });

  factory ApiMeal.fromJson(Map<String, dynamic> json) {
    final ingredients = <String>[];

    // Extract ingredients and measures (up to 20)
    for (int i = 1; i <= 20; i++) {
      final ingredient = json['strIngredient$i'];
      final measure = json['strMeasure$i'];
      if (ingredient != null && ingredient.isNotEmpty) {
        ingredients.add('$ingredient - ${measure ?? ''}');
      }
    }

    return ApiMeal(
      id: json['idMeal'],
      name: json['strMeal'],
      thumbnail: json['strMealThumb'],
      category: json['strCategory'],
      instructions: json['strInstructions'],
      ingredients: ingredients,
    );
  }
}