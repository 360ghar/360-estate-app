import 'package:estate_app/core/api/wire_enums.dart';
import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/core/presentation/widgets/app_segmented_button.dart';
import 'package:estate_app/features/properties/data/models/location_result.dart';
import 'package:estate_app/features/properties/presentation/property_wizard_data.dart';
import 'package:estate_app/features/properties/presentation/widgets/property_text.dart';
import 'package:estate_app/l10n/gen/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

/// The message under a field the wizard cannot move past.
String issueText(AppLocalizations l10n, WizardIssue issue) => switch (issue) {
  WizardIssue.name => l10n.propertyErrorName,
  WizardIssue.type => l10n.propertyErrorType,
  WizardIssue.city => l10n.propertyErrorCity,
  WizardIssue.rent => l10n.propertyErrorRent,
  WizardIssue.dueDay => l10n.propertyErrorDueDay,
  WizardIssue.grace => l10n.propertyErrorGrace,
};

/// A text field bound to one value of the wizard data. The controller lives
/// as long as the step, so typing keeps the cursor where it is.
class WizardTextField extends StatefulWidget {
  const WizardTextField({
    super.key,
    required this.initial,
    required this.onChanged,
    required this.label,
    this.hint,
    this.helper,
    this.error,
    this.prefix,
    this.keyboardType,
    this.digitsOnly = false,
    this.decimal = false,
    this.maxLines = 1,
    this.capitalization = TextCapitalization.none,
    this.autofillHints,
    this.action = TextInputAction.next,
  });

  final String initial;
  final ValueChanged<String> onChanged;
  final String label;
  final String? hint;
  final String? helper;
  final String? error;
  final String? prefix;
  final TextInputType? keyboardType;
  final bool digitsOnly;
  final bool decimal;
  final int maxLines;
  final TextCapitalization capitalization;
  final Iterable<String>? autofillHints;
  final TextInputAction action;

  @override
  State<WizardTextField> createState() => _WizardTextFieldState();
}

class _WizardTextFieldState extends State<WizardTextField> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.initial,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => TextFormField(
    controller: _controller,
    onChanged: widget.onChanged,
    keyboardType: widget.digitsOnly || widget.decimal
        ? TextInputType.numberWithOptions(decimal: widget.decimal)
        : widget.keyboardType,
    inputFormatters: [
      if (widget.digitsOnly) FilteringTextInputFormatter.digitsOnly,
      if (widget.decimal)
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
    ],
    textInputAction: widget.maxLines > 1
        ? TextInputAction.newline
        : widget.action,
    textCapitalization: widget.capitalization,
    autofillHints: widget.autofillHints,
    minLines: 1,
    maxLines: widget.maxLines,
    decoration: InputDecoration(
      labelText: widget.label,
      hintText: widget.hint,
      helperText: widget.helper,
      errorText: widget.error,
      prefixText: widget.prefix,
    ),
  );
}

/// Step 1: name, type, management status and description.
class WizardBasicsStep extends StatefulWidget {
  const WizardBasicsStep({
    super.key,
    required this.data,
    required this.onChanged,
    required this.issues,
  });

  final PropertyWizardData data;
  final VoidCallback onChanged;
  final Set<WizardIssue> issues;

  @override
  State<WizardBasicsStep> createState() => _WizardBasicsStepState();
}

class _WizardBasicsStepState extends State<WizardBasicsStep> {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final data = widget.data;
    String? error(WizardIssue i) =>
        widget.issues.contains(i) ? issueText(l10n, i) : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        WizardTextField(
          initial: data.name,
          label: l10n.propertyNameLabel,
          hint: l10n.propertyNameHint,
          error: error(WizardIssue.name),
          capitalization: TextCapitalization.words,
          onChanged: (v) {
            data.name = v;
            widget.onChanged();
          },
        ),
        const SizedBox(height: AppSpacing.lg),
        // Only the types the backend accepts.
        DropdownButtonFormField<PropertyType>(
          initialValue: data.type,
          isExpanded: true,
          decoration: InputDecoration(
            labelText: l10n.propertyTypeLabel,
            errorText: error(WizardIssue.type),
          ),
          items: [
            for (final type in PropertyType.values)
              DropdownMenuItem(value: type, child: Text(type.text(l10n))),
          ],
          onChanged: (value) {
            setState(() => data.type = value);
            widget.onChanged();
          },
        ),
        const SizedBox(height: AppSpacing.xl),
        Text(l10n.propertyStatusLabel, style: context.text.labelLarge),
        const SizedBox(height: AppSpacing.sm),
        AppSegmentedButton<ManagedPropertyStatus>(
          fullWidth: true,
          segments: [
            for (final status in ManagedPropertyStatus.values)
              AppSegment(value: status, label: status.text(l10n)),
          ],
          selected: data.status,
          onSelected: (value) {
            if (value == null) return;
            setState(() => data.status = value);
            widget.onChanged();
          },
        ),
        const SizedBox(height: AppSpacing.xl),
        WizardTextField(
          initial: data.description,
          label: l10n.propertyDescription,
          hint: l10n.propertyDescriptionHint,
          maxLines: 4,
          capitalization: TextCapitalization.sentences,
          onChanged: (v) {
            data.description = v;
            widget.onChanged();
          },
        ),
      ],
    );
  }
}

