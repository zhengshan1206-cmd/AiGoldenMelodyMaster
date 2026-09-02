

import 'package:ai_golden_melody_master/view/purchase/vip/vip_rights/vip_rights_controller.dart';
import 'package:get/get.dart';

import '../../../lanuch_page/launch_controller.dart';

class VipRightsBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<VipRightsController>(
          () => VipRightsController(),
    );
  }
}