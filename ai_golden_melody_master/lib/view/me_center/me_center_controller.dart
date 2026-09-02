import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../navigator/app_pages.dart';
import '../common/tutorial/tutorial_mixin.dart';

///个人中心的业务逻辑
class MeCenterController extends GetxController with TutorialMixin {
  final customerController = ScrollController();

  /// 当前页面竖直方向的滚动偏移量
  double currentOffset = 0;

  @override
  void onInit() {
    super.onInit();
    customerController.addListener(_onScrolled);
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

  /// 更多
  void loadMore(int index) {
    print("index: $index");
    if (index == 2) {
      Get.toNamed(Routes.strategyPage);
    }
  }
}
