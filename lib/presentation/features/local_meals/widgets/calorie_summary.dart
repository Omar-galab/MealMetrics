import 'package:flutter/material.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../domain/models/local_meal.dart';

class CalorieSummary extends StatelessWidget {
  final DateTime date;
  final List<LocalMeal> meals;
  final VoidCallback? onPressed;

  const CalorieSummary({
    super.key,
    required this.date,
    required this.meals,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final totalCalories = meals.fold(0, (sum, meal) => sum + meal.calories);
    final theme = Theme.of(context);

    return Card(
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    Formatters.formatDate(date),
                    style: theme.textTheme.titleMedium,
                  ),
                  Chip(
                    label: Text(
                      '$totalCalories kcal',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
                    backgroundColor: theme.colorScheme.primary,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ...meals.take(3).map((meal) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: Text(
                  '• ${meal.name} - ${meal.calories} kcal',
                  overflow: TextOverflow.ellipsis,
                ),
              )),
              if (meals.length > 3) ...[
                const SizedBox(height: 4),
                Text(
                  '+ ${meals.length - 3} more meals',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}