import 'package:estate_app/features/shell/presentation/controllers/shell_controller.dart';
import 'package:get/get.dart';

class ShellBindings extends Bindings {
  @override
  void dependencies() {
    // Use lazyPut so the controller is recreated if deleted, but check if exists first
    if (!Get.isRegistered<ShellController>()) {
      Get.put<ShellController>(ShellController(), permanent: true);
    } else {
      // Reset to Home tab when navigating back to shell
      Get.find<ShellController>().currentIndex.value = 0;
    }
  }
}
