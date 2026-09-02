import 'package:ai_golden_melody_master/view/publish/beans/banner_beans.dart';
import 'package:ai_golden_melody_master/view/publish/beans/zone_menus_bean.dart';
import 'package:ai_golden_melody_master/view/publish/widget/banner_widget.dart';
import 'package:ai_golden_melody_master/view/publish/widget/strstegy_tab_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class StrategySliverPinnedHeaderView extends StatefulWidget {
  const StrategySliverPinnedHeaderView({
    super.key,
    required this.categoryScrollController,
    required this.pageController,
    required this.onSize,
    required this.tabs,
    required this.selectedTab,
    required this.onTabChanged,
    required this.itemWidths,
  });

  final ScrollController categoryScrollController;
  final PageController pageController;
  final void Function(Size size, int index) onSize;
  final List<ZoneMenusBean> tabs;
  final RxInt selectedTab;
  final Function(int) onTabChanged;
  final Map<int, double> itemWidths;

  @override
  State<StrategySliverPinnedHeaderView> createState() =>
      _StrategySliverPinnedHeaderViewState();
}

class _StrategySliverPinnedHeaderViewState
    extends State<StrategySliverPinnedHeaderView> {
  // 跟踪banner是否显示
  bool _showBanner = true;
  final double _bannerHeight = 80.0;

  @override
  Widget build(BuildContext context) {
    final categoryH = widget.tabs.isEmpty ? 0.0 : 50.h;
    final topPaddingH = 146.h; // 顶部背景图片的高度

    // 根据banner显示状态调整高度
    final bannerH = _showBanner ? _bannerHeight : 0.0;
    final minH = topPaddingH + categoryH + bannerH;
    final maxH = categoryH + topPaddingH + bannerH;

    return SliverPersistentHeader(
      pinned: true,
      delegate: StickyHeaderDelegate(
        minHeight: minH,
        maxHeight: maxH,
        child: Stack(
          children: [
            SizedBox(
              height: maxH,
              width: double.infinity,
            ),
            // 背景图片
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Image.asset(
                    "assets/purchase/home/strategy_bg_1.png",
                    width: double.infinity,
                    height: 150.h,
                    fit: BoxFit.fitHeight,
                  ),
                  // 只有当banner显示时才显示banner容器
                  if (_showBanner)
                    Container(
                      width: double.infinity,
                      color: const Color(0XFF121212),
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: BannerWidget(
                        height: _bannerHeight,
                        position: 200,
                        onBannerClose: () {
                          setState(() {
                            _showBanner = false;
                          });
                        },
                        onBannerDataLoaded: (List<BannerBean> banners) {
                          setState(() {
                            _showBanner = banners.isNotEmpty;
                          });
                        },
                      ),
                    )
                ],
              ),
            ),
            // Tab栏
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: categoryH,
                padding: EdgeInsets.only(left: 12.h),
                color: const Color(0XFF121212),
                child: StrategyTabView(
                  tabs: widget.tabs,
                  selectedTab: widget.selectedTab,
                  scrollController: widget.categoryScrollController,
                  itemWidths: widget.itemWidths,
                  onTabChanged: (index) {
                    // 先更新选中的tab，这会触发滚动到居中位置
                    widget.onTabChanged(index);

                    // 然后切换到对应的页面
                    if (widget.pageController.hasClients) {
                      widget.pageController.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  StickyHeaderDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxExtent ||
        minHeight != oldDelegate.minExtent;
  }
}
