import 'package:ai_golden_melody_master/common/lib/app_ui/byhy_screen_utils.dart';
import 'package:ai_golden_melody_master/utils/by_color_utils.dart';
import 'package:ai_golden_melody_master/view/publish/controller/strategy_zone_controller.dart';
import 'package:ai_golden_melody_master/view/publish/widget/muti_status_view.dart';
import 'package:ai_golden_melody_master/view/publish/widget/strstegy_tab_view.dart';
import 'package:ai_golden_melody_master/view/publish/widget/strategy_item_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class StrategyZonePage extends GetView<StrategyZoneController> {
  StrategyZonePage({super.key});

  ///导航栏
  Widget buildNavBar() {
    return Container(
      width: double.infinity,
      height: 150.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/purchase/home/strategy_zoon_bg.png"),
          fit: BoxFit.fitHeight,
        ),
      ),
      child: Column(
        children: [
          SizedBox(
            height: ByScreenUtils.topSafeHeight,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: Icon(
                  Icons.arrow_back_ios_new,
                  size: 18.sp,
                  color: const Color(0XFFFFFFFF),
                ),
              ),
              Expanded(
                child: Text(
                  "音乐著作权和发行攻略专区",
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: const Color(0XFFFFFFFF),
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                width: 48.w,
              ),
            ],
          ),
          const Spacer(),
          tabBarView(),
          SizedBox(height: 2.w),
        ],
      ),
    );
  }

  ///tab
  Widget tabBarView() {
    return Obx(() => Container(
          decoration: BoxDecoration(
            color: const Color(0XFF2E2E2E),
            borderRadius: BorderRadius.circular(12.w),
          ),
          padding: EdgeInsets.all(3.w),
          height: 50.w,
          child: Row(
            children: [
              ...controller.modelList.map((e) => _tabBarItemView(
                    text: e.text,
                    type: e.type,
                    selectedType: controller.selectedType.value,
                    click: () {
                      controller.selectedTypeEvent(
                        type: e.type,
                      );
                    },
                  ))
            ],
          ),
        ));
  }

  ///主体 selectedType 0 著作者申请攻略 1 五大平台发行攻略
  Widget mainView() {
    return Container(
      padding: EdgeInsets.only(top: 12.w),
      child: Obx(
        () => controller.isLoading.value
            ? const Center(
                child: CircularProgressIndicator(
                  color: ByColorUtil.color00CB64,
                ),
              )
            : controller.tutorialTabs.isEmpty
                ? _noDataView()
                : NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification notification) {
                      if (notification is ScrollEndNotification) {
                        final metrics = notification.metrics;
                        if (metrics is PageMetrics) {
                          int currentPage = metrics.page!.round();
                          controller.onPageChanged(currentPage);
                        }
                      }
                      return false;
                    },
                    child: StrategyZonePageView(
                      pageController: controller.pageController,
                      tabs: controller.tutorialTabs,
                      onPageChanged: (int index) {
                        controller.onPageChanged(index);
                        _onPageChanged(index);
                      },
                    ),
                  ),
      ),
    );
  }

  /// 平台tab
  Widget platformTab() {
    return Obx(() {
      // 如果数据为空，不显示平台tab
      if (controller.tutorialTabs.isEmpty) {
        return const SizedBox.shrink();
      }

      return Container(
        padding: EdgeInsets.only(left: 12.w),
        height: 44.w,
        child: StrategyTabView(
          // 教程标签列表
          tabs: controller.tutorialTabs.value,
          // 当前选中的标签索引
          selectedTab: controller.selectedTutorialTab,
          // 水平滚动控制器
          scrollController: controller.tutorialTabScrollController,
          // 标签宽度映射表，用于自动滚动计算
          itemWidths: controller.tutorialItemWidths,
          // 标签切换回调，更新选中状态并触发页面切换
          onTabChanged: (index) {
            controller.updateSelectedTutorialTab(index);
          },
        ),
      );
    });
  }

  Widget _tabBarItemView({
    required String text,
    required int type,
    required int selectedType,
    required VoidCallback click,
  }) {
    return InkResponse(
      onTap: () {
        click();
      },
      child: Container(
        width: (1.sw - 30.w) / 2,
        decoration: BoxDecoration(
          color: type == selectedType
              ? ByColorUtil.color00CB64
              : Colors.transparent,
          borderRadius: BorderRadius.circular(
            10.w,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            color: type == selectedType
                ? ByColorUtil.colorF1
                : ByColorUtil.colorF2,
            fontWeight: FontWeight.w600,
            fontSize: 16.sp,
          ),
        ),
      ),
    );
  }

  ///无数据页面
  Widget _noDataView() {
    return const SizedBox.shrink();
    // return Column(
    //   mainAxisAlignment: MainAxisAlignment.center,
    //   children: [
    //     Image.asset(
    //       "assets/purchase/no_purchase_data_icon.png",
    //       width: 120.w,
    //       height: 120.w,
    //     ),
    //     Text(
    //       "暂无教程",
    //       style: TextStyle(
    //         color: Colors.white.withOpacity(0.5),
    //         fontSize: 14.sp,
    //         fontWeight: FontWeight.w500,
    //       ),
    //     )
    //   ],
    // );
  }

  void _onPageChanged(int index) {
    double offset = 0;
    for (var i = 0; i < index; i++) {
      offset += controller.tutorialItemWidths[i] ?? 0;
    }

    offset = offset -
        (Get.width - 24.w) / 2 +
        (controller.tutorialItemWidths[index] != null
                ? (controller.tutorialItemWidths[index]! - 8)
                : 0) /
            2;
    final maxScrollExtent =
        controller.tutorialTabScrollController.position.maxScrollExtent;

    controller.tutorialTabScrollController.animateTo(
      offset.clamp(0.0, maxScrollExtent),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFF121212),
      body: Obx(
        () => MultiStatusView(
          currentStatus: controller.statusType.value,
          child: Column(
            children: [
              buildNavBar(),
              Obx(() {
                return controller.selectedType.value == 0
                    ? const SizedBox.shrink()
                    : platformTab();
              }),
              Expanded(
                child: mainView(),
              ),
            ],
          ),
          action: () {
            controller.strategygetCategoryList();
          },
        ),
      ),
    );
  }
}

