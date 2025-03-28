import '../models/api_meal.dart';

abstract class TheMealDbRepository {
  Future<List<ApiMeal>> searchMeals(String query);
  Future<ApiMeal?> getMealDetails(String id);
  Future<List<ApiMeal>> filterMealsByCategory(String category);
}