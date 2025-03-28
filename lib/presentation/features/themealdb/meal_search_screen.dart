import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:omar_mahmoud1/presentation/features/themealdb/widgets/category_filter.dart';
import 'package:omar_mahmoud1/presentation/features/themealdb/widgets/search_bar.dart';
import '../../../core/providers.dart';
import '../../shared/components/error_view.dart';
import 'meal_detail_screen.dart';

class MealSearchScreen extends ConsumerWidget {
  const MealSearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchQuery = ref.watch(mealSearchQueryProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);

    return Scaffold(
      body: Column(
        children: [
          const MealSearchBar(),
          if (searchQuery.isNotEmpty || selectedCategory != null)
            const CategoryFilter(),
          Expanded(
            child: _buildMealList(ref, context),
          ),
        ],
      ),
    );
  }

  Widget _buildMealList(WidgetRef ref, BuildContext context) {
    if (ref.watch(selectedCategoryProvider) != null) {
      return _buildFilteredMeals(ref, context);
    } else if (ref.watch(mealSearchQueryProvider).isNotEmpty) {
      return _buildSearchResults(ref, context);
    } else {
      return const ErrorView(message: 'Search for meals or select a category');
    }
  }

  Widget _buildSearchResults(WidgetRef ref, BuildContext context) {
    final searchResults = ref.watch(mealSearchResultsProvider);

    return searchResults.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => ErrorView(message: error.toString()),
      data: (meals) {
        if (meals.isEmpty) {
          return const ErrorView(message: 'No meals found');
        }

        return GridView.builder(
          padding: const EdgeInsets.all(8),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 0.8,
          ),
          itemCount: meals.length,
          itemBuilder: (context, index) {
            final meal = meals[index];
            return GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MealDetailScreen(mealId: meal.id),
                ),
              ),
              child: Card(
                child: Column(
                  children: [
                    Expanded(
                      child: Image.network(
                        meal.thumbnail,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        meal.name,
                        style: Theme.of(context).textTheme.titleSmall,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (meal.category != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          meal.category!,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildFilteredMeals(WidgetRef ref, BuildContext context) {
    final filteredMeals = ref.watch(filteredMealsProvider);

    return filteredMeals.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => ErrorView(message: error.toString()),
      data: (meals) {
        if (meals.isEmpty) {
          return const ErrorView(message: 'No meals in this category');
        }

        return ListView.builder(
          itemCount: meals.length,
          itemBuilder: (context, index) {
            final meal = meals[index];
            return ListTile(
              leading: Image.network(
                meal.thumbnail,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
              title: Text(meal.name),
              subtitle: Text(meal.category ?? ''),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MealDetailScreen(mealId: meal.id),
                ),
              ),
            );
          },
        );
      },
    );
  }
}