import 'dart:async';

import 'package:estate_app/core/errors/failure.dart';
import 'package:estate_app/features/documents/domain/entities/document.dart';
import 'package:estate_app/features/documents/domain/repositories/documents_repository.dart';
import 'package:get/get.dart';

class DocumentsController extends GetxController {
  DocumentsController({required DocumentsRepository repository})
      : _repository = repository;

  final DocumentsRepository _repository;

  final RxList<Document> items = <Document>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool hasMore = true.obs;
  final Rxn<Failure> failure = Rxn<Failure>();

  // Filters
  final Rxn<int> filterPropertyId = Rxn<int>();
  final Rxn<DocumentType> filterType = Rxn<DocumentType>();

  int _page = 1;
  static const int _pageSize = 20;

  @override
  void onInit() {
    super.onInit();
    unawaited(loadDocuments());
  }

  Future<void> loadDocuments() async {
    _page = 1;
    hasMore.value = true;
    failure.value = null;
    isLoading.value = true;
    items.clear();

    try {
      final page = await _repository.getDocuments(
        page: _page,
        limit: _pageSize,
        propertyId: filterPropertyId.value,
        documentType: filterType.value?.apiValue,
      );
      items.assignAll(page.items);
      hasMore.value = page.hasMore;
    } on Failure catch (f) {
      failure.value = f;
    } catch (e) {
      failure.value = UnknownFailure('Failed to load documents', cause: e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMore() async {
    if (!hasMore.value || isLoadingMore.value || isLoading.value) return;

    isLoadingMore.value = true;

    try {
      final nextPage = _page + 1;
      final page = await _repository.getDocuments(
        page: nextPage,
        limit: _pageSize,
        propertyId: filterPropertyId.value,
        documentType: filterType.value?.apiValue,
      );

      items.addAll(page.items);
      _page = nextPage;
      hasMore.value = page.hasMore;
    } catch (_) {
      // Silently fail for load more
    } finally {
      isLoadingMore.value = false;
    }
  }

  @override
  Future<void> refresh() async {
    await loadDocuments();
  }

  void setPropertyFilter(int? propertyId) {
    filterPropertyId.value = propertyId;
    unawaited(loadDocuments());
  }

  void setTypeFilter(DocumentType? type) {
    filterType.value = type;
    unawaited(loadDocuments());
  }

  void clearFilters() {
    filterPropertyId.value = null;
    filterType.value = null;
    unawaited(loadDocuments());
  }

  bool get hasActiveFilters =>
      filterPropertyId.value != null || filterType.value != null;

  Future<void> deleteDocument(int id) async {
    try {
      await _repository.deleteDocument(id);
      items.removeWhere((doc) => doc.id == id);
      Get.snackbar(
        'Success',
        'Document deleted successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } on Failure catch (f) {
      Get.snackbar(
        'Error',
        f.message,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete document',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<String?> getDownloadUrl(int id) async {
    try {
      return await _repository.getDownloadUrl(id);
    } catch (_) {
      Get.snackbar(
        'Error',
        'Failed to get download URL',
        snackPosition: SnackPosition.BOTTOM,
      );
      return null;
    }
  }
}
