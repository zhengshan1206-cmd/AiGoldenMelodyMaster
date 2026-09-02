import 'package:ai_golden_melody_master/view/publish/beans/zone_menus_bean.dart';
import 'package:ai_golden_melody_master/view/publish/widget/strategy_item_view.dart';
import 'package:ai_golden_melody_master/view/publish/controller/strategy_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class StrategyPageView extends StatelessWidget {
  const StrategyPageView({
    super.key,
    required this.pageController,
    required this.onPageChanged,
    required this.tabs,
  });

  final PageController pageController;
  final void Function(int index) onPageChanged;
  final List<ZoneMenusBean> tabs;

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
        return StrategyListPage(
          categoryBean: bean,
          index: index,
        );
      },
    );
  }
}

class StrategyListPage extends StatefulWidget {
  const StrategyListPage({
    super.key,
    required this.index,
    required this.categoryBean,
  });

  final int index;
  final ZoneMenusBean categoryBean;

  @override
  State<StrategyListPage> createState() => _StrategyListPageState();
}

class _StrategyListPageState extends State<StrategyListPage>
    with AutomaticKeepAliveClientMixin {
  final StrategyController _controller = Get.find<StrategyController>();

  /// 当前页面的刷新控制器
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _refresh(context: context, showLoading: true);
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
    // 不检查任何状态，直接尝试加载
    // 让 SmartRefresher 自己处理上拉状态
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
          setState(() {});
        },
      );
    } catch (e) {
      print("_loadMore error: $e");
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
      print("_refresh error: $e");
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
