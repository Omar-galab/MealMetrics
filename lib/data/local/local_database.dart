import 'package:hive_flutter/hive_flutter.dart';
import '../../domain/models/local_meal.dart';

class LocalDatabase {

  static final LocalDatabase _singleton = LocalDatabase._internal();

  factory LocalDatabase() {
    return _singleton;
  }

  LocalDatabase._internal();

  static const String _boxName = 'meals_box';
  static late final Box<LocalMeal> _box;

   Future<void> init() async {
    _box = await Hive.openBox<LocalMeal>(_boxName);
  }

   Future<void> addMeal(LocalMeal meal) async {
    await _box.add(meal);
    
  }

  Future<void> deleteMeal(String id) async {
    final key = _box.keys.firstWhere((key) => _box.get(key)?.id == id, orElse: () => null);
    if (key != null) {
      await _box.delete(key); // Delete the meal using the correct key
    } else {
      throw Exception('Meal not found');
    }
  }

   List<LocalMeal> getMeals() {
    return _box.values.toList();
  }

   Stream<List<LocalMeal>> watchMeals() {
    return _box.watch().map((_) => _box.values.toList());
  }
   List<LocalMeal> getMealsSorted(String sortBy) {
    final meals = _box.values.toList();
    meals.sort((a, b) {
      switch (sortBy) {
        case 'name': return a.name.compareTo(b.name);
        case 'calories': return a.calories.compareTo(b.calories);
        default: return a.time.compareTo(b.time);
      }
    });
    return meals;
  }
   Stream<Map<DateTime, List<LocalMeal>>> watchMealsGroupedByDay(){
    return watchMeals().map((meals) {
      final grouped = <DateTime, List<LocalMeal>>{};
      for (final meal in meals) {
        final date = DateTime(meal.time.year, meal.time.month, meal.time.day);
        grouped.putIfAbsent(date, () => []).add(meal);
      }
      return grouped;
    });}
  /*static const String _boxName = 'meals_box';
  static late final Box<LocalMeal> _box;

  static Future<void> init() async {
    _box = await Hive.openBox<LocalMeal>(_boxName);
  }

  static Stream<List<LocalMeal>> watchMeals() {
    return _box.watch().map((event) => _box.values.cast<LocalMeal>().toList());
  }


  static Stream<Map<DateTime, List<LocalMeal>>> watchMealsGroupedByDay() {
    return watchMeals().map((meals) {
      final grouped = <DateTime, List<LocalMeal>>{};
      for (final meal in meals) {
        final date = DateTime(meal.time.year, meal.time.month, meal.time.day);
        grouped.putIfAbsent(date, () => []).add(meal);
      }
      return grouped;
    });
  }

  static Future<void> addMeal(LocalMeal meal) async {
    await _box.put(meal.id, meal);
  }

  static Future<void> deleteMeal(String id) async {
    await _box.delete(id);
  }

  static List<LocalMeal> getMealsSorted(String sortBy) {
    final meals = _box.values.toList();
    meals.sort((a, b) {
      switch (sortBy) {
        case 'name': return a.name.compareTo(b.name);
        case 'calories': return a.calories.compareTo(b.calories);
        default: return a.time.compareTo(b.time);
      }
    });
    return meals;
  }*/
}