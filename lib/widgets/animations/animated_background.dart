import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:janus/core/theme/app_theme.dart';

/// Modern animated background component with floating particles and gradient
/// Perfect for login and authentication screens
class AnimatedBackground extends StatefulWidget {
  final Widget child;
  final List<Color>? gradientColors;
  final int particleCount;
  final double particleSpeed;

  const AnimatedBackground({
    super.key,
    required this.child,
    this.gradientColors,
    this.particleCount = 50,
    this.particleSpeed = 1.0,
  });

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with TickerProviderStateMixin {
  late List<Particle> _particles;
  late AnimationController _gradientController;
  late AnimationController _particleController;

  @override
  void initState() {
    super.initState();
    _initializeParticles();
    _gradientController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  void _initializeParticles() {
    final random = math.Random();
    _particles = List.generate(
      widget.particleCount,
      (index) => Particle(
        x: random.nextDouble(),
        y: random.nextDouble(),
        size: random.nextDouble() * 4 + 2,
        speed: random.nextDouble() * widget.particleSpeed + 0.5,
        opacity: random.nextDouble() * 0.5 + 0.2,
        colorIndex: random.nextInt(5),
      ),
    );
  }

  @override
  void dispose() {
    _gradientController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors =
        widget.gradientColors ??
        [
          AppColors.purple.withOpacity(0.8),
          AppColors.blue.withOpacity(0.6),
          AppColors.coral.withOpacity(0.4),
        ];

    return Stack(
      children: [
        // Animated Gradient Background
        AnimatedBuilder(
          animation: _gradientController,
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    colors[0],
                    colors[1 % colors.length],
                    colors[2 % colors.length],
                  ],
                  stops: [
                    0.0,
                    0.5 +
                        math.sin(_gradientController.value * 2 * math.pi) * 0.2,
                    1.0,
                  ],
                ),
              ),
            );
          },
        ),

        // Floating Particles
        AnimatedBuilder(
          animation: _particleController,
          builder: (context, child) {
            return CustomPaint(
              painter: ParticlePainter(
                particles: _particles,
                progress: _particleController.value,
                colors: [
                  AppColors.purple,
                  AppColors.blue,
                  AppColors.coral,
                  AppColors.orange,
                  AppColors.green,
                ],
              ),
            );
          },
        ),

        // Animated Blob Shapes
        ...List.generate(3, (index) {
          return Positioned(
            left: 50 + index * 100,
            top: 100 + index * 150,
            child:
                Container(
                      width: 200 + index * 50,
                      height: 200 + index * 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            AppColors.purple.withOpacity(0.1),
                            AppColors.blue.withOpacity(0.05),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    )
                    .animate(onPlay: (controller) => controller.repeat())
                    .shimmer(
                      duration: Duration(seconds: 3 + index),
                      color: AppColors.purple.withOpacity(0.3),
                    )
                    .scale(
                      begin: const Offset(1.0, 1.0),
                      end: const Offset(1.2, 1.2),
                      duration: Duration(seconds: 4 + index * 2),
                      curve: Curves.easeInOut,
                    ),
          );
        }),

        // Content
        widget.child,
      ],
    );
  }
}

class Particle {
  double x;
  double y;
  double size;
  double speed;
  double opacity;
  int colorIndex;

  Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.opacity,
    required this.colorIndex,
  });
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final double progress;
  final List<Color> colors;

  ParticlePainter({
    required this.particles,
    required this.progress,
    required this.colors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      final paint = Paint()
        ..color = colors[particle.colorIndex % colors.length].withOpacity(
          particle.opacity,
        )
        ..style = PaintingStyle.fill;

      // Animate particle position
      final x = (particle.x + progress * particle.speed) % 1.0;
      final y = (particle.y + progress * particle.speed * 0.5) % 1.0;

      canvas.drawCircle(
        Offset(x * size.width, y * size.height),
        particle.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(ParticlePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
