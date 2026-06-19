// Dead code from the in-progress cursor-pagination migration.
//
// This repository implementation wraps the new paged data source which is
// never instantiated anywhere in the app (Phase 5 fix B3). Production
// callers use the legacy repositories in `lib/features/collections/data/`
// and `lib/features/more/expenses/data/`.
//
// The file is retained as part of the in-progress migration diff so the
// history stays intact.

import 'package:estate_app/features/finance/data/datasources/finance_remote_data_source.dart';

final class FinanceRepositoryImpl {
  FinanceRepositoryImpl(FinanceRemoteDataSource remoteDataSource);
}
