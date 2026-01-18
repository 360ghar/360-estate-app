import 'package:estate_app/core/providers.dart';
import 'package:estate_app/features/more/reports/data/reports_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@immutable
class ReportRequest {
  const ReportRequest({required this.type, this.from, this.to});

  final ReportType type;
  final DateTime? from;
  final DateTime? to;

  @override
  bool operator ==(Object other) {
    return other is ReportRequest &&
        other.type == type &&
        other.from == from &&
        other.to == to;
  }

  @override
  int get hashCode => Object.hash(type, from, to);
}

final reportsRepositoryProvider = Provider<ReportsRepository>((ref) {
  return ReportsRepository(ref.read(apiClientProvider));
});

final reportProvider = FutureProvider.family<ReportResult, ReportRequest>(
  (ref, request) {
    return ref.read(reportsRepositoryProvider).fetchReport(
          request.type,
          from: request.from,
          to: request.to,
        );
  },
);
