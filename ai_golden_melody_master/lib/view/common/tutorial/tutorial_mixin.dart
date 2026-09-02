import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:ai_golden_melody_master/common/lib/app_http/apis.dart';
import 'package:ai_golden_melody_master/common/lib/app_http/http_utils.dart';
import 'package:ai_golden_melody_master/view/publish/beans/zone_menus_bean.dart';
import 'package:ai_golden_melody_master/view/publish/beans/strategy_list_bean.dart';

/// 通用教程逻辑mixin
/// 包含教程tab、数据管理、切换等通用逻辑
/// 只请求第一页内容，不包含分页逻辑
mixin TutorialMixin on GetxController {
  /// 当前选中的教程标签索引（响应式变量）
  final selectedTutorialTab = 0.obs;

  /// 教程tab数据
  RxList<ZoneMenusBean> tutorialTabs = RxList<ZoneMenusBean>();

  /// 教程数据 - key为tab索引，value为该tab的数据列表
  Map<int, RxList<StrategyListBean>> tutorialDataMap = {};

  /// 教程内容页面控制器，用于PageView的页面切换
  final PageController tutorialPageController = PageController();

  /// 教程标签滚动控制器，用于水平滚动标签列表
  final ScrollController tutorialTabScrollController = ScrollController();

  /// 教程标签宽度映射表，用于计算自动滚动位置
  /// key: 标签索引, value: 标签宽度
  Map<int, double> tutorialItemWidths = {};

  @override
  void onInit() {
    super.onInit();
    getCategoryList();
  }

  @override
  void onClose() {
    tutorialPageController.dispose();
    tutorialTabScrollController.dispose();
    super.onClose();
  }

  /// 获取分类列表
  void getCategoryList() {
    HttpUtils.get(
        APIs.strategygetCategoryList, {"type": 'ai_music_app_guide_guide'},
        success: (data) {
      final List items = data["data"] ?? [];
      final List<ZoneMenusBean> records =
          items.map((ele) => ZoneMenusBean.fromJson(ele)).toList();

      // 更新tabs数据，这会触发UI更新
      tutorialTabs.value = records;

      // 初始化每个tab的数据结构
      for (int i = 0; i < records.length; i++) {
        tutorialDataMap[i] = RxList<StrategyListBean>();
      }

      // 加载第一个tab的数据
      if (records.isNotEmpty) {
        loadTutorialData(0);
      }

      // 确保UI更新，使用Future.delayed确保在下一个帧中更新
      Future.delayed(const Duration(milliseconds: 100), () {
        update();
      });
    }, fail: (code, msg) {
      EasyLoading.showToast(msg);
      // 即使失败也要更新UI，避免一直显示加载状态
      update();
    });
  }

  /// 加载教程数据 - 只请求第一页
  void loadTutorialData(int tabIndex) {
    if (tutorialTabs.isEmpty || tabIndex >= tutorialTabs.length) {
      return;
    }

    final groupId = tutorialTabs[tabIndex].id ?? 0;

    HttpUtils.get(APIs.getStrategyGuideList, {
      "type": "ai_music_app_guide_guide",
      "group_id": groupId,
      "page": 1,
      "pageSize": 10,
    }, success: (data) {
      final List items = data["data"]["data"] ?? [];
      final List<StrategyListBean> records =
          items.map((ele) => StrategyListBean.fromJson(ele)).toList();

      // 更新数据
      tutorialDataMap[tabIndex]?.value = records;

      update();
    }, fail: (code, msg) {
      EasyLoading.showToast(msg);
    });
  }

  /// 更新选中的教程tab
  void updateSelectedTutorialTab(int index) {
    // 如果点击的是当前选中的标签，不需要重复处理
    if (selectedTutorialTab.value == index) return;

    // 先加载数据，再更新选中状态，避免页面重建
    if (!tutorialDataMap.containsKey(index) ||
        tutorialDataMap[index]!.isEmpty) {
      loadTutorialData(index);
    }

    selectedTutorialTab.value = index;

    // 检查PageController是否已附加到滚动视图
    if (tutorialPageController.hasClients) {
      tutorialPageController.jumpToPage(index);
    }

    _scrollToSelectedTutorialTab(index);
  }

  /// 滚动到选中的tab对应列表
  void _scrollToSelectedTutorialTab(int index) {
    double offset = 0;
    for (var i = 0; i < index; i++) {
      offset += tutorialItemWidths[i] ?? 0;
    }

    // 计算居中偏移
    final screenWidth = Get.width;
    final itemWidth = tutorialItemWidths[index] ?? 0;
    final containerWidth = screenWidth - 24; // 假设左右各12的padding

    offset = offset - (containerWidth - itemWidth) / 2;

    if (tutorialTabScrollController.hasClients) {
      final maxScrollExtent =
          tutorialTabScrollController.position.maxScrollExtent;
      tutorialTabScrollController.animateTo(
        offset.clamp(0.0, maxScrollExtent),
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  /// 处理tutorial页面切换
  void onTutorialPageChanged(int index) {
    // 只有当索引真正改变时才更新
    if (selectedTutorialTab.value != index) {
      selectedTutorialTab.value = index;
      _scrollToSelectedTutorialTab(index);

      // 如果该tab还没有数据，则加载数据
      if (!tutorialDataMap.containsKey(index) ||
          tutorialDataMap[index]!.isEmpty) {
        loadTutorialData(index);
      }
    }
  }

  /// 获取指定tab的数据列表
  RxList<StrategyListBean> getTutorialData(int tabIndex) {
    return tutorialDataMap[tabIndex] ?? RxList<StrategyListBean>();
  }
}
