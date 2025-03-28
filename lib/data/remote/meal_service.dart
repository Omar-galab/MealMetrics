import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/app_constants.dart';
import '../../domain/models/api_meal.dart';

class MealService {
  final http.Client client;

  MealService(this.client);

  Future<List<ApiMeal>> searchMeals(String query) async {
    final response = await client.get(
      Uri.parse('${AppConstants.theMealDbBaseUrl}/search.php?s=$query'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['meals'] == null) return [];
      return (data['meals'] as List).map((meal) => ApiMeal.fromJson(meal)).toList();
    } else {
      throw Exception('Failed to load meals');
    }
  }

  Future<ApiMeal?> getMealDetails(String id) async {
    final response = await client.get(
      Uri.parse('${AppConstants.theMealDbBaseUrl}/lookup.php?i=$id'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['meals'] == null) return null;
      return ApiMeal.fromJson(data['meals'][0]);
    } else {
      throw Exception('Failed to load meal details');
    }
  }

  Future<List<ApiMeal>> filterMealsByCategory(String category) async {
    final response = await client.get(
      Uri.parse('${AppConstants.theMealDbBaseUrl}/filter.php?c=$category'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['meals'] == null) return [];
      return (data['meals'] as List).map((meal) => ApiMeal.fromJson(meal)).toList();
    } else {
      throw Exception('Failed to filter meals by category');
    }
  }
}