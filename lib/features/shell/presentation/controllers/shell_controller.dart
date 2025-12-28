import 'package:get/get.dart';

enum ShellTab { home, properties, tenants, finance, more }

class ShellController extends GetxController {
  final RxInt currentIndex = 0.obs;

  ShellTab get currentTab => ShellTab.values[currentIndex.value];

  void changeTab(int index) {
    if (index >= 0 && index < ShellTab.values.length) {
      currentIndex.value = index;
    }
  }

  void goToTab(ShellTab tab) {
    currentIndex.value = tab.index;
  }
}
