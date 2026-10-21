import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:flutter/material.dart';

/// A search field with an optional filter button and a row of filter chips
/// under it.
class AppSearchBar extends StatefulWidget {
  const AppSearchBar({
    super.key,
    required this.hintText,
    this.controller,
    this.onChanged,
    this.onFilterTap,
    this.filterChips,
    this.padding = const EdgeInsets.fromLTRB(
      AppSpacing.lg,
      AppSpacing.sm,
      AppSpacing.lg,
      AppSpacing.sm,
    ),
  });

  final String hintText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onFilterTap;
  final List<Widget>? filterChips;
  final EdgeInsetsGeometry padding;

  @override
  State<AppSearchBar> createState() => _AppSearchBarState();
}

class _AppSearchBarState extends State<AppSearchBar> {
  TextEditingController? _own;
  TextEditingController get _controller =>
      widget.controller ?? (_own ??= TextEditingController());

  @override
  void dispose() {
    _own?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chips = widget.filterChips ?? const <Widget>[];
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: widget.padding,
          child: Row(
            children: [
              Expanded(
                child: ValueListenableBuilder<TextEditingValue>(
                  valueListenable: _controller,
                  builder: (context, value, _) => TextField(
                    controller: _controller,
                    onChanged: widget.onChanged,
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      hintText: widget.hintText,
                      prefixIcon: const Icon(Icons.search_rounded),
                      suffixIcon: value.text.isEmpty
                          ? null
                          : IconButton(
                              tooltip: context.l10n.commonClearSearch,
                              icon: const Icon(Icons.close_rounded),
                              onPressed: () {
                                _controller.clear();
                                widget.onChanged?.call('');
                              },
                            ),
                    ),
                  ),
                ),
              ),
              if (widget.onFilterTap != null) ...[
                const SizedBox(width: AppSpacing.sm),
                IconButton.filledTonal(
                  tooltip: context.l10n.commonFilters,
                  onPressed: widget.onFilterTap,
                  icon: const Icon(Icons.tune_rounded),
                ),
              ],
            ],
          ),
        ),
        if (chips.isNotEmpty)
          SizedBox(
            height: 48,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              itemCount: chips.length,
              separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
              itemBuilder: (_, i) => Center(child: chips[i]),
            ),
          ),
      ],
    );
  }
}