/// Step 2: map point and address. The city is required.
class WizardLocationStep extends StatefulWidget {
  const WizardLocationStep({
    super.key,
    required this.data,
    required this.onChanged,
    required this.issues,
  });

  final PropertyWizardData data;
  final VoidCallback onChanged;
  final Set<WizardIssue> issues;

  @override
  State<WizardLocationStep> createState() => _WizardLocationStepState();
}

class _WizardLocationStepState extends State<WizardLocationStep> {
  /// Bumped when a picked place fills the address, so its field rebuilds
  /// with the new text.
  int _addressVersion = 0;

  /// The picked point gives the map position (`latitude` and `longitude`)
  /// and fills an empty address.
  Future<void> _pickLocation() async {
    final result = await context.push<LocationResult>('/location-search');
    if (result == null || !mounted) return;
    setState(() {
      widget.data
        ..latitude = result.lat
        ..longitude = result.lng
        ..locationName = result.name;
      if (widget.data.address.trim().isEmpty) {
        widget.data.address = result.name;
        _addressVersion++;
      }
    });
    widget.onChanged();
  }

  void _clearLocation() {
    setState(() {
      widget.data
        ..latitude = null
        ..longitude = null
        ..locationName = null;
    });
    widget.onChanged();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final data = widget.data;
    final hasPoint = data.latitude != null && data.longitude != null;

    return AutofillGroup(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          OutlinedButton.icon(
            onPressed: _pickLocation,
            icon: const Icon(Icons.my_location_rounded),
            label: Text(
              hasPoint
                  ? l10n.propertyChangeMapLocation
                  : l10n.propertySetMapLocation,
            ),
          ),
          if (hasPoint)
            Row(
              children: [
                ExcludeSemantics(
                  child: Icon(
                    Icons.place_outlined,
                    size: 18,
                    color: context.colors.primary,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    data.locationName ??
                        '${data.latitude!.toStringAsFixed(5)}, '
                            '${data.longitude!.toStringAsFixed(5)}',
                    style: context.text.bodyMedium,
                  ),
                ),
                TextButton(
                  onPressed: _clearLocation,
                  child: Text(l10n.propertyClearMapLocation),
                ),
              ],
            ),
          const SizedBox(height: AppSpacing.lg),
          WizardTextField(
            key: ValueKey(_addressVersion),
            initial: data.address,
            label: l10n.propertyAddressLabel,
            hint: l10n.propertyAddressHint,
            autofillHints: const [AutofillHints.streetAddressLine1],
            onChanged: (v) {
              data.address = v;
              widget.onChanged();
            },
          ),
          const SizedBox(height: AppSpacing.lg),
          WizardTextField(
            initial: data.city,
            label: l10n.propertyCityLabel,
            hint: l10n.propertyCityHint,
            error: widget.issues.contains(WizardIssue.city)
                ? issueText(l10n, WizardIssue.city)
                : null,
            capitalization: TextCapitalization.words,
            autofillHints: const [AutofillHints.addressCity],
            onChanged: (v) {
              data.city = v;
              widget.onChanged();
            },
          ),
          const SizedBox(height: AppSpacing.lg),
          WizardTextField(
            initial: data.state,
            label: l10n.propertyStateLabel,
            capitalization: TextCapitalization.words,
            autofillHints: const [AutofillHints.addressState],
            onChanged: (v) {
              data.state = v;
              widget.onChanged();
            },
          ),
          const SizedBox(height: AppSpacing.lg),
          WizardTextField(
            initial: data.pincode,
            label: l10n.propertyPincodeLabel,
            digitsOnly: true,
            action: TextInputAction.done,
            autofillHints: const [AutofillHints.postalCode],
            onChanged: (v) {
              data.pincode = v;
              widget.onChanged();
            },
          ),
        ],
      ),
    );
  }
}
