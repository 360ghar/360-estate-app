import 'package:estate_app/core/api/wire_enums.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/errors/user_facing_message.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/core/presentation/widgets/app_section_card.dart';
import 'package:estate_app/core/presentation/widgets/feedback.dart';
import 'package:estate_app/core/presentation/widgets/submit_bar.dart';
import 'package:estate_app/core/utils/dates.dart';
import 'package:estate_app/features/leases/leases_providers.dart';
import 'package:estate_app/features/leases/presentation/lease_text.dart';
import 'package:estate_app/features/maintenance/domain/entities/maintenance_request.dart';
import 'package:estate_app/features/properties/models/property.dart';
import 'package:estate_app/features/properties/properties_providers.dart';
import 'package:estate_app/features/tasks/presentation/task_text.dart';
import 'package:estate_app/features/tasks/tasks_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Sends a maintenance request (`MaintenanceRequestCreate`): property,
/// category, urgency and title are required. The lease, the estimated cost,
/// the visit day and the assigned agent are optional.
class TaskCreatePage extends ConsumerStatefulWidget {
  const TaskCreatePage({super.key});

  @override
  ConsumerState<TaskCreatePage> createState() => _TaskCreatePageState();
}

class _TaskCreatePageState extends ConsumerState<TaskCreatePage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _costController = TextEditingController();
  final _visitController = TextEditingController();

  int? _propertyId;
  int? _leaseId;
  MaintenanceCategory _category = MaintenanceCategory.other;
  MaintenanceUrgency _urgency = MaintenanceUrgency.medium;
  DateTime? _visit;
  bool _assignToAgent = false;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _costController.dispose();
    _visitController.dispose();
    super.dispose();
  }

  Future<void> _pickVisit() async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDate: _visit ?? DateTime.now(),
    );
    if (picked == null || !mounted) return;
    setState(() {
      _visit = picked;
      _visitController.text = shortDate(context, picked);
    });
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final propertyId = _propertyId;
    if (propertyId == null) return;
    setState(() => _isSubmitting = true);
    try {
      final agent = _assignToAgent
          ? ref.read(assignedAgentProvider).valueOrNull
          : null;
      await ref
          .read(maintenanceRepositoryProvider)
          .createRequest(
            propertyId: propertyId,
            category: _category,
            urgency: _urgency,
            title: _titleController.text,
            description: _descriptionController.text,
            leaseId: _leaseId,
            estimatedCost: double.tryParse(_costController.text.trim()),
            scheduledFor: _visit,
            assignedAgentId: agent?.id,
          );
      // The status-filtered family is cached per status: invalidate it too.
      ref
        ..invalidate(maintenancePagedByStatusProvider)
        ..invalidate(maintenanceListProvider)
        ..invalidate(maintenanceListForPropertyProvider);
      if (!mounted) return;
      context.showSnack(context.l10n.taskCreated);
      context.go('/tasks');
    } catch (error) {
      if (mounted) context.showSnack(userFacingMessage(error));
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final properties = ref.watch(propertiesListProvider);
    final propertyId = _propertyId;
    final leases = propertyId == null
        ? null
        : ref.watch(
            leasesListProvider(LeaseListFilter(propertyId: propertyId)),
          );
    final agent = ref.watch(assignedAgentProvider).valueOrNull;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.taskCreateTitle)),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              // Every field stays built, so the form validates all of them.
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppSectionCard(
                      title: l10n.taskSectionDetails,
                      children: [
                        TextFormField(
                          controller: _titleController,
                          textCapitalization: TextCapitalization.sentences,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            labelText: l10n.taskTitleLabel,
                            hintText: l10n.taskTitleHint,
                          ),
                          validator: (value) {
                            final text = value?.trim() ?? '';
                            if (text.isEmpty) return l10n.taskTitleRequired;
                            if (text.length < 3) return l10n.taskTitleTooShort;
                            return null;
                          },
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        TextFormField(
                          controller: _descriptionController,
                          minLines: 3,
                          maxLines: 6,
                          textCapitalization: TextCapitalization.sentences,
                          decoration: InputDecoration(
                            labelText: l10n.taskDescriptionLabel,
                            hintText: l10n.taskDescriptionHint,
                            alignLabelWithHint: true,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    AppSectionCard(
                      title: l10n.taskSectionCategory,
                      child: Wrap(
                        spacing: AppSpacing.sm,
                        runSpacing: AppSpacing.sm,
                        children: [
                          for (final category in MaintenanceCategory.values)
                            ChoiceChip(
                              avatar: Icon(category.icon, size: 18),
                              showCheckmark: false,
                              label: Text(category.text(l10n)),
                              selected: _category == category,
                              onSelected: (_) =>
                                  setState(() => _category = category),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    AppSectionCard(
                      title: l10n.taskSectionWhere,
                      children: [
                        properties.when(
                          loading: () => const LinearProgressIndicator(),
                          error: (error, _) => Row(
                            children: [
                              Expanded(child: Text(userFacingMessage(error))),
                              TextButton(
                                onPressed: () =>
                                    ref.invalidate(propertiesListProvider),
                                child: Text(l10n.commonRetry),
                              ),
                            ],
                          ),
                          data: (list) => list.isEmpty
                              ? Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        l10n.taskNoProperties,
                                        style: context.text.bodyMedium
                                            ?.copyWith(
                                              color: context
                                                  .colors
                                                  .onSurfaceVariant,
                                            ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          context.go('/properties/create'),
                                      child: Text(l10n.taskAddProperty),
                                    ),
                                  ],
                                )
                              : DropdownButtonFormField<int>(
                                  initialValue:
                                      list.any((p) => p.id == _propertyId)
                                      ? _propertyId
                                      : null,
                                  isExpanded: true,
                                  decoration: InputDecoration(
                                    labelText: l10n.taskPropertyLabel,
                                  ),
                                  items: [
                                    for (final property in list)
                                      if (property.id != null)
                                        DropdownMenuItem<int>(
                                          value: property.id,
                                          child: Text(
                                            property.displayName,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                  ],
                                  onChanged: (value) => setState(() {
                                    _propertyId = value;
                                    _leaseId = null;
                                  }),
                                  validator: (value) => value == null
                                      ? l10n.taskPropertyRequired
                                      : null,
                                ),
                        ),
                        if (leases != null)
                          leases.when(
                            loading: () => const Padding(
                              padding: EdgeInsets.only(top: AppSpacing.lg),
                              child: LinearProgressIndicator(),
                            ),
                            error: (error, _) => Padding(
                              padding: const EdgeInsets.only(
                                top: AppSpacing.lg,
                              ),
                              child: Text(userFacingMessage(error)),
                            ),
                            data: (list) => list.isEmpty
                                ? const SizedBox.shrink()
                                : Padding(
                                    padding: const EdgeInsets.only(
                                      top: AppSpacing.lg,
                                    ),
                                    child: DropdownButtonFormField<int?>(
                                      key: ValueKey('lease-$_propertyId'),
                                      initialValue:
                                          list.any((l) => l.id == _leaseId)
                                          ? _leaseId
                                          : null,
                                      isExpanded: true,
                                      decoration: InputDecoration(
                                        labelText: l10n.taskLeaseLabel,
                                      ),
                                      items: [
                                        DropdownMenuItem<int?>(
                                          child: Text(l10n.taskNoLease),
                                        ),
                                        for (final lease in list)
                                          if (lease.id != null)
                                            DropdownMenuItem<int?>(
                                              value: lease.id,
                                              child: Text(
                                                [
                                                  lease.title(l10n),
                                                  ?lease.status?.text(l10n),
                                                ].join('  ·  '),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                      ],
                                      onChanged: (value) =>
                                          setState(() => _leaseId = value),
                                    ),
                                  ),
                          ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    AppSectionCard(
                      title: l10n.taskSectionUrgency,
                      child: Wrap(
                        spacing: AppSpacing.sm,
                        runSpacing: AppSpacing.sm,
                        children: [
                          for (final urgency
                              in MaintenanceUrgency.values.reversed)
                            ChoiceChip(
                              avatar: Icon(urgency.glyph, size: 18),
                              showCheckmark: false,
                              label: Text(urgency.text(l10n)),
                              selected: _urgency == urgency,
                              onSelected: (_) =>
                                  setState(() => _urgency = urgency),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    AppSectionCard(
                      title: l10n.taskSectionCost,
                      children: [
                        TextFormField(
                          controller: _costController,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'[0-9.]'),
                            ),
                          ],
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                            labelText: l10n.taskCostLabel,
                            prefixText: '₹ ',
                          ),
                          validator: (value) {
                            final text = value?.trim() ?? '';
                            if (text.isEmpty) return null;
                            final parsed = double.tryParse(text);
                            return parsed == null || parsed < 0
                                ? l10n.taskCostInvalid
                                : null;
                          },
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        TextFormField(
                          controller: _visitController,
                          readOnly: true,
                          onTap: _pickVisit,
                          decoration: InputDecoration(
                            labelText: l10n.taskVisitLabel,
                            suffixIcon: _visit == null
                                ? const Icon(Icons.event_outlined)
                                : IconButton(
                                    tooltip: l10n.commonClearDate,
                                    icon: const Icon(Icons.close_rounded),
                                    onPressed: () => setState(() {
                                      _visit = null;
                                      _visitController.clear();
                                    }),
                                  ),
                          ),
                        ),
                        if (agent != null) ...[
                          const SizedBox(height: AppSpacing.sm),
                          SwitchListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(l10n.taskAssignTo(agent.name)),
                            subtitle: Text(l10n.taskAssignHelp),
                            value: _assignToAgent,
                            onChanged: (value) =>
                                setState(() => _assignToAgent = value),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SubmitBar(
              label: l10n.taskCreate,
              busy: _isSubmitting,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}
