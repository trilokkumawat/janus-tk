# Supabase Real-time Components

This directory contains reusable components for integrating Supabase with real-time data fetching in your Flutter application.

## Setup

1. **Configure Supabase credentials** in `lib/core/constants/supabase_constants.dart`:
   ```dart
   static const String supabaseUrl = 'YOUR_SUPABASE_URL';
   static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';
   ```

2. **Initialize Supabase** in your `main.dart`:
   ```dart
   void main() async {
     WidgetsFlutterBinding.ensureInitialized();
     await SupabaseService.initialize();
     runApp(const MyApp());
   }
   ```

## Components

### 1. RealtimeListView

A ListView that automatically updates when data changes in Supabase.

```dart
RealtimeListView(
  table: 'tasks',
  orderBy: 'created_at desc',
  itemBuilder: (context, item, index) {
    return ListTile(
      title: Text(item['title']),
      subtitle: Text(item['description']),
    );
  },
)
```

### 2. RealtimeCard

A card widget that displays a single item with real-time updates.

```dart
RealtimeCard(
  table: 'tasks',
  itemId: '123',
  builder: (context, item) {
    return Card(
      child: ListTile(
        title: Text(item['title']),
      ),
    );
  },
)
```

### 3. RealtimeCounter

A counter widget that displays the count of items in real-time.

```dart
RealtimeCounter(
  table: 'tasks',
  filter: 'status = "completed"',
  style: TextStyle(fontSize: 24),
)
```

### 4. RealtimeBadge

A badge widget that displays a count with real-time updates.

```dart
RealtimeBadge(
  table: 'notifications',
  filter: 'read = false',
  child: Icon(Icons.notifications),
)
```

### 5. RealtimeDataProvider (Riverpod)

A Riverpod provider for real-time data that can be used with `ConsumerWidget` or `Consumer`.

```dart
final tasksProvider = realtimeDataProvider('tasks');

// In your widget:
final tasksAsync = ref.watch(tasksProvider);

tasksAsync.when(
  data: (tasks) => ListView(...),
  loading: () => CircularProgressIndicator(),
  error: (error, stack) => Text('Error: $error'),
)
```

### 6. RealtimeStreamBuilder

A StreamBuilder that automatically subscribes to Supabase real-time changes.

```dart
RealtimeStreamBuilder<Map<String, dynamic>>(
  table: 'tasks',
  builder: (context, snapshot) {
    if (snapshot.hasError) {
      return Text('Error: ${snapshot.error}');
    }
    if (!snapshot.hasData) {
      return CircularProgressIndicator();
    }
    return ListView.builder(
      itemCount: snapshot.data!.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(snapshot.data![index]['title']),
        );
      },
    );
  },
)
```

## Direct Service Usage

You can also use `SupabaseService` directly for custom implementations:

```dart
final client = SupabaseService.client;

// Fetch data
final response = await client
    .from('tasks')
    .select()
    .order('created_at', ascending: false);

// Set up real-time subscription
final channel = client
    .channel('tasks_changes')
    .onPostgresChanges(
      event: PostgresChangeEvent.all,
      schema: 'public',
      table: 'tasks',
      callback: (payload) {
        // Handle changes
      },
    )
    .subscribe();
```

## Examples

See `example_usage.dart` for complete examples of all components.

## Notes

- All components automatically handle real-time updates via Supabase Postgres changes
- Components clean up subscriptions when disposed
- Error handling is built-in with customizable error widgets
- Loading states are handled automatically

