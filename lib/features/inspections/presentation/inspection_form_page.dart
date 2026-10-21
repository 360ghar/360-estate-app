import 'package:estate_app/app/router/routes.dart';
import 'package:estate_app/core/api/wire_enums.dart';
import 'package:estate_app/core/presentation/design_system/app_radii.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/errors/user_facing_message.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/core/presentation/widgets/app_section_card.dart';
import 'package:estate_app/core/presentation/widgets/feedback.dart';
import 'package:estate_app/core/utils/dates.dart';
import 'package:estate_app/features/inspections/data/inspections_repository.dart';
import 'package:estate_app/features/inspections/inspections_providers.dart';
import 'package:estate_app/features/inspections/presentation/inspection_text.dart';
import 'package:estate_app/features/inspections/presentation/widgets/checklist_editor.dart';
import 'package:estate_app/features/leases/leases_providers.dart';
import 'package:estate_app/features/leases/models/lease.dart';
import 'package:estate_app/features/leases/presentation/lease_text.dart';
import 'package:estate_app/features/properties/models/property.dart';
import 'package:estate_app/features/properties/properties_providers.dart';
import 'package:estate_app/l10n/gen/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// A new inspection: which lease, what kind and when, and its checklist.
class InspectionFormPage extends ConsumerStatefulWidget {
  const InspectionFormPage({super.key});

  @override
  ConsumerState<InspectionFormPage> createState() => _InspectionFormPageState();
}

