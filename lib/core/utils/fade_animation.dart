import 'package:flutter/material.dart';

class FadeAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;
  final bool fadeInOnInit;
  final Duration? delay;
  final VoidCallback? onFadeInComplete;
  final VoidCallback? onFadeOutComplete;
  final bool fadeOutAfterDelay;
  final Duration fadeOutDelay;

  const FadeAnimation({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOut,
    this.fadeInOnInit = true,
    this.delay,
    this.onFadeInComplete,
    this.onFadeOutComplete,
    this.fadeOutAfterDelay = false,
    this.fadeOutDelay = const Duration(seconds: 1),
  });

  @override
  State<FadeAnimation> createState() => _FadeAnimationState();
}

class _FadeAnimationState extends State<FadeAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);

    _animation = CurvedAnimation(parent: _controller, curve: widget.curve);

    if (widget.onFadeInComplete != null || widget.onFadeOutComplete != null) {
      _controller.addStatusListener(_handleAnimationStatus);
    }

    if (widget.fadeOutAfterDelay) {
      // Start with full opacity (visible)
      _controller.value = 1.0;
      _isInitialized = true;

      // After delay, fade out
      Future.delayed(widget.fadeOutDelay, () {
        if (mounted) {
          _controller.reverse();
        }
      });
    } else if (widget.fadeInOnInit) {
      if (widget.delay != null) {
        Future.delayed(widget.delay!, () {
          if (mounted) {
            _controller.forward();
            _isInitialized = true;
          }
        });
      } else {
        _controller.forward();
        _isInitialized = true;
      }
    } else {
      _controller.value = 1.0;
      _isInitialized = true;
    }
  }

  @override
  void didUpdateWidget(FadeAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.child != oldWidget.child) {
      _controller.reset();
      _controller.forward();
    }
  }

  void _handleAnimationStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      widget.onFadeInComplete?.call();
    } else if (status == AnimationStatus.dismissed) {
      widget.onFadeOutComplete?.call();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized && widget.fadeInOnInit) {
      return Opacity(opacity: 0.0, child: widget.child);
    }

    return FadeTransition(opacity: _animation, child: widget.child);
  }
}

class FadeSwitcher extends StatelessWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;
  final Widget Function(Widget child, Animation<double> animation)?
  transitionBuilder;

  const FadeSwitcher({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOut,
    this.transitionBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: duration,
      switchInCurve: curve,
      switchOutCurve: curve,
      transitionBuilder:
          transitionBuilder ??
          (child, animation) {
            return FadeTransition(opacity: animation, child: child);
          },
      child: child,
    );
  }
}

class AsyncValueFade extends StatelessWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;

  const AsyncValueFade({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOut,
  });

  @override
  Widget build(BuildContext context) {
    return FadeSwitcher(duration: duration, curve: curve, child: child);
  }
}
