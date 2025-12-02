import 'package:flutter/material.dart';
import 'package:janus/core/theme/app_theme.dart';

/// A reusable custom card component with theme-aware styling
///
/// This widget provides a consistent card design throughout the app
/// with automatic theme support and customizable properties.
///
/// Example usage:
/// ```dart
/// CustomCard(
///   margin: EdgeInsets.all(16),
///   child: ListTile(
///     title: Text('Title'),
///     subtitle: Text('Subtitle'),
///   ),
/// )
/// ```
class CustomCard extends StatelessWidget {
  /// The child widget to display inside the card
  final Widget child;

  /// Margin around the card
  final EdgeInsetsGeometry? margin;

  /// Padding inside the card
  final EdgeInsetsGeometry? padding;

  /// Card elevation
  final double? elevation;

  /// Card color (if null, uses theme-aware color)
  final Color? color;

  /// Card shape
  final ShapeBorder? shape;

  /// Border radius (default: 12)
  final double borderRadius;

  /// Whether to use theme-aware background color
  final bool useThemeBackground;

  /// Border around the card
  final Border? border;

  /// Box shadow for the card
  final List<BoxShadow>? boxShadow;

  /// Callback when card is tapped
  final VoidCallback? onTap;

  /// Callback when card is long pressed
  final VoidCallback? onLongPress;

  const CustomCard({
    super.key,
    required this.child,
    this.margin,
    this.padding,
    this.elevation,
    this.color,
    this.shape,
    this.borderRadius = 12.0,
    this.useThemeBackground = true,
    this.border,
    this.boxShadow,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Determine effective background color
    Color? effectiveColor = color;
    if (useThemeBackground && effectiveColor == null) {
      effectiveColor = isDark ? AppColors.darkCard : AppColors.lightCard;
    }

    // Build effective shape
    final effectiveShape =
        shape ??
        (border != null
            ? RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                side: BorderSide(
                  color: border!.top.color,
                  width: border!.top.width,
                ),
              )
            : RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius),
              ));

    // Build decoration if custom styling is needed
    BoxDecoration? decoration;
    if (boxShadow != null || (border != null && shape == null)) {
      decoration = BoxDecoration(
        color: effectiveColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: border,
        boxShadow: boxShadow,
      );
      effectiveColor = null; // Don't use Card's color if we have decoration
    }

    Widget cardContent = padding != null
        ? Padding(padding: padding!, child: child)
        : child;

    if (decoration != null) {
      cardContent = Container(decoration: decoration, child: cardContent);
    }

    final card = Card(
      margin: margin,
      elevation: elevation ?? 2,
      color: effectiveColor,
      shape: decoration == null ? effectiveShape : null,
      child: cardContent,
    );

    if (onTap != null || onLongPress != null) {
      return InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(borderRadius),
        child: card,
      );
    }

    return card;
  }
}
