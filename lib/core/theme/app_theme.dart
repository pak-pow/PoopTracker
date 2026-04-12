import 'package:flutter/material.dart';

class AppTheme {
  // Figma Color Palette
  static const Color backgroundCream = Color(0xFFFDFCF5);
  static const Color textDarkBrown = Color(0xFF3A3A3A);
  static const Color accentGreen = Color(0xFFA3B18A); // Sage Green
  static const Color accentPeach = Color(0xFFE29578); // Warm Terracotta
  static const Color softPink = Color(0xFFFFDAB9); // Blush

  static ThemeData get cozyTheme {
    return ThemeData(
      scaffoldBackgroundColor: backgroundCream,
      primaryColor: accentGreen,
      colorScheme: ColorScheme.light(
        primary: accentGreen,
        secondary: accentPeach,
        background: backgroundCream,
      ),
      fontFamily: 'Nunito', // Or 'Quicksand'
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: textDarkBrown),
        bodyMedium: TextStyle(color: textDarkBrown),
        titleLarge: TextStyle(
          color: textDarkBrown,
          fontWeight: FontWeight.bold,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentGreen,
          foregroundColor: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
      ),
    );
  }
}
