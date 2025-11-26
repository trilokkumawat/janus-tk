import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:janus/app.dart';
import 'package:janus/core/constants/routes.dart';
import 'package:janus/presentation/screens/auth/login_screen.dart';
import 'package:janus/presentation/screens/auth/forgot_password_screen.dart';
import 'package:janus/presentation/screens/home/home_screen.dart';
import 'package:janus/presentation/screens/profile/profile_screen.dart';
import 'package:janus/presentation/screens/projects/projects_screen.dart';
import 'package:janus/presentation/screens/projects/project_detail_screen.dart';
import 'package:janus/presentation/screens/tasks/tasks_screen.dart';
import 'package:janus/presentation/screens/tasks/task_detail_screen.dart';
import 'package:janus/presentation/screens/todos/todos_screen.dart';
import 'package:janus/presentation/screens/todos/todo_detail_screen.dart';
import 'package:janus/presentation/screens/goals/goals_screen.dart';
import 'package:janus/presentation/screens/goals/goal_detail_screen.dart';
import 'package:janus/widgets/common/page_not_found_screen.dart';
import 'package:janus/splash.dart';

/// Route configuration for the application
/// Defines all routes and their corresponding screens
class RouteConfig {
  static final ValueNotifier<bool> _refreshNotifier = ValueNotifier(false);

  /// Call this to notify router consumers of change (e.g. auth)
  static void refresh() {
    _refreshNotifier.value = !_refreshNotifier.value;
  }

