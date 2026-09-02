import 'package:ai_golden_melody_master/view/share_sales/reward/reward_controller.dart';
import 'package:get/get.dart';

class RewardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RewardController());
  }
}
