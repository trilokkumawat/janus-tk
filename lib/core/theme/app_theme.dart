import 'package:flutter/material.dart';
import 'package:janus/core/constants/fontsize.dart';

class AppColors {
  // Primary & Secondary Brand Colors
  static const primary = Color(0xFF8B5CF6); // Purple
  static const secondary = Color(0xFF3B82F6); // Blue

  // Legacy palette/other colors
  static const purple = primary;
  static const blue = secondary;
  static const coral = Color(0xFFFF6B6B);
  static const orange = Color(0xFFF59E0B);
  static const green = Color(0xFF10B981);

  // Gradients (using primary and secondary)
  static const primaryGradient = LinearGradient(
    colors: [primary, secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const secondaryGradient = LinearGradient(
    colors: [coral, Color(0xFFFF8E8E)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const accentGradient = LinearGradient(
    colors: [orange, Color(0xFFEF4444)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

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
      colorScheme: ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        tertiary: AppColors.coral,
        surface: AppColors.lightCard,
        background: AppColors.lightBackground,
        error: AppColors.highPriority,
        onPrimary: AppColors.lightText,
        onSecondary: AppColors.lightText,
        onSurface: AppColors.darkText,
        onBackground: AppColors.darkText,
        onError: AppColors.lightText,
      ),
      scaffoldBackgroundColor: AppColors.lightBackground,
      cardColor: AppColors.lightCard,
      textTheme: TextTheme(
        displayLarge: TextStyle(
          color: AppColors.darkText,
          fontSize: CustomFontSize.h1,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: TextStyle(
          color: AppColors.darkText,
          fontSize: CustomFontSize.h2,
          fontWeight: FontWeight.bold,
        ),
        displaySmall: TextStyle(
          color: AppColors.darkText,
          fontSize: CustomFontSize.h3,
          fontWeight: FontWeight.bold,
        ),
        headlineLarge: TextStyle(
          color: AppColors.darkText,
          fontSize: CustomFontSize.h4,
          fontWeight: FontWeight.w600,
        ),
        headlineMedium: TextStyle(
          color: AppColors.darkText,
          fontSize: CustomFontSize.h4,
          fontWeight: FontWeight.w600,
        ),
        headlineSmall: TextStyle(
          color: AppColors.darkText,
          fontSize: CustomFontSize.h5,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(
          color: AppColors.darkText,
          fontSize: CustomFontSize.bodyLarge,
        ),
        bodyMedium: TextStyle(
          color: AppColors.darkText,
          fontSize: CustomFontSize.bodyMedium,
        ),
        bodySmall: TextStyle(
          color: AppColors.secondaryText,
          fontSize: CustomFontSize.bodySmall,
        ),
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
      // Button Themes - Automatic styling for all buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.lightText,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: TextStyle(
            fontSize: CustomFontSize.buttonLarge,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.lightText,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: TextStyle(
            fontSize: CustomFontSize.buttonLarge,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: TextStyle(
            fontSize: CustomFontSize.buttonMedium,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: TextStyle(
            fontSize: CustomFontSize.buttonLarge,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      // Icon Button Theme
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: AppColors.primary,
          padding: const EdgeInsets.all(12),
        ),
      ),
      // Floating Action Button Theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.lightText,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  /// Dark theme configuration
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        tertiary: AppColors.coral,
        surface: AppColors.darkCard,
        background: AppColors.darkBackground,
        error: AppColors.highPriority,
        onPrimary: AppColors.lightText,
        onSecondary: AppColors.lightText,
        onSurface: AppColors.lightText,
        onBackground: AppColors.lightText,
        onError: AppColors.lightText,
      ),
      scaffoldBackgroundColor: AppColors.darkBackground,
      cardColor: AppColors.darkCard,
      textTheme: TextTheme(
        displayLarge: TextStyle(
          color: AppColors.lightText,
          fontSize: CustomFontSize.h1,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: TextStyle(
          color: AppColors.lightText,
          fontSize: CustomFontSize.h2,
          fontWeight: FontWeight.bold,
        ),
        displaySmall: TextStyle(
          color: AppColors.lightText,
          fontSize: CustomFontSize.h3,
          fontWeight: FontWeight.bold,
        ),
        headlineLarge: TextStyle(
          color: AppColors.lightText,
          fontSize: CustomFontSize.h4,
          fontWeight: FontWeight.w600,
        ),
        headlineMedium: TextStyle(
          color: AppColors.lightText,
          fontSize: CustomFontSize.h4,
          fontWeight: FontWeight.w600,
        ),
        headlineSmall: TextStyle(
          color: AppColors.lightText,
          fontSize: CustomFontSize.h5,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(
          color: AppColors.lightText,
          fontSize: CustomFontSize.bodyLarge,
        ),
        bodyMedium: TextStyle(
          color: AppColors.lightText,
          fontSize: CustomFontSize.bodyMedium,
        ),
        bodySmall: TextStyle(
          color: AppColors.secondaryText,
          fontSize: CustomFontSize.bodySmall,
        ),
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
      // Button Themes - Automatic styling for all buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.lightText,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: TextStyle(
            fontSize: CustomFontSize.buttonLarge,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.lightText,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: TextStyle(
            fontSize: CustomFontSize.buttonLarge,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: TextStyle(
            fontSize: CustomFontSize.buttonMedium,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: TextStyle(
            fontSize: CustomFontSize.buttonLarge,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      // Icon Button Theme
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: AppColors.primary,
          padding: const EdgeInsets.all(12),
        ),
      ),
      // Floating Action Button Theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.lightText,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