  /// Helper function to create fade transition animation
  static CustomTransitionPage _fadeTransition({
    required BuildContext context,
    required GoRouterState state,
    required Widget child,
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
          child: child,
        );
      },
      transitionDuration: duration,
    );
  }

  /// Helper function to create slide transition animation
  static CustomTransitionPage _slideTransition({
    required BuildContext context,
    required GoRouterState state,
    required Widget child,
    AxisDirection direction = AxisDirection.right,
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final offset = _getOffset(direction);
        final tween = Tween(
          begin: offset,
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.easeInOut));
        return SlideTransition(position: animation.drive(tween), child: child);
      },
      transitionDuration: duration,
    );
  }

  /// Helper function to create scale transition animation
  static CustomTransitionPage _scaleTransition({
    required BuildContext context,
    required GoRouterState state,
    required Widget child,
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: CurveTween(curve: Curves.easeInOut).animate(animation),
          child: child,
        );
      },
      transitionDuration: duration,
    );
  }

  /// Helper function to create slide and fade transition animation
  static CustomTransitionPage _slideFadeTransition({
    required BuildContext context,
    required GoRouterState state,
    required Widget child,
    AxisDirection direction = AxisDirection.right,
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final offset = _getOffset(direction);
        final slideTween = Tween(
          begin: offset,
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.easeInOut));
        return SlideTransition(
          position: animation.drive(slideTween),
          child: FadeTransition(
            opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
            child: child,
          ),
        );
      },
      transitionDuration: duration,
    );
  }

  /// Get offset based on direction
  static Offset _getOffset(AxisDirection direction) {
    switch (direction) {
      case AxisDirection.up:
        return const Offset(0, 1);
      case AxisDirection.down:
        return const Offset(0, -1);
      case AxisDirection.left:
        return const Offset(1, 0);
      case AxisDirection.right:
        return const Offset(-1, 0);
    }
  }

  static GoRouter createRouter() {
    return GoRouter(
      initialLocation: AppRoutes.splash,
      refreshListenable: _refreshNotifier,
      routes: [
        // Splash/Onboarding
        GoRoute(
          path: AppRoutes.splash,
          name: 'splash',
          pageBuilder: (context, state) => _fadeTransition(
            context: context,
            state: state,
            child: const SplashScreen(), // Temporary, replace with SplashScreen
            duration: const Duration(milliseconds: 400),
          ),
        ),
        GoRoute(
          path: AppRoutes.appState,
          name: 'app-state',
          pageBuilder: (context, state) => _fadeTransition(
            context: context,
            state: state,
            child: const AppState(),
          ),
        ),
        // GoRoute(
        //   path: AppRoutes.onboarding,
        //   name: 'onboarding',
        //   builder: (context, state) => const OnboardingScreen(),
        // ),

        // Auth routes
        GoRoute(
          path: AppRoutes.login,
          name: 'login',
          pageBuilder: (context, state) => _slideFadeTransition(
            context: context,
            state: state,
            child: const LoginScreen(),
            direction: AxisDirection.right,
          ),
        ),
        // GoRoute(
        //   path: AppRoutes.register,
        //   name: 'register',
        //   pageBuilder: (context, state) => _slideFadeTransition(
        //     context: context,
        //     state: state,
        //     child: const RegisterScreen(),
        //     direction: AxisDirection.right,
        //   ),
        // ),
        GoRoute(
          path: AppRoutes.forgotPassword,
          name: 'forgot-password',
          pageBuilder: (context, state) => _slideFadeTransition(
            context: context,
            state: state,
            child: const ForgotPasswordScreen(),
            direction: AxisDirection.right,
          ),
        ),

        // Main app routes
        GoRoute(
          path: AppRoutes.home,
          name: 'home',
          pageBuilder: (context, state) => _fadeTransition(
            context: context,
            state: state,
            child: const HomeScreen(),
          ),
        ),
        GoRoute(
          path: AppRoutes.profile,
          name: 'profile',
          pageBuilder: (context, state) => _slideTransition(
            context: context,
            state: state,
            child: const ProfileScreen(),
            direction: AxisDirection.left,
          ),
        ),

        // Projects routes
        GoRoute(
          path: AppRoutes.projects,
          name: 'projects',
          pageBuilder: (context, state) => _fadeTransition(
            context: context,
            state: state,
            child: const ProjectsScreen(),
          ),
          routes: [
            GoRoute(
              path: ':id',
              name: 'project-detail',
              pageBuilder: (context, state) {
                final id = state.pathParameters['id']!;
                return _scaleTransition(
                  context: context,
                  state: state,
                  child: ProjectDetailScreen(projectId: id),
                );
              },
            ),
          ],
        ),

        // Tasks routes
        GoRoute(
          path: AppRoutes.tasks,
          name: 'tasks',
          pageBuilder: (context, state) => _fadeTransition(
            context: context,
            state: state,
            child: const TasksScreen(),
          ),
          routes: [
            GoRoute(
              path: ':id',
              name: 'task-detail',
              pageBuilder: (context, state) {
                final id = state.pathParameters['id']!;
                return _scaleTransition(
                  context: context,
                  state: state,
                  child: TaskDetailScreen(taskId: id),
                );
              },
            ),
          ],
        ),

        // Todos routes
        GoRoute(
          path: AppRoutes.todos,
          name: 'todos',
          pageBuilder: (context, state) => _fadeTransition(
            context: context,
            state: state,
            child: const TodosScreen(),
          ),
          routes: [
            GoRoute(
              path: ':id',
              name: 'todo-detail',
              pageBuilder: (context, state) {
                final id = state.pathParameters['id']!;
                return _scaleTransition(
                  context: context,
                  state: state,
                  child: TodoDetailScreen(todoId: id),
                );
              },
            ),
          ],
        ),

        // Goals routes
        GoRoute(
          path: AppRoutes.goals,
          name: 'goals',
          pageBuilder: (context, state) => _fadeTransition(
            context: context,
            state: state,
            child: const GoalsScreen(),
          ),
          routes: [
            GoRoute(
              path: ':id',
              name: 'goal-detail',
              pageBuilder: (context, state) {
                final id = state.pathParameters['id']!;
                return _scaleTransition(
                  context: context,
                  state: state,
                  child: GoalDetailScreen(goalId: id),
                );
              },
            ),
          ],
        ),
      ],
      errorBuilder: (context, state) =>
          PageNotFoundScreen(uri: state.uri.toString()),
    );
  }
}
