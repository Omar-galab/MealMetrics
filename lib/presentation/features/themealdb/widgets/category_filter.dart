import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers.dart';

class CategoryFilter extends ConsumerWidget {
  const CategoryFilter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchResults = ref.watch(mealSearchResultsProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);

    return searchResults.when(
      loading: () => const LinearProgressIndicator(),
      error: (_, __) => const SizedBox(),
      data: (meals) {
        final categories = meals
            .map((meal) => meal.category)
            .whereType<String>()
            .toSet()
            .toList();

        if (categories.isEmpty) return const SizedBox();

        return SizedBox(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: ChoiceChip(
                  label: Text(category),
                  selected: selectedCategory == category,
                  onSelected: (selected) {
                    ref.read(selectedCategoryProvider.notifier).state =
                    selected ? category : null;
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}