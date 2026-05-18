import 'package:flutter/material.dart';

abstract final class AppBreakpoints {
  static const double compact = 360;
  static const double medium = 600;
  static const double expanded = 840;
  static const double large = 1024;
  static const double extraLarge = 1440;

  static bool isCompact(double width) => width < medium;
  static bool isMedium(double width) => width >= medium && width < expanded;
  static bool isExpanded(double width) => width >= expanded && width < large;
  static bool isLarge(double width) => width >= large;
  static bool isExtraLarge(double width) => width >= extraLarge;
}

enum ScreenSize { compact, medium, expanded, large, extraLarge }

extension ScreenSizeX on ScreenSize {
  bool get isCompact => this == ScreenSize.compact;
  bool get isMedium => this == ScreenSize.medium;
  bool get isExpandedOrLarger =>
      this == ScreenSize.expanded ||
      this == ScreenSize.large ||
      this == ScreenSize.extraLarge;
  bool get isLargeOrLarger =>
      this == ScreenSize.large || this == ScreenSize.extraLarge;

  int get gridColumns => switch (this) {
    ScreenSize.compact => 2,
    ScreenSize.medium => 3,
    ScreenSize.expanded => 3,
    ScreenSize.large => 4,
    ScreenSize.extraLarge => 5,
  };

  double get maxContentWidth => switch (this) {
    ScreenSize.compact => double.infinity,
    ScreenSize.medium => double.infinity,
    ScreenSize.expanded => 840,
    ScreenSize.large => 1024,
    ScreenSize.extraLarge => 1200,
  };

  EdgeInsets get screenPadding => switch (this) {
    ScreenSize.compact => const EdgeInsets.all(12),
    ScreenSize.medium => const EdgeInsets.all(16),
    ScreenSize.expanded => const EdgeInsets.symmetric(
      horizontal: 24,
      vertical: 16,
    ),
    ScreenSize.large => const EdgeInsets.symmetric(
      horizontal: 32,
      vertical: 20,
    ),
    ScreenSize.extraLarge => const EdgeInsets.symmetric(
      horizontal: 40,
      vertical: 24,
    ),
  };
}

ScreenSize getScreenSize(double width) {
  if (width >= AppBreakpoints.extraLarge) return ScreenSize.extraLarge;
  if (width >= AppBreakpoints.large) return ScreenSize.large;
  if (width >= AppBreakpoints.expanded) return ScreenSize.expanded;
  if (width >= AppBreakpoints.medium) return ScreenSize.medium;
  return ScreenSize.compact;
}

class ResponsiveBuilder extends StatelessWidget {
  const ResponsiveBuilder({super.key, required this.builder});

  final Widget Function(BuildContext context, ScreenSize screenSize) builder;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenSize = getScreenSize(constraints.maxWidth);
        return builder(context, screenSize);
      },
    );
  }
}

class ResponsivePadding extends StatelessWidget {
  const ResponsivePadding({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, screenSize) {
        return Padding(padding: screenSize.screenPadding, child: child);
      },
    );
  }
}

class ResponsiveCenter extends StatelessWidget {
  const ResponsiveCenter({super.key, required this.child, this.maxWidth = 840});

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}

class ResponsiveGrid extends StatelessWidget {
  const ResponsiveGrid({
    super.key,
    required this.children,
    this.crossAxisCount,
    this.mainAxisSpacing = 8,
    this.crossAxisSpacing = 8,
    this.childAspectRatio = 1.0,
  });

  final List<Widget> children;
  final int? crossAxisCount;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final double childAspectRatio;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenSize = getScreenSize(constraints.maxWidth);
        final columns = crossAxisCount ?? screenSize.gridColumns;
        return GridView.count(
          crossAxisCount: columns,
          mainAxisSpacing: mainAxisSpacing,
          crossAxisSpacing: crossAxisSpacing,
          childAspectRatio: childAspectRatio,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: children,
        );
      },
    );
  }
}
