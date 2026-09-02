import 'package:ai_golden_melody_master/view/lanuch_page/launch_controller.dart';
import 'package:get/get.dart';

import '../view/ai/ai_play_music/ai_play_music_controller.dart';
import '../view/lanuch_page/guide_controller.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<LaunchController>(LaunchController());
    Get.put(GuideController());
  }
}
