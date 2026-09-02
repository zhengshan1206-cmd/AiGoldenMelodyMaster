
import 'package:ai_golden_melody_master/view/share_sales/share_sales_controller.dart';
import 'package:get/get.dart';

class ShareSalesBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => ShareSalesController());
  }

}
