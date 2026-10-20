import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/core/presentation/widgets/app_card.dart';
import 'package:estate_app/core/presentation/widgets/app_empty_view.dart';
import 'package:estate_app/core/presentation/widgets/feedback.dart';
import 'package:estate_app/core/presentation/widgets/motion.dart';
import 'package:estate_app/features/inspections/inspections_providers.dart';
import 'package:estate_app/features/inspections/models/inspection_template.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Checklists kept on this device, to start an inspection from.
class InspectionTemplatesPage extends ConsumerStatefulWidget {
  const InspectionTemplatesPage({super.key});

  @override
  ConsumerState<InspectionTemplatesPage> createState() =>
      _InspectionTemplatesPageState();
}

class _InspectionTemplatesPageState
    extends ConsumerState<InspectionTemplatesPage> {
  @override
  void initState() {
    super.initState();
    // Seed the default templates on first use.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (ref.read(inspectionTemplatesProvider).isNotEmpty) return;
      final notifier = ref.read(inspectionTemplatesProvider.notifier);
      for (final template in defaultInspectionTemplates) {
        notifier.addTemplate(template);
      }
    });
  }

  Future<void> _create() async {
    final template = await showDialog<InspectionTemplate>(
      context: context,
      builder: (_) => const _TemplateDialog(),
    );
    if (template == null) return;
    await ref.read(inspectionTemplatesProvider.notifier).addTemplate(template);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final templates = ref.watch(inspectionTemplatesProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.inspectionTemplatesTitle)),
      floatingActionButton: templates.isEmpty
          ? null
          : FloatingActionButton.extended(
              onPressed: _create,
              icon: const Icon(Icons.add_rounded),
              label: Text(l10n.inspectionTemplatesNew),
            ),
      body: templates.isEmpty
          ? AppEmptyView(
              title: l10n.inspectionTemplatesEmptyTitle,
              message: l10n.inspectionTemplatesEmptyBody,
              icon: Icons.checklist_rounded,
              action: FilledButton.icon(
                onPressed: _create,
                icon: const Icon(Icons.add_rounded),
                label: Text(l10n.inspectionTemplatesNew),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.sm,
                AppSpacing.lg,
                96,
              ),
              itemCount: templates.length,
              separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
              itemBuilder: (context, index) => RiseIn(
                index: index,
                child: _TemplateCard(template: templates[index]),
              ),
            ),
    );
  }
}

class _TemplateCard extends ConsumerWidget {
  const _TemplateCard({required this.template});

  final InspectionTemplate template;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final muted = context.text.bodyMedium?.copyWith(
      color: context.colors.onSurfaceVariant,
    );
    final description = template.description?.trim() ?? '';

    Future<void> delete() async {
      final ok = await context.confirm(
        title: l10n.inspectionTemplatesDeleteTitle,
        message: l10n.inspectionTemplatesDeleteBody(template.name),
        confirmLabel: l10n.delete,
        destructive: true,
      );
      if (!ok) return;
      await ref
          .read(inspectionTemplatesProvider.notifier)
          .deleteTemplate(template.id);
    }

    return AppCard(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.sm,
        AppSpacing.xs,
        AppSpacing.lg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(template.name, style: context.text.titleLarge),
              ),
              IconButton(
                tooltip: l10n.inspectionTemplatesDelete,
                icon: const Icon(Icons.delete_outline_rounded),
                onPressed: delete,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (description.isNotEmpty) Text(description, style: muted),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  l10n.inspectionTemplatesItemCount(template.items.length),
                  style: context.text.labelMedium?.copyWith(
                    color: context.colors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                for (final (index, item) in template.items.indexed)
                  _NumberedLine(number: index + 1, text: item),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// "3  Kitchen appliances working", with the number in tabular figures.
class _NumberedLine extends StatelessWidget {
  const _NumberedLine({required this.number, required this.text});

  final int number;
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxs),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 28,
          child: Text(
            '$number',
            style: context.text.bodyMedium?.copyWith(
              color: context.colors.onSurfaceVariant,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ),
        Expanded(child: Text(text, style: context.text.bodyMedium)),
      ],
    ),
  );
}

/// Name, description and one item per line. Pops the new template, or null.
class _TemplateDialog extends StatefulWidget {
  const _TemplateDialog();

  @override
  State<_TemplateDialog> createState() => _TemplateDialogState();
}

class _TemplateDialogState extends State<_TemplateDialog> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _description = TextEditingController();
  final _items = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _description.dispose();
    _items.dispose();
    super.dispose();
  }

  List<String> get _lines => _items.text
      .split('\n')
      .map((s) => s.trim())
      .where((s) => s.isNotEmpty)
      .toList();

  void _save() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final description = _description.text.trim();
    Navigator.of(context).pop(
      InspectionTemplate.create(
        name: _name.text.trim(),
        description: description.isEmpty ? null : description,
        items: _lines,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AlertDialog(
      title: Text(l10n.inspectionTemplatesNew),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _name,
                autofocus: true,
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: l10n.inspectionTemplatesName,
                  hintText: l10n.inspectionTemplatesNameHint,
                ),
                validator: (v) => (v ?? '').trim().isEmpty
                    ? l10n.inspectionTemplatesNameRequired
                    : null,
              ),
              const SizedBox(height: AppSpacing.lg),
              TextFormField(
                controller: _description,
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: l10n.inspectionTemplatesDescription,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              TextFormField(
                controller: _items,
                minLines: 4,
                maxLines: 8,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  labelText: l10n.inspectionTemplatesItems,
                  helperText: l10n.inspectionTemplatesItemsHelp,
                  alignLabelWithHint: true,
                ),
                validator: (_) => _lines.isEmpty
                    ? l10n.inspectionTemplatesItemsRequired
                    : null,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.commonCancel),
        ),
        FilledButton(
          onPressed: _save,
          child: Text(l10n.inspectionTemplatesCreate),
        ),
      ],
    );
  }
}
