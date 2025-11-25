import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:janus/core/constants/routes.dart';
import 'package:janus/data/services/auth_service.dart';
import 'package:janus/presentation/screens/home/home_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Main application widget using BottomNavigationBar to navigate
/// between common app tabs and keeping state alive for each tab using IndexedStack.
/// Adds a FloatingActionButton to the main Scaffold.
class AppState extends StatefulWidget {
  const AppState({super.key});

  @override
  State<AppState> createState() => _AppStateState();
}

class _AppStateState extends State<AppState> {
  int _selectedIndex = 0;

  final List<Widget> _screens = <Widget>[
    const _KeepAliveWrapper(child: HomeScreen()),
    const _KeepAliveWrapper(child: Center(child: Text('Goals Screen'))),
    const _KeepAliveWrapper(child: Center(child: Text('Tasks Screen'))),
    const _KeepAliveWrapper(child: Center(child: Text('To-Dos Screen'))),
    const _KeepAliveWrapper(child: Center(child: Text('Profile Screen'))),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Use a GlobalKey to access the ScaffoldMessenger context after MaterialApp builds Scaffolds.
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  // Example placeholder action for FAB
  void _onFabPressed() {
    _scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text('Floating Action Button pressed on tab $_selectedIndex'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: _scaffoldMessengerKey,
      home: Scaffold(
        appBar: AppBar(title: const Text('Janus App')),
        body: IndexedStack(index: _selectedIndex, children: _screens),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.flag), label: 'Goals'),
            BottomNavigationBarItem(
              icon: Icon(Icons.playlist_add_check),
              label: 'To-Dos',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Theme.of(context).colorScheme.primary,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => SupabaseAuth.signOut(),
          child: const Icon(Icons.task_alt),
          tooltip: 'Tasks',
        ),
      ),
    );
  }
}

class _KeepAliveWrapper extends StatefulWidget {
  final Widget child;

  const _KeepAliveWrapper({required this.child});

  @override
  State<_KeepAliveWrapper> createState() => _KeepAliveWrapperState();
}

class _KeepAliveWrapperState extends State<_KeepAliveWrapper>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }

  @override
  bool get wantKeepAlive => true;
}
