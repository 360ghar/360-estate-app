import 'package:estate_app/features/more/reports/models/report_row.dart';
import 'package:estate_app/features/more/reports/presentation/widgets/report_text.dart';
import 'package:estate_app/l10n/gen/app_localizations.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final hi = lookupAppLocalizations(const Locale('hi'));

  test('report rows read in the app language', () {
    const row = ReportRow(
      label: 'Total income',
      value: 'From 1 Oct 2026',
      detail: 'Occupied - Lease ends 31 Mar 2027',
    );
    expect(row.labelText(hi), hi.reportsRowTotalIncome);
    expect(row.valueText(hi), hi.reportsRowFrom('1 Oct 2026'));
    expect(
      row.detailText(hi),
      '${hi.reportsRowOccupied}  ·  ${hi.reportsRowLeaseEnds('31 Mar 2027')}',
    );
    // A property title is shown as it is.
    expect(
      const ReportRow(label: '2 BHK Sector 51').labelText(hi),
      '2 BHK Sector 51',
    );
  });
}
