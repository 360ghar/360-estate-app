import 'package:estate_app/core/presentation/design_system/design_system.dart';
import 'package:flutter/material.dart';

/// A premium animated background for authentication screens.
///
/// Features:
/// - Deep gradient background (Dark slate → Navy → Dark indigo)
/// - 2 floating aurora orbs with different animation speeds (25s, 30s)
/// - Subtle grid pattern overlay (3% opacity white)
/// - Sine wave motion for orbs
///
/// Example:
/// ```dart
/// AuthBackground(
///   child: AuthPageLayout(child: ...),
/// )
/// ```
class AuthBackground extends StatefulWidget {
  /// The child widget to display on top of the background
  final Widget child;

  /// Whether to show the grid pattern overlay
  final bool showGrid;

  /// Number of floating orbs (0-3)
  final int orbCount;

  const AuthBackground({
    super.key,
    required this.child,
    this.showGrid = true,
    this.orbCount = 2,
  });

  @override
  State<AuthBackground> createState() => _AuthBackgroundState();
}

class _AuthBackgroundState extends State<AuthBackground>
    with TickerProviderStateMixin {
  late AnimationController _orb1Controller;
  late AnimationController _orb2Controller;
  late AnimationController _orb3Controller;

  @override
  void initState() {
    super.initState();

    // Create animation controllers for orbs with different speeds
    _orb1Controller = AnimationController(
      duration: const Duration(seconds: 25),
      vsync: this,
    )..repeat();

    _orb2Controller = AnimationController(
      duration: const Duration(seconds: 30),
      vsync: this,
    )..repeat();

    _orb3Controller = AnimationController(
      duration: const Duration(seconds: 35),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _orb1Controller.dispose();
    _orb2Controller.dispose();
    _orb3Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Base gradient background
        const _BaseGradient(),

        // Floating aurora orbs
        if (widget.orbCount > 0)
          _FloatingOrb(
            controller: _orb1Controller,
            baseX: 0.2,
            baseY: 0.3,
            color: AppGlassColors.auroraPurple,
          ),
        if (widget.orbCount > 1)
          _FloatingOrb(
            controller: _orb2Controller,
            baseX: 0.8,
            baseY: 0.7,
            color: AppGlassColors.auroraCyan,
            size: 180,
          ),
        if (widget.orbCount > 2)
          _FloatingOrb(
            controller: _orb3Controller,
            baseX: 0.5,
            baseY: 0.8,
            color: AppGlassColors.auroraIndigo,
            size: 150,
          ),

        // Optional grid pattern overlay
        if (widget.showGrid) const _GridPatternOverlay(),

        // Child content
        widget.child,
      ],
    );
  }
}

/// The base gradient background for auth screens
class _BaseGradient extends StatelessWidget {
  const _BaseGradient();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0F172A), // Slate 900
            Color(0xFF1E1B4B), // Indigo 950
            Color(0xFF312E81), // Indigo 900
            Color(0xFF1E3A5F), // Navy
          ],
          stops: [0.0, 0.3, 0.7, 1.0],
        ),
      ),
    );
  }
}

/// A floating orb with sine wave motion
class _FloatingOrb extends StatelessWidget {
  final AnimationController controller;
  final double baseX;
  final double baseY;
  final Color color;
  final double size;

  const _FloatingOrb({
    required this.controller,
    required this.baseX,
    required this.baseY,
    required this.color,
    this.size = 200,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final screenSize = MediaQuery.sizeOf(context);

        // Calculate position with sine wave motion
        final x = baseX + 0.15 * (controller.value * 2 - 1);
        final y = baseY + 0.15 * _sin(controller.value * 2 + 1);

        return Positioned(
          left: (x * screenSize.width) - size / 2,
          top: (y * screenSize.height) - size / 2,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                radius: 1.0,
                colors: [
                  color.withValues(alpha: 0.4),
                  color.withValues(alpha: 0.2),
                  color.withValues(alpha: 0),
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
          ),
        );
      },
    );
  }

  double _sin(double value) {
    final radians = value * 3.14159;
    return (radians).clamp(-1.0, 1.0);
  }
}

/// Subtle grid pattern overlay
class _GridPatternOverlay extends StatelessWidget {
  const _GridPatternOverlay();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(size: Size.infinite, painter: _GridPatternPainter()),
    );
  }
}

class _GridPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.03)
      ..strokeWidth = 1;

    const gridSize = 40.0;

    // Draw vertical lines
    for (double x = 0; x < size.width; x += gridSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // Draw horizontal lines
    for (double y = 0; y < size.height; y += gridSize) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// A simplified auth background with gradient only (no orbs)
///
/// Use this for lighter-weight auth screens where full animation
/// is not needed.
class SimpleAuthBackground extends StatelessWidget {
  /// The child widget to display on top
  final Widget child;

  const SimpleAuthBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [const _BaseGradient(), child]);
  }
}

/// A light mode variant of the auth background
class AuthBackgroundLight extends StatelessWidget {
  /// The child widget to display on top
  final Widget child;

  /// Whether to show the grid pattern overlay
  final bool showGrid;

  const AuthBackgroundLight({
    super.key,
    required this.child,
    this.showGrid = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFEEF2FF), // Very light indigo
                Color(0xFFE0E7FF), // Light indigo
                Color(0xFFC7D2FE), // Soft indigo
              ],
            ),
          ),
        ),
        if (showGrid)
          IgnorePointer(
            child: CustomPaint(
              size: Size.infinite,
              painter: _GridPatternPainterLight(),
            ),
          ),
        child,
      ],
    );
  }
}

class _GridPatternPainterLight extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF6366F1).withValues(alpha: 0.05)
      ..strokeWidth = 1;

    const gridSize = 40.0;

    for (double x = 0; x < size.width; x += gridSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    for (double y = 0; y < size.height; y += gridSize) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
