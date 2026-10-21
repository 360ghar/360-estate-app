import 'package:estate_app/core/presentation/design_system/app_spacing.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/core/presentation/widgets/with_text_controller.dart';
import 'package:estate_app/core/utils/dates.dart';
import 'package:estate_app/features/leases/domain/repositories/leases_repository.dart';
import 'package:estate_app/features/leases/models/lease.dart';
import 'package:flutter/material.dart';

Future<DateTime?> _pickDay(BuildContext context, DateTime initial) =>
    showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2020),
      lastDate: DateTime(2040),
    );

/// A date the user taps to change, inside a dialog.
class _DateField extends StatelessWidget {
  const _DateField({
    required this.label,
    required this.date,
    required this.onChanged,
  });

  final String label;
  final DateTime date;
  final ValueChanged<DateTime> onChanged;

  @override
  Widget build(BuildContext context) => InkWell(
    borderRadius: BorderRadius.circular(10),
    onTap: () async {
      final picked = await _pickDay(context, date);
      if (picked != null) onChanged(picked);
    },
    child: InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: const Icon(Icons.event_outlined),
      ),
      child: Text(shortDate(context, date)),
    ),
  );
}

/// Renew: the backend needs `start_date` and `end_date`. The rent falls back
/// to the old lease when left blank.
Future<LeaseRenewRequest?> showRenewDialog(BuildContext context, Lease lease) {
  final oldEnd = lease.endDate;
  var start = oldEnd == null
      ? DateTime.now()
      : DateTime(oldEnd.year, oldEnd.month, oldEnd.day + 1);
  var end = DateTime(start.year + 1, start.month, start.day - 1);
  var makeActive = false;
  String? error;

  return showDialog<LeaseRenewRequest>(
    context: context,
    builder: (dialogContext) => WithTextController(
      text: lease.monthlyRent?.toStringAsFixed(0) ?? '',
      builder: (context, rent) => StatefulBuilder(
        builder: (context, setState) {
          final l10n = context.l10n;
          return AlertDialog(
            title: Text(l10n.leaseRenewTitle),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _DateField(
                    label: l10n.leaseNewStart,
                    date: start,
                    onChanged: (d) => setState(() => start = d),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _DateField(
                    label: l10n.leaseNewEnd,
                    date: end,
                    onChanged: (d) => setState(() => end = d),
                  ),
                  if (error != null) ...[
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      error!,
                      style: context.text.bodySmall?.copyWith(
                        color: context.colors.error,
                      ),
                    ),
                  ],
                  const SizedBox(height: AppSpacing.lg),
                  TextField(
                    controller: rent,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: l10n.leaseNewRent,
                      helperText: l10n.leaseNewRentHelper,
                      prefixText: '₹ ',
                    ),
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(l10n.leaseStartActive),
                    value: makeActive,
                    onChanged: (v) => setState(() => makeActive = v),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: Text(l10n.commonCancel),
              ),
              FilledButton(
                onPressed: () {
                  if (!end.isAfter(start)) {
                    setState(() => error = l10n.leaseEndAfterStart);
                    return;
                  }
                  // Blank keeps the current rent; anything else must be a
                  // positive amount, not silently dropped.
                  final rentText = rent.text.trim();
                  final newRent = double.tryParse(rentText);
                  if (rentText.isNotEmpty &&
                      (newRent == null || newRent <= 0)) {
                    setState(() => error = l10n.leaseFormRentInvalid);
                    return;
                  }
                  Navigator.of(dialogContext).pop(
                    LeaseRenewRequest(
                      startDate: start,
                      endDate: end,
                      monthlyRent: newRent,
                      makeActive: makeActive,
                    ),
                  );
                },
                child: Text(l10n.leaseRenew),
              ),
            ],
          );
        },
      ),
    ),
  );
}

/// Terminate: the tenant leaves on `termination_date` (today by default).
/// This dialog is the confirmation: its action is destructive and red.
Future<LeaseTerminateRequest?> showTerminateDialog(BuildContext context) {
  var date = DateTime.now();
  return showDialog<LeaseTerminateRequest>(
    context: context,
    builder: (dialogContext) => WithTextController(
      builder: (context, reason) => StatefulBuilder(
        builder: (context, setState) {
          final l10n = context.l10n;
          return AlertDialog(
            title: Text(l10n.leaseTerminateTitle),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(l10n.leaseTerminateBody),
                  const SizedBox(height: AppSpacing.lg),
                  _DateField(
                    label: l10n.leaseTerminationDate,
                    date: date,
                    onChanged: (d) => setState(() => date = d),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  TextField(
                    controller: reason,
                    minLines: 2,
                    maxLines: 4,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(labelText: l10n.leaseReason),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: Text(l10n.commonCancel),
              ),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: context.colors.error,
                  foregroundColor: context.colors.onError,
                ),
                onPressed: () => Navigator.of(dialogContext).pop(
                  LeaseTerminateRequest(
                    reason: reason.text,
                    terminationDate: date,
                  ),
                ),
                child: Text(l10n.leaseTerminate),
              ),
            ],
          );
        },
      ),
    ),
  );
}
