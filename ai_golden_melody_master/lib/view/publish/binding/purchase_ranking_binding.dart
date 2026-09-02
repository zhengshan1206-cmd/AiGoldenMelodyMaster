import 'package:get/get.dart';
import '../controller/purchase_ranking_controller.dart';

class PurchaseRankingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PurchaseRankingController());
  }
}
