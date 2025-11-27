/// Route constants for the application
/// All route paths should be defined here for consistency
class AppRoutes {
  // Root routes
  static const String splash = '/';
  static const String onboarding = '/onboarding';

  static const String appState = '/app-state';
  static const String subscription = '/subscription';

  // Auth routes
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';

  // Main app routes
  static const String home = '/home';
  static const String profile = '/profile';

  // Feature routes
  static const String projects = '/projects';
  static const String projectDetail = '/projects/:id';
  static const String tasks = '/tasks';
  static const String taskDetail = '/tasks/:id';
  static const String todos = '/todos';
  static const String todoDetail = '/todos/:id';
  static const String goals = '/goals';
  static const String goalDetail = '/goals/:id';

  // Helper methods
  static String projectDetailPath(String id) => '/projects/$id';
  static String taskDetailPath(String id) => '/tasks/$id';
  static String todoDetailPath(String id) => '/todos/$id';
  static String goalDetailPath(String id) => '/goals/$id';
}
