import 'package:estate_app/core/providers.dart';
import 'package:estate_app/features/more/documents/data/documents_repository.dart';
import 'package:estate_app/features/more/documents/models/document_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final documentsRepositoryProvider = Provider<DocumentsRepository>((ref) {
  return DocumentsRepository(ref.read(apiClientProvider));
});

final documentsListProvider = FutureProvider<List<DocumentItem>>((ref) {
  return ref.read(documentsRepositoryProvider).list();
});
