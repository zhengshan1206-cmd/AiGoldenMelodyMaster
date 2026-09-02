import 'package:ai_golden_melody_master/common/lib/app_http/apis.dart';
import 'package:ai_golden_melody_master/common/lib/app_http/http_utils.dart';
import 'package:ai_golden_melody_master/model/launch/app_config.dart';
import 'package:ai_golden_melody_master/navigator/app_pages.dart';
import 'package:ai_golden_melody_master/view/lanuch_page/launch_controller.dart';
import 'package:ai_golden_melody_master/view/publish/beans/music_home_bean.dart';
import 'package:ai_golden_melody_master/view/publish/beans/music_selected_bean.dart';
import 'package:ai_golden_melody_master/view/publish/diaglog/home_marketing_dialog.dart';
import 'package:ai_golden_melody_master/view/common/tutorial/tutorial_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class PublishController extends GetxController with TutorialMixin {
  final customerController = ScrollController();

  /// 当前页面竖直方向的滚动偏移量
  double currentOffset = 0;

  ///首页数据
  Rx<MusicHomeBean?> musicHomeBean = Rx<MusicHomeBean?>(null);

  ///精选作品
  Rx<List<MusicSelectedBean>?> musicSelectedList =
      Rx<List<MusicSelectedBean>?>(null);

  /// 分享平台logo
  List<SharingPlatform>? sharingPlatformList = [];

  LaunchController launchController = Get.find<LaunchController>();

  ///是否可以弹出营销弹窗
  RxBool showBottomOperationView = true.obs;

  @override
  void onInit() {
    super.onInit();
    customerController.addListener(_onScrolled);
    getHomeData();
    getSelectedWorks();
    // showHomeMarketingDialog();
  }

  @override
  void onClose() {
    customerController.removeListener(_onScrolled);
    customerController.dispose();
    super.onClose();
  }

  /// 滚动监听，更新当前偏移量
  void _onScrolled() {
    currentOffset = customerController.offset;
    update();
  }

  /// 更新偏移量（供外部调用）
  void updateOffset(double offset) {
    currentOffset = offset;
    update();
  }

  /// 弹窗
  void showHomeMarketingDialog() {
    ///非会员弹窗
    var isVip = launchController.user.value?.isVip ?? 0;
    if (isVip == 0) {
      Get.dialog(
        HomeMarketingDialog(),
      );
    }
  }

  /// 滚动到顶部
  void scrollToTop() {
    if (customerController.hasClients) {
      customerController.animateTo(
        0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  ///获取首页数据
  void getHomeData() {
    HttpUtils.get(APIs.aiMusicHome, {}, success: (data) {
      if (data != null && data['data'] != null) {
        musicHomeBean.value = MusicHomeBean.fromJson(data['data']);
      }

      AppConfig? appConfig = launchController.appConfig;
      if (appConfig != null) {
        AppConfigData? appConfigData = appConfig.data;
        if (appConfigData != null) {
          sharingPlatformList = appConfigData.sharingPlatform ?? [];
        }
      }

      update();
    }, fail: (code, msg) {
      EasyLoading.showToast(msg);
    });
  }

  ///获取精选作品
  void getSelectedWorks() {
    HttpUtils.get(APIs.getSelectedWorks, {}, success: (data) {
      if (data != null && data['data'] != null) {
        final List items = data["data"] ?? [];
        final List<MusicSelectedBean> records =
            items.map((ele) => MusicSelectedBean.fromJson(ele)).toList();
        musicSelectedList.value = records;
      }
      update();
    }, fail: (code, msg) {
      EasyLoading.showToast(msg);
    });
  }

  /// 更多
  void loadMore(int index) {
    print("index: $index");
    if (index == 1) {
      Get.toNamed(Routes.purchaseRankingPage);
    } else if (index == 2) {
      Get.toNamed(Routes.strategyPage);
    }
  }

  ///根据传入的id获取分享平台logo
  String getSharingPlatformLogo(int id) {
    try {
      return sharingPlatformList
              ?.firstWhere((element) => element.id == id)
              .icon ??
          "";
    } catch (e) {
      return "";
    }
  }

  ///关闭底部运营条
  void closeBottomOperation() {
    showBottomOperationView.value = false;
  }
}
