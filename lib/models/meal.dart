class MealSummary {
  final String idMeal;
  final String strMeal;
  final String strMealThumb;

  MealSummary({
    required this.idMeal,
    required this.strMeal,
    required this.strMealThumb,
  });

  factory MealSummary.fromJson(Map<String, dynamic> json) {
    return MealSummary(
      idMeal: json['idMeal']?.toString() ?? '',
      strMeal: json['strMeal']?.toString() ?? '',
      strMealThumb: json['strMealThumb']?.toString() ?? '',
    );
  }
}

class MealIngredient {
  final String name;
  final String measure;

  MealIngredient({
    required this.name,
    required this.measure,
  });
}

class MealDetail {
  final String idMeal;
  final String strMeal;
  final String strCategory;
  final String strArea;
  final String strInstructions;
  final String strMealThumb;
  final List<MealIngredient> ingredients;

  MealDetail({
    required this.idMeal,
    required this.strMeal,
    required this.strCategory,
    required this.strArea,
    required this.strInstructions,
    required this.strMealThumb,
    required this.ingredients,
  });

  factory MealDetail.fromJson(Map<String, dynamic> json) {
    final ingredients = <MealIngredient>[];

    for (var index = 1; index <= 20; index++) {
      final ingredient = json['strIngredient$index']?.toString().trim();
      final measure = json['strMeasure$index']?.toString().trim() ?? '';
      if (ingredient != null && ingredient.isNotEmpty) {
        ingredients.add(MealIngredient(
          name: ingredient,
          measure: measure.isNotEmpty ? measure : '-',
        ));
      }
    }

    return MealDetail(
      idMeal: json['idMeal']?.toString() ?? '',
      strMeal: json['strMeal']?.toString() ?? '',
      strCategory: json['strCategory']?.toString() ?? '',
      strArea: json['strArea']?.toString() ?? '',
      strInstructions: json['strInstructions']?.toString() ?? '',
      strMealThumb: json['strMealThumb']?.toString() ?? '',
      ingredients: ingredients,
    );
  }
}
