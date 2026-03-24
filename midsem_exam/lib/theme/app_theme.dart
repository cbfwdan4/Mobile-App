import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Define primary colors with a premium touch
  static const Color primaryDark = Color(0xFF0F172A); // Deep Slate Navy
  static const Color secondaryDark = Color(0xFF1E293B); // Lighter Slate
  static const Color accentIndigo = Color(0xFF6366F1); // Electric Indigo
  static const Color accentViolet = Color(0xFF8B5CF6); // Vibrant Violet
  static const Color textBody = Color(0xFF94A3B8); // Muted Slate Blue
  static const Color textHeading = Colors.white; // Pure White
  static const Color cardBg = Color(0xFF1E293B); // Card Background

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: primaryDark,
      
      // Define color scheme for the entire app
      colorScheme: const ColorScheme.dark(
        primary: accentIndigo,
        secondary: accentViolet,
        surface: secondaryDark,
        onSurface: Colors.white,
        error: Colors.redAccent,
      ),

      // Premium Typography using Google Fonts
      textTheme: GoogleFonts.outfitTextTheme(
        const TextTheme(
          displayLarge: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            letterSpacing: -1.0,
            color: textHeading,
          ),
          displayMedium: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
            color: textHeading,
          ),
          headlineMedium: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: textHeading,
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            color: textBody,
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            color: textBody,
          ),
        ),
      ).apply(
        bodyColor: textBody,
        displayColor: textHeading,
      ),

      // Custom AppBar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),

      // Enhanced Card Theme with premium shadow and rounded corners
      cardTheme: CardThemeData(
        color: cardBg.withOpacity(0.4),
        elevation: 0,
        shadowColor: Colors.black.withOpacity(0.5),
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),

      // Stylized Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: secondaryDark.withOpacity(0.5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.05)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: accentIndigo, width: 2),
        ),
        labelStyle: const TextStyle(color: textBody),
        prefixIconColor: accentIndigo,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),

      // Special Button Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentIndigo,
          foregroundColor: Colors.white,
          elevation: 8,
          shadowColor: accentIndigo.withOpacity(0.4),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: accentIndigo,
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  // Utility for background gradients used in screens
  static BoxDecoration get mainGradient => const BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [primaryDark, Color(0xFF1E1B4B)], // Midnight to Dark Indigo
    ),
  );
}
