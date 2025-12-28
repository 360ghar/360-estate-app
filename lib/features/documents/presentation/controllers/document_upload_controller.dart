import 'dart:io';

import 'package:estate_app/core/errors/failure.dart';
import 'package:estate_app/features/documents/domain/entities/document.dart';
import 'package:estate_app/features/documents/domain/repositories/documents_repository.dart';
import 'package:get/get.dart';

class DocumentUploadController extends GetxController {
  DocumentUploadController({
    required DocumentsRepository repository,
    this.propertyId,
    this.leaseId,
  }) : _repository = repository;

  final DocumentsRepository _repository;
  final int? propertyId;
  final int? leaseId;

  final Rx<DocumentType> documentType = DocumentType.other.obs;
  final Rxn<File> selectedFile = Rxn<File>();
  final RxString description = ''.obs;
  final Rxn<DateTime> expiryDate = Rxn<DateTime>();

  final RxBool isUploading = false.obs;
  final Rxn<Failure> failure = Rxn<Failure>();

  final Rxn<int> selectedPropertyId = Rxn<int>();

  @override
  void onInit() {
    super.onInit();
    selectedPropertyId.value = propertyId;
  }

  void setDocumentType(DocumentType type) {
    documentType.value = type;
  }

  void setSelectedFile(File? file) {
    selectedFile.value = file;
  }

  void setDescription(String value) {
    description.value = value;
  }

  void setExpiryDate(DateTime? date) {
    expiryDate.value = date;
  }

  void setPropertyId(int? id) {
    selectedPropertyId.value = id;
  }

  bool get canSubmit => selectedFile.value != null;

  Future<void> upload() async {
    if (selectedFile.value == null) {
      Get.snackbar(
        'Error',
        'Please select a file to upload',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isUploading.value = true;
    failure.value = null;

    try {
      final document = await _repository.uploadDocument(
        file: selectedFile.value!,
        documentType: documentType.value.apiValue,
        propertyId: selectedPropertyId.value,
        leaseId: leaseId,
        description: description.value.isNotEmpty ? description.value : null,
        expiryDate: expiryDate.value,
      );

      Get.back<Document>(result: document);
      Get.snackbar(
        'Success',
        'Document uploaded successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } on Failure catch (f) {
      failure.value = f;
      Get.snackbar(
        'Error',
        f.message,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      failure.value = UnknownFailure('Failed to upload document', cause: e);
      Get.snackbar(
        'Error',
        'Failed to upload document: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isUploading.value = false;
    }
  }
}
