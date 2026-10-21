import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/core/presentation/widgets/app_section_card.dart';
import 'package:estate_app/core/presentation/widgets/feedback.dart';
import 'package:estate_app/features/inspections/inspections_providers.dart';
import 'package:estate_app/features/inspections/models/inspection_template.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The checklist of a new inspection: type items one by one, or start from a
/// saved template. [items] is owned by the caller; [onChanged] reports edits.
class ChecklistEditor extends ConsumerStatefulWidget {
  const ChecklistEditor({
    super.key,
    required this.items,
    required this.onChanged,
  });

  final List<String> items;
  final ValueChanged<List<String>> onChanged;

  @override
  ConsumerState<ChecklistEditor> createState() => _ChecklistEditorState();
}

class _ChecklistEditorState extends ConsumerState<ChecklistEditor> {
  final _item = TextEditingController();

  @override
  void dispose() {
    _item.dispose();
    super.dispose();
  }

  void _add() {
    final text = _item.text.trim();
    if (text.isEmpty) return;
    widget.onChanged([...widget.items, text]);
    _item.clear();
  }

  Future<void> _useTemplate() async {
    final saved = ref.read(inspectionTemplatesProvider);
    final templates = saved.isEmpty ? defaultInspectionTemplates : saved;
    final picked = await showModalBottomSheet<InspectionTemplate>(
      context: context,
      isScrollControlled: true,
      builder: (context) => _TemplateSheet(templates: templates),
    );
    if (picked == null || !mounted) return;
    final added = [
      for (final item in picked.items)
        if (!widget.items.contains(item)) item,
    ];
    widget.onChanged([...widget.items, ...added]);
    context.showSnack(context.l10n.inspectionFormTemplateAdded(added.length));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final items = widget.items;
    return AppSectionCard(
      title: l10n.inspectionFormChecklistSection,
      trailing: TextButton(
        onPressed: _useTemplate,
        child: Text(l10n.inspectionFormUseTemplate),
      ),
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: TextField(
                controller: _item,
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _add(),
                decoration: InputDecoration(
                  labelText: l10n.inspectionFormAddItem,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: IconButton.filledTonal(
                tooltip: l10n.inspectionFormAddItemButton,
                onPressed: _add,
                icon: const Icon(Icons.add_rounded),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        if (items.isEmpty)
          Text(
            l10n.inspectionFormNoItems,
            style: context.text.bodyMedium?.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
          ),
        for (final (index, item) in items.indexed)
          Row(
            children: [
              SizedBox(
                width: 28,
                child: Text(
                  '${index + 1}',
                  style: context.text.bodyMedium?.copyWith(
                    color: context.colors.onSurfaceVariant,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              ),
              Expanded(child: Text(item, style: context.text.bodyMedium)),
              IconButton(
                tooltip: l10n.inspectionFormRemoveItem,
                icon: const Icon(Icons.close_rounded),
                color: context.colors.onSurfaceVariant,
                onPressed: () => widget.onChanged([...items]..removeAt(index)),
              ),
            ],
          ),
      ],
    );
  }
}

class _TemplateSheet extends StatelessWidget {
  const _TemplateSheet({required this.templates});

  final List<InspectionTemplate> templates;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.7,
        ),
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.only(bottom: AppSpacing.lg),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                0,
                AppSpacing.lg,
                AppSpacing.sm,
              ),
              child: Text(
                l10n.inspectionFormTemplateSheetTitle,
                style: context.text.titleLarge,
              ),
            ),
            for (final template in templates)
              ListTile(
                title: Text(template.name),
                subtitle: Text(
                  l10n.inspectionTemplatesItemCount(template.items.length),
                ),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => Navigator.of(context).pop(template),
              ),
          ],
        ),
      ),
    );
  }
}
