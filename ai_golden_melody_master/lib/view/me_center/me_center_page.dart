import 'dart:io';

import 'package:ai_golden_melody_master/utils/assets.dart';
import 'package:ai_golden_melody_master/view/lanuch_page/launch_controller.dart';
import 'package:ai_golden_melody_master/view/me_center/me_center_controller.dart';
import 'package:ai_golden_melody_master/view/publish/widget/banner_widget.dart';
import 'package:ai_golden_melody_master/view/purchase/diaglog/come_back_pay_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../common/lib/app_common/consts/build_config.dart';
import '../../common/lib/app_http/channel.dart';
import '../../model/user/user_info_bean.dart';
import '../../navigator/app_pages.dart';
import '../../utils/by_color_utils.dart';
import '../publish/widget/strstegy_tab_view.dart';
import '../publish/widget/tutorial_single_page_view.dart';
import '../purchase/diaglog/buy_bottom_dialog.dart';
import '../purchase/diaglog/close_guide_dialog.dart';
import '../purchase/diaglog/no_free_time_pay_dialog.dart';
import '../purchase/vip/vip_purchase_controller.dart';

///个人中心页面
class MeCenterPage extends StatefulWidget {
  const MeCenterPage({super.key});

  @override
  State<MeCenterPage> createState() => _MeCenterPageState();
}

class _MeCenterPageState extends State<MeCenterPage> {
  final MeCenterController _controller = Get.find<MeCenterController>();

  // 添加ScrollController来保持滚动位置
  final ScrollController _scrollController = ScrollController();

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
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  ///顶部区域
  Widget topView({
    required LaunchController controller,
  }) {
    String bgPath = Assets.meBg1;
    if (controller.is30Vip) {
      bgPath = Assets.meBg2;
    } else if (controller.is90Vip) {
      bgPath = Assets.meBg3;
    } else if (controller.is365Vip) {
      bgPath = Assets.meBg4;
    }

    return Stack(
      // clipBehavior: Clip.none,
      children: [
        ///顶部背景图
        Image.asset(
          bgPath,
          width: 1.sw,
          height: 180.w,
          fit: BoxFit.fill,
        ),

        ///通知按钮 设置按钮
        Positioned(
          top: 52.w,
          right: 0,
          child: Row(
            children: [
              // const Spacer(),
              // Container(
              //   decoration: BoxDecoration(
              //       border: Border.all(
              //         color: const Color.fromRGBO(255, 255, 255, 0.1),
              //       ),
              //       color: const Color.fromRGBO(37, 37, 37, 0.8),
              //       borderRadius: BorderRadius.circular(28.w)),
              //   width: 28.w,
              //   height: 28.w,
              //   child: Image.asset(
              //     Assets.meMessageIcon,
              //     width: 28.w,
              //     height: 28.w,
              //     fit: BoxFit.fill,
              //   ),
              // ),
              SizedBox(
                width: 20.w,
              ),
              GestureDetector(
                onTap: () {
                  controller.goSettingPage();
                  // Get.find<LaunchController>().openNoMusicNoteAndOpenVipBgDialog();
                },
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color.fromRGBO(255, 255, 255, 0.1),
                      ),
                      color: const Color.fromRGBO(37, 37, 37, 0.8),
                      borderRadius: BorderRadius.circular(28.w)),
                  width: 28.w,
                  height: 28.w,
                  child: Image.asset(
                    Assets.meSettingIcon,
                    width: 28.w,
                    height: 28.w,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              SizedBox(
                width: 12.w,
              ),
            ],
          ),
        ),

        ///个人信息
        Positioned(
          top: 88.w,
          child: userInfoView(
            controller: controller,
          ),
        ),
      ],
    );
  }

