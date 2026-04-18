import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color background = Color(0xFFFAFAF3); // Parchment
  static const Color surfaceLowest = Color(0xFFFFFFFF); // White cards
  static const Color surfaceLow = Color(
    0xFFF5F4ED,
  ); // Slightly darker parchment

  static const Color primary = Color(0xFF566342); // Deep Sage Green
  static const Color primaryContainer = Color(0xFFA3B18A); // Soft Sage

  static const Color secondary = Color(0xFF8C4E35); // Rich Terracotta / Brown
  static const Color secondaryContainer = Color(0xFFFFAD8F); // Soft Peach

  static const Color textMain = Color(0xFF1B1C18); // Dark contrast text
  static const Color textVariant = Color(0xFF45483F); // Muted text

  static const Color outline = Color(0xFFC6C8BB); // Soft borders

  static ThemeData get organicTheme {
    return ThemeData(
      scaffoldBackgroundColor: background,
      primaryColor: primary,
      colorScheme: const ColorScheme.light(
        primary: primary,
        secondary: secondary,
        surface: background,
        onSurface: textMain,
      ),

      // We set Be Vietnam Pro as the default for everything...
      textTheme: GoogleFonts.beVietnamProTextTheme().copyWith(
        // ...and override the headlines to use Plus Jakarta Sans!
        displayLarge: GoogleFonts.plusJakartaSans(
          color: textMain,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: GoogleFonts.plusJakartaSans(
          color: textMain,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: GoogleFonts.plusJakartaSans(
          color: textMain,
          fontWeight: FontWeight.bold,
        ),
        titleMedium: GoogleFonts.plusJakartaSans(
          color: textMain,
          fontWeight: FontWeight.w600,
        ),

        bodyLarge: GoogleFonts.beVietnamPro(color: textMain),
        bodyMedium: GoogleFonts.beVietnamPro(color: textVariant),

        // This is for those tiny uppercase labels (e.g., "DISCOMFORT LEVEL")
        labelSmall: GoogleFonts.beVietnamPro(
          color: textVariant,
          letterSpacing: 1.5,
          fontWeight: FontWeight.w600,
          fontSize: 11,
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: secondary,
          foregroundColor: Colors.white,
          elevation: 0, // We use our custom sunlight shadow instead
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16), // Rounded-xl in Tailwind
          ),
        ),
      ),
    );
  }

  // Custom Sunlight Shadow from the Stitch UI (reusable across the app!)
  static List<BoxShadow> get sunlightShadow => [
    BoxShadow(
      color: const Color(0xFF1B1C18).withOpacity(0.06),
      blurRadius: 24,
      offset: const Offset(0, 8),
    ),
  ];
}
