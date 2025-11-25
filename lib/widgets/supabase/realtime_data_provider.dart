import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/services/supabase_service.dart';

/// Provider for real-time data from Supabase using StreamProvider
///
/// This provider automatically updates when data changes in the database
///
/// Example:
/// ```dart
/// final tasksProvider = realtimeDataProvider('tasks');
///
/// // In your widget:
/// final tasks = ref.watch(tasksProvider);
/// ```
final realtimeDataProvider =
    StreamProvider.family<List<Map<String, dynamic>>, String>((ref, table) {
      final controller = StreamController<List<Map<String, dynamic>>>();
      RealtimeChannel? channel;

      // Load initial data
      Future<void> loadData() async {
        try {
          final client = SupabaseService.client;
          final response = await client.from(table).select();
          controller.add(List<Map<String, dynamic>>.from(response));
        } catch (e) {
          controller.addError(e);
        }
      }

      // Handle real-time changes
      void handleRealtimeChange(PostgresChangePayload payload) {
        // Reload data when changes occur
        loadData();
      }

      // Set up real-time subscription
      void setupRealtime() {
        final client = SupabaseService.client;

        channel = client
            .channel('${table}_provider_changes')
            .onPostgresChanges(
              event: PostgresChangeEvent.all,
              schema: 'public',
              table: table,
              callback: handleRealtimeChange,
            )
            .subscribe();
      }

      // Initialize
      loadData();
      setupRealtime();

      // Cleanup on dispose
      ref.onDispose(() {
        channel?.unsubscribe();
        controller.close();
      });

      return controller.stream;
    });

/// Provider for filtered real-time data
final filteredRealtimeDataProvider =
    Provider.family<
      AsyncValue<List<Map<String, dynamic>>>,
      RealtimeQueryParams
    >((ref, params) {
      final allData = ref.watch(realtimeDataProvider(params.table));

      return allData.when(
        data: (items) {
          // Apply filters here if needed
          // This is a simplified version - extend as needed
          return AsyncValue.data(items);
        },
        loading: () => const AsyncValue.loading(),
        error: (error, stack) => AsyncValue.error(error, stack),
      );
    });

/// Parameters for real-time queries
class RealtimeQueryParams {
  final String table;
  final String? filter;
  final String? orderBy;
  final int? limit;

  const RealtimeQueryParams({
    required this.table,
    this.filter,
    this.orderBy,
    this.limit,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RealtimeQueryParams &&
          runtimeType == other.runtimeType &&
          table == other.table &&
          filter == other.filter &&
          orderBy == other.orderBy &&
          limit == other.limit;

  @override
  int get hashCode =>
      table.hashCode ^ filter.hashCode ^ orderBy.hashCode ^ limit.hashCode;
}
