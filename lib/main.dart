import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:janus/core/routes/route_config.dart';
import 'package:janus/core/theme/app_theme.dart';
import 'package:janus/data/services/auth_service.dart';
import 'package:janus/widgets/auth/session_expiration_handler.dart';
import 'package:janus/widgets/common/internet.dart';
import 'package:janus/widgets/navigation/app_router.dart';
import 'data/services/supabase_service.dart';
import 'data/services/deep_link_service.dart';

// Global scaffold messenger key for showing messages from anywhere
final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables from .env file
  await dotenv.load(fileName: '.env');

  // Initialize Supabase
  await SupabaseService.initialize();

  // Listen for auth state changes to refresh router
  SupabaseAuth.authStateChanges.listen((authState) {
    RouteConfig.refresh();
  });

  // Initialize deep link service
  DeepLinkService().initialize();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return SessionExpirationHandler(
      child: MaterialApp.router(
        title: 'Janus',
        theme: AppTheme.lightTheme,
        themeMode: ThemeMode.light,
        scaffoldMessengerKey: scaffoldMessengerKey,
        routerConfig: appRouter,
        builder: (context, child) {
          return ConnectivityBanner(child: child ?? const SizedBox.shrink());
        },
      ),
    );
  }
}
