// Dead code from the in-progress cursor-pagination migration.
//
// This repository implementation wraps the new paged data source which is
// never instantiated anywhere in the app (Phase 5 fix B9). The legacy
// `ApplicationsRepository` (see
// `lib/features/rental_applications/data/applications_repository.dart`)
// is the live implementation.
//
// The file is retained as part of the in-progress migration diff so the
// history stays intact.

import 'package:estate_app/features/applications/data/datasources/applications_remote_data_source.dart';

final class ApplicationsRepositoryImpl {
  ApplicationsRepositoryImpl({
    required ApplicationsRemoteDataSource dataSource,
  });
}