class StrategyZonePageView extends StatelessWidget {
  const StrategyZonePageView({
    super.key,
    required this.pageController,
    required this.onPageChanged,
    required this.tabs,
  });

  final PageController pageController;
  final void Function(int index) onPageChanged;
  final List<dynamic> tabs;

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: pageController,
      onPageChanged: onPageChanged,
      itemCount: tabs.length,
      scrollDirection: Axis.horizontal,
      physics: const PageScrollPhysics(),
      itemBuilder: (context, index) {
        final bean = tabs[index];
        return StrategyZoneListPage(
          categoryBean: bean,
          index: index,
        );
      },
    );
  }
}

class StrategyZoneListPage extends StatefulWidget {
  const StrategyZoneListPage({
    super.key,
    required this.index,
    required this.categoryBean,
  });

  final int index;
  final dynamic categoryBean;

  @override
  State<StrategyZoneListPage> createState() => _StrategyZoneListPageState();
}

class _StrategyZoneListPageState extends State<StrategyZoneListPage>
    with AutomaticKeepAliveClientMixin {
  final StrategyZoneController _controller = Get.find<StrategyZoneController>();

  /// 当前页面的刷新控制器
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    // 只有当该tab没有数据时才加载
    if (_controller.tutorialDataMap[widget.index]?.isEmpty ?? true) {
      _refresh(context: context, showLoading: true);
    }
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  // 上拉加载更多
  Future<void> _loadMore({
    required BuildContext context,
  }) async {
    try {
      _controller.loadTutorialData(
        widget.index,
        reset: false,
        onSuccess: (hasMore) {
          setState(() {});
          if (hasMore) {
            _refreshController.loadComplete();
          } else {
            _refreshController.loadNoData();
          }
        },
        onFailed: () {
          _refreshController.loadFailed();
        },
      );
    } catch (e) {
      _refreshController.loadFailed();
    }
  }

  // 下拉刷新
  Future<void> _refresh({
    bool showLoading = false,
    required BuildContext context,
  }) async {
    try {
      _controller.loadTutorialData(
        widget.index,
        reset: true,
        onSuccess: (hasMore) {
          _refreshController.resetNoData();
          _refreshController.refreshCompleted();
          setState(() {});
        },
        onFailed: () {
          _refreshController.refreshFailed();
        },
      );
    } catch (e) {
      _refreshController.refreshFailed();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Obx(() {
      final currentData = _controller.tutorialDataMap[widget.index];

      if (currentData == null || currentData.isEmpty) {
        return _noDataView();
      }

      return SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        controller: _refreshController,
        onRefresh: () => _refresh(context: context),
        onLoading: () => _loadMore(context: context),
        child: ListView(
          padding:
              EdgeInsets.only(top: 0.w, bottom: 0.h, left: 12.w, right: 12.w),
          children: [
            ...currentData.map(
              (e) => StrategyItemView(
                item: e,
                onTap: () {
                  _controller.openStrategyDetails(e);
                },
              ),
            ),
          ],
        ),
      );
    });
  }

  ///无数据页面
  Widget _noDataView() {
    return const SizedBox.shrink();
    // return Column(
    //   mainAxisAlignment: MainAxisAlignment.center,
    //   children: [
    //     Image.asset(
    //       "assets/purchase/no_purchase_data_icon.png",
    //       width: 120.w,
    //       height: 120.w,
    //     ),
    //     Text(
    //       "暂无教程",
    //       style: TextStyle(
    //         color: Colors.white.withOpacity(0.5),
    //         fontSize: 14.sp,
    //         fontWeight: FontWeight.w500,
    //       ),
    //     )
    //   ],
    // );
  }
}
