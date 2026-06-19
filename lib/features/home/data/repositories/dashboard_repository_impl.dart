// Dead code from the in-progress cursor-pagination migration.
//
// This repository implementation wraps the new paged data source which is
// never instantiated anywhere in the app (Phase 5 fix B7). The legacy
// `DashboardRepository` (see `lib/features/home/data/dashboard_repository.dart`)
// is the live implementation.
//
// The file is retained as part of the in-progress migration diff so the
// history stays intact.

import 'package:estate_app/features/home/data/datasources/dashboard_remote_data_source.dart';

final class DashboardRepositoryImpl {
  DashboardRepositoryImpl({
    required DashboardRemoteDataSource dataSource,
  });
}
