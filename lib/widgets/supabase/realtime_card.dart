import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'realtime_data_provider.dart';

/// A card widget that displays real-time data from Supabase
///
/// This widget automatically updates when data changes in the database
///
/// Example:
/// ```dart
/// RealtimeCard(
///   table: 'tasks',
///   itemId: '123',
///   builder: (context, item) {
///     return Card(
///       child: ListTile(
///         title: Text(item['title']),
///         subtitle: Text(item['description']),
///       ),
///     );
///   },
/// )
/// ```
class RealtimeCard extends ConsumerWidget {
  /// The table name to fetch data from
  final String table;

  /// The ID of the item to display
  final String itemId;

  /// Builder function for the card content
  final Widget Function(BuildContext context, Map<String, dynamic> item)
  builder;

  /// Custom error widget
  final Widget? errorWidget;

  /// Custom loading widget
  final Widget? loadingWidget;

  /// Custom not found widget
  final Widget? notFoundWidget;

  const RealtimeCard({
    super.key,
    required this.table,
    required this.itemId,
    required this.builder,
    this.errorWidget,
    this.loadingWidget,
    this.notFoundWidget,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataAsync = ref.watch(realtimeDataProvider(table));

    return dataAsync.when(
      data: (items) {
        final item = items.firstWhere(
          (item) => item['id'] == itemId,
          orElse: () => <String, dynamic>{},
        );

        if (item.isEmpty) {
          return notFoundWidget ?? const Center(child: Text('Item not found'));
        }

        return builder(context, item);
      },
      loading: () =>
          loadingWidget ?? const Center(child: CircularProgressIndicator()),
      error: (error, stack) =>
          errorWidget ??
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Error: $error'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => ref.refresh(realtimeDataProvider(table)),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
    );
  }
}
