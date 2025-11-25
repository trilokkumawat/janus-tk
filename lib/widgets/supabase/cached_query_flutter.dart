import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/services/supabase_service.dart';

/// Cache entry model
class _CacheEntry<T> {
  final List<T> data;
  final DateTime timestamp;
  final Duration duration;

  _CacheEntry({
    required this.data,
    required this.timestamp,
    required this.duration,
  });

  bool get isExpired {
    return DateTime.now().difference(timestamp) > duration;
  }
}

/// Cache state
class _CacheState {
  final Map<String, _CacheEntry<dynamic>> entries;

  _CacheState({Map<String, _CacheEntry<dynamic>>? entries})
    : entries = entries ?? {};

  _CacheState copyWith({Map<String, _CacheEntry<dynamic>>? entries}) {
    return _CacheState(entries: entries ?? this.entries);
  }

  _CacheState removeEntry(String key) {
    final newEntries = Map<String, _CacheEntry<dynamic>>.from(entries);
    newEntries.remove(key);
    return copyWith(entries: newEntries);
  }

  _CacheState addEntry<T>(String key, _CacheEntry<T> entry) {
    final newEntries = Map<String, _CacheEntry<dynamic>>.from(entries);
    newEntries[key] = entry;
    return copyWith(entries: newEntries);
  }

  _CacheState clear() {
    return _CacheState();
  }
}

/// Cache notifier for managing cached queries
class _CacheNotifier extends StateNotifier<_CacheState> {
  _CacheNotifier() : super(_CacheState());

  void addCacheEntry<T>(String key, List<T> data, Duration duration) {
    state = state.addEntry(
      key,
      _CacheEntry<T>(data: data, timestamp: DateTime.now(), duration: duration),
    );
  }

  void removeCacheEntry(String key) {
    state = state.removeEntry(key);
  }

  void clearCache() {
    state = state.clear();
  }

  _CacheEntry<T>? getCacheEntry<T>(String key) {
    final entry = state.entries[key];
    if (entry == null) return null;
    return entry as _CacheEntry<T>?;
  }
}

/// Cache provider
final _cacheProvider = StateNotifierProvider<_CacheNotifier, _CacheState>((
  ref,
) {
  return _CacheNotifier();
});

/// Configuration for a cached query
class _CachedQueryConfig<T> {
  final String queryKey;
  final Future<List<T>> Function() queryFn;
  final Duration cacheDuration;

  _CachedQueryConfig({
    required this.queryKey,
    required this.queryFn,
    required this.cacheDuration,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is _CachedQueryConfig<T> &&
        other.queryKey == queryKey &&
        other.cacheDuration == cacheDuration;
  }

  @override
  int get hashCode => queryKey.hashCode ^ cacheDuration.hashCode;
}

/// Creates a cached query provider
final _cachedQueryProviderFamily =
    FutureProvider.family<List<dynamic>, _CachedQueryConfig<dynamic>>((
      ref,
      config,
    ) async {
      final cacheNotifier = ref.read(_cacheProvider.notifier);
      final cacheEntry = cacheNotifier.getCacheEntry(config.queryKey);

      // Check if cache is valid
      if (cacheEntry != null && !cacheEntry.isExpired) {
        return cacheEntry.data;
      }

      // Fetch data
      final data = await config.queryFn();

      // Update cache
      cacheNotifier.addCacheEntry(config.queryKey, data, config.cacheDuration);

      return data;
    });

/// A widget that caches query results and provides efficient data fetching
///
/// This widget caches query results in memory to avoid unnecessary network requests.
/// It automatically manages cache invalidation and provides real-time updates when needed.
///
/// Example:
/// ```dart
/// CachedQueryFlutter(
///   queryKey: 'tasks_list',
///   queryFn: () async {
///     final response = await SupabaseService.client
///         .from('tasks')
///         .select()
///         .order('created_at', ascending: false);
///     return response;
///   },
///   builder: (context, data, isLoading, error) {
///     if (isLoading) return CircularProgressIndicator();
///     if (error != null) return Text('Error: $error');
///     return ListView.builder(
///       itemCount: data.length,
///       itemBuilder: (context, index) {
///         return ListTile(title: Text(data[index]['title']));
///       },
///     );
///   },
/// )
/// ```
class CachedQueryFlutter<T> extends ConsumerStatefulWidget {
  /// Unique key for the query cache
  final String queryKey;

