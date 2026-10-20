import 'package:estate_app/core/providers.dart';
import 'package:estate_app/features/auth/presentation/auth_controller.dart';
import 'package:estate_app/features/more/documents/data/documents_repository.dart';
import 'package:estate_app/features/more/documents/models/document_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final documentsRepositoryProvider = Provider<DocumentsRepository>((ref) {
  ref.watch(accountScopeProvider);
  return DocumentsRepository(
    ref.read(apiClientProvider),
    ref.read(fileUploadServiceProvider),
  );
});

/// Every document of the account (all pages).
final documentsListProvider = FutureProvider<List<DocumentItem>>((ref) {
  return ref.watch(documentsRepositoryProvider).listAll();
});

/// The documents linked to one property (all pages).
final documentsForPropertyProvider =
    FutureProvider.family<List<DocumentItem>, int>((ref, propertyId) {
      return ref
          .watch(documentsRepositoryProvider)
          .listAll(propertyId: propertyId);
    });
