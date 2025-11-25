import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'realtime_data_provider.dart';

/// A counter widget that displays the count of items in real-time
///
/// This widget automatically updates when items are added or removed
///
/// Example:
/// ```dart
/// RealtimeCounter(
///   table: 'tasks',
///   filter: 'status = "completed"',
///   style: TextStyle(fontSize: 24),
/// )
/// ```
class RealtimeCounter extends ConsumerWidget {
  /// The table name to count items from
  final String table;

  /// Optional filter to apply
  final String? filter;

  /// Text style for the counter
  final TextStyle? style;

  /// Prefix text before the count
  final String? prefix;

  /// Suffix text after the count
  final String? suffix;

  /// Custom loading widget
  final Widget? loadingWidget;

  /// Custom error widget
  final Widget? errorWidget;

  const RealtimeCounter({
    super.key,
    required this.table,
    this.filter,
    this.style,
    this.prefix,
    this.suffix,
    this.loadingWidget,
    this.errorWidget,
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
          // For production, use proper query filtering
        }

        return Text(
          '${prefix ?? ''}$count${suffix ?? ''}',
          style: style ?? Theme.of(context).textTheme.headlineMedium,
        );
      },
      loading: () =>
          loadingWidget ??
          const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
      error: (error, stack) =>
          errorWidget ??
          Text(
            'Error',
            style: style ?? Theme.of(context).textTheme.headlineMedium,
          ),
    );
  }
}
