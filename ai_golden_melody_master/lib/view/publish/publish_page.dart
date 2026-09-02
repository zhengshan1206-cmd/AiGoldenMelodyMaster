import 'dart:async';
import 'package:ai_golden_melody_master/navigator/app_pages.dart';
import 'package:ai_golden_melody_master/utils/by_color_utils.dart';
import 'package:ai_golden_melody_master/view/common/btn_breathing_animation_widget.dart';
import 'package:ai_golden_melody_master/view/lanuch_page/launch_controller.dart';
import 'package:ai_golden_melody_master/view/publish/beans/banner_beans.dart';
import 'package:ai_golden_melody_master/view/publish/controller/publish_controller.dart';
import 'package:ai_golden_melody_master/view/publish/widget/banner_widget.dart';
import 'package:ai_golden_melody_master/view/publish/widget/member_contdown.dart';
import 'package:ai_golden_melody_master/view/publish/widget/scale_transition_widget.dart';
import 'package:ai_golden_melody_master/view/publish/widget/svga_player.dart';
import 'package:ai_golden_melody_master/view/purchase/diaglog/show_history_bottom_dialog.dart';
import 'package:flustars_flutter3/flustars_flutter3.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'dart:ui';
import '../../common/lib/app_common/event/common_event.dart';
import '../../utils/common_event.dart';
import '../../utils/data_service.dart';
import '../../utils/navigation_utils.dart';
import '../purchase/vip/vip_purchase_controller.dart';
import 'widget/strstegy_tab_view.dart';
import 'widget/tutorial_single_page_view.dart';

///发行页面
class PublishPage extends StatefulWidget {
  const PublishPage({super.key});

  @override
  State<PublishPage> createState() => _PublishPageState();
}

class _PublishPageState extends State<PublishPage> {
  final PublishController _controller = Get.put(PublishController());

  final LaunchController _launchController = Get.find<LaunchController>();

  // 添加ScrollController来保持滚动位置
  final ScrollController _scrollController = ScrollController();

  ///是否展示底部促销（只关联有历史订单）
  bool showHistoryOrder = false;

  ///是否展示右侧促销（只关联有历史订单）
  bool showHistoryOrder2 = false;


  ///监听订单事件
  late StreamSubscription<ShowHistoryOrderEvent> showHistoryOrderSub;

