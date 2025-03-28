import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../domain/models/local_meal.dart';

class MealListItem extends StatelessWidget {
  final LocalMeal meal;
  final VoidCallback onDelete;
  final VoidCallback onTap;
  final double imageRadius;

  const MealListItem({
    super.key,
    required this.meal,
    required this.onDelete,
    required this.onTap,
    this.imageRadius = 24.0,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      elevation: 5,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: ListTile(
            leading:   _buildMealImage(context),

            title: Text(
              meal.name,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.local_fire_department,
                        size: 16,
                        color: Theme.of(context).colorScheme.secondary),
                    const SizedBox(width: 4),
                    Text(
                      '${meal.calories} kcal',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Icon(Icons.access_time,
                        size: 16,
                        color: Theme.of(context).colorScheme.secondary),
                    const SizedBox(width: 4),
                    Text(
                      Formatters.formatTime(meal.time),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
            trailing: IconButton(
              icon: Icon(Icons.delete_outline,
                  color: Theme.of(context).colorScheme.error),
              onPressed: () => _showDeleteConfirmation(context),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
          ),
        ),
      ),
    );
  }

  Widget _buildMealImage(BuildContext context) {
    return FutureBuilder<bool>(
      future: _checkImageExists(meal.photoPath),
      builder: (context, snapshot) {
        final exists = snapshot.data ?? false;

        return CircleAvatar(
          radius: imageRadius,
          backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
          child: exists
              ? ClipOval(
            child: Image.file(
              File(meal.photoPath!),
              width: imageRadius * 2,
              height: imageRadius * 2,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _buildFallbackIcon(context),
            ),
          )
              : _buildFallbackIcon(context),
        );
      },
    );
  }

  Widget _buildFallbackIcon(BuildContext context) {
    return Icon(
      Icons.fastfood,
      size: imageRadius,
      color: Theme.of(context).colorScheme.onSurfaceVariant,
    );
  }

  Future<bool> _checkImageExists(String? path) async {
    if (path == null) return false;
    return await File(path).exists();
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Meal'),
        content: Text('Are you sure you want to delete "${meal.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('CANCEL',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              onDelete();
            },
            child: Text('DELETE',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.error)),
          ),
        ],
      ),
    );
  }
}