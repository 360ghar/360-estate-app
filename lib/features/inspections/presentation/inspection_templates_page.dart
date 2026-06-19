import 'package:estate_app/core/presentation/design_system/app_colors.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/widgets/app_scaffold.dart';
import 'package:estate_app/features/inspections/inspections_providers.dart';
import 'package:estate_app/features/inspections/models/inspection_template.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    // Seed default templates on first load if none exist.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final templates = ref.read(inspectionTemplatesProvider);
      if (templates.isEmpty) {
        for (final t in defaultInspectionTemplates) {
          ref.read(inspectionTemplatesProvider.notifier).addTemplate(t);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final templates = ref.watch(inspectionTemplatesProvider);

    return AppScaffold(
      appBar: AppBar(
        title: const Text('Inspection Templates'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showCreateDialog,
        icon: const Icon(Icons.add),
        label: const Text('New Template'),
      ),
      body: templates.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.fact_check_outlined,
                    size: 64,
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  const Text('No templates yet'),
                  const SizedBox(height: AppSpacing.sm),
                  const Text(
                    'Create reusable checklists for move-in, annual, '
                    'and move-out inspections.',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.lg),
              itemCount: templates.length,
              separatorBuilder: (_, _) =>
                  const SizedBox(height: AppSpacing.md),
              itemBuilder: (context, index) =>
                  _TemplateCard(template: templates[index]),
            ),
    );
  }

  Future<void> _showCreateDialog() async {
    final nameController = TextEditingController();
    final descController = TextEditingController();
    final itemsController = TextEditingController();
    try {
      await showDialog<void>(
        context: context,
        builder: (dialogContext) => AlertDialog(
        title: const Text('New Template'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Template name',
                  hintText: 'e.g. Move-in Checklist',
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              TextField(
                controller: descController,
                decoration: const InputDecoration(
                  labelText: 'Description (optional)',
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              TextField(
                controller: itemsController,
                maxLines: 6,
                decoration: const InputDecoration(
                  labelText: 'Checklist items',
                  hintText: 'One item per line',
                  alignLabelWithHint: true,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final name = nameController.text.trim();
              if (name.isEmpty) return;
              final items = itemsController.text
                  .split('\n')
                  .map((s) => s.trim())
                  .where((s) => s.isNotEmpty)
                  .toList();
              if (items.isEmpty) return;
              final template = InspectionTemplate.create(
                name: name,
                description: descController.text.trim().isEmpty
                    ? null
                    : descController.text.trim(),
                items: items,
              );
              ref
                  .read(inspectionTemplatesProvider.notifier)
                  .addTemplate(template);
              Navigator.pop(dialogContext);
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
    } finally {
      nameController.dispose();
      descController.dispose();
      itemsController.dispose();
    }
  }
}

class _TemplateCard extends ConsumerWidget {
  const _TemplateCard({required this.template});

  final InspectionTemplate template;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    template.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, size: 20),
                  onPressed: () {
                    ref
                        .read(inspectionTemplatesProvider.notifier)
                        .deleteTemplate(template.id);
                  },
                ),
              ],
            ),
            if (template.description != null) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(
                template.description!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
            ],
            const SizedBox(height: AppSpacing.sm),
            Text(
              '${template.items.length} items',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.textTertiary,
                  ),
            ),
            const SizedBox(height: AppSpacing.sm),
            ...template.items.map(
              (item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      size: 16,
                      color: AppColors.textTertiary,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        item,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
