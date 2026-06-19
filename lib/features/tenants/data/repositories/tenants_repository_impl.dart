// Dead code from the in-progress cursor-pagination migration.
//
// This repository implementation wraps the new paged data source which is
// never instantiated anywhere in the app (Phase 5 fix B8). The legacy
// `TenantsRepository` (see `lib/features/more/tenants/data/tenants_repository.dart`)
// is the live implementation.
//
// The file is retained as part of the in-progress migration diff so the
// history stays intact.

import 'package:estate_app/features/tenants/data/datasources/tenants_remote_data_source.dart';

final class TenantsRepositoryImpl {
  TenantsRepositoryImpl({
    required TenantsRemoteDataSource dataSource,
  });
}
