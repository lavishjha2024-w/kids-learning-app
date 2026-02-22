import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Eye-friendly color palette following HCI principles
/// Uses soft pastels and warm tones to reduce eye strain
class AppColors {
  // Primary colors - soft pastels
  static const Color lightBlue = Color(0xFFB3D9FF);
  static const Color mintGreen = Color(0xFFB8E6D3);
  static const Color lavender = Color(0xFFD4C5E8);
  static const Color peach = Color(0xFFFFD4B3);
  
  // Background colors - warm off-white (not harsh white)
  static const Color warmOffWhite = Color(0xFFFAF9F6);
  static const Color softWhite = Color(0xFFFFFEF9);
  
  // Dark mode colors - soft dark theme (not pure black)
  static const Color softDarkBg = Color(0xFF2D2D2D);
  static const Color softDarkSurface = Color(0xFF3A3A3A);
  static const Color softDarkText = Color(0xFFE8E8E8);
  
  // Accent colors
  static const Color primaryAccent = Color(0xFF6B9BD2);
  static const Color successGreen = Color(0xFF7BC8A4);
  static const Color gentleOrange = Color(0xFFFFB88C);
  
  // Text colors
  static const Color textPrimary = Color(0xFF2C3E50);
  static const Color textSecondary = Color(0xFF5D6D7E);
  
  // Avoid harsh colors
  static const Color avoidRed = Color(0xFFFF6B6B); // Only for critical errors
  static const Color avoidNeon = Color(0xFFFF00FF); // Never use
}

/// App Theme following HCI principles:
/// - Large fonts (minimum 16-20px)
/// - Generous padding
/// - Clear visual hierarchy
/// - Recognition over recall (icons + labels)
class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColors.primaryAccent,
      scaffoldBackgroundColor: AppColors.warmOffWhite,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primaryAccent,
        secondary: AppColors.mintGreen,
        surface: AppColors.softWhite,
        background: AppColors.warmOffWhite,
        error: AppColors.avoidRed,
      ),
      
      // Typography - Large, rounded, readable fonts
      textTheme: TextTheme(
        displayLarge: GoogleFonts.comfortaa(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
          letterSpacing: 0.5,
        ),
        displayMedium: GoogleFonts.comfortaa(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
          letterSpacing: 0.5,
        ),
        displaySmall: GoogleFonts.comfortaa(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        headlineMedium: GoogleFonts.comfortaa(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        titleLarge: GoogleFonts.comfortaa(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        titleMedium: GoogleFonts.comfortaa(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
        bodyLarge: GoogleFonts.comfortaa(
          fontSize: 18,
          fontWeight: FontWeight.normal,
          color: AppColors.textPrimary,
        ),
        bodyMedium: GoogleFonts.comfortaa(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: AppColors.textPrimary,
        ),
        bodySmall: GoogleFonts.comfortaa(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: AppColors.textSecondary,
        ),
        labelLarge: GoogleFonts.comfortaa(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
      ),
      
      // Button theme - Large tappable targets (minimum 48dp)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(120, 56), // Large touch targets
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.comfortaa(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      // Card theme - Generous padding
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        margin: const EdgeInsets.all(12),
      ),
      
      // Input decoration - Clear, visible
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.softWhite,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.lightBlue, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.lightBlue, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.primaryAccent, width: 3),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),
      
      // AppBar theme
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.warmOffWhite,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.comfortaa(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
  
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: AppColors.lightBlue,
      scaffoldBackgroundColor: AppColors.softDarkBg,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.lightBlue,
        secondary: AppColors.mintGreen,
        surface: AppColors.softDarkSurface,
        background: AppColors.softDarkBg,
        error: AppColors.avoidRed,
      ),
      
      textTheme: TextTheme(
        displayLarge: GoogleFonts.comfortaa(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: AppColors.softDarkText,
          letterSpacing: 0.5,
        ),
        displayMedium: GoogleFonts.comfortaa(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: AppColors.softDarkText,
          letterSpacing: 0.5,
        ),
        displaySmall: GoogleFonts.comfortaa(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: AppColors.softDarkText,
        ),
        headlineMedium: GoogleFonts.comfortaa(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: AppColors.softDarkText,
        ),
        titleLarge: GoogleFonts.comfortaa(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.softDarkText,
        ),
        titleMedium: GoogleFonts.comfortaa(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: AppColors.softDarkText,
        ),
        bodyLarge: GoogleFonts.comfortaa(
          fontSize: 18,
          fontWeight: FontWeight.normal,
          color: AppColors.softDarkText,
        ),
        bodyMedium: GoogleFonts.comfortaa(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: AppColors.softDarkText,
        ),
        bodySmall: GoogleFonts.comfortaa(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: AppColors.softDarkText,
        ),
        labelLarge: GoogleFonts.comfortaa(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: AppColors.softDarkText,
        ),
      ),
      
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(120, 56),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.comfortaa(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        margin: const EdgeInsets.all(12),
      ),
      
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.softDarkBg,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.comfortaa(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: AppColors.softDarkText,
        ),
      ),
    );
  }
}
