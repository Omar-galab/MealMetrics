import 'package:hive/hive.dart';
import '../../domain/models/local_meal.dart';

class HiveAdapters {
  static void registerAdapters() {
    Hive.registerAdapter(LocalMealAdapter()); // Register the adapter
  }
}