import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/features/properties/presentation/property_wizard_data.dart';
import 'package:estate_app/features/properties/presentation/widgets/wizard_step_details.dart';
import 'package:estate_app/features/properties/properties_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A blank or invalid number clears the field (the wizard data holds the
/// cleared value).
double? _double(String text) => double.tryParse(text.trim());
int? _int(String text) => int.tryParse(text.trim());

String _show(num? value) {
  if (value == null) return '';
  return value == value.roundToDouble() ? '${value.round()}' : '$value';
}

/// Two fields side by side, or stacked when the screen or the text is large.
class _Pair extends StatelessWidget {
  const _Pair(this.first, this.second);

  final Widget first;
  final Widget second;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final roomy =
          constraints.maxWidth / MediaQuery.textScalerOf(context).scale(1) >=
          320;
      if (!roomy) {
        return Column(
          children: [
            first,
            const SizedBox(height: AppSpacing.lg),
            second,
          ],
        );
      }
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: first),
          const SizedBox(width: AppSpacing.md),
          Expanded(child: second),
        ],
      );
    },
  );
}

/// Step 3: size, rooms and amenities. Nothing here is required.
class WizardSpecsStep extends ConsumerStatefulWidget {
  const WizardSpecsStep({
    super.key,
    required this.data,
    required this.onChanged,
  });

  final PropertyWizardData data;
  final VoidCallback onChanged;

  @override
  ConsumerState<WizardSpecsStep> createState() => _WizardSpecsStepState();
}

class _WizardSpecsStepState extends ConsumerState<WizardSpecsStep> {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final data = widget.data;
    final catalog = ref.watch(amenityCatalogProvider);

    Widget count(String label, int? value, ValueChanged<int?> set) =>
        WizardTextField(
          initial: _show(value),
          label: label,
          digitsOnly: true,
          onChanged: (v) {
            set(_int(v));
            widget.onChanged();
          },
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Pair(
          WizardTextField(
            initial: _show(data.areaSqft),
            label: l10n.propertyAreaLabel,
            decimal: true,
            onChanged: (v) {
              data.areaSqft = _double(v);
              widget.onChanged();
            },
          ),
          count(l10n.propertyAgeLabel, data.ageOfProperty, (v) {
            data.ageOfProperty = v;
          }),
        ),
        const SizedBox(height: AppSpacing.lg),
        _Pair(
          count(l10n.propertyBedrooms, data.bedrooms, (v) => data.bedrooms = v),
          count(
            l10n.propertyBathrooms,
            data.bathrooms,
            (v) => data.bathrooms = v,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        count(
          l10n.propertyBalconies,
          data.balconies,
          (v) => data.balconies = v,
        ),
        const SizedBox(height: AppSpacing.xl),
        // The backend catalogue, sent as `amenity_ids`.
        Text(l10n.propertyAmenities, style: context.text.labelLarge),
        const SizedBox(height: AppSpacing.sm),
        catalog.when(
          loading: () => const LinearProgressIndicator(),
          error: (_, _) => Row(
            children: [
              Expanded(
                child: Text(
                  l10n.propertyAmenitiesFailed,
                  style: context.text.bodyMedium?.copyWith(
                    color: context.colors.error,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => ref.invalidate(amenityCatalogProvider),
                child: Text(l10n.commonRetry),
              ),
            ],
          ),
          data: (items) => Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              for (final amenity in items)
                if (amenity.id != null)
                  FilterChip(
                    label: Text(amenity.title ?? l10n.propertyAmenities),
                    selected: data.amenityIds.contains(amenity.id),
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          data.amenityIds.add(amenity.id!);
                        } else {
                          data.amenityIds.remove(amenity.id);
                        }
                      });
                      widget.onChanged();
                    },
                  ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Step 4: rent, deposit and the collection terms new leases start with.
class WizardRentStep extends StatelessWidget {
  const WizardRentStep({
    super.key,
    required this.data,
    required this.onChanged,
    required this.issues,
  });

  final PropertyWizardData data;
  final VoidCallback onChanged;
  final Set<WizardIssue> issues;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    String? error(WizardIssue i) =>
        issues.contains(i) ? issueText(l10n, i) : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        WizardTextField(
          initial: _show(data.monthlyRent),
          label: l10n.propertyRentLabel,
          prefix: '₹ ',
          decimal: true,
          error: error(WizardIssue.rent),
          onChanged: (v) {
            data.monthlyRent = _double(v);
            onChanged();
          },
        ),
        const SizedBox(height: AppSpacing.lg),
        WizardTextField(
          initial: _show(data.securityDeposit),
          label: l10n.propertyDepositLabel,
          prefix: '₹ ',
          decimal: true,
          onChanged: (v) {
            data.securityDeposit = _double(v);
            onChanged();
          },
        ),
        const SizedBox(height: AppSpacing.lg),
        _Pair(
          WizardTextField(
            initial: '${data.paymentDueDay}',
            label: l10n.propertyDueDayLabel,
            helper: l10n.propertyDueDayHelper,
            digitsOnly: true,
            error: error(WizardIssue.dueDay),
            onChanged: (v) {
              // An empty text keeps an out-of-range value that validation
              // rejects, instead of silently becoming day 1.
              data.paymentDueDay = _int(v) ?? 0;
              onChanged();
            },
          ),
          WizardTextField(
            initial: '${data.gracePeriodDays}',
            label: l10n.propertyGraceLabel,
            helper: l10n.propertyGraceHelper,
            digitsOnly: true,
            action: TextInputAction.done,
            error: error(WizardIssue.grace),
            onChanged: (v) {
              data.gracePeriodDays = _int(v) ?? -1;
              onChanged();
            },
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          l10n.propertyRentTermsNote,
          style: context.text.bodySmall?.copyWith(
            color: context.colors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
