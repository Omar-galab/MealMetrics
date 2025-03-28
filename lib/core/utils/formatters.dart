import 'package:intl/intl.dart';

class Formatters {
  static String formatDate(DateTime date) {
    return DateFormat.yMMMd().format(date);
  }

  static String formatTime(DateTime time) {
    return DateFormat.jm().format(time);
  }

  static String formatCalories(int calories) {
    return '$calories kcal';
  }
}