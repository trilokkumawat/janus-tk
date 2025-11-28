import 'package:flutter/widgets.dart';

/// Custom vertical gaps for consistent spacing
class Gaps {
  // Height gaps
  static const Widget h4 = SizedBox(height: 4);
  static const Widget h8 = SizedBox(height: 8);
  static const Widget h10 = SizedBox(height: 10);
  static const Widget h12 = SizedBox(height: 12);
  static const Widget h16 = SizedBox(height: 16);
  static const Widget h20 = SizedBox(height: 20);
  static const Widget h25 = SizedBox(height: 25);
  static const Widget h30 = SizedBox(height: 30);

  static const Widget h24 = SizedBox(height: 24);
  static const Widget h32 = SizedBox(height: 32);
  static const Widget h40 = SizedBox(height: 40);
  static const Widget h48 = SizedBox(height: 48);
  static const Widget h56 = SizedBox(height: 56);
  static const Widget h64 = SizedBox(height: 64);

  // Width gaps
  static const Widget w4 = SizedBox(width: 4);
  static const Widget w8 = SizedBox(width: 8);
  static const Widget w12 = SizedBox(width: 12);
  static const Widget w16 = SizedBox(width: 16);
  static const Widget w20 = SizedBox(width: 20);
  static const Widget w24 = SizedBox(width: 24);
  static const Widget w32 = SizedBox(width: 32);
  static const Widget w40 = SizedBox(width: 40);
  static const Widget w48 = SizedBox(width: 48);
  static const Widget w56 = SizedBox(width: 56);
  static const Widget w64 = SizedBox(width: 64);

  // Custom size
  static Widget height(double value) => SizedBox(height: value);
  static Widget width(double value) => SizedBox(width: value);
}
