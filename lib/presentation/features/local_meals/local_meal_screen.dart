import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:omar_mahmoud1/domain/models/local_meal.dart';
import 'package:omar_mahmoud1/presentation/features/local_meals/meal_details_screen.dart';
import 'package:omar_mahmoud1/presentation/features/local_meals/widgets/add_meal_form.dart';
import 'package:omar_mahmoud1/presentation/features/local_meals/widgets/meal_list_item.dart';

import '../../../data/local/local_database.dart';

class LocalMealScreen extends StatefulWidget {
  const LocalMealScreen({super.key});

  @override
  State<LocalMealScreen> createState() => _LocalMealScreenState();
}

class _LocalMealScreenState extends State<LocalMealScreen> {
  final LocalDatabase _localDatabase = LocalDatabase();
    String dropDownValue = 'name';
    List<LocalMeal> sortedMeals = [];
  @override
  void initState() {
    super.initState();
    _loadSortedMeals();
  }
  
  Future<void> _loadSortedMeals() async {
    final meals = Hive.box<LocalMeal>('meals_box').values.toList();
    meals.sort((a, b) {
      switch (dropDownValue) {
        case 'name':
          return a.name.compareTo(b.name);
        case 'calories':
          return a.calories.compareTo(b.calories);
        default:
          return a.time.compareTo(b.time);
      }
    });
    setState(() {
      sortedMeals = meals;
    });
  }
  Future<void> _deleteMeal(String id, BuildContext context) async {
  try {
    await _localDatabase.deleteMeal(id); // Use the updated deleteMeal method
    await _loadSortedMeals(); // Refresh the sortedMeals list after deletion
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Meal deleted')),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: ${e.toString()}')),
    );
  }
}

Future<void> _addMeal(LocalMeal meal, BuildContext context) async {
  try {
    await _localDatabase.addMeal(meal); // Add the new meal to the database
    await _loadSortedMeals(); // Refresh the sortedMeals list after adding a meal
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Meal added successfully')),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: ${e.toString()}')),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed:
              () => showDialog(
                context: context,
                builder:
                    (_) => AlertDialog(
                      title: const Text('Add Meal'),
                      content: AddMealForm(
                        onAddMeal: (meal) => _addMeal(meal, context), // Pass the _addMeal method
                      ),
                    ),
              ),
          child: const Icon(Icons.add),
        ),
        body: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(16.0),
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: DropdownButton<String>(
                value: dropDownValue,
                isExpanded: true,
                underline: const SizedBox(), // Remove default underline
                style: const TextStyle(color: Colors.black, fontSize: 16.0),
                items: const [
                  DropdownMenuItem(value: 'time', child: Text('Sort by Time')),
                  DropdownMenuItem(value: 'name', child: Text('Sort by Name')),
                  DropdownMenuItem(value: 'calories', child: Text('Sort by Calories')),
                ],
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      dropDownValue = newValue;
                    });
                    _loadSortedMeals(); // Reload sorted meals based on the selected value
                  }
                },
              ),
            ),
            TabBar(tabs: [Tab(text: 'Meals'), Tab(text: 'Daily Summary')]),
            Expanded(
              child: TabBarView(
                children: [
                  // Meals List
                  ValueListenableBuilder(
                    valueListenable:
                        Hive.box<LocalMeal>('meals_box').listenable(),
                    builder: (context, Box<LocalMeal> box, _) {
                      if (box.values.isEmpty) {
                        return Center(child: Text('No meals add yes.'));
                      }
                      return ListView.builder(
                        itemCount: sortedMeals.length, // Use the updated sortedMeals list
                        itemBuilder: (context, index) {
                          final meal = sortedMeals[index];
                          return MealListItem(
                            meal: meal,
                            onDelete: () => _deleteMeal(meal.id, context ),
                            onTap:
                                () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) => MealDetailsScreen(meal: meal),
                                  ),
                                ),
                          );
                        },
                      );
                    },
                  ),
                  ValueListenableBuilder(
                    valueListenable:
                        Hive.box<LocalMeal>('meals_box').listenable(),
                    builder: (context, Box<LocalMeal> box, _) {
                      if (box.values.isEmpty) {
                        return Center(child: Text('No meals add yes.'));
                      }
                      final meals = box.values.toList();
                      final groupedMeals = <DateTime, List<LocalMeal>>{};
                      for (final meal in meals) {
                        final date = DateTime(
                          meal.time.year,
                          meal.time.month,
                          meal.time.day,
                        );
                        groupedMeals.putIfAbsent(date, () => []).add(meal);
                      }
                      return ListView.builder(
                        itemCount: groupedMeals.length,
                        itemBuilder: (context, index) {
                          final date = groupedMeals.keys.elementAt(index);
                          final meals = groupedMeals[date]!;
                          return Card(
                            child: ListTile(
                              title: Text(DateFormat.yMMMd().format(date)),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children:
                                    meals
                                        .map(
                                          (meal) => Text(
                                            '${meal.name} - ${meal.calories} kcal',
                                          ),
                                        )
                                        .toList(),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


