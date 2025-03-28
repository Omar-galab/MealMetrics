class AppConstants {
  static const String theMealDbBaseUrl = 'https://www.themealdb.com/api/json/v1/1';

  static const List<String> sortOptions = [
    'time',
    'name',
    'calories',
  ];

  static const Map<String, String> sortOptionLabels = {
    'time': 'Time',
    'name': 'Name',
    'calories': 'Calories',
  };
}