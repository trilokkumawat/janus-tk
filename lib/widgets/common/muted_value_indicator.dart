import 'package:flutter/material.dart';

/// A widget that displays a muted value indicator
///
/// This widget shows when a value is muted, typically used to indicate
/// that a value is not active or has been silenced.
///
/// Example:
/// ```dart
/// MutedValueIndicator(
///   value: 'Some text',
///   isMuted: true,
/// )
/// ```
class MutedValueIndicator extends StatelessWidget {
  /// The value to display
  final String value;

  /// Whether the value is muted
  final bool isMuted;

  /// Custom text style for the muted value
  final TextStyle? mutedTextStyle;

  /// Custom text style for the normal value
  final TextStyle? normalTextStyle;

  /// Icon to show when muted (default: Icons.volume_off)
  final IconData? mutedIcon;

  /// Size of the muted icon
  final double? iconSize;

  /// Spacing between icon and text
  final double? iconSpacing;

  /// Alignment of the content
  final AlignmentGeometry? alignment;

  const MutedValueIndicator({
    super.key,
    required this.value,
    this.isMuted = false,
    this.mutedTextStyle,
    this.normalTextStyle,
    this.mutedIcon,
    this.iconSize,
    this.iconSpacing,
    this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultMutedStyle = TextStyle(
      color: Colors.grey[600],
      decoration: TextDecoration.lineThrough,
      decorationColor: Colors.grey[600],
    );
    final defaultNormalStyle = theme.textTheme.bodyMedium;

    return Align(
      alignment: alignment ?? Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isMuted) ...[
            Icon(
              mutedIcon ?? Icons.volume_off,
              size: iconSize ?? 16,
              color: Colors.grey[600],
            ),
            SizedBox(width: iconSpacing ?? 8),
          ],
          Text(
            value,
            style: isMuted
                ? (mutedTextStyle ?? defaultMutedStyle)
                : (normalTextStyle ?? defaultNormalStyle),
          ),
        ],
      ),
    );
  }
}

/// A widget that displays a muted value badge
///
/// This widget shows a badge indicating that a value is muted
///
/// Example:
/// ```dart
/// MutedValueBadge(
///   child: Text('Some content'),
///   isMuted: true,
/// )
/// ```
class MutedValueBadge extends StatelessWidget {
  /// The child widget to display
  final Widget child;

  /// Whether the value is muted
  final bool isMuted;

  /// Badge color when muted
  final Color? mutedColor;

  /// Badge text
  final String? badgeText;

  /// Badge position
  final AlignmentGeometry badgeAlignment;

  const MutedValueBadge({
    super.key,
    required this.child,
    this.isMuted = false,
    this.mutedColor,
    this.badgeText,
    this.badgeAlignment = Alignment.topRight,
  });

  @override
  Widget build(BuildContext context) {
    if (!isMuted) {
      return child;
    }

    return Stack(
      children: [
        Opacity(opacity: 0.5, child: child),
        Positioned.fill(
          child: Align(
            alignment: badgeAlignment,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: mutedColor ?? Colors.grey[600],
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                badgeText ?? 'MUTED',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
