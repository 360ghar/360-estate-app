import 'package:estate_app/features/shell/presentation/controllers/shell_controller.dart';
import 'package:get/get.dart';

class ShellBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<ShellController>(ShellController(), permanent: true);
  }
}
