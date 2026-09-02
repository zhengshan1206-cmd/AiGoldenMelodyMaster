import 'package:get/get.dart';

import 'ai_play_music_controller.dart';

class AiPlayMusicBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AiPlayMusicController>(
      () => AiPlayMusicController(),
    );
  }
}
