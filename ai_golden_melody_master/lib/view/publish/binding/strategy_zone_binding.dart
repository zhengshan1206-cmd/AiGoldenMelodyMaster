import 'package:get/get.dart';
import '../controller/strategy_zone_controller.dart';

class StrategyZoneBinding extends Bindings {
  @override
  void dependencies() {
    // Get.lazyPut(() => StrategyZoneController());
    Get.put(StrategyZoneController(
      type: Get.arguments['type'] ?? 0,
    ));
  }
}
