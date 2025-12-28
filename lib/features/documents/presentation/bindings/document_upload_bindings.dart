import 'package:estate_app/features/documents/domain/repositories/documents_repository.dart';
import 'package:estate_app/features/documents/presentation/controllers/document_upload_controller.dart';
import 'package:get/get.dart';

class DocumentUploadBindings extends Bindings {
  @override
  void dependencies() {
    final propertyId = Get.arguments?['propertyId'] as int?;
    final leaseId = Get.arguments?['leaseId'] as int?;

    Get.lazyPut<DocumentUploadController>(
      () => DocumentUploadController(
        repository: Get.find<DocumentsRepository>(),
        propertyId: propertyId,
        leaseId: leaseId,
      ),
    );
  }
}
