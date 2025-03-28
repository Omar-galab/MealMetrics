import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:omar_mahmoud1/domain/models/local_meal.dart';

class MealDetailsScreen extends StatelessWidget {
  final LocalMeal meal;

  const MealDetailsScreen({Key? key, required this.meal}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(meal.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Meal Image
            Container(
              width: double.infinity,
              height: 250.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: meal.photoPath != null && meal.photoPath!.isNotEmpty
                      ? FileImage(File(meal.photoPath!))
                      : const NetworkImage('https://via.placeholder.com/250'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            // Meal Name
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                meal.name,
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8.0),
            // Meal Time
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Time: ${DateFormat.yMMMd().add_jm().format(meal.time)}',
                style: TextStyle(fontSize: 16.0, color: Colors.grey[600]),
              ),
            ),
            const SizedBox(height: 8.0),
            // Calories
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Calories: ${meal.calories} kcal',
                style: TextStyle(fontSize: 16.0, color: Colors.grey[600]),
              ),
            ),
            const SizedBox(height: 16.0),
            // Description
           
          ],
        ),
      ),
    );
  }
}