import 'package:ai_golden_melody_master/common/lib/app_http/apis.dart';
import 'package:ai_golden_melody_master/common/lib/app_http/http_utils.dart';
import 'package:ai_golden_melody_master/view/lanuch_page/launch_controller.dart';
import 'package:ai_golden_melody_master/view/publish/beans/strategy_guide_config_bean.dart';
import 'package:ai_golden_melody_master/view/publish/beans/zoon_detail_bean.dart';
import 'package:ai_golden_melody_master/view/publish/widget/muti_status_view.dart';
import 'package:ai_golden_melody_master/view/purchase/vip/vip_purchase_controller.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class StrategyDetailsController extends GetxController {
  StrategyDetailsController({
    required this.id,
    required this.type,
    required this.groupId,
  });
  final int id;
  final String type;
  final int groupId;

  /// 攻略详情
  Rx<ZoonDetailBean?> strategyDetails = Rx<ZoonDetailBean?>(null);

  /// 攻略配置
  Rx<StrategyGuideConfigBean?> strategyGuideConfig =
      Rx<StrategyGuideConfigBean?>(null);

  /// 状态类型
  Rx<MultiStatusType> statusType = MultiStatusType.statusContent.obs;

  final VipPurchaseController _vipPurchaseController =
      Get.find<VipPurchaseController>();

  @override
  void onInit() {
    super.onInit();
    getStrategyDetails();
    getStrategyGuideConfig();
  }

  /// 数字转换方法：超过10000用W展示，保留2位小数
  String formatNumber(int number) {
    if (number >= 10000) {
      double wNumber = number / 10000.0;
      return '${wNumber.toStringAsFixed(2)}w';
    }
    return number.toString();
  }

  /// 获取攻略详情
  void getStrategyDetails() {
    HttpUtils.get(APIs.getStrategyGuideDetail, {
      "id": id,
      "type": type,
      "group_id": groupId,
    }, success: (data) {
      if (data != null && data["data"] != null) {
        strategyDetails.value = ZoonDetailBean.fromJson(data["data"]);
        statusType.value = MultiStatusType.statusContent;
      }

      ///协议初始化
      Get.find<VipPurchaseController>().agreementCheckedStatusChanged(false);
    }, fail: (code, msg) {
      EasyLoading.showToast(msg);
      statusType.value = MultiStatusType.statusNoNetWork;
    });
  }

  /// 获取攻略配置
  void getStrategyGuideConfig() {
    HttpUtils.get(APIs.getStrategyGuideConfig, {}, success: (data) {
      if (data != null && data["data"] != null) {
        strategyGuideConfig.value =
            StrategyGuideConfigBean.fromJson(data["data"]);
      }
    }, fail: (code, msg) {
      EasyLoading.showToast(msg);
    });
  }

  /// 购买事件
  void buyEvent() {
    final userInfo = Get.find<LaunchController>().user;
    if (userInfo.value?.isFormal == 0) {
      ///登录
      Get.find<LaunchController>().login(loginSuccess: () {},source: "strategy_details");
      return;
    }
    if (userInfo.value?.isVip == 0) {
      _vipPurchaseController.buyEvent();
    } else {
      // 升级会员
      Get.find<LaunchController>().showVipUpgradeDialog();
    }
  }
}
