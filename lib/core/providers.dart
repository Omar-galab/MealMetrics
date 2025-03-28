import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import '../data/local/local_database.dart';
import '../data/remote/meal_service.dart';
import '../domain/models/api_meal.dart';


// ==================== Local Meals Providers ====================
final localDatabaseProvider = Provider<LocalDatabase>((ref) {
  return LocalDatabase();
});



// ==================== API Meals Providers ====================
final httpClientProvider = Provider<Client>((ref) => Client());

final mealServiceProvider = Provider<MealService>((ref) {
  final client = ref.read(httpClientProvider);
  return MealService(client);
});

final mealSearchQueryProvider = StateProvider<String>((ref) => '');

final mealSearchResultsProvider = FutureProvider.autoDispose<List<ApiMeal>>((ref) async {
  final query = ref.watch(mealSearchQueryProvider);
  if (query.isEmpty) return [];

  final service = ref.read(mealServiceProvider);
  return await service.searchMeals(query);
});

final mealDetailsProvider = FutureProvider.autoDispose.family<ApiMeal?, String>((ref, mealId) async {
  final service = ref.read(mealServiceProvider);
  return await service.getMealDetails(mealId);
});

final selectedCategoryProvider = StateProvider<String?>((ref) => null);

final filteredMealsProvider = FutureProvider.autoDispose<List<ApiMeal>>((ref) async {
  final category = ref.watch(selectedCategoryProvider);
  if (category == null) return [];

  final service = ref.read(mealServiceProvider);
  return await service.filterMealsByCategory(category);
});