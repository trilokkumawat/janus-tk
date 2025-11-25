/// Example usage of Supabase real-time components
///
/// This file demonstrates how to use the various Supabase widgets
/// in your application. These are examples only and should be adapted
/// to your specific use case.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'realtime_list_view.dart';
import 'realtime_card.dart';
import 'realtime_counter.dart';
import 'realtime_badge.dart';
import 'realtime_data_provider.dart';
import '../../data/services/supabase_service.dart';

// ============================================================================
// Example 1: Using RealtimeListView
// ============================================================================

class TasksListExample extends StatelessWidget {
  const TasksListExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tasks')),
      body: RealtimeListView(
        table: 'tasks',
        orderBy: 'created_at desc',
        itemBuilder: (context, item, index) {
          return ListTile(
            title: Text(item['title'] ?? 'No title'),
            subtitle: Text(item['description'] ?? ''),
            trailing: item['completed'] == true
                ? const Icon(Icons.check_circle, color: Colors.green)
                : const Icon(Icons.radio_button_unchecked),
          );
        },
        emptyWidget: const Center(child: Text('No tasks found')),
      ),
    );
  }
}

// ============================================================================
// Example 2: Using RealtimeCard
// ============================================================================

class TaskDetailExample extends StatelessWidget {
  final String taskId;

  const TaskDetailExample({super.key, required this.taskId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Task Details')),
      body: RealtimeCard(
        table: 'tasks',
        itemId: taskId,
        builder: (context, item) {
          return Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['title'] ?? 'No title',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item['description'] ?? 'No description',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(
                        item['completed'] == true
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked,
                        color: item['completed'] == true
                            ? Colors.green
                            : Colors.grey,
                      ),
                      const SizedBox(width: 8),
                      Text(item['completed'] == true ? 'Completed' : 'Pending'),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ============================================================================
// Example 3: Using RealtimeCounter
// ============================================================================

class TasksCounterExample extends StatelessWidget {
  const TasksCounterExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Task Counter')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Total Tasks:'),
            RealtimeCounter(
              table: 'tasks',
              style: Theme.of(context).textTheme.displayLarge,
            ),
            const SizedBox(height: 32),
            const Text('Completed Tasks:'),
            RealtimeCounter(
              table: 'tasks',
              filter: 'completed = true',
              style: Theme.of(context).textTheme.displayLarge,
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// Example 4: Using RealtimeBadge
// ============================================================================

class NotificationsExample extends StatelessWidget {
  const NotificationsExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          RealtimeBadge(
            table: 'notifications',
            filter: 'read = false',
            child: IconButton(
              icon: const Icon(Icons.notifications),
              onPressed: () {
                // Navigate to notifications
              },
            ),
          ),
        ],
      ),
      body: const Center(child: Text('Notifications Screen')),
    );
  }
}

// ============================================================================
// Example 5: Using RealtimeDataProvider with Riverpod
// ============================================================================

class TasksWithProviderExample extends ConsumerWidget {
  const TasksWithProviderExample({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(realtimeDataProvider('tasks'));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks with Provider'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(realtimeDataProvider('tasks'));
            },
          ),
        ],
      ),
      body: tasksAsync.when(
        data: (tasks) {
          if (tasks.isEmpty) {
            return const Center(child: Text('No tasks found'));
          }

          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return ListTile(
                title: Text(task['title'] ?? 'No title'),
                subtitle: Text(task['description'] ?? ''),
                trailing: task['completed'] == true
                    ? const Icon(Icons.check_circle, color: Colors.green)
                    : const Icon(Icons.radio_button_unchecked),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ref.invalidate(realtimeDataProvider('tasks'));
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// Example 6: Custom widget using SupabaseService directly
// ============================================================================

class CustomSupabaseExample extends StatefulWidget {
  const CustomSupabaseExample({super.key});

  @override
  State<CustomSupabaseExample> createState() => _CustomSupabaseExampleState();
}

class _CustomSupabaseExampleState extends State<CustomSupabaseExample> {
  List<Map<String, dynamic>> _items = [];
  bool _isLoading = true;
  RealtimeChannel? _channel;

  @override
  void initState() {
    super.initState();
    _loadData();
    _setupRealtime();
  }

  Future<void> _loadData() async {
    try {
      final client = SupabaseService.client;
      final response = await client
          .from('tasks')
          .select()
          .order('created_at', ascending: false);

      setState(() {
        _items = List<Map<String, dynamic>>.from(response);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  void _setupRealtime() {
    final client = SupabaseService.client;

    _channel = client
        .channel('custom_tasks_changes')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'tasks',
          callback: (payload) {
            _loadData(); // Reload data when changes occur
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
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Custom Supabase Example')),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: ListView.builder(
          itemCount: _items.length,
          itemBuilder: (context, index) {
            final item = _items[index];
            return ListTile(
              title: Text(item['title'] ?? 'No title'),
              subtitle: Text(item['description'] ?? ''),
            );
          },
        ),
      ),
    );
  }
}
