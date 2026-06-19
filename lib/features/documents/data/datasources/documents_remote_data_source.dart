// Dead code from the in-progress cursor-pagination migration.
//
// This file was added as part of the migration to a cursor-based paginated
// data source for documents. The legacy `DocumentsRepository` (see
// `lib/features/more/documents/data/documents_repository.dart`) remains the
// wired-up implementation and is used by every provider/UI in this
// feature.
//
// Until the new data source is actually wired up, the classes below are
// unreachable from the app. We delete the method bodies here (Phase 5 fix
// B4) but keep the file as part of the in-progress migration so the diff
// history is preserved.

abstract interface class DocumentsRemoteDataSource {
  // Intentionally empty - see file-level comment.
}

/// Placeholder removed in Phase 5. Retained only so the file diff stays in
/// the migration history; never instantiated at runtime.
final class ApiDocumentsRemoteDataSource
    implements DocumentsRemoteDataSource {
  ApiDocumentsRemoteDataSource();
}
