import 'package:flutter/material.dart';

class AppColors {
  // Primary Gradients
  static const primaryGradient = LinearGradient(
    colors: [Color(0xFF8B5CF6), Color(0xFF3B82F6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const secondaryGradient = LinearGradient(
    colors: [Color(0xFFFF6B6B), Color(0xFFFF8E8E)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const accentGradient = LinearGradient(
    colors: [Color(0xFFF59E0B), Color(0xFFEF4444)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Solid Colors
  static const purple = Color(0xFF8B5CF6);
  static const blue = Color(0xFF3B82F6);
  static const coral = Color(0xFFFF6B6B);
  static const orange = Color(0xFFF59E0B);
  static const green = Color(0xFF10B981);

  // Priority Colors
  static const highPriority = Color(0xFFEF4444);
  static const mediumPriority = Color(0xFFF59E0B);
  static const lowPriority = Color(0xFF10B981);

  // Backgrounds
  static const darkBackground = Color(0xFF0F172A);
  static const darkCard = Color(0xFF1E293B);
  static const lightBackground = Color(0xFFFAFBFC);
  static const lightCard = Color(0xFFFFFFFF);

  // Text
  static const darkText = Color(0xFF000000);
  static const lightText = Color(0xFFFFFFFF);
  static const secondaryText = Color(0xFF6B7280);

  // Glass Morphism
  static const glassTint = Color(0x1AFFFFFF);
}

class AppTheme {
  /// Light theme configuration
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.purple,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: AppColors.lightBackground,
      cardColor: AppColors.lightCard,
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: AppColors.darkText,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: TextStyle(
          color: AppColors.darkText,
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
        displaySmall: TextStyle(
          color: AppColors.darkText,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        headlineLarge: TextStyle(
          color: AppColors.darkText,
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
        headlineMedium: TextStyle(
          color: AppColors.darkText,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        headlineSmall: TextStyle(
          color: AppColors.darkText,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(color: AppColors.darkText, fontSize: 16),
        bodyMedium: TextStyle(color: AppColors.darkText, fontSize: 14),
        bodySmall: TextStyle(color: AppColors.secondaryText, fontSize: 12),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.lightCard,
        foregroundColor: AppColors.darkText,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: AppColors.lightCard,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  /// Dark theme configuration
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.purple,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: AppColors.darkBackground,
      cardColor: AppColors.darkCard,
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: AppColors.lightText,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: TextStyle(
          color: AppColors.lightText,
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
        displaySmall: TextStyle(
          color: AppColors.lightText,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        headlineLarge: TextStyle(
          color: AppColors.lightText,
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
        headlineMedium: TextStyle(
          color: AppColors.lightText,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        headlineSmall: TextStyle(
          color: AppColors.lightText,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(color: AppColors.lightText, fontSize: 16),
        bodyMedium: TextStyle(color: AppColors.lightText, fontSize: 14),
        bodySmall: TextStyle(color: AppColors.secondaryText, fontSize: 12),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.darkCard,
        foregroundColor: AppColors.lightText,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: AppColors.darkCard,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
