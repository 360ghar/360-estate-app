import 'package:flutter/material.dart';

class AppSegment<T> {
  const AppSegment({required this.value, required this.label, this.icon});

  final T value;
  final String label;
  final IconData? icon;
}

/// A single-choice switch between views (list / grid, list / board). It is
/// Material's [SegmentedButton], styled by the theme.
class AppSegmentedButton<T> extends StatelessWidget {
  const AppSegmentedButton({
    super.key,
    required this.segments,
    required this.selected,
    required this.onSelected,
    this.fullWidth = false,
    this.showLabels = true,
  });

  final List<AppSegment<T>> segments;
  final T? selected;
  final ValueChanged<T?> onSelected;
  final bool fullWidth;

  /// Icons only, with the label as tooltip, when space is tight.
  final bool showLabels;

  @override
  Widget build(BuildContext context) {
    if (segments.isEmpty) return const SizedBox.shrink();
    final button = SegmentedButton<T>(
      showSelectedIcon: false,
      emptySelectionAllowed: selected == null,
      selected: {?selected},
      onSelectionChanged: (values) =>
          onSelected(values.isEmpty ? null : values.first),
      segments: [
        for (final s in segments)
          ButtonSegment<T>(
            value: s.value,
            icon: s.icon == null ? null : Icon(s.icon, size: 18),
            label: showLabels || s.icon == null ? Text(s.label) : null,
            tooltip: showLabels ? null : s.label,
          ),
      ],
    );
    return fullWidth ? SizedBox(width: double.infinity, child: button) : button;
  }
}
