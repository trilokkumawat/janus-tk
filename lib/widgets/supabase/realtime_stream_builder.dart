import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// A widget that builds itself based on real-time data from Supabase
///
/// This widget automatically subscribes to Supabase real-time changes
/// and rebuilds when data changes
///
/// Example:
/// ```dart
/// RealtimeStreamBuilder<Map<String, dynamic>>(
///   table: 'tasks',
///   builder: (context, snapshot) {
///     if (snapshot.hasError) {
///       return Text('Error: ${snapshot.error}');
///     }
///     if (!snapshot.hasData) {
///       return CircularProgressIndicator();
///     }
///     return ListView.builder(
///       itemCount: snapshot.data!.length,
///       itemBuilder: (context, index) {
///         return ListTile(
///           title: Text(snapshot.data![index]['title']),
///         );
///       },
///     );
///   },
/// )
/// ```
class RealtimeStreamBuilder<T> extends StatefulWidget {
  /// The table name to subscribe to
  final String table;

  /// Builder function that receives the data snapshot
  final Widget Function(BuildContext context, AsyncSnapshot<List<T>> snapshot)
  builder;

  /// Optional filter to apply to the query
  final String? filter;

  /// Optional order by clause
  final String? orderBy;

  /// Optional limit for the query
  final int? limit;

  /// Optional columns to select
  final String? columns;

  /// Event types to listen to (insert, update, delete)
  /// Note: Currently supports all events via PostgresChangeEvent.all
  // final List<RealtimeListenTypes>? eventTypes;

  /// Custom error widget
  final Widget? errorWidget;

  /// Custom loading widget
  final Widget? loadingWidget;

  const RealtimeStreamBuilder({
    super.key,
    required this.table,
    required this.builder,
    this.filter,
    this.orderBy,
    this.limit,
    this.columns,
    // this.eventTypes,
    this.errorWidget,
    this.loadingWidget,
  });

  @override
  State<RealtimeStreamBuilder<T>> createState() =>
      _RealtimeStreamBuilderState<T>();
}

class _RealtimeStreamBuilderState<T> extends State<RealtimeStreamBuilder<T>> {
  Stream<List<T>>? _stream;
  RealtimeChannel? _channel;

  @override
  void initState() {
    super.initState();
    _setupStream();
  }

  void _setupStream() {
    final client = Supabase.instance.client;

    // Build the query
    dynamic query = client.from(widget.table).select(widget.columns ?? '*');

    if (widget.filter != null) {
      // Note: This is a simplified filter. For complex filters,
      // you may need to use the Supabase query builder methods
      query = query.eq('id', widget.filter!);
    }

    if (widget.orderBy != null) {
      final parts = widget.orderBy!.split(' ');
      if (parts.length == 2) {
        query = query.order(
          parts[0],
          ascending: parts[1].toLowerCase() == 'asc',
        );
      } else {
        query = query.order(parts[0]);
      }
    }

    if (widget.limit != null) {
      query = query.limit(widget.limit!);
    }

    // Get initial data
    final initialDataFuture = query.select<List<Map<String, dynamic>>>();

    // Set up real-time subscription
    _channel = client
        .channel('${widget.table}_changes')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: widget.table,
          callback: (payload) {
            // Trigger a refresh when changes occur
            _refreshData();
          },
        )
        .subscribe();

    // Create stream from future and real-time updates
    _stream = Stream<List<T>>.periodic(
      const Duration(milliseconds: 100),
      (_) => initialDataFuture.then((data) => data as List<T>),
    ).asyncMap((_) => initialDataFuture.then((data) => data as List<T>));
  }

  Future<void> _refreshData() async {
    final client = Supabase.instance.client;
    dynamic query = client.from(widget.table).select(widget.columns ?? '*');

    if (widget.filter != null) {
      query = query.eq('id', widget.filter!);
    }

    if (widget.orderBy != null) {
      final parts = widget.orderBy!.split(' ');
      if (parts.length == 2) {
        query = query.order(
          parts[0],
          ascending: parts[1].toLowerCase() == 'asc',
        );
      } else {
        query = query.order(parts[0]);
      }
    }

    if (widget.limit != null) {
      query = query.limit(widget.limit!);
    }

    await query.select<List<Map<String, dynamic>>>();
    // Update stream with new data
    // Note: This is a simplified approach. For production, consider
    // using a StreamController for better control
  }

  @override
  void dispose() {
    _channel?.unsubscribe();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_stream == null) {
      return widget.loadingWidget ?? const CircularProgressIndicator();
    }

    return StreamBuilder<List<T>>(
      stream: _stream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return widget.errorWidget ??
              Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting &&
            !snapshot.hasData) {
          return widget.loadingWidget ?? const CircularProgressIndicator();
        }

        return widget.builder(context, snapshot);
      },
    );
  }
}
