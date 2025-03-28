

import '../models/local_meal.dart';

abstract class MealRepository {
  Future<void> addMeal(LocalMeal meal);
  Future<void> deleteMeal(String id);
  List<LocalMeal> getAllMeals();
  List<LocalMeal> getMealsSorted(String sortBy);
  Map<DateTime, List<LocalMeal>> getMealsGroupedByDay();
}