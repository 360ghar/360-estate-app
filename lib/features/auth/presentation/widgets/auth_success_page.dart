import 'package:estate_app/core/presentation/design_system/design_system.dart';
import 'package:flutter/material.dart';

/// An authentication success page with celebration animation.
///
/// Features:
/// - Circle background with glow
/// - Animated stroke drawing for checkmark
/// - 800ms duration with elastic curve
/// - Scale animation 0→1
///
/// Example:
/// ```dart
/// AuthSuccessPage(
///   title: 'Welcome!',
///   message: 'Your account has been created successfully.',
///   onContinue: () => Navigator.push(...),
/// )
/// ```
class AuthSuccessPage extends StatefulWidget {
  /// Title to display
  final String title;

  /// Message to display
  final String message;

  /// Callback for continue button
  final VoidCallback? onContinue;

  /// Continue button label
  final String continueLabel;

  /// Icon to display (default is checkmark)
  final IconData? icon;

  const AuthSuccessPage({
    super.key,
    this.title = 'Success!',
    this.message = '',
    this.onContinue,
    this.continueLabel = 'Continue',
    this.icon,
  });

  @override
  State<AuthSuccessPage> createState() => _AuthSuccessPageState();
}

class _AuthSuccessPageState extends State<AuthSuccessPage>
    with TickerProviderStateMixin {
  late AnimationController _checkmarkController;
  late AnimationController _scaleController;
  late AnimationController _confettiController;

  @override
  void initState() {
    super.initState();

    // Checkmark animation controller
    _checkmarkController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Scale animation controller
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    // Confetti animation controller
    _confettiController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Start animations
    _scaleController.forward().then((_) {
      _checkmarkController.forward();
    });
    _confettiController.forward();
  }

  @override
  void dispose() {
    _checkmarkController.dispose();
    _scaleController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0F172A),
              Color(0xFF1E1B4B),
              Color(0xFF312E81),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Success animation
                  _SuccessCheckmarkAnimation(
                    checkmarkController: _checkmarkController,
                    scaleController: _scaleController,
                    icon: widget.icon,
                  ),
                  const SizedBox(height: 40),

                  // Title
                  FadeTransition(
                    opacity: _scaleController,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.3),
                        end: Offset.zero,
                      ).animate(CurvedAnimation(
                        parent: _scaleController,
                        curve: Curves.easeOut,
                      )),
                      child: Text(
                        widget.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Message
                  FadeTransition(
                    opacity: _scaleController,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.3),
                        end: Offset.zero,
                      ).animate(CurvedAnimation(
                        parent: _scaleController,
                        curve: Curves.easeOut,
                      )),
                      child: Text(
                        widget.message,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(height: 48),

                  // Continue button
                  FadeTransition(
                    opacity: _scaleController,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.5),
                        end: Offset.zero,
                      ).animate(CurvedAnimation(
                        parent: _scaleController,
                        curve: Curves.easeOut,
                      )),
                      child: _ContinueButton(
                        label: widget.continueLabel,
                        onPressed: widget.onContinue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SuccessCheckmarkAnimation extends StatelessWidget {
  final AnimationController checkmarkController;
  final AnimationController scaleController;
  final IconData? icon;

  const _SuccessCheckmarkAnimation({
    required this.checkmarkController,
    required this.scaleController,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
      height: 140,
      child: AnimatedBuilder(
        animation: scaleController,
        builder: (context, child) {
          final scale = Curves.elasticOut.transform(scaleController.value);
          return Transform.scale(
            scale: scale,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Outer glow ring
                Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.success.withValues(alpha: 0.15 * scaleController.value),
                        blurRadius: 30,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                ),
                // Checkmark canvas
                SizedBox(
                  width: 120,
                  height: 120,
                  child: _CheckmarkCanvas(
                    controller: checkmarkController,
                    icon: icon,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _CheckmarkCanvas extends StatelessWidget {
  final AnimationController controller;
  final IconData? icon;

  const _CheckmarkCanvas({
    required this.controller,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(120, 120),
      painter: _CheckmarkPainter(
        progress: controller.value,
        icon: icon,
      ),
    );
  }
}

class _CheckmarkPainter extends CustomPainter {
  final double progress;
  final IconData? icon;

  _CheckmarkPainter({required this.progress, this.icon});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;

    // Draw glow background
    final glowPaint = Paint()
      ..color = AppColors.success.withValues(alpha: 0.2)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15);
    canvas.drawCircle(center, radius, glowPaint);

    // Draw background circle
    final bgPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.1)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, bgPaint);

    // Draw border circle
    final borderPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(center, radius, borderPaint);

    if (icon != null) {
      // Draw icon
      final textPainter = TextPainter(
        text: TextSpan(
          text: String.fromCharCode(icon!.codePoint),
          style: TextStyle(
            color: Colors.white.withValues(alpha: progress),
            fontSize: 48,
            fontFamily: icon!.fontFamily,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          center.dx - textPainter.width / 2,
          center.dy - textPainter.height / 2,
        ),
      );
    } else {
      // Draw checkmark
      final checkmarkPaint = Paint()
        ..color = AppColors.successLight
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;

      final path = Path();

      // Calculate checkmark points
      final checkmarkProgress = Curves.easeInOut.transform(progress);
      final startPoint = Offset(center.dx - 20, center.dy);
      final middlePoint = Offset(center.dx - 5, center.dy + 15);
      final endPoint = Offset(center.dx + 20, center.dy - 15);

      if (checkmarkProgress < 0.5) {
        // Draw first segment
        final segmentProgress = checkmarkProgress * 2;
        final currentPoint = Offset(
          startPoint.dx + (middlePoint.dx - startPoint.dx) * segmentProgress,
          startPoint.dy + (middlePoint.dy - startPoint.dy) * segmentProgress,
        );
        path.moveTo(startPoint.dx, startPoint.dy);
        path.lineTo(currentPoint.dx, currentPoint.dy);
      } else {
        // Draw both segments
        final segmentProgress = (checkmarkProgress - 0.5) * 2;
        final currentPoint = Offset(
          middlePoint.dx + (endPoint.dx - middlePoint.dx) * segmentProgress,
          middlePoint.dy + (endPoint.dy - middlePoint.dy) * segmentProgress,
        );
        path.moveTo(startPoint.dx, startPoint.dy);
        path.lineTo(middlePoint.dx, middlePoint.dy);
        path.lineTo(currentPoint.dx, currentPoint.dy);
      }

      canvas.drawPath(path, checkmarkPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _CheckmarkPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class _ContinueButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;

  const _ContinueButton({
    required this.label,
    this.onPressed,
  });

  @override
  State<_ContinueButton> createState() => _ContinueButtonState();
}

class _ContinueButtonState extends State<_ContinueButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _scaleController;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _scaleController.forward(),
      onTapUp: (_) {
        _scaleController.reverse();
        widget.onPressed?.call();
      },
      onTapCancel: () => _scaleController.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) => Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        ),
        child: Container(
          width: double.infinity,
          height: 52,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFF3B82F6),
                Color(0xFF2563EB),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF3B82F6).withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Text(
              widget.label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A success widget that can be embedded in other pages.
///
/// Smaller version for use within dialogs or other containers.
class AuthSuccessWidget extends StatelessWidget {
  /// Title to display
  final String title;

  /// Message to display
  final String? message;

  /// Icon to display (default is checkmark)
  final IconData? icon;

  const AuthSuccessWidget({
    super.key,
    required this.title,
    this.message,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Success icon
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [
                Color(0xFF059669),
                Color(0xFF10B981),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.success.withValues(alpha: 0.3),
                blurRadius: 12,
              ),
            ],
          ),
          child: const Icon(
            Icons.check,
            size: 32,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),

        // Title
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.center,
        ),

        // Message
        if (message != null) ...[
          const SizedBox(height: 8),
          Text(
            message!,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}

/// Confetti overlay for celebration effect.
class ConfettiOverlay extends StatefulWidget {
  /// Child widget to display under confetti
  final Widget child;

  /// Whether to show confetti
  final bool showConfetti;

  const ConfettiOverlay({
    super.key,
    required this.child,
    this.showConfetti = true,
  });

  @override
  State<ConfettiOverlay> createState() => _ConfettiOverlayState();
}

class _ConfettiOverlayState extends State<ConfettiOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_ConfettiParticle> _particles = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    if (widget.showConfetti) {
      _generateParticles();
      _controller.forward();
    }
  }

  void _generateParticles() {
    final random = DateTime.now().millisecondsSinceEpoch;
    for (int i = 0; i < 50; i++) {
      _particles.add(_ConfettiParticle(
        x: (i % 5) / 4 - 0.5,
        y: -1.0,
        color: [
          AppColors.successLight,
          AppColors.accent,
          AppColors.infoLight,
          const Color(0xFFFBBF24),
          const Color(0xFFF472B6),
        ][(i + random) % 5],
        size: 5 + (i % 3) * 2,
        speedY: 0.3 + (i % 5) * 0.1,
        speedX: ((i % 2) * 2 - 1) * 0.1,
        rotation: i * 0.2,
      ));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (widget.showConfetti)
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return CustomPaint(
                size: Size.infinite,
                painter: _ConfettiPainter(
                  particles: _particles,
                  progress: _controller.value,
                ),
              );
            },
          ),
      ],
    );
  }
}

class _ConfettiParticle {
  final double x;
  double y;
  final Color color;
  final double size;
  final double speedY;
  final double speedX;
  final double rotation;

  _ConfettiParticle({
    required this.x,
    required this.y,
    required this.color,
    required this.size,
    required this.speedY,
    required this.speedX,
    required this.rotation,
  });
}

class _ConfettiPainter extends CustomPainter {
  final List<_ConfettiParticle> particles;
  final double progress;

  _ConfettiPainter({required this.particles, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      final y = particle.y + progress * particle.speedY * 2;
      final x = particle.x + progress * particle.speedX;

      if (y > 1.0) continue;

      final paint = Paint()..color = particle.color.withValues(alpha: 1 - progress * 0.5);

      final screenX = size.width / 2 + x * size.width / 2;
      final screenY = size.height * y;

      canvas.save();
      canvas.translate(screenX, screenY);
      canvas.rotate(particle.rotation + progress * 6.28);
      canvas.drawRect(
        Rect.fromCenter(
          center: Offset.zero,
          width: particle.size.toDouble(),
          height: particle.size * 0.6,
        ),
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
