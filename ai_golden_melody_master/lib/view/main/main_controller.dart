import 'package:ai_golden_melody_master/utils/by_init_utils.dart';
import 'package:ai_golden_melody_master/view/ai/ai_write_music/ai_write_music_controller.dart';
import 'package:ai_golden_melody_master/view/ai/ai_write_music/ai_write_music_page.dart';
import 'package:ai_golden_melody_master/view/lanuch_page/launch_controller.dart';
import 'package:ai_golden_melody_master/view/me_center/me_center_page.dart';
import 'package:ai_golden_melody_master/view/publish/publish_page.dart';
import 'package:ai_golden_melody_master/view/share_sales/share_sales_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:ai_golden_melody_master/common/lib/app_common/event/common_event.dart';
import 'dart:async';

import '../../utils/common_event.dart';
import '../purchase/vip/vip_purchase_controller.dart';
import '../share_sales/share_sales_page.dart';

///首页controller
class MainController extends GetxController {
  ///当前的指针
  int currentIndex = 0;

  ///当前导航页面
  List<Widget> tabBarPages = [];

  /// 事件监听器
  StreamSubscription? _switchTabSubscription;

  @override
  void onInit() {
    super.onInit();
    initController();
    initData();
    _initEventListeners();

    // 检查是否有传入的tabIndex参数
    _handleTabIndexArgument();
  }

  @override
  void onReady() {
    super.onReady();
    // 在页面准备就绪后再次检查参数，确保在页面重建后也能处理
    _handleTabIndexArgument();
  }

  /// 处理传入的tabIndex参数
  void _handleTabIndexArgument() {
    final arguments = Get.arguments;
    if (arguments != null && arguments['tabIndex'] != null) {
      final tabIndex = arguments['tabIndex'] as int;
      Future.delayed(const Duration(milliseconds: 200), () {
        tabChanged(index: tabIndex);
      });
    }
  }

  /// 切换到指定Tab（供外部调用）
  void switchToTab(int index) {
    tabChanged(index: index);
  }

  @override
  void onClose() {
    _switchTabSubscription?.cancel();
    super.onClose();
  }

  /// 初始化事件监听
  void _initEventListeners() {
    _switchTabSubscription = eventBus.on<SwitchTabEvent>().listen((event) {
      tabChanged(index: event.tabIndex);
    });
  }

  ///初始化数据
  initData() {
    tabBarPages.add(PublishPage());
    tabBarPages.add(const AiWriteMusicPage());
    tabBarPages.add(const ShareSalesPage());
    tabBarPages.add(const MeCenterPage());
    tabChanged(index: 1);

    bool isVipPurchaseController = Get.isRegistered<VipPurchaseController>();
    if (!isVipPurchaseController) {
      Get.put(VipPurchaseController());
    } else {
      Get.find<VipPurchaseController>().loadData();
    }

    // 友盟SDK已在用户同意隐私政策后初始化，此处不再重复初始化
    ByInitUtils.initUmeng();

    update();
  }

  initController() {
    Get.lazyPut<AiWriteMusicController>(() => AiWriteMusicController());
    Get.lazyPut<ShareSalesController>(() => ShareSalesController());
    bool isRegister = Get.isRegistered<AiWriteMusicController>();
    if (isRegister) {
      Get.find<AiWriteMusicController>().initData();
    } else {
      Get.put(AiWriteMusicController());
    }
  }

  ///页面切换
  void tabChanged({
    required int index,
  }) {
    if (Get.find<AiWriteMusicController>().isRecordVoice) {
      EasyLoading.showToast("请专心录制音频～");
      return;
    }

    if (index == 2) {
      bool isLogin = Get.find<LaunchController>().isLogin;
      if (!isLogin) {
        Get.find<LaunchController>().login(
            loginSuccess: () {
              currentIndex = index;
              update();
              if (index == 2) {
                bool isShareSalesController =
                    Get.isRegistered<ShareSalesController>();
                if (!isShareSalesController) {
                  Get.lazyPut<ShareSalesController>(
                      () => ShareSalesController());
                }
                Get.find<ShareSalesController>().getData();
              }
            },
            source: "earn_money_btn");
        return;
      }
    }

    if (currentIndex != index) {
      currentIndex = index;
      update();
    }

    if (index == 0) {
      eventBus.fire(const StopMusicButtonEvent());
    }

    if (index == 1) {
      bool isAiWriteMusicController =
          Get.isRegistered<AiWriteMusicController>();
      if (!isAiWriteMusicController) {
        Get.lazyPut<AiWriteMusicController>(() => AiWriteMusicController());
      }
      Get.find<AiWriteMusicController>().loadAiMusicSongRights();
    }

    if (index == 2) {
      bool isShareSalesController = Get.isRegistered<ShareSalesController>();
      if (!isShareSalesController) {
        Get.lazyPut<ShareSalesController>(() => ShareSalesController());
      }
      Get.find<ShareSalesController>().getData();
    }

    if (index == 3) {
      bool isVipPurchaseController = Get.isRegistered<VipPurchaseController>();
      if (!isVipPurchaseController) {
        Get.put(VipPurchaseController());
      }
      Get.find<VipPurchaseController>().loadData();
      eventBus.fire(const StopMusicButtonEvent());
    }

    Get.find<LaunchController>().reloadUserInfo();
  }
}
