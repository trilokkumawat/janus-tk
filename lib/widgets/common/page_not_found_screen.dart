import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:janus/core/constants/dimensions.dart';
import 'package:lottie/lottie.dart';

/// Creative 404 Page Not Found Screen with Lottie Animation
///
/// Displays an animated 404 error page with a Lottie animation,
/// creative styling, and navigation options.
class PageNotFoundScreen extends StatefulWidget {
  /// The URI that was not found (optional)
  final String? uri;

  const PageNotFoundScreen({super.key, this.uri});

  @override
  State<PageNotFoundScreen> createState() => _PageNotFoundScreenState();
}

class _PageNotFoundScreenState extends State<PageNotFoundScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.2, 1.0, curve: Curves.easeOutCubic),
          ),
        );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colorScheme.surface,
              colorScheme.surfaceContainerHighest.withOpacity(0.3),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: AppDimensions.paddingAllXL,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Lottie Animation
                      SizedBox(
                        height: AppDimensions.height250,
                        width: AppDimensions.width250,
                        child: Lottie.network(
                          'https://assets5.lottiefiles.com/packages/lf20_jcikwtux.json',
                          // Popular 404 animation from LottieFiles
                          // You can replace this URL with your own Lottie animation
                          // or use Lottie.asset('assets/animations/404.json') for local files
                          errorBuilder: (context, error, stackTrace) {
                            // Fallback icon if network animation fails
                            return Icon(
                              Icons.error_outline,
                              size: AppDimensions.iconSize200,
                              color: colorScheme.primary.withOpacity(0.5),
                            );
                          },
                          fit: BoxFit.contain,
                          repeat: true,
                          animate: true,
                        ),
                      ),
                      SizedBox(height: AppDimensions.height2XL),

                      // 404 Text with gradient
                      ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          colors: [colorScheme.primary, colorScheme.secondary],
                        ).createShader(bounds),
                        child: Text(
                          '404',
                          style: TextStyle(
                            fontSize: AppDimensions.fontSize6XL,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: AppDimensions.widthXS,
                          ),
                        ),
                      ),
                      SizedBox(height: AppDimensions.heightL),

                      // Page Not Found Title
                      Text(
                        'Oops! Page Not Found',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: AppDimensions.heightM),

                      // Description
                      Text(
                        'The page you are looking for might have been removed,\n'
                        'had its name changed, or is temporarily unavailable.',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: colorScheme.onSurface.withOpacity(0.7),
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: AppDimensions.heightS),

                      // Show URI if provided
                      if (widget.uri != null) ...[
                        Container(
                          padding: AppDimensions.paddingSymmetric(
                            horizontal: AppDimensions.paddingL,
                            vertical: AppDimensions.paddingS,
                          ),
                          margin: EdgeInsets.only(top: AppDimensions.heightL),
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceContainerHighest
                                .withOpacity(0.5),
                            borderRadius: AppDimensions.borderRadiusM,
                            border: Border.all(
                              color: colorScheme.outline.withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            widget.uri!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurface.withOpacity(0.6),
                              fontFamily: 'monospace',
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: AppDimensions.height2XL),
                      ] else
                        SizedBox(height: AppDimensions.height2XL),

                      // Action Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Go Back Button
                          OutlinedButton.icon(
                            onPressed: () => context.pop(),
                            icon: const Icon(Icons.arrow_back_rounded),
                            label: const Text('Go Back'),
                            style: OutlinedButton.styleFrom(
                              padding: AppDimensions.paddingSymmetric(
                                horizontal: AppDimensions.paddingXL,
                                vertical: AppDimensions.paddingL,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: AppDimensions.borderRadiusM,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
