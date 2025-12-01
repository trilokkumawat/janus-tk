import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/services/supabase_fn/supabase_service.dart';
import '../../core/extensions/state_extensions.dart';

/// A specialized ListView that displays real-time data from Supabase
///
/// This widget automatically updates when data changes in the database
///
/// Example:
/// ```dart
/// RealtimeListView(
///   table: 'tasks',
///   itemBuilder: (context, item, index) {
///     return ListTile(
///       title: Text(item['title']),
///       subtitle: Text(item['description']),
///     );
///   },
/// )
/// ```
class RealtimeListView extends StatefulWidget {
  /// The table name to fetch data from
  final String table;

  /// Builder function for each list item
  final Widget Function(
    BuildContext context,
    Map<String, dynamic> item,
    int index,
  )
  itemBuilder;

  /// Optional filter query
  final String? filter;

  /// Optional order by clause (e.g., 'created_at desc')
  final String? orderBy;

  /// Optional limit for the query
  final int? limit;

  /// Optional columns to select
  final String? columns;

  /// Custom empty state widget
  final Widget? emptyWidget;

  /// Custom error widget
  final Widget? errorWidget;

  /// Custom loading widget
  final Widget? loadingWidget;

  /// Custom loading widget for lazy loading (shows at bottom when loading more)
  final Widget? lazyLoadingWidget;

  /// Scroll controller
  final ScrollController? scrollController;

  /// Padding for the list
  final EdgeInsets? padding;

  /// Enable lazy loading (pagination)
  final bool enableLazyLoading;

  /// Number of items to load per page
  final int pageSize;

  /// ID column name for pagination (default: 'id')
  final String? idColumn;

  const RealtimeListView({
    super.key,
    required this.table,
    required this.itemBuilder,
    this.filter,
    this.orderBy,
    this.limit,
    this.columns,
    this.emptyWidget,
    this.errorWidget,
    this.loadingWidget,
    this.lazyLoadingWidget,
    this.scrollController,
    this.padding,
    this.enableLazyLoading = false,
    this.pageSize = 20,
    this.idColumn,
  });

  @override
  State<RealtimeListView> createState() => _RealtimeListViewState();
}

class _RealtimeListViewState extends State<RealtimeListView> {
  List<Map<String, dynamic>> _items = [];
  bool _isLoading = true;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  String? _error;
  RealtimeChannel? _channel;
  ScrollController? _internalScrollController;
  dynamic _lastCursorValue; // Can be String, int, or DateTime
  String? _orderColumn;
  bool _isAscending = true;

  @override
  void initState() {
    super.initState();
    _internalScrollController = widget.scrollController ?? ScrollController();
    if (widget.enableLazyLoading) {
      _internalScrollController!.addListener(_onScroll);
    }
    _loadData();
    _setupRealtimeSubscription();
  }

  /// Reset pagination and reload data from the beginning
  Future<void> resetPagination() async {
    safeSetState(() {
      _items = [];
      _lastCursorValue = null;
      _hasMore = true;
    });
    await _loadData();
  }

  void _onScroll() {
    if (!widget.enableLazyLoading ||
        _isLoadingMore ||
        !_hasMore ||
        !_internalScrollController!.hasClients)
      return;

    final position = _internalScrollController!.position;
    final maxScroll = position.maxScrollExtent;
    final currentScroll = position.pixels;
    final delta = 200.0; // Load more when 200px from bottom

    // Load more when user scrolls near the bottom
    if (currentScroll >= (maxScroll - delta)) {
      _loadMoreData();
    }
  }