  ///个人信息页面
  Widget userInfoView({required LaunchController controller}) {
    UserInfoBean? userInfoBean = controller.user.value;
    String isVipIcon = Assets.noVipIcon;
    String idPath = Assets.userNotLoginIcon;
    int level = 0;
    if (userInfoBean != null) {
      if (userInfoBean.isVip == 1) {
        isVipIcon = Assets.vipIcon;
      }
      if (userInfoBean.vipLevel == 30) {
        idPath = Assets.userLoginHeader;
      } else if (userInfoBean.vipLevel == 90) {
        idPath = Assets.userLoginHeader2;
      } else if (userInfoBean.vipLevel == 365) {
        idPath = Assets.userLoginHeader3;
      }
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ///头像区域
        InkResponse(
          onTap: () {
            if(!controller.isLogin){
              controller.login(source: "me_center");
            }
          },
          child: Container(
              width: 60.w,
              height: 60.w,
              margin: EdgeInsets.only(left: 24.w, right: 12.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.w),
                border: Border.all(
                  color: const Color(0XFF586464),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.w),
                child: Image.asset(
                  idPath,
                  width: 60.w,
                  height: 60.w,
                ),
              )),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10.w,
            ),
            GestureDetector(
                onTap: () {
                  controller.login(source: "me_center");
                },
                child: Row(
                  children: [
                    Text(
                      !controller.isLogin ? "立即登录" : userInfoBean!.nickName,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600),
                    ),
                    Image.asset(
                      isVipIcon,
                      width: 24.w,
                      height: 24.w,
                    )
                  ],
                )),
            SizedBox(
              height: 8.w,
            ),
            if (userInfoBean != null)
              GestureDetector(
                onTap: () {
                  controller.copyId();
                },
                child: Row(
                  children: [
                    Text(
                      "ID:${userInfoBean.userId}",
                      style: TextStyle(
                          color: const Color.fromRGBO(255, 255, 255, 0.5),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      width: 4.w,
                    ),
                    Image.asset(
                      Assets.copyIcon,
                      width: 12.w,
                      height: 12.w,
                    ),
                    // _inviteCode(),
                  ],
                ),
              )
          ],
        )
      ],
    );
  }

  ///banner vip 解锁
  Widget bannerView({required LaunchController controller}) {
    UserInfoBean? userInfoBean = controller.user.value;
    bool isLogin = false;
    if (userInfoBean != null) {
      if (userInfoBean.isFormal == 1) {
        isLogin = true;
      }
    }

    if (userInfoBean != null) {
      if (userInfoBean.isVip == 1) {
        String path = Assets.meVip1;
        String text = "创作会员";
        List<Color> colorsList = [
          Color(0xFF00CB64),
          Color(0xFF00CB64),
          Color(0xFF00E973),
          Color(0xFF06FF81),
          Color(0xFF00E973),
          Color(0xFF00CB64),
          Color(0xFF00CB64),
        ];
        if (userInfoBean.vipLevel == 30) {
          path = Assets.meVip1;
        } else if (userInfoBean.vipLevel == 90) {
          path = Assets.meVip2;
          text = "高级会员";
          colorsList = [
            Color(0xFFC98465),
            Color(0xFFC98465),
            Color(0xFFE69977),
            Color(0xFFF5AD8C),
            Color(0xFFF4B69A),
            Color(0xFFC98465),
            Color(0xFFC98465),
          ];
        } else if (userInfoBean.vipLevel == 365) {
          path = Assets.meVip3;
          text = "尊享会员";
          colorsList = [
            Color(0xFFCCA869),
            Color(0xFFD8B16D),
            Color(0xFFE1B870),
            Color(0xFFFFDA98),
            Color(0xFFFDD692),
            Color(0xFFD7B06D),
            Color(0xFFCCA869),
          ];
        }

        return InkResponse(
            onTap: () {
              controller.goToVipRightPage();
            },
            child: Stack(
              children: [
                Image.asset(
                  path,
                  height: 60.w,
                  fit: BoxFit.fill,
                  width: 1.sw,
                ),
                Positioned(
                    top: 10.w,
                    left: 15.w,
                    child: SizedBox(
                      width: 72,
                      height: 24,
                      child: ShaderMask(
                        blendMode: BlendMode.srcIn,
                        shaderCallback: (bounds) => LinearGradient(
                          begin: const Alignment(-0.54, -0.84), // 对应123.89°角度
                          end: const Alignment(0.54, 0.84),
                          colors: colorsList,
                          stops: const [0.0, 0.18, 0.32, 0.42, 0.56, 0.77, 1.0],
                        ).createShader(bounds),
                        child: Text(
                          text,
                          style: const TextStyle(
                            fontFamily: 'PingFang SC',
                            fontWeight: FontWeight.w800,
                            fontSize: 18,
                            height: 1.33, // 24px/18px
                            fontStyle: FontStyle.normal,
                            letterSpacing: 0, // 相当于text-transform:none
                            textBaseline: TextBaseline.alphabetic,
                          ),
                        ),
                      ),
                    )),
                Positioned(
                    top: 38.w,
                    left: 15.w,
                    child: Text(
                      "AI音乐高效创作工具",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontWeight: FontWeight.normal,
                        fontSize: 12.sp,
                      ),
                    ))
              ],
            ));
      }
    }

    return InkResponse(
      onTap: () {
        if (isLogin) {
          Get.put(VipPurchaseController());
          Get.find<VipPurchaseController>().loadData();
          controller.goToVipPage();
        } else {
          controller.login(source: "me_center");
        }
      },
      child: Image.asset(
        Assets.openVipBanner,
        height: 79.w,
        fit: BoxFit.fill,
        width: 1.sw,
      ),
    );
  }

  ///我的作品区域
  Widget myWorkView({
    required LaunchController controller,
  }) {
    return Row(
      children: [
        SizedBox(
          width: 12.w,
        ),
        _myWorkItemView(
          text: controller.myWorksNumber.toString(),
          title: "我的作品",
          iconPath: Assets.meMusicIcon,
          clickEvent: () {
            controller.goMyWorkPage();
          },
          text2: "首",
        ),
        const Spacer(),
        _myWorkItemView(
          text: controller.user.value != null
              ? controller.user.value!.integral.toString()
              : "0",
          title: "我的音符值",
          iconPath: Assets.meEarnIcon,
          clickEvent: () {
            controller.goMeMusicNodeValuePage();
          },
        ),
        const Spacer(),
        _myWorkItemView(
          text: "客服",
          title: "在线咨询",
          iconPath: Assets.meOnlineIcon,
          clickEvent: () {
            controller.openCustomerService();
          },
          type: 1,
        ),
        SizedBox(
          width: 12.w,
        ),
      ],
    );
  }

  Widget _myWorkItemView({
    required String text,
    required String title,
    required String iconPath,
    required VoidCallback clickEvent,
    String? text2,
    int type = 0,
  }) {
    int number = 0;
    double fontSize = 18.sp;
    if (type == 0) {
      number = int.parse(text);
      if (number < 9999) {
        fontSize = 22.sp;
      } else {
        fontSize = 18.sp;
      }
      Get.log("当前的数量===> $number  type===>$type fontSize===>$fontSize");
    }
    return GestureDetector(
      onTap: () {
        clickEvent();
      },
      child: Container(
        width: 109.w,
        height: 64.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1E1E1E),
              Color(0xFF2A2A2A),
            ],
          ),
        ),
        padding: EdgeInsets.only(left: 10.w, top: 8.w, bottom: 10.w),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      text,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: fontSize),
                    ),
                    if (text2 != null)
                      Padding(
                        padding: EdgeInsets.only(top: 5.w),
                        child: Text(
                          text2,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                              fontSize: 14.sp),
                        ),
                      ),
                  ],
                ),
                const Spacer(),
                Image.asset(
                  Assets.goNext,
                  width: 12.w,
                  height: 12.w,
                ),
                SizedBox(
                  width: 10.w,
                )
              ],
            ),
            const Spacer(),
            Row(
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: const Color.fromRGBO(255, 255, 255, 0.5),
                    fontSize: 12.sp,
                  ),
                ),
                const Spacer(),
                // Image.asset(
                //   iconPath,
                //   width: 38.w,
                //   height: 28.w,
                // ),
              ],
            )
          ],
        ),
      ),
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
  Widget _bannerView() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: const BannerWidget(
        height: 80.0,
        position: 7,
        topMargin: 12,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFF121212),
      body: CustomScrollView(
        controller: _scrollController,
        physics: const ClampingScrollPhysics(),
        slivers: [
          // 顶部内容
          SliverToBoxAdapter(
            child: Column(
              children: [
                Stack(
                  children: [
                    SizedBox(
                      child: GetBuilder<LaunchController>(
                        builder: (controller) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              topView(controller: controller),
                              SizedBox(
                                height: controller.isVip ? 52.w : 67.w,
                              ),
                              myWorkView(controller: controller),
                              _bannerView(),
                              SizedBox(
                                height: 15.h,
                              ),
                            ],
                          );
                        },
                      ),
                    ),

                    ///banner
                    Positioned(
                      top: 160.w,
                      right: 12.w,
                      left: 12.w,
                      child: GetBuilder<LaunchController>(
                        builder: (controller) {
                          return bannerView(
                            controller: controller,
                          );
                        },
                      ),
                    ),
                  ],
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
    );
  }
}

/// 自定义SliverPersistentHeaderDelegate实现吸顶效果
class _StickyTabDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double minHeight;
  final double maxHeight;
  final MeCenterController controller;

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
          // titleView with opacity

          // _inviteCode(),

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
