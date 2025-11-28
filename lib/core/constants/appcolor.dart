import 'package:flutter/material.dart';

class CustomAppColor {
  static const Color primary = Color(0xFF6055D8);
  static const Color secondary = Color(0xFF8390FA);
  static const Color accent = Color(0xFF23B6E6);
  static const Color background = Color(0xFFFFFFFF);
  static const Color card = Color(0xFFFFFFFF);
  static const Color text = Color(0xFF1D1E20);
  static const Color subtext = Color(0xFF8A8A8E);
  static const Color error = Color(0xFFFF5964);
  static const Color success = Color(0xFF38C172);
  static const Color warning = Color(0xFFFFC93C);
  static const Color grey = Color(0xFF8A8A8E);
  static const Color greylight = Color(0xFFF8F7F7);
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color red = Color(0xFFFF0000);
  static const Color yellow = Color(0xFFFFD700);

  // You can add more as needed
}

const LinearGradient customGradient = LinearGradient(
  colors: [
    Color(0xFF4285F4), // Google Blue
    Color(0xFF34A853), // Google Green
    Color(0xFFFBBC05), // Google Yellow
    Color(0xFFEA4335), // Google Red
  ],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);
