import 'package:ai_golden_melody_master/common/lib/app_http/apis.dart';
import 'package:ai_golden_melody_master/common/lib/app_http/http_utils.dart';
import 'package:ai_golden_melody_master/view/publish/beans/music_selected_bean.dart';
import 'package:ai_golden_melody_master/view/publish/beans/ranking_tab_list_bean.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class PurchaseRankingController extends GetxController {
  final RxList<RankingTabListBean> tabList = RxList<RankingTabListBean>([]);

  ///选中的tab索引
  final RxInt selectedTabIndex = 0.obs;

  /// 存储每个tab对应的歌曲列表
  final Map<int, RxList<MusicSelectedBean>> songListsMap = {};

  // 已加载过的tab id
  final Set<int> loadedTabIds = {};

  // 添加控制器
  final PageController tutorialPageController =
      PageController(viewportFraction: 0.8);
  final ScrollController tutorialTabScrollController = ScrollController();
  final Map<int, double> tutorialItemWidths = {};

  @override
  void onInit() {
    super.onInit();
    getCategoryList();
  }

  ///更新选中的tab索引
  void updateSelectedTutorialTab(int index) {
    print('Updating selected tab to: $index');
    selectedTabIndex.value = index;

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

  /// PageView页面切换时调用，联动tab
  void onPageChanged(int index) {
    selectedTabIndex.value = index;
    _scrollToSelectedTutorialTab(index);
    // 懒加载
    if (tabList.isNotEmpty && index < tabList.length) {
      final categoryId = tabList[index].id;
      if (!loadedTabIds.contains(categoryId)) {
        getRankingList(categoryId);
      }
    }
  }

  /// tab点击时联动PageView
  void jumpToPage(int index) {
    tutorialPageController.jumpToPage(index);
    updateSelectedTutorialTab(index);
    // 懒加载
    if (tabList.isNotEmpty && index < tabList.length) {
      final categoryId = tabList[index].id;
      if (!loadedTabIds.contains(categoryId)) {
        getRankingList(categoryId);
      }
    }
  }

  ///获取歌曲榜单分类列表
  void getCategoryList() {
    HttpUtils.get(APIs.getCategoryList, {}, success: (data) {
      if (data != null && data['data'] != null) {
        final List items = data["data"] ?? [];
        final List<RankingTabListBean> records =
            items.map((ele) => RankingTabListBean.fromJson(ele)).toList();
        tabList.value = records;

        // 初始化每个tab的歌曲列表
        for (var tab in records) {
          songListsMap[tab.id] = RxList<MusicSelectedBean>([]);
        }

        // 只请求前两个tab的数据
        if (records.isNotEmpty) getRankingList(records[0].id);
        if (records.length > 1) getRankingList(records[1].id);
      }
      update();
    }, fail: (code, msg) {
      EasyLoading.showToast(msg);
    });
  }

  ///获取歌曲榜单列表
  void getRankingList(int categoryId) {
    // 已加载过就不再请求
    if (loadedTabIds.contains(categoryId)) return;
    loadedTabIds.add(categoryId);
    HttpUtils.get(APIs.getRankWorks, {"group_id": categoryId}, success: (data) {
      if (data != null && data['data'] != null) {
        final List items = data["data"] ?? [];
        final List<MusicSelectedBean> records =
            items.map((ele) => MusicSelectedBean.fromJson(ele)).toList();

        // 更新对应tab的歌曲列表
        songListsMap[categoryId]?.value = records;
      }
      update();
    }, fail: (code, msg) {
      EasyLoading.showToast(msg);
    });
  }

  /// 获取指定tab的歌曲列表
  RxList<MusicSelectedBean> getSongListForTab(int tabIndex) {
    if (tabIndex < tabList.length) {
      final categoryId = tabList[tabIndex].id;
      return songListsMap[categoryId] ?? RxList<MusicSelectedBean>([]);
    }
    return RxList<MusicSelectedBean>([]);
  }
}
