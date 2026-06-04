import 'package:estate_app/core/presentation/design_system/design_system.dart';
import 'package:flutter/material.dart';

/// An animated gradient background with floating aurora orbs.
///
/// Creates a premium animated background with multi-stop gradient
/// and floating decorative orbs with sine wave motion.
///
/// Example:
/// ```dart
/// AnimatedGradientBackground(
///   child: Scaffold(
///     body: Center(child: Text('Content')),
///   ),
/// )
/// ```
class AnimatedGradientBackground extends StatefulWidget {
  /// The child widget to display on top of the background
  final Widget child;

  /// Gradient colors for the animation
  final List<Color>? colors;

  /// Animation duration (default 20 seconds)
  final Duration duration;

  /// Number of floating orbs (default 2)
  final int orbCount;

  /// Whether to show grid pattern overlay
  final bool showGrid;

  const AnimatedGradientBackground({
    super.key,
    required this.child,
    this.colors,
    this.duration = const Duration(seconds: 20),
    this.orbCount = 2,
    this.showGrid = false,
  });

  @override
  State<AnimatedGradientBackground> createState() =>
      _AnimatedGradientBackgroundState();
}

class _AnimatedGradientBackgroundState extends State<AnimatedGradientBackground>
    with TickerProviderStateMixin {
  late AnimationController _gradientController;
  late AnimationController _orb1Controller;
  late AnimationController _orb2Controller;
  late List<AnimationController> _orbControllers;

  final List<_OrbPosition> _orbPositions = [];

  @override
  void initState() {
    super.initState();

    // Gradient animation controller
    _gradientController = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..repeat();

    // Orb controllers
    _orb1Controller = AnimationController(
      duration: const Duration(seconds: 25),
      vsync: this,
    )..repeat();

    _orb2Controller = AnimationController(
      duration: const Duration(seconds: 30),
      vsync: this,
    )..repeat();

    _orbControllers = [_orb1Controller, _orb2Controller];

    // Initialize orb positions
    for (int i = 0; i < widget.orbCount; i++) {
      _orbPositions.add(_OrbPosition(
        baseX: i == 0 ? 0.2 : 0.8,
        baseY: i == 0 ? 0.3 : 0.7,
        amplitude: 0.15,
        speed: i == 0 ? 1.0 : 0.8,
      ));
    }
  }

  @override
  void dispose() {
    _gradientController.dispose();
    for (var controller in _orbControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultColors = const [
      Color(0xFF0F172A), // Slate 900
      Color(0xFF1E1B4B), // Indigo 950
      Color(0xFF312E81), // Indigo 900
      Color(0xFF1E3A5F), // Navy
    ];

    final colors = widget.colors ?? defaultColors;

    return Stack(
      children: [
        // Animated gradient background
        AnimatedBuilder(
          animation: _gradientController,
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: colors,
                  stops: _calculateStops(_gradientController.value),
                ),
              ),
            );
          },
        ),

        // Floating aurora orbs
        ...List.generate(widget.orbCount, (index) {
          return _buildOrb(index);
        }),

        // Optional grid pattern overlay
        if (widget.showGrid) _buildGridPattern(),

        // Child content
        widget.child,
      ],
    );
  }

  List<double> _calculateStops(double value) {
    // Animate gradient stops for shifting effect
    final offset = value % 1.0;
    return [
      (0.0 + offset * 0.3) % 1.0,
      (0.3 + offset * 0.3) % 1.0,
      (0.6 + offset * 0.3) % 1.0,
      (0.9 + offset * 0.3) % 1.0,
    ]..sort();
  }

  Widget _buildOrb(int index) {
    final controller = _orbControllers[index % _orbControllers.length];
    final position = _orbPositions[index % _orbPositions.length];
    final orbColor = index == 0
        ? AppGlassColors.auroraPurple
        : AppGlassColors.auroraCyan;

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final size = MediaQuery.sizeOf(context);
        final x = position.baseX +
            position.amplitude *
                (index == 0
                    ? _sinValue(controller.value)
                    : _cosValue(controller.value));
        final y = position.baseY +
            position.amplitude *
                (index == 0
                    ? _cosValue(controller.value * 0.7)
                    : _sinValue(controller.value * 0.8));

        return Positioned(
          left: (x * size.width) - 100,
          top: (y * size.height) - 100,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                radius: 1.0,
                colors: [
                  orbColor.withValues(alpha: 0.3),
                  orbColor.withValues(alpha: 0.1),
                  orbColor.withValues(alpha: 0),
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildGridPattern() {
    return IgnorePointer(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.03),
        ),
        child: CustomPaint(
          size: Size.infinite,
          painter: _GridPatternPainter(),
        ),
      ),
    );
  }

  double _sinValue(double value) {
    return (2 * (value - 0.5)).clamp(-1.0, 1.0);
  }

  double _cosValue(double value) {
    final radians = value * 2 * 3.14159;
    return (radians).clamp(-1.0, 1.0);
  }
}

class _OrbPosition {
  final double baseX;
  final double baseY;
  final double amplitude;
  final double speed;

  _OrbPosition({
    required this.baseX,
    required this.baseY,
    required this.amplitude,
    required this.speed,
  });
}

class _GridPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.05)
      ..strokeWidth = 1;

    const gridSize = 40.0;

    // Draw vertical lines
    for (double x = 0; x < size.width; x += gridSize) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }

    // Draw horizontal lines
    for (double y = 0; y < size.height; y += gridSize) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// An auth-specific animated gradient background.
///
/// Optimized for authentication screens with deep colors
/// and subtle aurora effects.
class AuthGradientBackground extends StatelessWidget {
  /// The child widget to display on top
  final Widget child;

  /// Whether to show grid pattern overlay
  final bool showGrid;

  const AuthGradientBackground({
    super.key,
    required this.child,
    this.showGrid = true,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedGradientBackground(
      colors: const [
        Color(0xFF0F172A), // Slate 900
        Color(0xFF1E1B4B), // Indigo 950
        Color(0xFF312E81), // Indigo 900
        Color(0xFF1E3A5F), // Navy
      ],
      showGrid: showGrid,
      child: child,
    );
  }
}

/// A subtle animated background for non-auth screens.
///
/// Lighter, more subtle animation for general app screens.
class SubtleGradientBackground extends StatelessWidget {
  /// The child widget to display on top
  final Widget child;

  /// Whether to animate
  final bool animate;

  const SubtleGradientBackground({
    super.key,
    required this.child,
    this.animate = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!animate) {
      return Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFF9FAFB),
              Color(0xFFF3F4F6),
            ],
          ),
        ),
        child: child,
      );
    }

    return AnimatedBuilder(
      animation: const AlwaysStoppedAnimation(0),
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFFF9FAFB),
                const Color(0xFFF3F4F6),
                const Color(0xFFEEF2FF),
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
          child: child,
        );
      },
      child: child,
    );
  }
}
