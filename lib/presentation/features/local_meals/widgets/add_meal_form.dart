import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../../../../data/local/local_database.dart';
import '../../../../domain/models/local_meal.dart';

class AddMealForm extends ConsumerStatefulWidget {
  final Function(LocalMeal) onAddMeal;

  const AddMealForm({super.key, required this.onAddMeal});

  @override
  ConsumerState<AddMealForm> createState() => _AddMealFormState();
}

class _AddMealFormState extends ConsumerState<AddMealForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _caloriesController = TextEditingController();
  TimeOfDay _selectedTime = TimeOfDay.now();
  File? _selectedImage;
  final localDatabase = LocalDatabase();

  @override
  void dispose() {
    _nameController.dispose();
    _caloriesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildImagePicker(),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Meal Name',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a meal name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _caloriesController,
              decoration: const InputDecoration(
                labelText: 'Calories',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter calories';
                }
                if (int.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Time'),
              subtitle: Text(_selectedTime.format(context)),
              trailing: const Icon(Icons.access_time),
              onTap: () async {
                final time = await showTimePicker(
                  context: context,
                  initialTime: _selectedTime,
                );
                if (time != null) {
                  setState(() => _selectedTime = time);
                }
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _submitForm,
              child: const Text('Add Meal'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return GestureDetector(
      onTap: _pickImage,
      child: CircleAvatar(
        radius: 50,
        backgroundColor: Colors.grey[200],
        backgroundImage: _selectedImage != null ? FileImage(_selectedImage!) : null,
        child: _selectedImage == null
            ? const Icon(Icons.camera_alt, size: 40)
            : null,
      ),
    );
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final meal = LocalMeal(
        id: const Uuid().v4(),
        name: _nameController.text,
        calories: int.parse(_caloriesController.text),
        time: DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          _selectedTime.hour,
          _selectedTime.minute,
        ),
        photoPath: _selectedImage?.path,
      );

      widget.onAddMeal(meal);
      Navigator.pop(context);
    }
  }
}