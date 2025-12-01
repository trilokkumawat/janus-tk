import 'package:flutter/material.dart';
import 'package:janus/core/constants/routes.dart';
import 'package:janus/data/services/auth_service.dart';
import 'package:janus/widgets/navigation/app_router.dart';
import '../../main.dart';

/// Widget that listens for session expiration and handles redirect + message
class SessionExpirationHandler extends StatefulWidget {
  final Widget child;

  const SessionExpirationHandler({super.key, required this.child});

  @override
  State<SessionExpirationHandler> createState() =>
      _SessionExpirationHandlerState();
}

class _SessionExpirationHandlerState extends State<SessionExpirationHandler> {
  bool? _previousAuthState;

  @override
  void initState() {
    super.initState();
    _previousAuthState = SupabaseAuth.isAuthenticated;

    // Listen for auth state changes
    SupabaseAuth.authStateChanges.listen((authState) {
      final isAuthenticated = authState.session != null;

      // Detect session expiration: user was authenticated but now is not
      if (_previousAuthState == true && !isAuthenticated && mounted) {
        // Session expired - show message and redirect
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            scaffoldMessengerKey.currentState?.showSnackBar(
              const SnackBar(
                content: Text('Your session has expired. Please login again.'),
                backgroundColor: Colors.orange,
                duration: Duration(seconds: 4),
              ),
            );

            // Redirect to login screen using the router directly
            appRouter.go(AppRoutes.login);
          }
        });
      }

      _previousAuthState = isAuthenticated;
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
