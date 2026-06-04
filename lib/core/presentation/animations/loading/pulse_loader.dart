import 'package:flutter/material.dart';

/// A pulse animation widget for loading states.
///
/// Continuously animates opacity and scale to create a breathing effect.
/// Ideal for loading indicators and placeholder content.
///
/// Example:
/// ```dart
/// PulseLoader(
///   child: CircularProgressIndicator(),
/// )
/// ```
class PulseLoader extends StatefulWidget {
  /// The child widget to pulse
  final Widget child;

  /// Pulse scale (default 1.1)
  final double pulseScale;

  /// Minimum opacity during pulse (default 0.6)
  final double minOpacity;

  /// Maximum opacity during pulse (default 1.0)
  final double maxOpacity;

  /// Duration of one pulse cycle (default 1 second)
  final Duration duration;

  /// Whether the pulse is active
  final bool pulsing;

  const PulseLoader({
    super.key,
    required this.child,
    this.pulseScale = 1.1,
    this.minOpacity = 0.6,
    this.maxOpacity = 1.0,
    this.duration = const Duration(seconds: 1),
    this.pulsing = true,
  });

  @override
  State<PulseLoader> createState() => _PulseLoaderState();
}

class _PulseLoaderState extends State<PulseLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.pulseScale,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _opacityAnimation = Tween<double>(
      begin: widget.maxOpacity,
      end: widget.minOpacity,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    if (widget.pulsing) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(PulseLoader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.pulsing != oldWidget.pulsing) {
      if (widget.pulsing) {
        _controller.repeat(reverse: true);
      } else {
        _controller.stop();
        _controller.animateTo(0);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _opacityAnimation.value,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}

/// A spinning loader with pulse effect.
///
/// Combines rotation with pulsing scale for a premium loading indicator.
class PulseSpinner extends StatefulWidget {
  /// Color of the spinner
  final Color? color;

  /// Size of the spinner (default 40)
  final double size;

  /// Stroke width (default 4)
  final double strokeWidth;

  /// Duration of one rotation (default 1 second)
  final Duration duration;

  const PulseSpinner({
    super.key,
    this.color,
    this.size = 40,
    this.strokeWidth = 4,
    this.duration = const Duration(seconds: 1),
  });

  @override
  State<PulseSpinner> createState() => _PulseSpinnerState();
}

class _PulseSpinnerState extends State<PulseSpinner>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? Theme.of(context).colorScheme.primary;

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.rotate(
            angle: _controller.value * 2 * 3.14159,
            child: child,
          );
        },
        child: CustomPaint(
          size: Size(widget.size, widget.size),
          painter: _SpinnerPainter(
            color: color,
            strokeWidth: widget.strokeWidth,
          ),
        ),
      ),
    );
  }
}

class _SpinnerPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  _SpinnerPainter({
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Draw background circle
    final backgroundPaint = Paint()
      ..color = color.withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Draw foreground arc
    final foregroundPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    const startAngle = -3.14159 / 2; // Start at top
    const sweepAngle = 3.14159 * 1.5; // 3/4 circle

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      foregroundPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _SpinnerPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}

/// A collection of dots that pulse in sequence.
///
/// Creates a wave-like loading effect with multiple dots.
class DotPulseLoader extends StatefulWidget {
  /// Number of dots (default 3)
  final int dotCount;

  /// Color of the dots
  final Color? color;

  /// Size of each dot (default 12)
  final double dotSize;

  /// Spacing between dots (default 8)
  final double spacing;

  /// Duration of one pulse cycle (default 1.2 seconds)
  final Duration duration;

  const DotPulseLoader({
    super.key,
    this.dotCount = 3,
    this.color,
    this.dotSize = 12,
    this.spacing = 8,
    this.duration = const Duration(milliseconds: 1200),
  });

  @override
  State<DotPulseLoader> createState() => _DotPulseLoaderState();
}

class _DotPulseLoaderState extends State<DotPulseLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? Theme.of(context).colorScheme.primary;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        widget.dotCount,
        (index) {
          final delay = index / widget.dotCount;
          return AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final animValue = (_controller.value - delay).clamp(0.0, 1.0);
              final scale = 0.5 + 0.5 * (1 + _easeInOut(animValue * 2 - 1)) / 2;
              final opacity = 0.3 + 0.7 * (1 + _easeInOut(animValue * 2 - 1)) / 2;

              return Container(
                width: widget.dotSize,
                height: widget.dotSize,
                margin: EdgeInsets.only(
                  right: index < widget.dotCount - 1 ? widget.spacing : 0,
                ),
                child: Transform.scale(
                  scale: scale,
                  child: Opacity(
                    opacity: opacity,
                    child: child,
                  ),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
          );
        },
      ),
    );
  }

  double _easeInOut(double t) {
    return t < 0.5 ? 2 * t * t : 1 - 2 * (1 - t) * (1 - t);
  }
}

/// A glassmorphism loading indicator.
///
/// Displays a pulsing loader inside a glass card.
class GlassLoadingIndicator extends StatelessWidget {
  /// Optional message to display below the loader
  final String? message;

  /// Color of the spinner
  final Color? spinnerColor;

  const GlassLoadingIndicator({
    super.key,
    this.message,
    this.spinnerColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const PulseSpinner(size: 32),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
