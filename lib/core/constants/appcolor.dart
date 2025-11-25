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
