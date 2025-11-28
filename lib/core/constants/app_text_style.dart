import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:janus/core/constants/appcolor.dart';
import 'package:janus/core/constants/fontsize.dart';

class AppTextStyle {
  // Headings
  static TextStyle get h1 => GoogleFonts.inter(
    fontSize: CustomFontSize.h1,
    fontWeight: FontWeight.bold,
    color: CustomAppColor.text,
    letterSpacing: -0.5,
  );

  static TextStyle get h2 => GoogleFonts.inter(
    fontSize: CustomFontSize.h2,
    fontWeight: FontWeight.bold,
    color: CustomAppColor.text,
    letterSpacing: -0.5,
  );

  static TextStyle get h3 => GoogleFonts.inter(
    fontSize: CustomFontSize.h3,
    fontWeight: FontWeight.bold,
    color: CustomAppColor.text,
    letterSpacing: -0.3,
  );

  static TextStyle get h4 => GoogleFonts.inter(
    fontSize: CustomFontSize.h4,
    fontWeight: FontWeight.w600,
    color: CustomAppColor.text,
  );

  static TextStyle get h5 => GoogleFonts.inter(
    fontSize: CustomFontSize.h5,
    fontWeight: FontWeight.w600,
    color: CustomAppColor.text,
  );

  static TextStyle get h6 => GoogleFonts.inter(
    fontSize: CustomFontSize.h6,
    fontWeight: FontWeight.w600,
    color: CustomAppColor.text,
  );

  // Body Text
  static TextStyle get bodyLarge => GoogleFonts.inter(
    fontSize: CustomFontSize.bodyLarge,
    fontWeight: FontWeight.normal,
    color: CustomAppColor.text,
  );

  static TextStyle get bodyMedium => GoogleFonts.inter(
    fontSize: CustomFontSize.bodyMedium,
    fontWeight: FontWeight.normal,
    color: CustomAppColor.text,
  );

  static TextStyle get bodySmall => GoogleFonts.inter(
    fontSize: CustomFontSize.bodySmall,
    fontWeight: FontWeight.normal,
    color: CustomAppColor.text,
  );

  // Subtext
  static TextStyle get subtextLarge => GoogleFonts.inter(
    fontSize: CustomFontSize.bodyLarge,
    fontWeight: FontWeight.normal,
    color: CustomAppColor.subtext,
  );

  static TextStyle get subtextMedium => GoogleFonts.inter(
    fontSize: CustomFontSize.bodyMedium,
    fontWeight: FontWeight.normal,
    color: CustomAppColor.subtext,
  );

  static TextStyle get subtextSmall => GoogleFonts.inter(
    fontSize: CustomFontSize.bodySmall,
    fontWeight: FontWeight.normal,
    color: CustomAppColor.subtext,
  );

  // Button Text
  static TextStyle get buttonLarge => GoogleFonts.inter(
    fontSize: CustomFontSize.buttonLarge,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    letterSpacing: 0.5,
  );

  static TextStyle get buttonMedium => GoogleFonts.inter(
    fontSize: CustomFontSize.buttonMedium,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    letterSpacing: 0.5,
  );

  static TextStyle get buttonSmall => GoogleFonts.inter(
    fontSize: CustomFontSize.buttonSmall,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    letterSpacing: 0.5,
  );

  // Caption
  static TextStyle get caption => GoogleFonts.inter(
    fontSize: CustomFontSize.caption,
    fontWeight: FontWeight.normal,
    color: CustomAppColor.subtext,
  );

  // Overline
  static TextStyle get overline => GoogleFonts.inter(
    fontSize: CustomFontSize.overline,
    fontWeight: FontWeight.w500,
    color: CustomAppColor.subtext,
    letterSpacing: 1.5,
  );

  // Error Text
  static TextStyle get error => GoogleFonts.inter(
    fontSize: CustomFontSize.bodyMedium,
    fontWeight: FontWeight.normal,
    color: CustomAppColor.primary,
  );

  // Success Text
  static TextStyle get success => GoogleFonts.inter(
    fontSize: CustomFontSize.bodyMedium,
    fontWeight: FontWeight.normal,
    color: CustomAppColor.success,
  );

  // Warning Text
  static TextStyle get warning => GoogleFonts.inter(
    fontSize: CustomFontSize.bodyMedium,
    fontWeight: FontWeight.normal,
    color: CustomAppColor.warning,
  );

  // Helper method to customize text style
  static TextStyle custom({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? letterSpacing,
    double? height,
    TextDecoration? decoration,
    TextAlign? justify,
  }) {
    return GoogleFonts.inter(
      fontSize: fontSize ?? CustomFontSize.bodyMedium,
      fontWeight: fontWeight ?? FontWeight.normal,
      color: color ?? CustomAppColor.text,
      letterSpacing: letterSpacing,
      height: height,
      decoration: decoration,
      textBaseline: justify == TextAlign.justify
          ? TextBaseline.ideographic
          : null,
    );
  }
}
