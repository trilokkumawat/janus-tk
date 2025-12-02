import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:janus/core/constants/app_text_style.dart';
import 'package:janus/core/constants/routes.dart';
import 'package:janus/core/theme/app_theme.dart';
import 'package:janus/core/utils/fade_animation.dart';
import 'package:janus/data/services/auth/auth_service.dart';
import 'package:janus/widgets/common/animated_text_kit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void checkAuthAndNavigate() async {
    // Wait for splash screen to show for at least 1 second
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // Check authentication state
    final isAuthenticated = SupabaseAuth.isAuthenticated;

    if (mounted) {
      if (isAuthenticated) {
        // User is logged in, navigate to home
        context.go(AppRoutes.appState);
      } else {
        // User is not logged in, navigate to login
        context.go(AppRoutes.login);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    checkAuthAndNavigate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FadeAnimation(
              curve: Curves.easeOut,
              duration: const Duration(seconds: 2),
              // delay: const Duration(seconds: 2),
              child: Image(
                image: AssetImage('assets/img/januslogo2.png'),
                width: 180,
                height: 180,
                fit: BoxFit.contain,
              ),
            ),
            FadeAnimation(
              curve: Curves.easeOut,
              duration: const Duration(seconds: 2),
              // delay: const Duration(seconds: 2),
              child: Text(
                'Janus',
                style: AppTextStyle.h1.copyWith(color: AppColors.primary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