  @override
  void initState() {
    super.initState();
    // 监听tab切换，保持滚动位置
    ever(_controller.selectedTutorialTab, (int index) {
      // 延迟一帧后恢复滚动位置，确保页面重建完成
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          // 保持当前滚动位置
          final currentOffset = _scrollController.offset;
          if (currentOffset > 0) {
            _scrollController.jumpTo(currentOffset);
          }
        }
      });
    });

    initSub();

    DataService.onEvent(DataServiceEventName.homeShow, {});
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void initSub() {
    setState(() {
      showHistoryOrder = SpUtil.getBool("show_history_order", defValue: false) ?? false;
      showHistoryOrder2 = SpUtil.getBool("show_history_order2", defValue: false) ?? false;

    });
    showHistoryOrderSub = eventBus.on<ShowHistoryOrderEvent>().listen((e) {
      if (mounted) {
        setState(() {
          showHistoryOrder = SpUtil.getBool("show_history_order", defValue: false) ?? false;
          showHistoryOrder2 = SpUtil.getBool("show_history_order2", defValue: false) ?? false;
        });
      }
    });
    Get.log("===showHistoryOrder=== $showHistoryOrder");

  }

  ///菜单栏
  Widget menuView() {
    return Obx(() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          menuItemView('assets/purchase/home/home_menu_1.png',
              _controller.musicHomeBean.value?.totalIssue ?? 0, '累计发行(首)'),
          menuItemView('assets/purchase/home/home_menu_2.png',
              _controller.musicHomeBean.value?.totalResidence ?? 0, '累计入住(人)'),
          menuItemView('assets/purchase/home/home_menu_3.png',
              _controller.musicHomeBean.value?.totalIncome ?? 0, '估累计收益(元)'),
        ],
      );
    });
  }

  ///菜单栏item
  Widget menuItemView(String bgUrl, int count, String title) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 113.w,
        height: 68.h,
        padding: EdgeInsets.only(top: 18.h, left: 10.h),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(bgUrl),
            fit: BoxFit.contain,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$count',
              style: TextStyle(
                fontSize: 22.sp,
                color: const Color(0XFF121212),
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 12.sp,
                color: const Color(0XFF121212).withOpacity(0.5),
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///精选作品
  Widget selectedView() {
    return Column(
      children: [
        titleView("精选作品", 1),
        SizedBox(height: 17.h),
        Obx(() {
          return SizedBox(
            height: _controller.musicSelectedList.value?.length != null &&
                    _controller.musicSelectedList.value!.length > 2
                ? 362.h // 有数据时的最高高度：2行 * 196.h + 间距
                : 182.h, // 无数据时的最低高度
            child: GridView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: (_controller.musicSelectedList.value?.length ?? 0) > 4
                  ? 4
                  : (_controller.musicSelectedList.value?.length ?? 0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 7.w,
                crossAxisSpacing: 7.w,
                childAspectRatio: 172.w / 172.h,
              ),
              itemBuilder: (context, index) => selectedItemView(index),
            ),
          );
        }),
      ],
    );
  }

  ///标题
  Widget titleView(String title, int index) {
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16.sp,
              color: const Color(0XFFFFFFFF),
              fontWeight: FontWeight.w600,
            ),
          ),
          GestureDetector(
            onTap: () {
              _controller.loadMore(index);
            },
            child: Container(
              width: 30.w,
              height: 20.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.w),
                border: Border.all(
                  color: const Color(0XFFFFFFFF).withOpacity(0.05),
                  width: 1.w,
                ),
              ),
              child: Center(
                child: Image.asset(
                  "assets/purchase/home/home_right_icon.png",
                  width: 14.w,
                  height: 14.h,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  ///精选作品列表
  Widget selectedList() {
    return GridView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 4,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 7.w,
        crossAxisSpacing: 7.w,
        childAspectRatio: 172.w / 172.h,
      ),
      itemBuilder: (context, index) => selectedItemView(index),
    );
  }

  ///精选作品item
  Widget selectedItemView(int index) {
    final item = _controller.musicSelectedList.value?[index];
    return GestureDetector(
      onTap: () {
        Get.toNamed(
          Routes.aiPlayMusicPage,
          arguments: {
            "type": 1,
            "id": item?.id,
          },
        );
        // eventBus.fire(PlayMusicDataEvent());
      },
      child: newSelectedView(index),
    );
  }

  Widget newSelectedView(int index) {
    final double overlap = 9.w; // 你可以根据实际效果调整
    final item = _controller.musicSelectedList.value?[index];
    final int count = item?.sharePlatform.length ?? 0;
    if (item == null) {
      return loadingView();
    }
    return Container(
      width: 172.w,
      height: 172.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.w),
        color: const Color(0XFF1E1E1E),
      ),
      child: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: 172.h,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.w),
              child: Image.network(
                item?.coverUrl ?? "",
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  // print("loadingProgress: $loadingProgress");
                  if (loadingProgress == null) return child;
                  return loadingView();
                },
                errorBuilder: (context, error, stackTrace) {
                  return loadingView();
                },
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              width: double.infinity,
              height: 172.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.w),
                color: Colors.black.withOpacity(0.3),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12.w),
                  bottomRight: Radius.circular(12.w),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          item?.name ?? "",
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 3.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (item.musicAuthor != "")
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.only(right: 4.h),
                                  child: Text(
                                    item.musicAuthor,
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: Colors.white.withOpacity(0.5),
                                      fontWeight: FontWeight.w400,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            Container(
                              height: 14.h,
                              alignment: Alignment.centerLeft,
                              width:
                                  count > 0 ? 14.w + (count - 1) * overlap : 0,
                              child: count > 0
                                  ? Stack(
                                      alignment: Alignment.centerRight,
                                      children: List.generate(
                                        count,
                                        (index) {
                                          return Positioned(
                                            left: index * overlap,
                                            child: Image.network(
                                              item.sharePlatform[index].icon,
                                              width: 14.w,
                                              height: 14.h,
                                            ),
                                          );
                                        },
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: 34.w,
                    height: 34.h,
                    margin: EdgeInsets.only(left: 12.h),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Image.asset(
                        "assets/purchase/home/home_play_icon.png",
                        width: 17.w,
                        height: 17.h,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget loadingView() {
    return Container(
      width: 172.w,
      height: 172.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.w),
        color: const Color(0XFF1E1E1E),
      ),
      child: Center(
        child: SizedBox(
          width: 56.w,
          height: 56.h,
          child: const SvgaPlayer(
            url: 'assets/home/img_loading.svga',
            isRepeat: true,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  ///作品旧版
  Widget oldSelectedView(int index) {
    final double overlap = 9.w; // 你可以根据实际效果调整
    final item = _controller.musicSelectedList.value?[index];
    final int count = item?.sharePlatform.length ?? 0;
    return Stack(
      children: [
        Container(
          height: 196.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.w),
            color: Colors.black,
            border: Border.all(
              color: const Color(0XFF1E1E1E),
              width: 1.w,
            ),
          ),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 172.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.w),
                    topRight: Radius.circular(12.w),
                  ),
                  // image: DecorationImage(
                  //     image: NetworkImage(item?.coverUrl ?? ""),
                  //     fit: BoxFit.cover),
                ),
                child: Stack(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 172.h,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12.w),
                          topRight: Radius.circular(12.w),
                        ),
                        child: Image.network(
                          item?.coverUrl ?? "",
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            // return Image.asset(
                            //   Assets.aiMusicBackground,
                            //   width: 52.w,
                            //   height: 52.h,
                            //   fit: BoxFit.cover,
                            // );
                            return SizedBox(
                              width: double.infinity,
                              height: 172.h,
                              child: const SvgaPlayer(
                                url: 'assets/home/img_loading.svga',
                                isRepeat: true,
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: Colors.black.withOpacity(0.15),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        width: double.infinity,
                        height: 32.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12.w),
                            topRight: Radius.circular(12.w),
                          ),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black,
                              Colors.black.withOpacity(0),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: ClipOval(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 4.88, sigmaY: 4.88),
                          child: Container(
                            width: 52.w,
                            height: 52.h,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Image.asset(
                                "assets/purchase/home/home_play_icon.png",
                                width: 26.w,
                                height: 26.h,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        width: double.infinity,
                        height: 32.h,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withOpacity(0),
                              Colors.black,
                            ],
                          ),
                          // border: Border(
                          //   bottom: BorderSide(
                          //     color: Colors.black,
                          //     width: 1.w,
                          //     style: BorderStyle.solid,
                          //   ),
                          // ),
                        ),
                        child: Container(
                          padding: EdgeInsets.only(
                            left: 10.w,
                            right: 32.w,
                            top: 12.h,
                          ),
                          child: Text(
                            item?.name ?? "",
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 10.w,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item?.musicAuthor ?? "",
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.white.withOpacity(0.5),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    // 叠加间距

                    Container(
                      height: 14.h,
                      alignment: Alignment.centerRight,
                      width: count > 0 ? 14.w + (count - 1) * overlap : 0,
                      child: count > 0
                          ? Stack(
                              alignment: Alignment.centerRight,
                              children: List.generate(
                                count,
                                (index) {
                                  return Positioned(
                                    left: index * overlap,
                                    child: Image.network(
                                      item?.sharePlatform[index].icon ?? "",
                                      width: 14.w,
                                      height: 14.h,
                                    ),
                                  );
                                },
                              ),
                            )
                          : const SizedBox.shrink(),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 172.h,
          left: 0,
          right: 0,
          child: Container(
            width: double.infinity,
            height: 1.h,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  ///精选创作教程tab
  Widget tutorialTabView() {
    final tabs = _controller.tutorialTabs.value;

    if (tabs.isEmpty) {
      return const SizedBox.shrink();
    }

    return StrategyTabView(
      // 教程标签列表
      tabs: tabs,
      // 当前选中的标签索引
      selectedTab: _controller.selectedTutorialTab,
      // 水平滚动控制器
      scrollController: _controller.tutorialTabScrollController,
      // 标签宽度映射表，用于自动滚动计算
      itemWidths: _controller.tutorialItemWidths,
      // 标签切换回调，更新选中状态并触发页面切换
      onTabChanged: (index) {
        _controller.updateSelectedTutorialTab(index);
      },
    );
  }

  ///精选创作教程
  Widget tutorialView() {
    return Obx(() {
      final tabs = _controller.tutorialTabs.value;
      final selectedTab = _controller.selectedTutorialTab.value;

      if (tabs.isEmpty) {
        return const SizedBox.shrink();
      }

      // 确保selectedTab在有效范围内
      final validTabIndex =
          selectedTab >= 0 && selectedTab < tabs.length ? selectedTab : 0;

      // 使用AnimatedSwitcher来平滑切换，避免页面重建
      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: TutorialSinglePageView(
          key: ValueKey(validTabIndex), // 使用key来标识不同的tab
          tabIndex: validTabIndex,
          controller: _controller,
        ),
      );
    });
  }

  /// 吸顶的Tab视图
  Widget stickyTabView() {
    // 这个方法现在只作为占位符，实际内容在_StickyTabDelegate中构建
    return Container();
  }

  ///banner
  Widget bannerView() {
    return BannerWidget(
      height: 80.0,
      position: 1,
      topMargin: 12,
      onBannerTap: (BannerBean banner) {},
      onBannerClose: () {},
    );
  }

  ///营销活动
  Widget marketingView() {
    return AnimatedOpacity(
      opacity: _controller.showBottomOperationView.value ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 400),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
        height: _controller.showBottomOperationView.value ? 80.h : 0,
        transform: Matrix4.translationValues(
          _controller.showBottomOperationView.value ? 0 : Get.width,
          0,
          0,
        ),
        child: GestureDetector(
          onTap: () {
            // 跳转付费页面
            _launchController.checkPreLogin(
                actionCallback: () {
                  _launchController.checkIsNewUser(true);
                  _launchController.goToVipPage();
                },
                source: "publish_page");
          },
          child: Stack(
            children: [
              SizedBox(
                width: double.infinity,
                height: 80.h,
              ),
              Positioned(
                top: 0,
                right: 19.w,
                child: Container(
                  height: 32.h,
                  padding: EdgeInsets.symmetric(horizontal: 2.w),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFFFF9A62), // #E9FD37
                        Color(0xFFFF3D1E), // #FEBF31
                      ],
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(6),
                      topRight: Radius.circular(6),
                    ),
                  ),
                  child: MemberCountdown(
                    fontSize: 14.sp,
                    textColor: ByColorUtil.colorF1,
                    bgColor: Colors.black,
                    separatorColor: ByColorUtil.colorF1,
                    timeItemWidth: 24.w,
                    borderRadius: 4.w,
                    showMilliseconds: true,
                  ),
                ),
              ),
              Positioned(
                top: 20.h,
                left: 0,
                right: 0,
                child: _launchController.homeBottomImage.isNotEmpty
                    ? Image.network(
                        _launchController.homeBottomImage,
                        height: 60.h,
                        fit: BoxFit.contain,
                      )
                    : Image.asset(
                        "assets/purchase/home_marketing_1.png",
                        height: 60.h,
                        fit: BoxFit.contain,
                      ),
              ),
              Positioned(
                bottom: 4.h,
                right: 4.w,
                child: ScaleTransitionWidget(
                  min: 0.95,
                  max: 1.05,
                  period: 500,
                  child: Image.asset(
                    "assets/purchase/home_marketing_btn_2.png",
                    width: 72.w,
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
              Positioned(
                top: 0.w,
                right: 0.w,
                child: GestureDetector(
                  onTap: () {
                    // 点击关闭按钮，关闭底部运营条
                    _controller.closeBottomOperation();
                  },
                  child: Padding(
                    padding: EdgeInsets.only(left: 12.w, bottom: 12.h),
                    child: Image.asset(
                      "assets/purchase/home_marketing_close_icon.png",
                      width: 12.w,
                      height: 12.w,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ///底部悬浮内容
  Widget bottomFloatingView() {
    if (showHistoryOrder) {
      return Positioned(
          bottom: 8.w, left: 0, right: 0, child: ShowHistoryBottomDialog());
    }
    return Obx(
      () {
        return Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            width: 1.sw,
            padding: EdgeInsets.symmetric(horizontal: 7.w),
            child: Column(
              children: [
                if (_launchController.user.value?.isVip == 0 &&
                    _launchController.user.value!.activeDay! <= 1)
                  marketingView(),
              ],
            ),
          ),
        );
      },
    );
  }

  ///折扣显示弹窗
  Widget discountDialog() {
    if(!showHistoryOrder2){
      return SizedBox();
    }
    return Positioned(
      bottom: 176.w,
      right: 3.w,
      child: DiscountDialog(),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     backgroundColor: const Color(0XFF121212),
  //     body: Stack(
  //       children: [
  //         NestedScrollView(
  //           // 设置外层滚动的物理特性，使用ClampingScrollPhysics避免滚动冲突
  //           physics: const ClampingScrollPhysics(),
  //           // 添加滚动协调器
  //           floatHeaderSlivers: true,
  //           headerSliverBuilder:
  //               (BuildContext context, bool innerBoxIsScrolled) {
  //             return [
  //               SliverToBoxAdapter(
  //                 child: Column(
  //                   children: [
  //                     Obx(() => Container(
  //                           width: 1.sw,
  //                           padding: EdgeInsets.only(
  //                               top: 0, left: 12.w, right: 12.w),
  //                           decoration: BoxDecoration(
  //                             image: DecorationImage(
  //                               image: _launchController
  //                                       .homeBgUrl.value.isNotEmpty
  //                                   ? NetworkImage(
  //                                       _launchController.homeBgUrl.value)
  //                                   : const AssetImage(
  //                                       "assets/purchase/home/home_top_bg.png"),
  //                               fit: BoxFit.fitWidth,
  //                               alignment: Alignment.topCenter,
  //                             ),
  //                           ),
  //                           child: Column(
  //                             children: [
  //                               SizedBox(height: 175.h),
  //                               Container(
  //                                 padding:
  //                                     EdgeInsets.symmetric(horizontal: 28.w),
  //                                 child: GestureDetector(
  //                                   onTap: () {
  //                                     // 使用导航工具类跳转到AI写歌Tab
  //                                     NavigationUtils.navigateToTab(1);
  //                                   },
  //                                   child: Image.asset(
  //                                     "assets/purchase/home/home_top_btn_bg.png",
  //                                     height: 60.h,
  //                                   ),
  //                                 ),
  //                               ),
  //                               SizedBox(height: 20.h),
  //                               menuView(),
  //                               bannerView(),
  //                               SizedBox(height: 23.h),
  //                               selectedView(),
  //                             ],
  //                           ),
  //                         )),
  //                   ],
  //                 ),
  //               ),
  //               // 吸顶的Tab视图
  //               SliverPersistentHeader(
  //                 pinned: true, // 设置为true实现吸顶效果
  //                 floating: false,
  //                 delegate: _StickyTabDelegate(
  //                   child: stickyTabView(),
  //                   minHeight: 76.h, // 最小高度：标题高度 + tab高度 + 间距
  //                   maxHeight: 76.h, // 最大高度：标题高度 + tab高度 + 间距
  //                   controller: _controller,
  //                 ),
  //               ),
  //             ];
  //           },
  //           body: NotificationListener<ScrollNotification>(
  //             onNotification: (ScrollNotification notification) {
  //               // 处理滚动通知，避免滚动冲突
  //               if (notification is ScrollEndNotification) {
  //                 final metrics = notification.metrics;
  //                 if (metrics is PageMetrics) {
  //                   int currentPage = metrics.page!.round();
  //                   _controller.onTutorialPageChanged(currentPage);
  //                 }
  //               }
  //               return false;
  //             },
  //             child: tutorialView(),
  //             // child: SizedBox(height: 10.h)
  //           ),
  //         ),
  //         bottomFloatingView(),
  //       ],
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFF121212),
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            physics: const ClampingScrollPhysics(),
            slivers: [
              // 顶部内容
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    Obx(
                      () => Container(
                        width: 1.sw,
                        padding:
                            EdgeInsets.only(top: 0, left: 12.w, right: 12.w),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: _launchController.homeBgUrl.value.isNotEmpty
                                ? NetworkImage(
                                    _launchController.homeBgUrl.value)
                                : const AssetImage(
                                    "assets/purchase/home/home_top_bg.png"),
                            fit: BoxFit.fitWidth,
                            alignment: Alignment.topCenter,
                          ),
                        ),
                        child: Column(
                          children: [
                            SizedBox(height: 175.h),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 28.w),
                              child: GestureDetector(
                                onTap: () {
                                  // 使用导航工具类跳转到AI写歌Tab
                                  NavigationUtils.navigateToTab(1);
                                },
                                // child: Image.asset(
                                //   "assets/purchase/home/home_top_btn_bg.png",
                                //   height: 60.h,
                                // ),
                                child: BtnBreathingAnimationWidget(
                                  child: Image.asset(
                                    "assets/purchase/home/home_top_btn_bg.png",
                                    height: 60.h,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 20.h),
                            menuView(),
                            bannerView(),
                            SizedBox(height: 23.h),
                            selectedView(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // 吸顶的Tab视图
              SliverPersistentHeader(
                pinned: true,
                floating: false,
                delegate: _StickyTabDelegate(
                  child: Container(), // 占位符，实际内容在delegate中构建
                  minHeight: 76.h,
                  maxHeight: 76.h,
                  controller: _controller,
                ),
              ),
              // 教程内容
              SliverToBoxAdapter(
                child: tutorialView(),
              ),
            ],
          ),
          bottomFloatingView(),
          discountDialog(),
        ],
      ),
    );
  }
}

/// 自定义SliverPersistentHeaderDelegate实现吸顶效果
class _StickyTabDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double minHeight;
  final double maxHeight;
  final PublishController controller;

  _StickyTabDelegate({
    required this.child,
    required this.minHeight,
    required this.maxHeight,
    required this.controller,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    // 获取状态栏高度
    final statusBarHeight = MediaQuery.of(context).padding.top;

    // 当shrinkOffset > 0时，说明已经开始滑动，背景色变为Color(0XFF121212)
    Color backgroundColor =
        shrinkOffset > 0 ? const Color(0XFF121212) : Colors.transparent;

    // 计算titleView的透明度
    // 当滑动距离接近状态栏高度时，titleView开始变透明
    double titleOpacity = 1.0;
    if (shrinkOffset > 0) {
      // 在状态栏高度范围内实现渐变透明效果
      titleOpacity = (statusBarHeight - shrinkOffset) / statusBarHeight;
      titleOpacity = titleOpacity.clamp(0.0, 1.0);
    }

    return Container(
      color: backgroundColor,
      child: _buildStickyContent(titleOpacity, context),
    );
  }

  Widget _buildStickyContent(double titleOpacity, BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Column(
        children: [
          SizedBox(height: 7.h),
          Opacity(
            opacity: titleOpacity,
            child: _buildTitleView(context),
          ),
          SizedBox(
            height: 44.h,
            child: _buildTabView(),
          ),
        ],
      ),
    );
  }

  Widget _buildTitleView(BuildContext context) {
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "精选创作教程",
            style: TextStyle(
              fontSize: 16.sp,
              color: const Color(0XFFFFFFFF),
              fontWeight: FontWeight.w600,
            ),
          ),
          GestureDetector(
            onTap: () {
              controller.loadMore(2);
            },
            child: Container(
              width: 30.w,
              height: 20.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.w),
                border: Border.all(
                  color: const Color(0XFFFFFFFF).withOpacity(0.05),
                  width: 1.w,
                ),
              ),
              child: Center(
                child: Image.asset(
                  "assets/purchase/home/home_right_icon.png",
                  width: 14.w,
                  height: 14.h,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabView() {
    return Obx(() {
      final tabs = controller.tutorialTabs.value;

      if (tabs.isEmpty) {
        return const SizedBox.shrink();
      }

      return StrategyTabView(
        // 教程标签列表
        tabs: tabs,
        // 当前选中的标签索引
        selectedTab: controller.selectedTutorialTab,
        // 水平滚动控制器
        scrollController: controller.tutorialTabScrollController,
        // 标签宽度映射表，用于自动滚动计算
        itemWidths: controller.tutorialItemWidths,
        // 标签切换回调，更新选中状态并触发页面切换
        onTabChanged: (index) {
          if (index >= 0 && index < tabs.length) {
            controller.updateSelectedTutorialTab(index);
          }
        },
      );
    });
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    if (oldDelegate is _StickyTabDelegate) {
      // 当tutorialTabs数据发生变化时，强制重建
      return controller.tutorialTabs.value.length !=
              oldDelegate.controller.tutorialTabs.value.length ||
          controller.selectedTutorialTab.value !=
              oldDelegate.controller.selectedTutorialTab.value;
    }
    return true;
  }
}
