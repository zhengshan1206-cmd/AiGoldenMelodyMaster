import 'package:ai_golden_melody_master/view/publish/controller/strategy_details_controller.dart';
import 'package:ai_golden_melody_master/view/purchase/vip/vip_purchase_controller.dart';
import 'package:get/get.dart';

class StrategyDetailsBinding extends Bindings {
  @override
  void dependencies() {
    // 先绑定VipPurchaseController，确保在StrategyDetailsController之前注册
    final vipController = Get.put(VipPurchaseController());

    final args = Get.arguments as Map<String, dynamic>?;
    final type = args?['type'] as String?;
    final id = args?['id'] as int?;
    final groupId = args?['groupId'] as int?;

    if (type != null && id != null && groupId != null) {
      Get.put(StrategyDetailsController(
        id: id,
        type: type,
        groupId: groupId,
      ));
    }

    // 确保VipPurchaseController加载数据
    vipController.loadData();
  }
}
