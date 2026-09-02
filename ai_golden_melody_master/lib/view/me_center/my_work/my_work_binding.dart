
import 'package:get/get.dart';

import 'my_work_controller.dart';

class MyWorkBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<MyWorkController>(
          () => MyWorkController(),
    );
  }

}