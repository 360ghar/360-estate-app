import 'package:estate_app/core/api/wire_enums.dart';
import 'package:estate_app/core/presentation/design_system/app_text_styles.dart';
import 'package:estate_app/core/presentation/extensions/build_context_x.dart';
import 'package:estate_app/core/presentation/widgets/app_list_card.dart';
import 'package:estate_app/core/presentation/widgets/app_status_badge.dart';
import 'package:estate_app/core/presentation/widgets/feedback.dart';
import 'package:estate_app/core/utils/dates.dart';
import 'package:estate_app/core/utils/money.dart';
import 'package:estate_app/features/collections/models/rent_charge.dart';
import 'package:estate_app/features/collections/presentation/rent_status_text.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

/// One rent charge: who owes it, for which property, how much is left, when
/// it is due, and its status. An open charge opens the payment form and can
/// send the tenant a reminder.
class ChargeRow extends StatelessWidget {
  const ChargeRow({
    super.key,
    required this.row,
    this.tenantName,
    this.propertyTitle,
  });

  final RentChargeWithTotals row;
  final String? tenantName;
  final String? propertyTitle;

  String _tenant(BuildContext context) {
    final name = tenantName?.trim();
    if (name != null && name.isNotEmpty) return name;
    return context.l10n.commonLeaseNumber('${row.charge.leaseId ?? '-'}');
  }

  String _property(BuildContext context) {
    final title = propertyTitle?.trim();
    if (title != null && title.isNotEmpty) return title;
    return context.l10n.commonPropertyNumber('${row.charge.propertyId ?? '-'}');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final status = row.status;
    final isOpen = status?.isOpen ?? false;
    final dueDate = row.dueDate;
    final daysLate = dueDate == null || !isOpen
        ? 0
        : _daysBetween(dueDate, DateTime.now());
    final amount = isOpen ? row.balance : row.totalDue;

    return AppListCard(
      title: _tenant(context),
      subtitle: _property(context),
      trailing: Text(
        rupees(amount),
        style: AppTextStyles.currencySmall.copyWith(
          color: status == RentChargeStatus.overdue
              ? context.colors.error
              : context.colors.onSurface,
        ),
      ),
      facts: [
        if (dueDate == null)
          l10n.collectionsNoDueDate
        else
          l10n.collectionsDueOn(shortDate(context, dueDate)),
        if (isOpen && row.paid > 0)
          l10n.collectionsPaidOf(rupees(row.paid), rupees(row.totalDue)),
        if (row.lateFee > 0) l10n.collectionsLateFee(rupees(row.lateFee)),
        if (status == RentChargeStatus.overdue && daysLate > 0)
          l10n.collectionsDaysOverdue(daysLate),
      ],
      status: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (status != null)
            AppStatusBadge(label: status.text(l10n), type: status.statusType),
          if (isOpen)
            IconButton(
              tooltip: l10n.collectionsRemind,
              icon: const Icon(Icons.send_outlined, size: 20),
              onPressed: () => _remind(context),
            ),
        ],
      ),
      onTap: isOpen && row.id != null
          ? () => context.go('/collections/payments/new?chargeId=${row.id}')
          : null,
    );
  }

  /// Opens WhatsApp (the user picks the tenant) or, failing that, SMS, with
  /// the reminder filled in.
  Future<void> _remind(BuildContext context) async {
    final l10n = context.l10n;
    final dueDate = row.dueDate;
    final message = Uri.encodeComponent(
      l10n.collectionsReminderMessage(
        _tenant(context),
        rupees(row.balance),
        _property(context),
        dueDate == null ? l10n.collectionsSoon : shortDate(context, dueDate),
      ),
    );
    if (await launchUrl(
      Uri.parse('https://wa.me/?text=$message'),
      mode: LaunchMode.externalApplication,
    )) {
      return;
    }
    if (await launchUrl(Uri.parse('sms:?body=$message'))) return;
    if (context.mounted) context.showSnack(l10n.collectionsNoMessagingApp);
  }
}

/// Whole calendar days from [from] to [to], both read as the local dates the
/// user sees (not 24-hour periods).
int _daysBetween(DateTime from, DateTime to) {
  final a = DateTime.utc(from.year, from.month, from.day);
  final b = DateTime.utc(to.year, to.month, to.day);
  return b.difference(a).inDays;
}
