import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers.dart';
import '../../../domain/models/api_meal.dart';

class MealDetailScreen extends ConsumerStatefulWidget {
  final String mealId;

  const MealDetailScreen({super.key, required this.mealId});

  @override
  ConsumerState<MealDetailScreen> createState() => _MealDetailScreenState();
}

class _MealDetailScreenState extends ConsumerState<MealDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final mealAsync = ref.watch(mealDetailsProvider(widget.mealId));

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: mealAsync.when(
              loading: () => FlexibleSpaceBar(
                background: Container(color: Colors.grey[200]),
                title: const Text('Loading...'),
              ),
              error: (error, stack) => FlexibleSpaceBar(
                title: const Text('Error'),
                background: Container(color: Colors.red[100]),
              ),
              data: (meal) => FlexibleSpaceBar(
                title: Text(
                  meal?.name ?? '',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    shadows: [
                      Shadow(
                        color: Colors.black,
                        blurRadius: 10,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                ),
                background: Hero(
                  tag: 'meal-image-${widget.mealId}',
                  child: CachedNetworkImage(
                    imageUrl: meal?.thumbnail ?? '',
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Colors.grey[200],
                    ),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: mealAsync.when(
              loading: () => const Padding(
                padding: EdgeInsets.all(32.0),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (error, stack) => Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Error: $error'),
              ),
              data: (meal) {
                if (meal == null) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('Meal not found'),
                  );
                }
                return _MealDetailContent(meal: meal);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _MealDetailContent extends StatelessWidget {
  final ApiMeal meal;

  const _MealDetailContent({required this.meal});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (meal.category != null) ...[
            Chip(label: Text(meal.category!)),
            const SizedBox(height: 16),
          ],
          if (meal.ingredients != null && meal.ingredients!.isNotEmpty) ...[
            const Text(
              'Ingredients',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...meal.ingredients!.map((ingredient) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Text('• $ingredient'),
            )),
            const SizedBox(height: 16),
          ],
          if (meal.instructions != null) ...[
            const Text(
              'Instructions',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(meal.instructions!),
          ],
        ],
      ),
    );
  }
}