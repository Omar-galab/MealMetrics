import 'package:flutter/material.dart';

class TextStyles {
  static TextStyle get titleLarge => const TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
  );

  static TextStyle get titleMedium => const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );

  static TextStyle get titleSmall => const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  static TextStyle get bodyLarge => const TextStyle(
    fontSize: 16,
  );

  static TextStyle get bodyMedium => const TextStyle(
    fontSize: 14,
  );
}