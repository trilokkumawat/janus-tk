import 'package:flutter/material.dart';
import 'package:janus/widgets/common/custom_card.dart';

/// An animated list item widget with staggered fade and slide animations
///
/// This widget provides smooth entrance animations for list items,
/// with each item appearing after a delay based on its index.
///
/// Example usage:
/// ```dart
/// ListView.builder(
///   itemCount: items.length,
///   itemBuilder: (context, index) {
///     return AnimatedListItem(
///       index: index,
///       child: Card(
///         child: ListTile(
///           title: Text(items[index].name),
///         ),
///       ),
///     );
///   },
/// )
/// ```
class AnimatedListItem extends StatefulWidget {
  /// The child widget to animate
  final Widget child;

  /// The index of the item in the list (used for staggered delay)
  final int index;

  /// Base delay between each item animation (in milliseconds)
  final int delayPerItem;

  /// Duration of the animation
  final Duration duration;

  /// Animation curve
  final Curve curve;

  /// Whether to include slide animation along with fade
  final bool enableSlide;

  /// Direction of slide animation
  final AxisDirection slideDirection;

  /// Offset for slide animation
  final double slideOffset;

  const AnimatedListItem({
    super.key,
    required this.child,
    required this.index,
    this.delayPerItem = 50,
    this.duration = const Duration(milliseconds: 400),
    this.curve = Curves.easeOut,
    this.enableSlide = true,
    this.slideDirection = AxisDirection.down,
    this.slideOffset = 20.0,
  });

  @override
  State<AnimatedListItem> createState() => _AnimatedListItemState();
}

class _AnimatedListItemState extends State<AnimatedListItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);

    _fadeAnimation = CurvedAnimation(parent: _controller, curve: widget.curve);

    if (widget.enableSlide) {
      final offset = _getSlideOffset();
      _slideAnimation = Tween<Offset>(
        begin: offset,
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));
    } else {
      _slideAnimation = AlwaysStoppedAnimation(Offset.zero);
    }

    // Start animation after delay based on index
    final delay = Duration(milliseconds: widget.index * widget.delayPerItem);
    Future.delayed(delay, () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  Offset _getSlideOffset() {
    switch (widget.slideDirection) {
      case AxisDirection.up:
        return Offset(0, widget.slideOffset);
      case AxisDirection.down:
        return Offset(0, -widget.slideOffset);
      case AxisDirection.left:
        return Offset(widget.slideOffset, 0);
      case AxisDirection.right:
        return Offset(-widget.slideOffset, 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(position: _slideAnimation, child: widget.child),
    );
  }
}

/// A wrapper for animated cards in lists
///
/// Convenience widget that combines Card with AnimatedListItem
///
/// Example usage:
/// ```dart
/// ListView.builder(
///   itemCount: items.length,
///   itemBuilder: (context, index) {
///     return AnimatedCard(
///       index: index,
///       margin: EdgeInsets.only(bottom: 8),
///       child: ListTile(
///         title: Text(items[index].name),
///       ),
///     );
///   },
/// )
/// ```
class AnimatedCard extends StatelessWidget {
  /// The child widget to display inside the card
  final Widget child;

  /// The index of the item in the list
  final int index;

  /// Card margin
  final EdgeInsetsGeometry? margin;

  /// Card elevation
  final double? elevation;

  /// Card color
  final Color? color;

  /// Card shape
  final ShapeBorder? shape;

  /// Animation delay per item (in milliseconds)
  final int delayPerItem;

  /// Animation duration
  final Duration duration;

  /// Animation curve
  final Curve curve;

  /// Whether to enable slide animation
  final bool enableSlide;

  const AnimatedCard({
    super.key,
    required this.child,
    required this.index,
    this.margin,
    this.elevation,
    this.color,
    this.shape,
    this.delayPerItem = 300,
    this.duration = const Duration(milliseconds: 600),
    this.curve = Curves.easeInOut,
    this.enableSlide = true,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedListItem(
      index: index,
      delayPerItem: delayPerItem,
      duration: duration,
      curve: curve,
      enableSlide: enableSlide,
      child: CustomCard(
        margin: margin,
        elevation: elevation,
        color: color,
        shape: shape,
        child: child,
      ),
    );
  }
}
