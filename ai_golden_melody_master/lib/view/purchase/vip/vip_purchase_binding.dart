import 'package:ai_golden_melody_master/view/purchase/vip/vip_purchase_controller.dart';
import 'package:get/get.dart';

class VipPurchaseBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(VipPurchaseController());
  }
}
