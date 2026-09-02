

import 'package:get/get.dart';

import 'me_music_note_value_list_controller.dart';

class MeMusicNoteValueListBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<MeMusicNoteValueListController>(
          () => MeMusicNoteValueListController(),
    );
  }

}