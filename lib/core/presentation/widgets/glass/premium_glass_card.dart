import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:estate_app/core/presentation/design_system/app_glass_blur.dart';
import 'package:estate_app/core/presentation/design_system/app_glass_colors.dart';

/// Premium glass card with animated border glow and superior visual effects.
///
/// Features:
/// - Animated gradient border on hover/focus
/// - Smooth scale animation on press
/// - Optimized blur effect
/// - Premium shadow system
/// - Optional shimmer effect
class PremiumGlassCard extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final double borderRadius;
  final double blur;
  final double opacity;
  final bool shimmer;
  final bool animateOnHover;
  final VoidCallback? onTap;

  const PremiumGlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.margin = EdgeInsets.zero,
    this.borderRadius = 20,
    this.blur = AppGlassBlur.extra,
    this.opacity = AppGlassColors.opacityMedium,
    this.shimmer = false,
    this.animateOnHover = true,
    this.onTap,
  });

  @override
  State<PremiumGlassCard> createState() => _PremiumGlassCardState();
}

class _PremiumGlassCardState extends State<PremiumGlassCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _shimmerController;
  late Animation<double> _shimmerAnimation;
  bool _isPressed = false;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
    _shimmerAnimation = Tween<double>(begin: -2, end: 2).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: widget.margin,
      child: AnimatedScale(
        scale: _isPressed ? 0.98 : 1.0,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOutCubic,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            boxShadow: _getShadow(isDark),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: widget.blur, sigmaY: widget.blur),
              child: Stack(
                children: [
                  // Base glass layer
                  Container(
                    padding: widget.padding,
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppGlassColors.glassSurfaceDark(widget.opacity)
                          : AppGlassColors.glassSurfaceLight(widget.opacity),
                      borderRadius: BorderRadius.circular(widget.borderRadius),
                      border: Border.all(
                        color: isDark
                            ? AppGlassColors.borderDark
                            : AppGlassColors.borderLight,
                        width: 1,
                      ),
                    ),
                    child: widget.child,
                  ),

                  // Animated gradient border glow
                  if (_isHovered || widget.onTap != null)
                    _buildGradientBorder(widget.borderRadius),

                  // Shimmer effect
                  if (widget.shimmer) _buildShimmer(widget.borderRadius),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGradientBorder(double radius) {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(
            width: 1.5,
            color: Colors.transparent,
          ),
        ),
        child: CustomPaint(
          painter: _GradientBorderPainter(
            borderRadius: radius,
            colors: const [
              Color(0xFF3B82F6),
              Color(0xFF8B5CF6),
              Color(0xFF06B6D4),
              Color(0xFF3B82F6),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShimmer(double radius) {
    return AnimatedBuilder(
      animation: _shimmerAnimation,
      builder: (context, child) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: Opacity(
            opacity: 0.3,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Colors.transparent,
                    Colors.white.withValues(alpha: 0.1),
                    Colors.transparent,
                  ],
                  stops: [
                    _shimmerAnimation.value - 0.3,
                    _shimmerAnimation.value,
                    _shimmerAnimation.value + 0.3,
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  List<BoxShadow> _getShadow(bool isDark) {
    return [
      BoxShadow(
        color: isDark
            ? Colors.black.withValues(alpha: 0.3)
            : Colors.black.withValues(alpha: 0.1),
        offset: const Offset(0, 8),
        blurRadius: 32,
        spreadRadius: -8,
      ),
      BoxShadow(
        color: isDark
            ? Colors.black.withValues(alpha: 0.2)
            : Colors.black.withValues(alpha: 0.05),
        offset: const Offset(0, 2),
        blurRadius: 8,
      ),
    ];
  }
}

/// Custom painter for animated gradient border
class _GradientBorderPainter extends CustomPainter {
  final double borderRadius;
  final List<Color> colors;

  _GradientBorderPainter({
    required this.borderRadius,
    required this.colors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(borderRadius));

    final gradient = LinearGradient(
      colors: colors,
      stops: const [0.0, 0.33, 0.66, 1.0],
    ).createShader(rect);

    final paint = Paint()
      ..shader = gradient
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 2);

    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// Premium input field with focus glow animation
class PremiumGlassInput extends StatefulWidget {
  final String label;
  final String hint;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final bool enabled;
  final String? error;
  final IconData? prefixIcon;
  final int maxLines;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;

  const PremiumGlassInput({
    super.key,
    required this.label,
    required this.hint,
    this.controller,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.enabled = true,
    this.error,
    this.prefixIcon,
    this.maxLines = 1,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
  });

  @override
  State<PremiumGlassInput> createState() => _PremiumGlassInputState();
}

class _PremiumGlassInputState extends State<PremiumGlassInput>
    with SingleTickerProviderStateMixin {
  late AnimationController _focusController;
  late Animation<double> _glowAnimation;
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _focusController, curve: Curves.easeOutCubic),
    );
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
    if (_isFocused) {
      _focusController.forward();
    } else {
      _focusController.reverse();
    }
  }

  @override
  void dispose() {
    _focusController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hasError = widget.error != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.7),
            fontSize: 13,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 10),
        AnimatedBuilder(
          animation: _glowAnimation,
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                boxShadow: _getGlowShadow(hasError),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppGlassColors.glassSurfaceDark(0.15)
                          : AppGlassColors.glassSurfaceLight(0.6),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: hasError
                            ? const Color(0xFFEF4444)
                            : _isFocused
                                ? const Color(0xFF3B82F6)
                                : isDark
                                    ? AppGlassColors.borderDark
                                    : AppGlassColors.borderLight,
                        width: _isFocused ? 1.5 : 1,
                      ),
                    ),
                    child: TextField(
                      controller: widget.controller,
                      focusNode: _focusNode,
                      keyboardType: widget.keyboardType,
                      textInputAction: widget.textInputAction,
                      obscureText: widget.obscureText,
                      maxLines: widget.maxLines,
                      enabled: widget.enabled,
                      onChanged: widget.onChanged,
                      onSubmitted: widget.onSubmitted,
                      onTap: widget.onTap,
                      style: TextStyle(
                        color: isDark ? Colors.white : AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      cursorColor: const Color(0xFF3B82F6),
                      decoration: InputDecoration(
                        hintText: widget.hint,
                        hintStyle: TextStyle(
                          color: Colors.white.withValues(alpha: 0.4),
                          fontSize: 16,
                        ),
                        prefixIcon: widget.prefixIcon != null
                            ? Icon(
                                widget.prefixIcon,
                                color: Colors.white.withValues(alpha: 0.5),
                                size: 20,
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        if (widget.error != null) ...[
          const SizedBox(height: 8),
          Text(
            widget.error!,
            style: TextStyle(
              color: const Color(0xFFEF4444).withValues(alpha: 0.9),
              fontSize: 12,
            ),
          ),
        ],
      ],
    );
  }

  List<BoxShadow> _getGlowShadow(bool hasError) {
    if (hasError) {
      return [
        BoxShadow(
          color: const Color(0xFFEF4444).withValues(alpha: 0.3 * _glowAnimation.value),
          blurRadius: 16,
          spreadRadius: 0,
        ),
      ];
    }
    return [
      BoxShadow(
        color: const Color(0xFF3B82F6).withValues(alpha: 0.25 * _glowAnimation.value),
        blurRadius: 20,
        spreadRadius: 0,
      ),
      BoxShadow(
        color: const Color(0xFF8B5CF6).withValues(alpha: 0.15 * _glowAnimation.value),
        blurRadius: 24,
        spreadRadius: 0,
      ),
    ];
  }
}

/// Premium button with gradient background and smooth animations
class PremiumGlassButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final bool isPrimary;
  final bool isSecondary;
  final bool isGhost;

  const PremiumGlassButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.isPrimary = true,
    this.isSecondary = false,
    this.isGhost = false,
  });

  @override
  State<PremiumGlassButton> createState() => _PremiumGlassButtonState();
}

