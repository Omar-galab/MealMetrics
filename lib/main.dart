import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:omar_mahmoud1/data/local/local_database.dart';
import 'package:omar_mahmoud1/presentation/home_screen.dart';
import 'package:omar_mahmoud1/presentation/shared/styles/app_theme.dart';

import 'domain/models/local_meal.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(LocalMealAdapter());
  await Hive.openBox<LocalMeal>('meals_box');
  LocalDatabase().init(); // Initialize the local database
  

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meal Tracker',
      theme: appTheme, // Use the defined theme
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
