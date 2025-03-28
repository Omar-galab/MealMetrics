class Validators {
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a name';
    }
    return null;
  }

  static String? validateCalories(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter calories';
    }
    final calories = int.tryParse(value);
    if (calories == null) {
      return 'Please enter a valid number';
    }
    if (calories <= 0) {
      return 'Calories must be positive';
    }
    return null;
  }
}