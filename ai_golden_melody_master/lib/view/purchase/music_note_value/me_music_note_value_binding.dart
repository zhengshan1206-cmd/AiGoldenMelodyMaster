
import 'package:get/get.dart';

import 'me_music_note_value_controller.dart';

class MeMusicNoteValueBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<MeMusicNoteValueController>(
          () => MeMusicNoteValueController(),
    );
  }
}