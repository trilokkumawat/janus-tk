import 'package:flutter/material.dart';

class AppDimensions {
  AppDimensions._();

  // Height
  static const double heightXS = 4.0;
  static const double heightS = 8.0;
  static const double heightM = 12.0;
  static const double heightL = 16.0;
  static const double heightXL = 24.0;
  static const double height2XL = 32.0;
  static const double height3XL = 48.0;
  static const double height4XL = 64.0;
  static const double height5XL = 96.0;
  static const double height6XL = 128.0;
  static const double height180 = 180.0;
  static const double height200 = 200.0;
  static const double height250 = 250.0;

  // Width
  static const double widthXS = 4.0;
  static const double widthS = 8.0;
  static const double widthM = 12.0;
  static const double widthL = 16.0;
  static const double widthXL = 24.0;
  static const double width2XL = 32.0;
  static const double width3XL = 48.0;
  static const double width4XL = 64.0;
  static const double width5XL = 96.0;
  static const double width6XL = 128.0;
  static const double width180 = 180.0;
  static const double width200 = 200.0;
  static const double width250 = 250.0;

  // Spacing
  static const double spacingXS = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 12.0;
  static const double spacingL = 16.0;
  static const double spacingXL = 24.0;
  static const double spacing2XL = 32.0;
  static const double spacing3XL = 48.0;
  static const double spacing4XL = 64.0;

  // Padding
  static const double paddingXS = 4.0;
  static const double paddingS = 8.0;
  static const double paddingM = 12.0;
  static const double paddingL = 16.0;
  static const double paddingXL = 24.0;
  static const double padding2XL = 32.0;
  static const double padding3XL = 48.0;
  static const double padding4XL = 64.0;

  // Padding helpers
  static EdgeInsets get paddingAllXS => const EdgeInsets.all(paddingXS);
  static EdgeInsets get paddingAllS => const EdgeInsets.all(paddingS);
  static EdgeInsets get paddingAllM => const EdgeInsets.all(paddingM);
  static EdgeInsets get paddingAllL => const EdgeInsets.all(paddingL);
  static EdgeInsets get paddingAllXL => const EdgeInsets.all(paddingXL);
  static EdgeInsets get paddingAll2XL => const EdgeInsets.all(padding2XL);
  static EdgeInsets get paddingHorizontalS =>
      const EdgeInsets.symmetric(horizontal: paddingS);
  static EdgeInsets get paddingHorizontalM =>
      const EdgeInsets.symmetric(horizontal: paddingM);
  static EdgeInsets get paddingHorizontalL =>
      const EdgeInsets.symmetric(horizontal: paddingL);
  static EdgeInsets get paddingHorizontalXL =>
      const EdgeInsets.symmetric(horizontal: paddingXL);
  static EdgeInsets get paddingVerticalS =>
      const EdgeInsets.symmetric(vertical: paddingS);
  static EdgeInsets get paddingVerticalM =>
      const EdgeInsets.symmetric(vertical: paddingM);
  static EdgeInsets get paddingVerticalL =>
      const EdgeInsets.symmetric(vertical: paddingL);
  static EdgeInsets get paddingVerticalXL =>
      const EdgeInsets.symmetric(vertical: paddingXL);

  static EdgeInsets paddingSymmetric({
    required double horizontal,
    required double vertical,
  }) => EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical);

  // Border radius
  static const double radiusXS = 4.0;
  static const double radiusS = 8.0;
  static const double radiusM = 12.0;
  static const double radiusL = 16.0;
  static const double radiusXL = 24.0;
  static const double radius2XL = 32.0;
  static BorderRadius get borderRadiusXS => BorderRadius.circular(radiusXS);
  static BorderRadius get borderRadiusS => BorderRadius.circular(radiusS);
  static BorderRadius get borderRadiusM => BorderRadius.circular(radiusM);
  static BorderRadius get borderRadiusL => BorderRadius.circular(radiusL);
  static BorderRadius get borderRadiusXL => BorderRadius.circular(radiusXL);
  static BorderRadius get borderRadius2XL => BorderRadius.circular(radius2XL);

  // Font size
  static const double fontSizeXS = 10.0;
  static const double fontSizeS = 12.0;
  static const double fontSizeM = 14.0;
  static const double fontSizeL = 16.0;
  static const double fontSizeXL = 18.0;
  static const double fontSize2XL = 20.0;
  static const double fontSize3XL = 24.0;
  static const double fontSize4XL = 32.0;
  static const double fontSize5XL = 48.0;
  static const double fontSize6XL = 72.0;

  // Icon size
  static const double iconSizeS = 16.0;
  static const double iconSizeM = 24.0;
  static const double iconSizeL = 32.0;
  static const double iconSizeXL = 48.0;
  static const double iconSize2XL = 64.0;
  static const double iconSize200 = 200.0;
}
