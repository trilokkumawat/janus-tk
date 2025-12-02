import 'package:flutter/material.dart';
import 'package:janus/core/extensions/state_extensions.dart';
import 'package:janus/core/theme/app_theme.dart';
import 'package:janus/data/services/auth/auth_service.dart';
import 'package:janus/domain/entities/enumberable.dart';
import 'package:janus/presentation/screens/home/home_screen.dart';

/// Main application widget using BottomNavigationBar to navigate
/// between common app tabs and keeping state alive for each tab using IndexedStack.
/// Adds a FloatingActionButton to the main Scaffold.
class AppState extends StatefulWidget {
  const AppState({super.key});

  @override
  State<AppState> createState() => _AppStateState();
}

class _AppStateState extends State<AppState> with SafeStateMixin {
  int _selectedIndex = 0;

  final List<Widget> _screens = <Widget>[
    const _KeepAliveWrapper(child: HomeScreen()),
    const _KeepAliveWrapper(child: Center(child: Text('Ideas Screen'))),
    const _KeepAliveWrapper(child: Center(child: Text('Goals Screen'))),
    const _KeepAliveWrapper(child: Center(child: Text('To-Dos Screen'))),
  ];

  void _onItemTapped(int index) {
    safeSetState(() {
      _selectedIndex = index;
    });
  }

  // Use a GlobalKey to access the ScaffoldMessenger context after MaterialApp builds Scaffolds.
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  String getHeaderTitle(int index) {
    switch (index) {
      case 0:
        return AppStateHeader.home.name;
      case 1:
        return AppStateHeader.ideas.name;
      case 2:
        return AppStateHeader.goals.name;
      case 3:
        return AppStateHeader.todos.name;
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      scaffoldMessengerKey: _scaffoldMessengerKey,
      home: Scaffold(
        appBar: AppBar(title: Text(getHeaderTitle(_selectedIndex))),
        body: IndexedStack(index: _selectedIndex, children: _screens),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.flag), label: 'Ideas'),
            BottomNavigationBarItem(
              icon: Icon(Icons.golf_course_sharp),
              label: 'Goals',
            ),

            BottomNavigationBarItem(icon: Icon(Icons.list), label: 'To-Dos'),
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
