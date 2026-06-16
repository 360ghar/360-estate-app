import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';

/// Premium animated background for auth screens.
///
/// Features:
/// - Multi-layer animated mesh gradient
/// - Floating aurora orbs with sine wave motion
/// - Noise texture for depth
/// - Subtle shimmer effect
/// - Optimized with RepaintBoundary
class PremiumAuthBackground extends StatefulWidget {
  final Widget child;
  final bool showNoise;

  const PremiumAuthBackground({
    super.key,
    required this.child,
    this.showNoise = true,
  });

  @override
  State<PremiumAuthBackground> createState() => _PremiumAuthBackgroundState();
}

class _PremiumAuthBackgroundState extends State<PremiumAuthBackground>
    with TickerProviderStateMixin {
  late AnimationController _gradientController;
  late AnimationController _orb1Controller;
  late AnimationController _orb2Controller;
  late AnimationController _orb3Controller;
  late AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();

    // 30-second cycle for smooth gradient transitions
    _gradientController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    )..repeat();

    // Different cycles for each orb to create organic movement
    _orb1Controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    _orb2Controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 25),
    )..repeat();

    _orb3Controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 18),
    )..repeat();

    // Shimmer animation
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _gradientController.dispose();
    _orb1Controller.dispose();
    _orb2Controller.dispose();
    _orb3Controller.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Stack(
        children: [
          // Base gradient layer
          _buildBaseGradient(),

          // Animated mesh gradient overlay
          _buildMeshGradient(),

          // Floating aurora orbs
          _buildAuroraOrbs(),

          // Noise texture overlay
          if (widget.showNoise) _buildNoiseOverlay(),

          // Shimmer effect
          _buildShimmer(),

          // Content
          widget.child,
        ],
      ),
    );
  }

  Widget _buildBaseGradient() {
    return Positioned.fill(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0A0E27), // Deep midnight
              Color(0xFF1A1F3A), // Dark navy
              Color(0xFF0F172A), // Slate
              Color(0xFF1E1B4B), // Indigo
            ],
            stops: [0.0, 0.3, 0.6, 1.0],
          ),
        ),
      ),
    );
  }

  Widget _buildMeshGradient() {
    return Positioned.fill(
      child: AnimatedBuilder(
        animation: _gradientController,
        builder: (context, child) {
          final t = _gradientController.value;

          // Create shifting gradient colors based on animation
          final color1 = Color.lerp(
            const Color(0xFF3B82F6),
            const Color(0xFF8B5CF6),
            t,
          )!;
          final color2 = Color.lerp(
            const Color(0xFF8B5CF6),
            const Color(0xFF06B6D4),
            t,
          )!;
          final color3 = Color.lerp(
            const Color(0xFF06B6D4),
            const Color(0xFF3B82F6),
            t,
          )!;

          return Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(-1 + 2 * t, -1 + 2 * (t * 0.7 % 1.0)),
                radius: 1.5,
                colors: [
                  color1.withValues(alpha: 0.15),
                  color2.withValues(alpha: 0.1),
                  color3.withValues(alpha: 0.05),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.3, 0.6, 1.0],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAuroraOrbs() {
    return Positioned.fill(
      child: Stack(
        children: [
          // Large blue orb
          _buildOrb(
            controller: _orb1Controller,
            baseColor: const Color(0xFF3B82F6),
            size: 280,
            offsetStart: const Offset(-0.3, -0.2),
            offsetEnd: const Offset(0.3, 0.4),
          ),

          // Purple orb
          _buildOrb(
            controller: _orb2Controller,
            baseColor: const Color(0xFF8B5CF6),
            size: 220,
            offsetStart: const Offset(0.5, -0.3),
            offsetEnd: const Offset(-0.4, 0.6),
          ),

          // Teal accent orb
          _buildOrb(
            controller: _orb3Controller,
            baseColor: const Color(0xFF06B6D4),
            size: 180,
            offsetStart: const Offset(-0.2, 0.6),
            offsetEnd: const Offset(0.6, -0.3),
          ),
        ],
      ),
    );
  }

  Widget _buildOrb({
    required AnimationController controller,
    required Color baseColor,
    required double size,
    required Offset offsetStart,
    required Offset offsetEnd,
  }) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final t = controller.value;

        // Use smooth easing function
        final smoothT = _smoothStep(t);

        // Calculate position with sine wave motion
        final offsetX = lerpDouble(offsetStart.dx, offsetEnd.dx, smoothT)!;
        final offsetY = lerpDouble(offsetStart.dy, offsetEnd.dy, smoothT)!;

        // Calculate scale for breathing effect
        final scale = 1.0 + 0.2 * math.sin(t * math.pi * 2);

        // Calculate opacity
        final opacity = 0.3 + 0.15 * math.sin(t * math.pi * 2 + math.pi / 4);

        return Positioned(
          left: (0.5 + offsetX) * MediaQuery.sizeOf(context).width - size / 2,
          top: (0.5 + offsetY) * MediaQuery.sizeOf(context).height - size / 2,
          child: Transform.scale(
            scale: scale,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    baseColor.withValues(alpha: opacity),
                    baseColor.withValues(alpha: opacity * 0.5),
                    baseColor.withValues(alpha: 0.0),
                  ],
                  stops: const [0.0, 0.4, 1.0],
                ),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: baseColor.withValues(alpha: 0.05),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNoiseOverlay() {
    return Positioned.fill(
      child: Opacity(
        opacity: 0.03,
        child: CustomPaint(painter: _NoisePainter(), size: Size.infinite),
      ),
    );
  }

  Widget _buildShimmer() {
    return Positioned.fill(
      child: AnimatedBuilder(
        animation: _shimmerController,
        builder: (context, child) {
          final t = _shimmerController.value;
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.transparent,
                  Colors.white.withValues(alpha: 0.02 * math.sin(t * math.pi)),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
          );
        },
      ),
    );
  }

  /// Smooth step function for eased transitions
  double _smoothStep(double t) {
    return t * t * (3 - 2 * t);
  }
}

/// Custom painter for noise texture effect
class _NoisePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final random = math.Random(42); // Fixed seed for consistent pattern

    for (int i = 0; i < 500; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final radius = random.nextDouble() * 1.5;
      final alpha = random.nextDouble() * 0.3;

      canvas.drawCircle(
        Offset(x, y),
        radius,
        Paint()..color = Colors.white.withValues(alpha: alpha),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Simpler variant of premium background for better performance
class SimplePremiumBackground extends StatelessWidget {
  final Widget child;

  const SimplePremiumBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0A0E27), Color(0xFF1A1F3A), Color(0xFF1E1B4B)],
          stops: [0.0, 0.5, 1.0],
        ),
      ),
      child: Stack(
        children: [
          // Static gradient orbs
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 350,
              height: 350,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF3B82F6).withValues(alpha: 0.2),
                    const Color(0xFF3B82F6).withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -80,
            left: -80,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF8B5CF6).withValues(alpha: 0.15),
                    const Color(0xFF8B5CF6).withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}
