import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:flutter/material.dart';

/// A shared search bar with optional filter chips and filter button.
///
/// Extracts the repeated search + filter pattern used across list pages.
///
/// Example:
/// ```dart
/// AppSearchBar(
///   hintText: 'Search properties...',
///   onChanged: (value) => setState(() => _query = value),
///   filterChips: [
///     FilterChip(label: Text('All'), onSelected: (_) {}),
///     FilterChip(label: Text('Active'), onSelected: (_) {}),
///   ],
/// )
/// ```
class AppSearchBar extends StatelessWidget {
  const AppSearchBar({
    super.key,
    this.hintText = 'Search...',
    this.controller,
    this.onChanged,
    this.onFilterTap,
    this.filterChips,
    this.padding = const EdgeInsets.symmetric(
      horizontal: AppSpacing.lg,
      vertical: AppSpacing.sm,
    ),
  });

  /// Placeholder text for the search field
  final String hintText;

  /// Text controller for the search field
  final TextEditingController? controller;

  /// Called when search text changes
  final ValueChanged<String>? onChanged;

  /// Called when filter button is tapped (shown only if non-null)
  final VoidCallback? onFilterTap;

  /// Optional filter chips displayed below the search field
  final List<Widget>? filterChips;

  /// Outer padding
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: padding,
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  onChanged: onChanged,
                  decoration: InputDecoration(
                    hintText: hintText,
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: scheme.onSurfaceVariant,
                      size: 20,
                    ),
                    suffixIcon: controller != null &&
                            controller!.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear_rounded, size: 18),
                            onPressed: () {
                              controller!.clear();
                              onChanged?.call('');
                            },
                          )
                        : null,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                  ),
                ),
              ),
              if (onFilterTap != null) ...[
                const SizedBox(width: AppSpacing.sm),
                IconButton.outlined(
                  onPressed: onFilterTap,
                  icon: const Icon(Icons.tune_rounded, size: 20),
                  style: IconButton.styleFrom(
                    side: BorderSide(color: scheme.outline),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        if (filterChips != null && filterChips!.isNotEmpty)
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.xs,
              ),
              itemCount: filterChips!.length,
              separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
              itemBuilder: (_, index) => filterChips![index],
            ),
          ),
      ],
    );
  }
}
