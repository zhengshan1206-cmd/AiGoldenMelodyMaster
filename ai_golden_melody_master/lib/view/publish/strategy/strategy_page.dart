import 'package:ai_golden_melody_master/common/lib/app_ui/byhy_screen_utils.dart';
import 'package:ai_golden_melody_master/view/publish/controller/strategy_controller.dart';
import 'package:ai_golden_melody_master/view/publish/widget/muti_status_view.dart';
import 'package:ai_golden_melody_master/view/publish/widget/strategy_sliver_pinned_header_view.dart';
import 'package:ai_golden_melody_master/view/publish/widget/strategy_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class StrategyPage extends StatefulWidget {
  const StrategyPage({super.key});

  @override
  State<StrategyPage> createState() => _StrategyPageState();
}

class _StrategyPageState extends State<StrategyPage> {
  final StrategyController _controller = Get.find<StrategyController>();

  /// 列表项宽度
  final Map<int, double> _itemWidths = {};

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFF121212),
      body: Stack(
        children: [
          _buildBody(context),
          _buildAppBar(context),
        ],
      ),
    );
  }

  _buildBody(BuildContext context) {
    return Obx(() {
      final categoryBeans = _controller.tutorialTabs;

      return MultiStatusView(
        currentStatus: _controller.statusType.value,
        child: NestedScrollView(
          /// 限制 NestedScrollView 的滚动行为
          physics: const ClampingScrollPhysics(),
          controller: _controller.mainScrollController,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              StrategySliverPinnedHeaderView(
                categoryScrollController:
                    _controller.tutorialTabScrollController,
                pageController: _controller.pageController,
                onSize: (Size size, int index) {
                  _itemWidths[index] = size.width;
                  // 同时更新控制器中的宽度映射
                  _controller.tutorialItemWidths[index] = size.width;
                },
                tabs: categoryBeans,
                selectedTab: _controller.selectedTutorialTab,
                onTabChanged: (index) {
                  _controller.updateSelectedTutorialTab(index);
                },
                itemWidths: _controller.tutorialItemWidths,
              ),
            ];
          },
          body: categoryBeans.isEmpty
              ? _noDataView()
              : NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification notification) {
                    if (notification is ScrollEndNotification) {
                      final metrics = notification.metrics;
                      if (metrics is PageMetrics) {
                        int currentPage = metrics.page!.round();
                        _controller.onPageChanged(currentPage);
                      }
                    }
                    return false;
                  },
                  child: StrategyPageView(
                    pageController: _controller.pageController,
                    tabs: categoryBeans,
                    onPageChanged: (int index) {
                      _onPageChanged(index, context);
                    },
                  ),
                ),
        ),
        action: () async {
          _controller.strategygetCategoryList();
        },
      );
    });
  }

  Positioned _buildAppBar(BuildContext context) {
    return Positioned(
      top: ByScreenUtils.topSafeHeight,
      left: 10.w,
      child: GestureDetector(
        onTap: () {
          Get.back();
        },
        child: Container(
          width: 32.w,
          height: 32.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.w),
          ),
          child: Icon(
            Icons.arrow_back_ios_new,
            size: 18.sp,
            color: const Color(0XFFFFFFFF),
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

  void _onPageChanged(int index, BuildContext context) {
    // 直接调用控制器的页面切换方法，让控制器统一处理滚动逻辑
    _controller.onPageChanged(index);
  }
}