  /// Function that performs the query
  final Future<List<T>> Function() queryFn;

  /// Builder function that receives the cached data
  final Widget Function(
    BuildContext context,
    List<T> data,
    bool isLoading,
    Object? error,
  )
  builder;

  /// Cache duration (default: 5 minutes)
  final Duration? cacheDuration;

  /// Whether to enable real-time updates
  final bool enableRealtime;

  /// Table name for real-time subscription (required if enableRealtime is true)
  final String? table;

  /// Whether to refetch on mount
  final bool refetchOnMount;

  /// Whether to refetch on reconnect
  final bool refetchOnReconnect;

  /// Custom error widget
  final Widget? errorWidget;

  /// Custom loading widget
  final Widget? loadingWidget;

  /// Custom empty widget
  final Widget? emptyWidget;

  const CachedQueryFlutter({
    super.key,
    required this.queryKey,
    required this.queryFn,
    required this.builder,
    this.cacheDuration,
    this.enableRealtime = false,
    this.table,
    this.refetchOnMount = true,
    this.refetchOnReconnect = true,
    this.errorWidget,
    this.loadingWidget,
    this.emptyWidget,
  }) : assert(
         !enableRealtime || table != null,
         'Table name is required when enableRealtime is true',
       );

  @override
  ConsumerState<CachedQueryFlutter<T>> createState() =>
      _CachedQueryFlutterState<T>();
}

class _CachedQueryFlutterState<T> extends ConsumerState<CachedQueryFlutter<T>> {
  RealtimeChannel? _channel;
  late final _CachedQueryConfig<T> _config;

  @override
  void initState() {
    super.initState();
    _config = _CachedQueryConfig<T>(
      queryKey: widget.queryKey,
      queryFn: widget.queryFn,
      cacheDuration: widget.cacheDuration ?? const Duration(minutes: 5),
    );

    if (widget.enableRealtime && widget.table != null) {
      _setupRealtimeSubscription();
    }
  }

  void _setupRealtimeSubscription() {
    final client = SupabaseService.client;
    _channel = client
        .channel('${widget.queryKey}_realtime')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: widget.table!,
          callback: (_) {
            // Invalidate cache and refetch when real-time changes occur
            ref.read(_cacheProvider.notifier).removeCacheEntry(widget.queryKey);
            // Trigger a refetch by invalidating the provider
            ref.invalidate(_cachedQueryProviderFamily(_config));
          },
        )
        .subscribe();
  }

  @override
  void dispose() {
    _channel?.unsubscribe();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final queryState = ref.watch(_cachedQueryProviderFamily(_config));

    return queryState.when(
      data: (data) {
        final typedData = data as List<T>;
        if (typedData.isEmpty && widget.emptyWidget != null) {
          return widget.emptyWidget!;
        }
        return widget.builder(context, typedData, false, null);
      },
      loading: () => widget.loadingWidget ?? const CircularProgressIndicator(),
      error: (error, stackTrace) =>
          widget.errorWidget ??
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  'Error: ${error.toString()}',
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
    );
  }
}

/// Helper class for managing cached queries
class CachedQueryManager {
  /// Invalidate a specific query cache
  static void invalidate(WidgetRef ref, String queryKey) {
    ref.read(_cacheProvider.notifier).removeCacheEntry(queryKey);
  }

  /// Clear all query caches
  static void clearAll(WidgetRef ref) {
    ref.read(_cacheProvider.notifier).clearCache();
  }

  /// Prefetch a query and cache it
  static Future<void> prefetch<T>(
    WidgetRef ref,
    String queryKey,
    Future<List<T>> Function() queryFn, {
    Duration cacheDuration = const Duration(minutes: 5),
  }) async {
    final data = await queryFn();
    ref
        .read(_cacheProvider.notifier)
        .addCacheEntry(queryKey, data, cacheDuration);
  }
}
