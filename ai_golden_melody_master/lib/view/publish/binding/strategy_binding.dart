import 'package:get/get.dart';
import '../controller/strategy_controller.dart';

class StrategyBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(StrategyController());
  }
}
