import 'package:estate_app/core/network/api_client.dart';
import 'package:estate_app/features/documents/data/datasources/documents_remote_data_source.dart';
import 'package:estate_app/features/documents/data/repositories/documents_repository_impl.dart';
import 'package:estate_app/features/documents/domain/repositories/documents_repository.dart';
import 'package:estate_app/features/documents/presentation/controllers/documents_controller.dart';
import 'package:get/get.dart';

class DocumentsBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DocumentsRemoteDataSource>(
      () => ApiDocumentsRemoteDataSource(Get.find<ApiClient>()),
    );

    Get.lazyPut<DocumentsRepository>(
      () => DocumentsRepositoryImpl(Get.find<DocumentsRemoteDataSource>()),
    );

    Get.lazyPut<DocumentsController>(
      () => DocumentsController(repository: Get.find<DocumentsRepository>()),
    );
  }
}
