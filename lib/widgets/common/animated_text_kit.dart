import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:janus/core/constants/app_text_style.dart';
import 'package:janus/core/theme/app_theme.dart';

/// Type of animated text to display
enum AnimatedTextType {
  typewriter,
  fade,
  rotate,
  scale,
  typer,
  colorize,
  wavy,
  flicker,
}

/// A reusable animated text component using animated_text_kit
///
/// Provides various text animation effects with theme-aware styling.
///
/// Example usage:
/// ```dart
/// CustomAnimatedText(
///   text: 'Hello World',
///   type: AnimatedTextType.typewriter,
///   style: AppTextStyle.h3,
/// )
/// ```
class CustomAnimatedText extends StatelessWidget {
  /// The text to animate
  final String text;

  /// List of texts to animate (for typewriter, fade, etc.)
  final List<String>? textList;

  /// Type of animation
  final AnimatedTextType type;

  /// Text style
  final TextStyle? style;

  /// Text alignment
  final TextAlign textAlign;

  /// Speed of animation
  final Duration speed;

  /// Total duration for the animation
  final Duration? totalRepeatCount;

  /// Number of times to repeat (null for infinite)
  final int? repeatForever;

  /// Pause between animations
  final Duration pause;

  /// Display full text at once
  final bool displayFullTextOnTap;

  /// Callback when animation completes
  final VoidCallback? onFinished;

  /// Callback when animation starts (receives index and isLast)
  final void Function(int, bool)? onNext;

  /// Callback before next text (receives index and isLast)
  final void Function(int, bool)? onNextBeforePause;

  /// Colors for colorize animation
  final List<Color>? colors;

  const CustomAnimatedText({
    super.key,
    required this.text,
    this.textList,
    this.type = AnimatedTextType.typewriter,
    this.style,
    this.textAlign = TextAlign.start,
    this.speed = const Duration(milliseconds: 50),
    this.totalRepeatCount,
    this.repeatForever,
    this.pause = const Duration(milliseconds: 1000),
    this.displayFullTextOnTap = false,
    this.onFinished,
    this.onNext,
    this.onNextBeforePause,
    this.colors,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final effectiveStyle =
        style ??
        AppTextStyle.h3.copyWith(
          color: isDark ? AppColors.lightText : AppColors.darkText,
        );

    final effectiveColors =
        colors ??
        [
          AppColors.purple,
          AppColors.blue,
          AppColors.coral,
          AppColors.orange,
          AppColors.green,
        ];

    final texts = textList ?? [text];

    switch (type) {
      case AnimatedTextType.typewriter:
        return TypewriterAnimatedTextKit(
          text: texts,
          textStyle: effectiveStyle,
          textAlign: textAlign,
          speed: speed,
          totalRepeatCount: repeatForever ?? 1,
          pause: pause,
          displayFullTextOnTap: displayFullTextOnTap,
          onFinished: onFinished,
          onNext: onNext,
          onNextBeforePause: onNextBeforePause,
        );

      case AnimatedTextType.fade:
        return FadeAnimatedTextKit(
          text: texts,
          textStyle: effectiveStyle,
          textAlign: textAlign,
          duration: speed,
          totalRepeatCount: repeatForever ?? 1,
          pause: pause,
          displayFullTextOnTap: displayFullTextOnTap,
          onFinished: onFinished,
          onNext: onNext,
          onNextBeforePause: onNextBeforePause,
        );

      case AnimatedTextType.rotate:
        return RotateAnimatedTextKit(
          text: texts,
          textStyle: effectiveStyle,
          textAlign: textAlign,
          totalRepeatCount: repeatForever ?? 1,
          pause: pause,
          displayFullTextOnTap: displayFullTextOnTap,
          onFinished: onFinished,
          onNext: onNext,
          onNextBeforePause: onNextBeforePause,
        );

      case AnimatedTextType.scale:
        return ScaleAnimatedTextKit(
          text: texts,
          textStyle: effectiveStyle,
          textAlign: textAlign,
          totalRepeatCount: repeatForever ?? 1,
          pause: pause,
          displayFullTextOnTap: displayFullTextOnTap,
          onFinished: onFinished,
          onNext: onNext,
          onNextBeforePause: onNextBeforePause,
        );

      case AnimatedTextType.typer:
        return TyperAnimatedTextKit(
          text: texts,
          textStyle: effectiveStyle,
          textAlign: textAlign,
          speed: speed,
          totalRepeatCount: repeatForever ?? 1,
          pause: pause,
          displayFullTextOnTap: displayFullTextOnTap,
          onFinished: onFinished,
          onNext: onNext,
          onNextBeforePause: onNextBeforePause,
        );

      case AnimatedTextType.colorize:
        return ColorizeAnimatedTextKit(
          text: texts,
          textStyle: effectiveStyle,
          textAlign: textAlign,
          speed: speed,
          totalRepeatCount: repeatForever ?? 1,
          pause: pause,
          displayFullTextOnTap: displayFullTextOnTap,
          onFinished: onFinished,
          onNext: onNext,
          onNextBeforePause: onNextBeforePause,
          colors: effectiveColors,
        );

      case AnimatedTextType.wavy:
        return WavyAnimatedTextKit(
          text: texts,
          textStyle: effectiveStyle,
          textAlign: textAlign,
          speed: speed,
          totalRepeatCount: repeatForever ?? 1,
          pause: pause,
          displayFullTextOnTap: displayFullTextOnTap,
          onFinished: onFinished,
          onNext: onNext,
          onNextBeforePause: onNextBeforePause,
        );

      case AnimatedTextType.flicker:
        return FlickerAnimatedTextKit(
          text: texts,
          textStyle: effectiveStyle,
          textAlign: textAlign,
          speed: speed,
          totalRepeatCount: repeatForever ?? 1,
          displayFullTextOnTap: displayFullTextOnTap,
          onFinished: onFinished,
          onNext: onNext,
          onNextBeforePause: onNextBeforePause,
        );
    }
  }
}

/// Convenience widget for typewriter animated text
///
/// Example usage:
/// ```dart
/// TypewriterText(
///   text: 'Hello World',
///   style: AppTextStyle.h2,
/// )
/// ```
class TypewriterText extends StatelessWidget {
  final String text;
  final List<String>? textList;
  final TextStyle? style;
  final TextAlign textAlign;
  final Duration speed;
  final int? repeatForever;
  final Duration pause;

