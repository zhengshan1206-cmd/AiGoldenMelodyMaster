import 'package:get/get.dart';

import 'launch_error_controller.dart';

class LaunchErrorBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LaunchErrorController>(
      () => LaunchErrorController(),
    );
  }
}
