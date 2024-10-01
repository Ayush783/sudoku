import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme => ThemeData(
        fontFamily: 'Londrina',
        textTheme: const TextTheme(
          bodyLarge: TextStyle(
            fontSize: 22,
          ),
          bodyMedium: TextStyle(
            fontSize: 18,
          ),
          bodySmall: TextStyle(
            fontSize: 16,
          ),
        ),
      );
}
