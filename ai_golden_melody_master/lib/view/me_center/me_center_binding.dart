import 'package:get/get.dart';
import 'me_center_controller.dart';

class MeCenterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MeCenterController>(() => MeCenterController());
  }
}