class _PremiumGlassButtonState extends State<PremiumGlassButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTapDown: widget.isLoading ? null : (_) => _handlePressDown(),
      onTapUp: widget.isLoading ? null : (_) => _handlePressUp(),
      onTapCancel: widget.isLoading ? null : _handlePressUp,
      onTap: widget.isLoading ? null : widget.onPressed,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _isPressed ? _scaleAnimation.value : 1.0,
            child: _buildButton(isDark),
          );
        },
      ),
    );
  }

  Widget _buildButton(bool isDark) {
    if (widget.isGhost) {
      return _buildGhostButton(isDark);
    }

    if (widget.isSecondary) {
      return _buildSecondaryButton(isDark);
    }

    return _buildPrimaryButton(isDark);
  }

  Widget _buildPrimaryButton(bool isDark) {
    return Container(
      height: 54,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF3B82F6),
            Color(0xFF2563EB),
          ],
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3B82F6).withValues(alpha: 0.4),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.isLoading ? null : widget.onPressed,
          borderRadius: BorderRadius.circular(14),
          child: Center(
            child: widget.isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.icon != null) ...[
                        Icon(widget.icon, size: 20, color: Colors.white),
                        const SizedBox(width: 10),
                      ],
                      Text(
                        widget.label,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildSecondaryButton(bool isDark) {
    return Container(
      height: 54,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF8B5CF6),
            Color(0xFF7C3AED),
          ],
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF8B5CF6).withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.isLoading ? null : widget.onPressed,
          borderRadius: BorderRadius.circular(14),
          child: Center(
            child: widget.isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    widget.label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildGhostButton(bool isDark) {
    return Container(
      height: 54,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.isLoading ? null : widget.onPressed,
          borderRadius: BorderRadius.circular(14),
          child: Center(
            child: widget.isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    widget.label,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.3,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  void _handlePressDown() {
    setState(() => _isPressed = true);
    _controller.forward();
  }

  void _handlePressUp() {
    setState(() => _isPressed = false);
    _controller.reverse();
  }
}

// Import AppColors for reference
abstract final class AppColors {
  static const Color textPrimary = Color(0xFF1F2937);
}
