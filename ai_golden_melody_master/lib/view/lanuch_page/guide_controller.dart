import 'package:ai_golden_melody_master/common/lib/app_common/aes/byhy_aes_storage_utils.dart';
import 'package:ai_golden_melody_master/common/lib/app_common/consts/const.dart';
import 'package:ai_golden_melody_master/navigator/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GuideController extends GetxController {
  ///引导页标题
  List<String> pageTitles = [
    // '发行变现，让才华变现',
    // '热门教程，轻松上手',
    // '多风格音乐作品，尽情探索',
    '多模式创作，随心所欲'
  ];

  ///引导页内容
  List<String> pageContents = [
    // '全网发行无阻，变现快人一步',
    // '手把手教创作，快速掌握音乐技巧',
    // '解锁百变风格，探索音乐新境界',
    '模式自由组合，灵感肆意绽放'
  ];

  ///当前引导页索引
  RxInt currentIndex = 0.obs;

  ///引导页控制器
  late final PageController pageController;

  @override
  void onInit() {
    super.onInit();
    pageController = PageController();
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  ///更新当前引导页索引
  void updateCurrentIndex(int index) {
    // 确保索引在有效范围内
    if (index >= 0 && index < pageTitles.length) {
      currentIndex.value = index;
    }
  }

  ///跳过引导页
  void skipGuide() {
    ByStorageUtils.saveBool(Consts.kLaunchGuideCheck, true);
    Get.offNamed(Routes.main);
  }
}