  Future<void> _loadData() async {
    try {
      safeSetState(() {
        _isLoading = true;
        _error = null;
        _items = [];
        _lastCursorValue = null;
        _hasMore = true;
      });

      final client = SupabaseService.client;
      dynamic query = client.from(widget.table).select(widget.columns ?? '*');

      if (widget.filter != null) {
        // For more complex filters, you can extend this
        query = query.eq('id', widget.filter!);
      }

      // Parse orderBy to determine order column and direction
      if (widget.orderBy != null) {
        final parts = widget.orderBy!.split(' ');
        _orderColumn = parts[0];
        _isAscending = parts.length == 2
            ? parts[1].toLowerCase() == 'asc'
            : true;
        query = query.order(_orderColumn!, ascending: _isAscending);
      } else {
        // Default to ID column
        _orderColumn = widget.idColumn ?? 'id';
        _isAscending = true;
        query = query.order(_orderColumn!);
      }

      final limit = widget.enableLazyLoading
          ? widget.pageSize
          : (widget.limit ?? 1000);

      query = query.limit(limit);

      final response = await query;
      final items = List<Map<String, dynamic>>.from(response);

      safeSetState(() {
        _items = items;
        _isLoading = false;
        if (widget.enableLazyLoading) {
          _hasMore = items.length >= widget.pageSize;
          if (items.isNotEmpty && _orderColumn != null) {
            // Store the cursor value from the last item
            _lastCursorValue = items.last[_orderColumn!];
          }
        }
      });
    } catch (e) {
      safeSetState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _loadMoreData() async {
    if (_isLoadingMore ||
        !_hasMore ||
        _lastCursorValue == null ||
        _orderColumn == null) {
      return;
    }

    try {
      safeSetState(() {
        _isLoadingMore = true;
      });

      final client = SupabaseService.client;
      dynamic query = client.from(widget.table).select(widget.columns ?? '*');

      if (widget.filter != null) {
        query = query.eq('id', widget.filter!);
      }

      // Add cursor filter BEFORE ordering
      // For ascending: get records greater than cursor
      // For descending: get records less than cursor
      // Convert cursor value to appropriate type if needed
      dynamic cursorValue = _lastCursorValue;

      // If the cursor is a string that looks like a number, try to convert it
      // This handles cases where IDs are stored as strings but should be compared as numbers
      if (cursorValue is String &&
          _orderColumn == (widget.idColumn ?? 'id') &&
          int.tryParse(cursorValue) != null) {
        // For ID columns, try to use the numeric value if it's a valid integer
        cursorValue = int.parse(cursorValue);
      }

      if (_isAscending) {
        query = query.gt(_orderColumn!, cursorValue);
      } else {
        query = query.lt(_orderColumn!, cursorValue);
      }

      // Apply ordering AFTER the filter
      query = query.order(_orderColumn!, ascending: _isAscending);

      query = query.limit(widget.pageSize);

      final response = await query;
      final newItems = List<Map<String, dynamic>>.from(response);

      safeSetState(() {
        if (newItems.isNotEmpty) {
          _items.addAll(newItems);
          _hasMore = newItems.length >= widget.pageSize;
          // Update cursor value from the last item
          _lastCursorValue = newItems.last[_orderColumn!];
        } else {
          _hasMore = false;
        }
        _isLoadingMore = false;
      });
    } catch (e) {
      safeSetState(() {
        _isLoadingMore = false;
        _error = 'Failed to load more: $e';
      });
    }
  }

  void _setupRealtimeSubscription() {
    final client = SupabaseService.client;

    _channel = client
        .channel('${widget.table}_list_changes')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: widget.table,
          callback: (payload) {
            _handleRealtimeChange(payload);
          },
        )
        .subscribe();
  }

  void _handleRealtimeChange(PostgresChangePayload payload) {
    safeSetState(() {
      switch (payload.eventType) {
        case PostgresChangeEvent.insert:
          _items.add(payload.newRecord);
          break;
        case PostgresChangeEvent.update:
          final index = _items.indexWhere(
            (item) => item['id'] == payload.newRecord['id'],
          );
          if (index != -1) {
            _items[index] = payload.newRecord;
          }
          break;
        case PostgresChangeEvent.delete:
          _items.removeWhere((item) => item['id'] == payload.oldRecord['id']);
          break;
        default:
          break;
      }
    });
  }

  @override
  void dispose() {
    _channel?.unsubscribe();
    if (widget.scrollController == null && _internalScrollController != null) {
      _internalScrollController!.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return widget.loadingWidget ??
          const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return widget.errorWidget ??
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Error: $_error'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _loadData,
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
    }

    if (_items.isEmpty) {
      return widget.emptyWidget ??
          const Center(child: Text('No data available'));
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView.builder(
        controller: _internalScrollController,
        padding: widget.padding,
        itemCount:
            _items.length +
            (widget.enableLazyLoading && _isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (widget.enableLazyLoading &&
              index == _items.length &&
              _isLoadingMore) {
            return widget.lazyLoadingWidget ??
                Container(
                  padding: const EdgeInsets.all(24.0),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 16),
                      Text(
                        'Loading more...',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                );
          }
          return widget.itemBuilder(context, _items[index], index);
        },
      ),
    );
  }
}
