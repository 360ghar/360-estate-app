import 'dart:ui';

import 'package:estate_app/core/presentation/design_system/design_system.dart';
import 'package:flutter/material.dart';

/// A glassmorphism bottom sheet with frosted glass effect.
///
/// Provides a premium modal bottom sheet with customizable
/// glass styling, animation, and drag handle.
///
/// Example:
/// ```dart
/// GlassBottomSheet.show(
///   context: context,
///   child: ContentWidget(),
/// )
/// ```
class GlassBottomSheet extends StatelessWidget {
  /// The child widget inside the bottom sheet
  final Widget child;

  /// Optional title for the bottom sheet
  final String? title;

  /// Optional subtitle for the bottom sheet
  final String? subtitle;

  /// Blur sigma value
  final double blur;

  /// Opacity of the glass surface
  final double opacity;

  /// Border radius of the bottom sheet
  final double borderRadius;

  /// Whether to show the drag handle
  final bool showDragHandle;

  /// Optional padding for the content
  final EdgeInsetsGeometry? contentPadding;

  /// Optional maximum height
  final double? maxHeight;

  const GlassBottomSheet({
    super.key,
    required this.child,
    this.title,
    this.subtitle,
    this.blur = AppGlassBlur.extra,
    this.opacity = AppGlassColors.opacityMedium,
    this.borderRadius = 20,
    this.showDragHandle = true,
    this.contentPadding,
    this.maxHeight,
  });

  /// Shows a glass bottom sheet as a modal
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    String? title,
    String? subtitle,
    double blur = AppGlassBlur.extra,
    double opacity = AppGlassColors.opacityMedium,
    double borderRadius = 20,
    bool showDragHandle = true,
    EdgeInsetsGeometry? contentPadding,
    double? maxHeight,
    bool isDismissible = true,
    bool enableDrag = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return GlassBottomSheet(
          title: title,
          subtitle: subtitle,
          blur: blur,
          opacity: opacity,
          borderRadius: borderRadius,
          showDragHandle: showDragHandle,
          contentPadding: contentPadding,
          maxHeight: maxHeight,
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenHeight = MediaQuery.sizeOf(context).height;
    final effectiveMaxHeight = maxHeight ?? screenHeight * 0.9;

    return Container(
      constraints: BoxConstraints(
        maxHeight: effectiveMaxHeight,
      ),
      decoration: BoxDecoration(
        color: AppGlassColors.scrim,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Tap area to dismiss
          Expanded(
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: const SizedBox.shrink(),
            ),
          ),
          // Bottom sheet content
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(borderRadius),
              topRight: Radius.circular(borderRadius),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: effectiveMaxHeight,
                ),
                decoration: BoxDecoration(
                  color: (isDark
                          ? AppGlassColors.glassSurfaceDark(opacity)
                          : AppGlassColors.glassSurfaceLight(opacity))
                      .withValues(alpha: 0.95),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(borderRadius),
                    topRight: Radius.circular(borderRadius),
                  ),
                  border: Border(
                    top: BorderSide(
                      color: isDark
                          ? AppGlassColors.borderDark
                          : AppGlassColors.borderLight,
                    ),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 20,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (showDragHandle) _buildDragHandle(context),
                    if (title != null || subtitle != null) _buildHeader(context),
                    Flexible(
                      child: SingleChildScrollView(
                        padding: contentPadding ??
                            const EdgeInsets.fromLTRB(
                              20,
                              8,
                              20,
                              20,
                            ),
                        child: child,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDragHandle(BuildContext context) {
    return GestureDetector(
      onVerticalDragStart: (_) {
        Navigator.of(context).pop();
      },
      child: Center(
        child: Container(
          width: 40,
          height: 4,
          margin: const EdgeInsets.only(top: 12, bottom: 8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    if (title == null && subtitle == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Text(
              title!,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          if (subtitle != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                subtitle!,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 14,
                ),
              ),
            ),
          Divider(
            height: 16,
            thickness: 1,
            color: Colors.white.withValues(alpha: 0.1),
          ),
        ],
      ),
    );
  }
}

/// A glass bottom sheet with custom scrollable content.
class GlassScrollableBottomSheet extends StatelessWidget {
  /// The child widget inside the bottom sheet
  final Widget child;

  /// Optional title for the bottom sheet
  final String? title;

  /// Blur sigma value
  final double blur;

  /// Opacity of the glass surface
  final double opacity;

  /// Border radius of the bottom sheet
  final double borderRadius;

  const GlassScrollableBottomSheet({
    super.key,
    required this.child,
    this.title,
    this.blur = AppGlassBlur.extra,
    this.opacity = AppGlassColors.opacityMedium,
    this.borderRadius = 20,
  });

  @override
  Widget build(BuildContext context) {
    // This widget is primarily used through the static `show` method
    // Returning empty container as fallback
    return const SizedBox.shrink();
  }

  /// Shows a scrollable glass bottom sheet
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    String? title,
    double blur = AppGlassBlur.extra,
    double opacity = AppGlassColors.opacityMedium,
    double borderRadius = 20,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.95,
          builder: (context, scrollController) {
            return _ScrollableGlassBottomSheetContent(
              title: title,
              blur: blur,
              opacity: opacity,
              borderRadius: borderRadius,
              scrollController: scrollController,
              child: child,
            );
          },
        );
      },
    );
  }
}

class _ScrollableGlassBottomSheetContent extends StatelessWidget {
  final String? title;
  final double blur;
  final double opacity;
  final double borderRadius;
  final ScrollController scrollController;
  final Widget child;

  const _ScrollableGlassBottomSheetContent({
    required this.title,
    required this.blur,
    required this.opacity,
    required this.borderRadius,
    required this.scrollController,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppGlassColors.scrim,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(borderRadius),
          topRight: Radius.circular(borderRadius),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            decoration: BoxDecoration(
              color: AppGlassColors.glassSurfaceDark(opacity).withValues(alpha: 0.95),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(borderRadius),
                topRight: Radius.circular(borderRadius),
              ),
              border: Border(
                top: BorderSide(
                  color: AppGlassColors.borderDark,
                ),
              ),
            ),
            child: CustomScrollView(
              controller: scrollController,
              slivers: [
                // Drag handle
                SliverToBoxAdapter(
                  child: Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(top: 12, bottom: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
                // Title
                if (title != null)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                        20,
                        8,
                        20,
                        16,
                      ),
                      child: Text(
                        title!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                // Content
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  sliver: child,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
