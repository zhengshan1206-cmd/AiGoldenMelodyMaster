import 'package:ai_golden_melody_master/view/ai/ai_write_music/ai_write_music_controller.dart';
import 'package:ai_golden_melody_master/view/lanuch_page/launch_controller.dart';
import 'package:ai_golden_melody_master/view/me_center/me_center_controller.dart';
import 'package:get/get.dart';

import 'main_controller.dart';

///首页binding
class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainController>(
      () => MainController(),
    );
    Get.lazyPut<MeCenterController>(
      () => MeCenterController(),
    );
    Get.lazyPut<AiWriteMusicController>(
          () => AiWriteMusicController(),
    );
  }
}
