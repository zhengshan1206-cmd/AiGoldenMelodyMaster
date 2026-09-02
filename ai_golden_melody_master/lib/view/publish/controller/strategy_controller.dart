import 'package:ai_golden_melody_master/common/lib/app_http/apis.dart';
import 'package:ai_golden_melody_master/common/lib/app_http/http_utils.dart';
import 'package:ai_golden_melody_master/navigator/app_pages.dart';
import 'package:ai_golden_melody_master/view/publish/beans/strategy_list_bean.dart';
import 'package:ai_golden_melody_master/view/publish/beans/zone_menus_bean.dart';
import 'package:ai_golden_melody_master/view/publish/widget/muti_status_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class StrategyController extends GetxController {
  ///tab分类列表
  RxList<ZoneMenusBean> tutorialTabs = RxList<ZoneMenusBean>();

  ///当前选中的tab
  RxInt selectedTutorialTab = 0.obs;

  /// 分页相关参数
  Map<int, int> pageMap = {}; // key: tab索引, value: 当前页码
  Map<int, bool> hasMoreMap = {}; // key: tab索引, value: 是否还有更多数据
  int pageSize = 10; // 修改为合理的分页大小

  /// 教程标签宽度映射表，用于计算自动滚动位置
  /// key: 标签索引, value: 标签宽度
  Map<int, double> tutorialItemWidths = {};

  /// 用于水平滚动标签列表
  ScrollController tutorialTabScrollController = ScrollController();

  /// 用于NestedScrollView的主滚动控制器
  ScrollController mainScrollController = ScrollController();

  /// 用于PageView的控制器
  PageController pageController = PageController();

  ///教程数据
  Map<int, RxList<StrategyListBean>> tutorialDataMap = {};

  /// 状态类型
  Rx<MultiStatusType> statusType = MultiStatusType.statusContent.obs;

  @override
  void onInit() {
    super.onInit();
    strategygetCategoryList();

    // 添加主滚动监听
    mainScrollController.addListener(_onScroll);
  }

  @override
  void onClose() {
    tutorialTabScrollController.dispose();
    mainScrollController.removeListener(_onScroll);
    mainScrollController.dispose();
    pageController.dispose();
    super.onClose();
  }

  /// 主滚动监听
  void _onScroll() {
    final offset = mainScrollController.offset;
    // 可以在这里处理滚动相关的逻辑
  }

  /// 滚动到选中的tab对应列表
  void _scrollToSelectedTutorialTab(int index) {
    if (tutorialItemWidths.isEmpty || !tutorialTabScrollController.hasClients) {
      return;
    }

    double offset = 0;
    for (var i = 0; i < index; i++) {
      offset += tutorialItemWidths[i] ?? 0;
    }

    // 计算居中偏移
    final screenWidth = Get.width;
    final itemWidth = tutorialItemWidths[index] ?? 0;
    final containerWidth = screenWidth - 24; // 左右各12的padding

    // 计算需要滚动到的位置，使选中的tab居中
    offset = offset - (containerWidth - itemWidth) / 2;

    final maxScrollExtent =
        tutorialTabScrollController.position.maxScrollExtent;
    final targetOffset = offset.clamp(0.0, maxScrollExtent);

    tutorialTabScrollController.animateTo(
      targetOffset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  /// 处理tab切换的公共逻辑
  void _handleTabChange(int index) {
    // 如果点击的是当前选中的标签，不需要重复处理
    if (selectedTutorialTab.value == index) return;

    selectedTutorialTab.value = index;

    // 滚动到选中的tab，使其居中显示
    _scrollToSelectedTutorialTab(index);

    // 如果该tab还没有数据，则加载数据
    if (!tutorialDataMap.containsKey(index) ||
        tutorialDataMap[index]!.isEmpty) {
      loadTutorialData(index, reset: true);
    }
    update(); // 通知UI更新
  }

  void updateSelectedTutorialTab(int index) {
    _handleTabChange(index);
  }

  /// 页面切换回调
  void onPageChanged(int index) {
    if (selectedTutorialTab.value != index) {
      selectedTutorialTab.value = index;

      // 滚动到选中的tab，使其居中显示
      _scrollToSelectedTutorialTab(index);

      // 如果该tab还没有数据，则加载数据
      if (!tutorialDataMap.containsKey(index) ||
          tutorialDataMap[index]!.isEmpty) {
        loadTutorialData(index, reset: true);
      }
      update(); // 通知UI更新
    }
  }

  ///跳转详情
  void openStrategyDetails(StrategyListBean bean) {
    Get.toNamed(Routes.strategyDetailsPage, arguments: {
      "id": bean.id,
      "type": "ai_music_app_guide_guide",
      "groupId": tutorialTabs.value[selectedTutorialTab.value].id,
    });
  }

  ///获取分类列表
  void strategygetCategoryList() {
    HttpUtils.get(
        APIs.strategygetCategoryList, {"type": 'ai_music_app_guide_guide'},
        success: (data) {
      final List items = data["data"] ?? [];
      final List<ZoneMenusBean> records =
          items.map((ele) => ZoneMenusBean.fromJson(ele)).toList();
      tutorialTabs.value = records;

      // 初始化每个tab的数据结构
      for (int i = 0; i < records.length; i++) {
        tutorialDataMap[i] = RxList<StrategyListBean>();
        pageMap[i] = 1;
        hasMoreMap[i] = true;
      }

      // 加载第一个tab的数据
      if (records.isNotEmpty) {
        loadTutorialData(0, reset: true);
      }
      statusType.value = MultiStatusType.statusContent;
      update(); // 通知UI更新
    }, fail: (code, msg) {
      // EasyLoading.showToast(msg);
      statusType.value = MultiStatusType.statusNoNetWork;
    });
  }

  /// 检查指定tab是否还有更多数据
  bool hasMoreDataForTab(int tabIndex) {
    return hasMoreMap[tabIndex] ?? false;
  }

  /// 检查当前tab是否还有更多数据
  bool hasMoreDataForCurrentTab() {
    final currentTab = selectedTutorialTab.value;
    return hasMoreMap[currentTab] ?? false;
  }

  /// 加载教程数据 - 用于初始化和tab切换
  void loadTutorialData(
    int tabIndex, {
    bool reset = false,
    Function(bool hasMore)? onSuccess,
    VoidCallback? onFailed,
  }) {
    if (tutorialTabs.isEmpty || tabIndex >= tutorialTabs.length) {
      return;
    }

    if (reset) {
      pageMap[tabIndex] = 1;
      tutorialDataMap[tabIndex]?.clear();
      hasMoreMap[tabIndex] = true;
    }

    final currentPage = pageMap[tabIndex] ?? 1;
    final groupId = tutorialTabs[tabIndex].id ?? 0;

    HttpUtils.get(
      APIs.getStrategyGuideList,
      {
        "type": "ai_music_app_guide_guide",
        "group_id": groupId,
        "page": currentPage,
        "pageSize": pageSize,
      },
      success: (data) {
        if (data == null || data["data"] == null) {
          EasyLoading.showToast("获取攻略列表失败");
          return;
        }

        final List items = data["data"]["data"] ?? [];
        final List<StrategyListBean> records =
            items.map((ele) => StrategyListBean.fromJson(ele)).toList();

        if (records.isNotEmpty) {
          if (reset) {
            tutorialDataMap[tabIndex]?.clear();
            tutorialDataMap[tabIndex]?.addAll(records);
            // 刷新时，始终允许上拉
            hasMoreMap[tabIndex] = true;
            pageMap[tabIndex] = 2; // 下次加载第2页
          } else {
            tutorialDataMap[tabIndex]?.addAll(records);
            // 只有上拉加载时，才根据返回数据量判断是否还有更多
            if (records.length >= pageSize) {
              pageMap[tabIndex] = (pageMap[tabIndex] ?? 1) + 1;
              hasMoreMap[tabIndex] = true;
            } else {
              hasMoreMap[tabIndex] = false;
            }
          }
          // 调用成功回调
          onSuccess?.call(hasMoreMap[tabIndex] ?? false);
        } else {
          if (reset) {
            // 刷新时，只有本地和服务器都没数据才禁止上拉
            if ((tutorialDataMap[tabIndex]?.isEmpty ?? true)) {
              hasMoreMap[tabIndex] = false;
            } else {
              hasMoreMap[tabIndex] = true;
            }
          } else {
            hasMoreMap[tabIndex] = false;
          }
          onSuccess?.call(hasMoreMap[tabIndex] ?? false);
        }
        update(); // 通知UI更新
      },
      fail: (code, msg) {
        EasyLoading.showToast(msg);
        onFailed?.call();
      },
    );
  }
}