  const TypewriterText({
    super.key,
    required this.text,
    this.textList,
    this.style,
    this.textAlign = TextAlign.start,
    this.speed = const Duration(milliseconds: 50),
    this.repeatForever,
    this.pause = const Duration(milliseconds: 1000),
  });

  @override
  Widget build(BuildContext context) {
    return CustomAnimatedText(
      text: text,
      textList: textList,
      type: AnimatedTextType.typewriter,
      style: style,
      textAlign: textAlign,
      speed: speed,
      repeatForever: repeatForever,
      pause: pause,
    );
  }
}

/// Convenience widget for fade animated text
class FadeText extends StatelessWidget {
  final String text;
  final List<String>? textList;
  final TextStyle? style;
  final TextAlign textAlign;
  final Duration speed;
  final int? repeatForever;
  final Duration pause;

  const FadeText({
    super.key,
    required this.text,
    this.textList,
    this.style,
    this.textAlign = TextAlign.start,
    this.speed = const Duration(milliseconds: 200),
    this.repeatForever,
    this.pause = const Duration(milliseconds: 1000),
  });

  @override
  Widget build(BuildContext context) {
    return CustomAnimatedText(
      text: text,
      textList: textList,
      type: AnimatedTextType.fade,
      style: style,
      textAlign: textAlign,
      speed: speed,
      repeatForever: repeatForever,
      pause: pause,
    );
  }
}

/// Convenience widget for colorize animated text
class ColorizeText extends StatelessWidget {
  final String text;
  final List<String>? textList;
  final TextStyle? style;
  final TextAlign textAlign;
  final Duration speed;
  final int? repeatForever;
  final Duration pause;
  final List<Color>? colors;

  const ColorizeText({
    super.key,
    required this.text,
    this.textList,
    this.style,
    this.textAlign = TextAlign.start,
    this.speed = const Duration(milliseconds: 200),
    this.repeatForever,
    this.pause = const Duration(milliseconds: 1000),
    this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return CustomAnimatedText(
      text: text,
      textList: textList,
      type: AnimatedTextType.colorize,
      style: style,
      textAlign: textAlign,
      speed: speed,
      repeatForever: repeatForever,
      pause: pause,
      colors: colors,
    );
  }
}
