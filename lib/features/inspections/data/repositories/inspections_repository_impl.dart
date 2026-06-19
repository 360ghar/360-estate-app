// Dead code from the in-progress cursor-pagination migration.
//
// This repository implementation wraps the new paged data source which is
// never instantiated anywhere in the app (Phase 5 fix B2). The legacy
// `InspectionsRepository` class (see
// `lib/features/inspections/data/inspections_repository.dart`) is the live
// implementation.
//
// The file is retained as part of the in-progress migration diff so the
// history stays intact. Re-introducing a paged implementation will require
// rewriting this file to match the real backend contract.

import 'package:estate_app/features/inspections/data/datasources/inspections_remote_data_source.dart';

final class InspectionsRepositoryImpl {
  InspectionsRepositoryImpl({required InspectionsRemoteDataSource dataSource});
}
