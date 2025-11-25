import 'package:flutter/material.dart';

/// Mixin that provides safe setState functionality
///
/// This mixin adds a safeSetState method that checks if the widget
/// is still mounted before calling setState, preventing errors when
/// setState is called after the widget has been disposed.
///
/// Example:
/// ```dart
/// class _MyWidgetState extends State<MyWidget> with SafeStateMixin {
///   void updateData() {
///     safeSetState(() {
///       // Update state here
///     });
///   }
/// }
/// ```
mixin SafeStateMixin<T extends StatefulWidget> on State<T> {
  /// Safely calls setState only if the widget is still mounted
  ///
  /// This prevents "setState() called after dispose()" errors
  /// that can occur when async operations complete after the widget
  /// has been disposed.
  ///
  /// Returns true if setState was called, false if the widget was not mounted
  bool safeSetState(VoidCallback fn) {
    if (mounted) {
      setState(fn);
      return true;
    }
    return false;
  }
}

/// Extension on State to provide safe setState functionality
///
/// This extension adds a safeSetState method that checks if the widget
/// is still mounted before calling setState, preventing errors when
/// setState is called after the widget has been disposed.
///
/// Note: This uses a workaround to access setState. For better type safety,
/// consider using SafeStateMixin instead.
///
/// Example:
/// ```dart
/// class _MyWidgetState extends State<MyWidget> {
///   void updateData() {
///     safeSetState(() {
///       // Update state here
///     });
///   }
/// }
/// ```
extension SafeStateExtension<T extends StatefulWidget> on State<T> {
  /// Safely calls setState only if the widget is still mounted
  ///
  /// This prevents "setState() called after dispose()" errors
  /// that can occur when async operations complete after the widget
  /// has been disposed.
  ///
  /// Returns true if setState was called, false if the widget was not mounted
  bool safeSetState(VoidCallback fn) {
    if (mounted) {
      // Use dynamic to bypass the protected access restriction
      // This is safe because we're checking mounted first
      (this as dynamic).setState(fn);
      return true;
    }
    return false;
  }
}
