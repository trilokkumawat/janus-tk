import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'dart:math' as math;

/// Global confetti overlay that can be triggered from anywhere
///
/// This widget provides a confetti animation overlay that can be
/// controlled globally using ConfettiController.
///
/// Example:
/// ```dart
/// // In your app:
/// ConfettiOverlay(
///   child: YourApp(),
/// )
///
/// // Trigger confetti from anywhere:
/// GlobalConfettiController.show();
/// ```
class ConfettiOverlay extends StatefulWidget {
  /// The child widget to display
  final Widget child;

  /// Number of confetti particles
  final int particleCount;

  /// Colors for confetti
  final List<Color> colors;

  /// Duration of the confetti animation
  final Duration duration;

  /// Gravity for confetti particles (must be between 0 and 1)
  final double gravity;

  const ConfettiOverlay({
    super.key,
    required this.child,
    this.particleCount = 50,
    this.colors = const [
      Colors.green,
      Colors.blue,
      Colors.pink,
      Colors.orange,
      Colors.purple,
    ],
    this.duration = const Duration(seconds: 3),
    this.gravity = 0.1,
  }) : assert(gravity >= 0 && gravity <= 1, 'Gravity must be between 0 and 1');

  @override
  State<ConfettiOverlay> createState() => _ConfettiOverlayState();
}

class _ConfettiOverlayState extends State<ConfettiOverlay> {
  late final ConfettiController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ConfettiController(duration: widget.duration);
    // Register this controller globally
    GlobalConfettiController.instance = _controller;
  }

  @override
  void dispose() {
    if (GlobalConfettiController.instance == _controller) {
      GlobalConfettiController.instance = null;
    }
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        // Confetti overlay from top
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: _controller,
            blastDirection: math.pi / 2, // Downward
            emissionFrequency: 0.05,
            numberOfParticles: widget.particleCount,
            gravity: widget.gravity.clamp(
              0.0,
              1.0,
            ), // Ensure gravity is between 0 and 1
            colors: widget.colors,
            shouldLoop: false,
          ),
        ),
        // Additional confetti from bottom
        Align(
          alignment: Alignment.bottomCenter,
          child: ConfettiWidget(
            confettiController: _controller,
            blastDirection: -math.pi / 2, // Upward
            emissionFrequency: 0.05,
            numberOfParticles: widget.particleCount ~/ 2,
            gravity: widget.gravity.clamp(
              0.0,
              1.0,
            ), // Ensure gravity is between 0 and 1
            colors: widget.colors,
            shouldLoop: false,
          ),
        ),
      ],
    );
  }
}

/// Global controller for confetti overlay
///
/// Use this to trigger confetti from anywhere in your app
///
/// Example:
/// ```dart
/// // Show confetti
/// GlobalConfettiController.show();
///
/// // Show confetti with custom duration
/// GlobalConfettiController.show(duration: Duration(seconds: 5));
///
/// // Stop confetti
/// GlobalConfettiController.stop();
/// ```
class GlobalConfettiController {
  static ConfettiController? instance;

  /// Show confetti animation
  ///
  /// [duration] - How long the confetti should play (optional)
  static void show({Duration? duration}) {
    instance?.play();
    if (duration != null) {
      Future.delayed(duration, () {
        instance?.stop();
      });
    }
  }

  /// Stop confetti animation
  static void stop() {
    instance?.stop();
  }
}
