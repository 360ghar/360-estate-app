import 'package:estate_app/features/more/reports/data/reports_repository.dart';
import 'package:estate_app/features/more/reports/models/report_row.dart';
import 'package:estate_app/l10n/gen/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

extension ReportTypeText on ReportType {
  String text(AppLocalizations l10n) => switch (this) {
    ReportType.rentRoll => l10n.reportsTypeRentRoll,
    ReportType.income => l10n.reportsTypeIncome,
    ReportType.expenses => l10n.reportsTypeExpenses,
    ReportType.pnl => l10n.reportsTypePnl,
    ReportType.occupancy => l10n.reportsTypeOccupancy,
    ReportType.maintenance => l10n.reportsTypeMaintenance,
  };

  String about(AppLocalizations l10n) => switch (this) {
    ReportType.rentRoll => l10n.reportsAboutRentRoll,
    ReportType.income => l10n.reportsAboutIncome,
    ReportType.expenses => l10n.reportsAboutExpenses,
    ReportType.pnl => l10n.reportsAboutPnl,
    ReportType.occupancy => l10n.reportsAboutOccupancy,
    ReportType.maintenance => l10n.reportsAboutMaintenance,
  };

  /// The income, expense and P&L routes take a date window.
  bool get windowed =>
      this == ReportType.income ||
      this == ReportType.expenses ||
      this == ReportType.pnl;
}

/// [ReportRowMapper] (data layer) writes fixed English labels and phrases;
/// these show them in the app language. Anything else (a property title, a
/// number) shows as it is.
// ponytail: keyed on ReportRowMapper's English text. Give ReportRow a kind
// field if that text starts to change often.
extension ReportRowText on ReportRow {
  String labelText(AppLocalizations l10n) => switch (label) {
    'Total income' => l10n.reportsRowTotalIncome,
    'Total expenses' => l10n.reportsRowTotalExpenses,
    'Net income' => l10n.reportsRowNetIncome,
    'Properties' => l10n.reportsRowProperties,
    'Property' => l10n.reportsRowProperty,
    'Occupied' => l10n.reportsRowOccupied,
    'Vacant' => l10n.reportsRowVacant,
    'Occupancy rate' => l10n.reportsRowOccupancyRate,
    'Maintenance requests' => l10n.reportsRowMaintenanceRequests,
    'Period' => l10n.reportsRowPeriod,
    final other => other ?? '',
  };

  String? valueText(AppLocalizations l10n) =>
      value == null ? null : _phrase(l10n, value!);

  /// The rent-roll detail: the occupancy word and the lease end, as one line.
  String? detailText(AppLocalizations l10n) => detail
      ?.split(' - ')
      .map((part) => _phrase(l10n, part))
      .join('  \u00B7  ');
}

String _phrase(AppLocalizations l10n, String text) {
  String after(String prefix) => text.substring(prefix.length);
  return switch (text) {
    'All time' => l10n.reportsRowAllTime,
    'Occupied' => l10n.reportsRowOccupied,
    'Vacant' => l10n.reportsRowVacant,
    _ when text.startsWith('From ') => l10n.reportsRowFrom(after('From ')),
    _ when text.startsWith('Until ') => l10n.reportsRowUntil(after('Until ')),
    _ when text.startsWith('Lease ends ') => l10n.reportsRowLeaseEnds(
      after('Lease ends '),
    ),
    _ => text,
  };
}

/// Shares [result] as CSV through the system share sheet.
Future<void> shareReportCsv(ReportResult result) {
  final buffer = StringBuffer()..writeln('Label,Amount,Value');
  for (final row in result.rows) {
    buffer.writeln(
      '${_csvCell(row.label ?? '')},'
      '${row.amount?.toStringAsFixed(2) ?? ''},'
      '${_csvCell(row.value ?? '')}',
    );
  }
  final date = DateFormat('yyyy-MM-dd').format(DateTime.now());
  return Share.share(
    buffer.toString(),
    subject: '${result.type.name} report ($date)',
  );
}

/// Quotes a cell that holds a comma, a quote or a line break. A cell that
/// starts like a formula gets a leading quote, so a spreadsheet shows it as
/// text instead of running it.
String _csvCell(String value) {
  var cell = value;
  if (RegExp(r'^[=+\-@]').hasMatch(cell)) cell = "'$cell";
  if (RegExp('[,"\n\r]').hasMatch(cell)) {
    return '"${cell.replaceAll('"', '""')}"';
  }
  return cell;
}
