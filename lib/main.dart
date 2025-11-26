import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:janus/core/routes/route_config.dart';
import 'package:janus/core/theme/app_theme.dart';
import 'package:janus/data/services/auth_service.dart';
import 'package:janus/widgets/navigation/app_router.dart';
import 'data/services/supabase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables from .env file
  await dotenv.load(fileName: '.env');

  // Initialize Supabase
  await SupabaseService.initialize();
  SupabaseAuth.authStateChanges.listen((authState) {
    RouteConfig.refresh();
  });
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Janus',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: appRouter,
    );
  }
}
