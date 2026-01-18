import 'package:estate_app/core/network/api_client.dart';
import 'package:estate_app/core/network/response_parser.dart';
import 'package:estate_app/features/more/reports/models/report_row.dart';

enum ReportType { rentRoll, income, expenses, pnl, occupancy, maintenance }

class ReportResult {
  const ReportResult({required this.type, required this.rows});

  final ReportType type;
  final List<ReportRow> rows;
}

class ReportsRepository {
  ReportsRepository(this._client);

  final ApiClient _client;

  Future<ReportResult> fetchReport(
    ReportType type, {
    DateTime? from,
    DateTime? to,
  }) async {
    final response = await _client.get(
      '/pm/reports/${_endpointFor(type)}',
      queryParameters: {
        if (from != null) 'from': from.toIso8601String(),
        if (to != null) 'to': to.toIso8601String(),
      },
    );

    final data = unwrapData(response.data);
    final rows = <ReportRow>[];

    if (data is List) {
      rows.addAll(
        data.whereType<Map<String, dynamic>>().map(ReportRow.fromJson),
      );
    } else if (data is Map<String, dynamic>) {
      final list = data['rows'];
      if (list is List) {
        rows.addAll(
          list.whereType<Map<String, dynamic>>().map(ReportRow.fromJson),
        );
      } else {
        rows.addAll(
          data.entries.map(
            (entry) => ReportRow(
              label: entry.key,
              value: entry.value?.toString(),
            ),
          ),
        );
      }
    }

    return ReportResult(type: type, rows: rows);
  }
}

String _endpointFor(ReportType type) {
  return switch (type) {
    ReportType.rentRoll => 'rent-roll',
    ReportType.income => 'income',
    ReportType.expenses => 'expenses',
    ReportType.pnl => 'pnl',
    ReportType.occupancy => 'occupancy',
    ReportType.maintenance => 'maintenance',
  };
}
