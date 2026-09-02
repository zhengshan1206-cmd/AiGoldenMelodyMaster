import 'package:get/get.dart';

import '../view/lanuch_page/guide_controller.dart';

class GuidePageBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(GuideController());
  }
}
