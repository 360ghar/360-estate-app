import 'package:estate_app/core/api/wire_enums.dart';
import 'package:estate_app/core/network/api_client.dart';
import 'package:estate_app/core/network/api_paths.dart';
import 'package:estate_app/core/network/response_parser.dart';
import 'package:estate_app/core/pagination/fetch_all.dart';
import 'package:estate_app/core/pagination/page.dart';
import 'package:estate_app/core/utils/parse.dart';
import 'package:estate_app/features/more/reports/models/report_row.dart';
import 'package:intl/intl.dart';

enum ReportType { rentRoll, income, expenses, pnl, occupancy, maintenance }

class ReportResult {
  const ReportResult({required this.type, required this.rows});

  final ReportType type;
  final List<ReportRow> rows;
}

/// Builds the screen lines from the typed report payloads. The backend sends
/// plain numbers and names. The labels are the app's own.
abstract final class ReportRowMapper {
  /// One `RentRollItem`: the property title, its rent, and whether a lease
  /// occupies it.
  static ReportRow rentRollItem(Map<String, dynamic> json) {
    final occupancy = RentRollOccupancy.fromJson(json['occupancy']);
    final status = switch (occupancy) {
      RentRollOccupancy.occupied => 'Occupied',
      RentRollOccupancy.vacant => 'Vacant',
      null => null,
    };
    final leaseEnd = parseDateTime(json['lease_end_date']);
    final parts = <String>[
      ?status,
      if (leaseEnd != null)
        'Lease ends ${DateFormat('d MMM yyyy').format(leaseEnd)}',
    ];
    final rent = parseDouble(json['monthly_rent']);
    return ReportRow(
      label: parseString(json['title']) ?? 'Property',
      amount: rent,
      value: rent == null ? status : null,
      detail: parts.isEmpty ? null : parts.join(' - '),
    );
  }

  /// `IncomeReport`: `total_income` for the window `start` to `end`.
  static List<ReportRow> income(Map<String, dynamic> json) => [
    ReportRow(label: 'Total income', amount: parseDouble(json['total_income'])),
    _period(json),
  ];

  /// `ExpenseReport`: `total_expenses` for the window.
  static List<ReportRow> expenses(Map<String, dynamic> json) => [
    ReportRow(
      label: 'Total expenses',
      amount: parseDouble(json['total_expenses']),
    ),
    _period(json),
  ];

  /// `PnLReport`: income, expenses and `net_income`.
  static List<ReportRow> pnl(Map<String, dynamic> json) => [
    ReportRow(label: 'Total income', amount: parseDouble(json['total_income'])),
    ReportRow(
      label: 'Total expenses',
      amount: parseDouble(json['total_expenses']),
    ),
    ReportRow(label: 'Net income', amount: parseDouble(json['net_income'])),
    _period(json),
  ];

  /// `OccupancyReport`: `total`, `occupied` and `vacant` property counts.
  static List<ReportRow> occupancy(Map<String, dynamic> json) {
    final total = parseInt(json['total']);
    final occupied = parseInt(json['occupied']);
    final rate = (total == null || total == 0 || occupied == null)
        ? null
        : '${(occupied * 100 / total).toStringAsFixed(0)}%';
    return [
      ReportRow(label: 'Properties', value: total?.toString()),
      ReportRow(label: 'Occupied', value: occupied?.toString()),
      ReportRow(label: 'Vacant', value: parseInt(json['vacant'])?.toString()),
      if (rate != null) ReportRow(label: 'Occupancy rate', value: rate),
    ];
  }

  /// `MaintenanceReport`: `total_requests`.
  static List<ReportRow> maintenance(Map<String, dynamic> json) => [
    ReportRow(
      label: 'Maintenance requests',
      value: parseInt(json['total_requests'])?.toString(),
    ),
  ];

  /// The `start` to `end` window of a report that has one. A window with no
  /// bound covers all time.
  static ReportRow _period(Map<String, dynamic> json) {
    final start = parseDateTime(json['start']);
    final end = parseDateTime(json['end']);
    final format = DateFormat('d MMM yyyy');
    final value = switch ((start, end)) {
      (null, null) => 'All time',
      (final s?, null) => 'From ${format.format(s)}',
      (null, final e?) => 'Until ${format.format(e)}',
      (final s?, final e?) => '${format.format(s)} - ${format.format(e)}',
    };
    return ReportRow(label: 'Period', value: value);
  }
}

class ReportsRepository {
  ReportsRepository(this._client);

  final ApiClient _client;

  /// The income, expense and P&L routes take the window as `start` and `end`
  /// (dates). The rent roll is a cursor list: every page is read.
  Future<ReportResult> fetchReport(
    ReportType type, {
    DateTime? from,
    DateTime? to,
  }) async {
    if (type == ReportType.rentRoll) {
      final items = await fetchAllPages<Map<String, dynamic>>(_rentRollPage);
      return ReportResult(
        type: type,
        rows: [for (final item in items) ReportRowMapper.rentRollItem(item)],
      );
    }

    final windowed =
        type == ReportType.income ||
        type == ReportType.expenses ||
        type == ReportType.pnl;
    final response = await _client.get<dynamic>(
      '${ApiPaths.reports}/${_endpointFor(type)}',
      ownerScoped: true,
      queryParameters: {
        if (windowed && from != null) 'start': toApiDateOnly(from),
        if (windowed && to != null) 'end': toApiDateOnly(to),
      },
    );
    final body = unwrapMap(response.data);
    final rows = switch (type) {
      ReportType.income => ReportRowMapper.income(body),
      ReportType.expenses => ReportRowMapper.expenses(body),
      ReportType.pnl => ReportRowMapper.pnl(body),
      ReportType.occupancy => ReportRowMapper.occupancy(body),
      ReportType.maintenance => ReportRowMapper.maintenance(body),
      ReportType.rentRoll => const <ReportRow>[],
    };
    return ReportResult(type: type, rows: rows);
  }

  Future<Page<Map<String, dynamic>>> _rentRollPage({
    required String? cursor,
    required int limit,
  }) async {
    final response = await _client.get<dynamic>(
      '${ApiPaths.reports}/rent-roll',
      ownerScoped: true,
      queryParameters: {if (cursor != null) 'cursor': cursor, 'limit': limit},
    );
    final raw = unwrapPage(response.data);
    return Page<Map<String, dynamic>>(
      items: raw.items.whereType<Map<String, dynamic>>().toList(),
      limit: limit,
      hasMore: raw.hasMore,
      nextCursor: raw.nextCursor,
    );
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
