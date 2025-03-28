import 'package:hive/hive.dart';
part 'local_meal.g.dart'; // This links to the generated file
@HiveType(typeId: 0)
class LocalMeal extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final int calories;

  @HiveField(3)
  final DateTime time;

  @HiveField(4)
  final String? photoPath;

  @HiveField(5)  // New field
  final String? notes;  // Add this line

  LocalMeal({
    required this.id,
    required this.name,
    required this.calories,
    required this.time,
    this.photoPath,
    this.notes,  // Add this to constructor
  });
}