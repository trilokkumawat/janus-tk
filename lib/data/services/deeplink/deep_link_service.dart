import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:janus/core/constants/routes.dart';
import 'package:janus/widgets/navigation/app_router.dart';
import 'package:janus/main.dart';

class DeepLinkService {
  static final DeepLinkService _instance = DeepLinkService._internal();
  factory DeepLinkService() => _instance;
  DeepLinkService._internal();

  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _linkSubscription;
  Uri? _lastHandledUri;
  DateTime? _lastHandledTime;

  void initialize() {
    _appLinks.getInitialLink().then((Uri? uri) {
      if (uri != null) {
        print('📱 App opened from deep link: $uri');
        Future.delayed(const Duration(milliseconds: 800), () {
          _handleDeepLink(uri);
        });
      }
    });

    _linkSubscription = _appLinks.uriLinkStream.listen(
      (Uri uri) {
        print('🔗 Deep link received while app is running: $uri');
        _handleDeepLink(uri);
      },
      onError: (err) {
        print('❌ Deep link error: $err');
      },
    );
  }

  void _handleDeepLink(Uri uri) {
    final now = DateTime.now();
    if (_lastHandledUri == uri &&
        _lastHandledTime != null &&
        now.difference(_lastHandledTime!).inSeconds < 2) {
      print('⏭️ Skipping duplicate deep link: $uri');
      return;
    }

    print('🔗 Deep link received: $uri');
    print('   Scheme: ${uri.scheme}');
    print('   Host: ${uri.host}');
    print('   Path: ${uri.path}');
    print('   Query parameters: ${uri.queryParameters}');

    _lastHandledUri = uri;
    _lastHandledTime = now;

    final isCheckoutSuccess =
        uri.scheme == 'janus' &&
            (uri.host == 'checkout-success' ||
                uri.path.contains('checkout-success')) ||
        uri.scheme == 'https' &&
            (uri.path.contains('/checkout-success') ||
                uri.host.contains('checkout-success'));

    // final isCheckoutCancel =
    //     uri.scheme == 'janus' &&
    //         (uri.host == 'checkout-cancel' ||
    //             uri.path.contains('checkout-cancel')) ||
    //     uri.scheme == 'https' &&
    //         (uri.path.contains('/checkout-cancel') ||
    //             uri.host.contains('checkout-cancel'));

    if (uri.scheme == 'janus' || uri.scheme == 'https') {
      if (isCheckoutSuccess) {
        final sessionId = uri.queryParameters['session_id'];
        print('✅ Checkout SUCCESS - Session ID: $sessionId');

        WidgetsBinding.instance.addPostFrameCallback((_) {
          scaffoldMessengerKey.currentState?.showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.white),
                  SizedBox(width: 8),
                  Text('Payment successful! Redirecting...'),
                ],
              ),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );

          Future.delayed(const Duration(milliseconds: 500), () {
            try {
              appRouter.go(
                '${AppRoutes.checkoutSuccess}?session_id=$sessionId',
              );
            } catch (e) {
              print('❌ Navigation error: $e');
              appRouter.go(AppRoutes.checkoutSuccess);
            }
          });
        });
      }
      // else if (isCheckoutCancel) {
      //   print('❌ Checkout CANCELLED');
      //   WidgetsBinding.instance.addPostFrameCallback((_) {
      //     scaffoldMessengerKey.currentState?.showSnackBar(
      //       SnackBar(
      //         content: const Row(
      //           children: [
      //             Icon(Icons.cancel, color: Colors.white),
      //             SizedBox(width: 8),
      //             Text('Payment cancelled'),
      //           ],
      //         ),
      //         backgroundColor: Colors.orange,
      //         duration: const Duration(seconds: 2),
      //       ),
      //     );
      //     Future.delayed(const Duration(milliseconds: 500), () {
      //       try {
      //         appRouter.go(AppRoutes.checkoutCancel);
      //       } catch (e) {
      //         print('❌ Navigation error: $e');
      //       }
      //     });
      //   });
      // }
      else {
        print('⚠️ Unknown deep link host: ${uri.host}, path: ${uri.path}');
      }
    } else {
      print('⚠️ Unknown deep link scheme: ${uri.scheme}');
    }
  }

  void dispose() {
    _linkSubscription?.cancel();
  }
}
