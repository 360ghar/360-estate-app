// Dead code from the in-progress cursor-pagination migration.
//
// This file was added as part of the migration to a cursor-based paginated
// data source for finance (rent charges, rent payments, expenses). None of
// the methods on this class are reachable from production code paths:
//
//   - Rent charges go through `RentRepository.listChargesPage` (see
//     `lib/features/collections/data/rent_repository.dart`).
//   - Rent payments go through the legacy `RentRepository.listPayments`.
//   - Expenses go through `ExpensesRepository.list` (see
//     `lib/features/more/expenses/data/expenses_repository.dart`).
//
// The file is retained as part of the in-progress migration diff (Phase 5
// fix B3) but the method bodies have been deleted.

abstract interface class FinanceRemoteDataSource {
  // Intentionally empty - see file-level comment.
}

/// Placeholder removed in Phase 5. Retained only so the file diff stays in
/// the migration history; never instantiated at runtime.
final class ApiFinanceRemoteDataSource implements FinanceRemoteDataSource {
  ApiFinanceRemoteDataSource();
}