class _InspectionFormPageState extends ConsumerState<InspectionFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _notes = TextEditingController();

  int? _propertyId;
  int? _leaseId;
  InspectionType _type = InspectionType.routine;
  DateTime? _conductedOn;
  List<String> _items = const [];
  bool _saving = false;

  @override
  void dispose() {
    _notes.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _conductedOn ?? now,
      firstDate: DateTime(now.year - 2),
      lastDate: DateTime(now.year + 1, 12, 31),
    );
    if (picked != null) setState(() => _conductedOn = picked);
  }

  Future<void> _submit() async {
    final l10n = context.l10n;
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final leaseId = _leaseId;
    if (leaseId == null) {
      // A property with no lease shows no lease field to validate.
      context.showSnack(l10n.inspectionFormChooseLease);
      return;
    }
    setState(() => _saving = true);
    try {
      await ref
          .read(inspectionsRepositoryProvider)
          .create(
            InspectionCreateRequest(
              leaseId: leaseId,
              inspectionType: _type,
              conductedAt: _conductedOn,
              overallNotes: _notes.text,
              items: List<String>.from(_items),
            ),
          );
      ref.invalidate(inspectionsListProvider);
      if (!mounted) return;
      context.showSnack(l10n.inspectionFormCreated);
      context.go(Routes.inspections);
    } catch (error) {
      if (mounted) context.showSnack(userFacingMessage(error));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.inspectionFormTitle)),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            _LeasePicker(
              propertyId: _propertyId,
              leaseId: _leaseId,
              onProperty: (id) => setState(() {
                _propertyId = id;
                _leaseId = null;
              }),
              onLease: (id) => setState(() => _leaseId = id),
            ),
            const SizedBox(height: AppSpacing.md),
            AppSectionCard(
              title: l10n.inspectionFormDetailsSection,
              children: [
                Text(
                  l10n.inspectionFormType,
                  style: context.text.labelLarge?.copyWith(
                    color: context.colors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: [
                    for (final type in InspectionType.values)
                      ChoiceChip(
                        label: Text(type.text(l10n)),
                        selected: _type == type,
                        onSelected: (_) => setState(() => _type = type),
                      ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                InkWell(
                  borderRadius: AppRadii.md,
                  onTap: _pickDate,
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: l10n.inspectionFormDate,
                      suffixIcon: const Icon(Icons.calendar_today_outlined),
                    ),
                    child: Text(
                      _conductedOn == null
                          ? l10n.inspectionFormToday
                          : shortDate(context, _conductedOn!),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                TextFormField(
                  controller: _notes,
                  minLines: 3,
                  maxLines: 6,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    labelText: l10n.inspectionFormNotes,
                    helperText: l10n.inspectionFormNotesHelp,
                    alignLabelWithHint: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            ChecklistEditor(
              items: _items,
              onChanged: (items) => setState(() => _items = items),
            ),
            const SizedBox(height: AppSpacing.xl),
            FilledButton.icon(
              onPressed: _saving ? null : _submit,
              icon: _saving
                  ? const SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : null,
              label: Text(l10n.inspectionFormCreate),
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }
}

/// The inspection belongs to a lease: pick the property, then one of its
/// leases.
class _LeasePicker extends ConsumerWidget {
  const _LeasePicker({
    required this.propertyId,
    required this.leaseId,
    required this.onProperty,
    required this.onLease,
  });

  final int? propertyId;
  final int? leaseId;
  final ValueChanged<int?> onProperty;
  final ValueChanged<int?> onLease;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final muted = context.text.bodyMedium?.copyWith(
      color: context.colors.onSurfaceVariant,
    );
    final properties = ref.watch(propertiesListProvider);
    final property = propertyId;
    final leases = property == null
        ? null
        : ref.watch(leasesListProvider(LeaseListFilter(propertyId: property)));

    return AppSectionCard(
      title: l10n.inspectionFormLeaseSection,
      children: [
        properties.when(
          loading: () => const LinearProgressIndicator(),
          error: (error, _) => _LoadError(
            message: userFacingMessage(error),
            style: muted,
            onRetry: () => ref.invalidate(propertiesListProvider),
          ),
          data: (list) => DropdownButtonFormField<int>(
            initialValue: list.any((p) => p.id == propertyId)
                ? propertyId
                : null,
            isExpanded: true,
            decoration: InputDecoration(labelText: l10n.inspectionFormProperty),
            items: [
              for (final p in list)
                if (p.id != null)
                  DropdownMenuItem<int>(
                    value: p.id,
                    child: Text(p.displayName, overflow: TextOverflow.ellipsis),
                  ),
            ],
            onChanged: onProperty,
            validator: (v) =>
                v == null ? l10n.inspectionFormChooseProperty : null,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        if (leases == null)
          Text(l10n.inspectionFormPickPropertyFirst, style: muted)
        else
          leases.when(
            loading: () => const LinearProgressIndicator(),
            error: (error, _) => _LoadError(
              message: userFacingMessage(error),
              style: muted,
              onRetry: () => ref.invalidate(
                leasesListProvider(LeaseListFilter(propertyId: property)),
              ),
            ),
            data: (list) => list.isEmpty
                ? Row(
                    children: [
                      Expanded(
                        child: Text(l10n.inspectionFormNoLease, style: muted),
                      ),
                      TextButton(
                        onPressed: () => context.go(Routes.leasesNew),
                        child: Text(l10n.inspectionFormAddLease),
                      ),
                    ],
                  )
                : DropdownButtonFormField<int>(
                    key: ValueKey('lease-$propertyId'),
                    initialValue: list.any((l) => l.id == leaseId)
                        ? leaseId
                        : null,
                    isExpanded: true,
                    decoration: InputDecoration(
                      labelText: l10n.inspectionFormLease,
                    ),
                    items: [
                      for (final lease in list)
                        if (lease.id != null)
                          DropdownMenuItem<int>(
                            value: lease.id,
                            child: Text(
                              _leaseLabel(l10n, lease),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                    ],
                    onChanged: onLease,
                    validator: (v) =>
                        v == null ? l10n.inspectionFormChooseLease : null,
                  ),
          ),
      ],
    );
  }

  static String _leaseLabel(AppLocalizations l10n, Lease lease) {
    final status = lease.status?.text(l10n) ?? '';
    return status.isEmpty
        ? lease.displayName
        : '${lease.displayName} · $status';
  }
}

/// A failed load with a retry, so the form is not left unusable.
class _LoadError extends StatelessWidget {
  const _LoadError({
    required this.message,
    required this.style,
    required this.onRetry,
  });

  final String message;
  final TextStyle? style;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(child: Text(message, style: style)),
      TextButton(onPressed: onRetry, child: Text(context.l10n.commonRetry)),
    ],
  );
}
