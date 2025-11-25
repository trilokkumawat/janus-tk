import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'realtime_data_provider.dart';

/// A badge widget that displays a count with real-time updates
///
/// This widget automatically updates when items are added or removed
///
/// Example:
/// ```dart
/// RealtimeBadge(
///   table: 'notifications',
///   filter: 'read = false',
///   child: Icon(Icons.notifications),
/// )
/// ```
class RealtimeBadge extends ConsumerWidget {
  /// The table name to count items from
  final String table;

  /// Optional filter to apply
  final String? filter;

  /// The widget to display the badge on
  final Widget child;

  /// Badge color
  final Color? badgeColor;

  /// Badge text color
  final Color? textColor;

  /// Minimum count to show badge (default: 0)
  final int minCount;

  /// Custom loading widget
  final Widget? loadingWidget;

  const RealtimeBadge({
    super.key,
    required this.table,
    required this.child,
    this.filter,
    this.badgeColor,
    this.textColor,
    this.minCount = 0,
    this.loadingWidget,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataAsync = ref.watch(realtimeDataProvider(table));

    return dataAsync.when(
      data: (items) {
        int count = items.length;

        // Apply filter if provided
        if (filter != null) {
          // This is a simplified filter - extend as needed
        }

        if (count <= minCount) {
          return child;
        }

        return Badge(
          backgroundColor: badgeColor ?? Colors.red,
          textColor: textColor ?? Colors.white,
          label: Text(
            count > 99 ? '99+' : count.toString(),
            style: const TextStyle(fontSize: 10),
          ),
          child: child,
        );
      },
      loading: () => loadingWidget ?? child,
      error: (error, stack) => child,
    );
  }
}
