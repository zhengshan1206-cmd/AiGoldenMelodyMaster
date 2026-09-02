import 'dart:ui';

import 'package:ai_golden_melody_master/common/lib/app_ui/byhy_screen_utils.dart';
import 'package:ai_golden_melody_master/navigator/app_pages.dart';
import 'package:ai_golden_melody_master/utils/assets.dart';
import 'package:ai_golden_melody_master/utils/navigation_utils.dart';
import 'package:ai_golden_melody_master/view/lanuch_page/launch_controller.dart';
import 'package:ai_golden_melody_master/view/publish/controller/purchase_ranking_controller.dart';
import 'package:ai_golden_melody_master/view/publish/beans/music_selected_bean.dart';
import 'package:ai_golden_melody_master/view/publish/widget/svga_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../common/lib/app_common/event/common_event.dart';
import '../../utils/common_event.dart';
import '../common/btn_breathing_animation_widget.dart';

class PurchaseRankingPage extends StatelessWidget {
  PurchaseRankingPage({super.key});

  final PurchaseRankingController _controller =
      Get.put(PurchaseRankingController());

  final LaunchController _launchController = Get.find<LaunchController>();

  ///返回按钮
  Widget _backButton() {
    return Positioned(
      top: ByScreenUtils.topSafeHeight,
      left: 12.w,
      child: GestureDetector(
        onTap: () {
          Get.back();
        },
        child: Container(
          width: 32.w,
          height: 32.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.w),
            color: Colors.black.withOpacity(0.3),
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

  ///tab切换列表
  Widget _tabList() {
    return Obx(() {
      return Container(
        width: 1.sw,
        height: 60.h,
        padding: EdgeInsets.only(left: 12.w, top: 11.w, bottom: 15.w),
        child: ListView.builder(
          controller: _controller.tutorialTabScrollController,
          scrollDirection: Axis.horizontal,
          itemCount: _controller.tabList.value.length,
          itemBuilder: (context, index) {
            return Obx(() {
              final isSelected = _controller.selectedTabIndex.value == index;
              return LayoutBuilder(
                builder: (context, constraints) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    final renderBox = context.findRenderObject() as RenderBox?;
                    if (renderBox != null) {
                      _controller.tutorialItemWidths[index] =
                          renderBox.size.width;
                    }
                  });

                  return GestureDetector(
                    onTap: () {
                      if (_controller.selectedTabIndex.value == index) return;
                      _controller.jumpToPage(index);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(right: 8.w),
                      padding: EdgeInsets.symmetric(horizontal: 13.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18.w),
                        border: Border.all(
                          width: 2.w,
                          color: isSelected
                              ? const Color(0xFFFFFFFF).withOpacity(0.1)
                              : Colors.transparent,
                        ),
                      ),
                      child: Row(
                        children: [
                          Opacity(
                            opacity: isSelected ? 1 : 0.5,
                            child: Image.asset(
                              "assets/purchase/home/ranking_icon_2.png",
                              width: 14.w,
                              height: 14.h,
                            ),
                          ),
                          Text(
                            _controller.tabList[index].title,
                            style: TextStyle(
                              color: isSelected
                                  ? const Color(0xFFFFFFFF)
                                  : const Color(0xFFFFFFFF).withOpacity(0.5),
                              fontSize: 14.sp,
                            ),
                          ),
                          Opacity(
                            opacity: isSelected ? 1 : 0.5,
                            child: Image.asset(
                              "assets/purchase/home/ranking_icon_3.png",
                              width: 14.w,
                              height: 14.h,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            });
          },
        ),
      );
    });
  }

  ///歌曲列表PageView
  Widget _songListPageView() {
    return Obx(() => Positioned(
          top: 304.h,
          left: 0,
          right: 0,
          bottom: 0,
          child: PageView.builder(
            controller: _controller.tutorialPageController,
            onPageChanged: _controller.onPageChanged,
            itemCount: _controller.tabList.value.length,
            padEnds: false,
            itemBuilder: (context, index) {
              return Obx(() {
                final songList = _controller.getSongListForTab(index);
                return Opacity(
                  opacity:
                      index == _controller.selectedTabIndex.value ? 1 : 0.5,
                  child: Container(
                    margin: EdgeInsets.only(
                      right: 0,
                      left: 12.w,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12.w),
                        topRight: Radius.circular(12.w),
                      ),
                      border: Border.all(
                        width: 1.w,
                        color: const Color(0xFFFFFFFF).withOpacity(0.1),
                      ),
                    ),
                    child: Stack(
                      children: [
                        // 背景图片
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: Image.asset(
                            "assets/purchase/home/ranking_module_bg_${(index % 3) + 1}.png",
                            width: double.infinity,
                            height: 185.h,
                            fit: BoxFit.fill,
                          ),
                        ),
                        // 渐变遮罩（从200.h开始）
                        Positioned(
                          top: 185.h,
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(12.w),
                                bottomRight: Radius.circular(12.w),
                              ),
                              color: const Color(0xFF2E2E2E).withOpacity(0.2),
                            ),
                          ),
                        ),
                        // 内容
                        Container(
                          padding: EdgeInsets.only(
                              left: 12.w, right: 12.w, top: 12.h),
                          child: songList.isEmpty
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircularProgressIndicator(
                                        color: const Color(0xFF24FECF),
                                        strokeWidth: 2.w,
                                      ),
                                      SizedBox(height: 16.h),
                                      Text(
                                        '加载中...',
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.5),
                                          fontSize: 14.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : ListView.builder(
                                  padding: EdgeInsets.zero,
                                  itemCount: songList.length,
                                  itemBuilder: (context, songIndex) {
                                    return _songListItem(
                                        songList[songIndex], songIndex);
                                  },
                                ),
                        ),
                      ],
                    ),
                  ),
                );
              });
            },
          ),
        ));
  }

  ///歌曲列表item
  Widget _songListItem(MusicSelectedBean song, int index) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(
          Routes.aiPlayMusicPage,
          arguments: {
            "type": 1,
            "id": song.id,
          },
        );
        // eventBus.fire(PlayMusicDataEvent());
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 15.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 64.w,
              height: 52.h,
              child: Stack(
                children: [
                  Positioned(
                    top: 5.h,
                    right: 0,
                    child: Image.asset(
                      "assets/purchase/home/ranking_icon_1.png",
                      width: 44.w,
                      height: 44.h,
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5.w),
                      child: song.coverUrl.isNotEmpty
                          ? Image.network(
                              song.coverUrl,
                              width: 52.w,
                              height: 52.h,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: const Color(0xFF1E1E1E),
                                  width: 52.w,
                                  height: 52.h,
                                  child: const SvgaPlayer(
                                    url: 'assets/home/img_loading.svga',
                                    isRepeat: true,
                                    fit: BoxFit.cover,
                                  ),
                                );
                              },
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Container(
                                  color: const Color(0xFF1E1E1E),
                                  width: 52.w,
                                  height: 52.h,
                                  child: const SvgaPlayer(
                                    url: 'assets/home/img_loading.svga',
                                    isRepeat: true,
                                    fit: BoxFit.cover,
                                  ),
                                );
                              },
                            )
                          : Container(
                              width: 52.w,
                              height: 52.h,
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(5.w),
                              ),
                              child: Icon(
                                Icons.music_note,
                                color: Colors.white.withOpacity(0.5),
                                size: 20.sp,
                              ),
                            ),
                    ),
                  ),
                  Positioned(
                    top: 16.h,
                    left: 16.w,
                    child: ClipOval(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 1.88, sigmaY: 1.88),
                        child: Container(
                          width: 20.w,
                          height: 20.h,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Image.asset(
                              "assets/purchase/home/home_play_icon.png",
                              width: 10.w,
                              height: 10.h,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 10.w,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    song.name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: 6.h,
                  ),
                  Text(
                    song.musicAuthor,
                    style: TextStyle(
                      color: const Color(0xFFFFFFFF).withOpacity(0.5),
                      fontSize: 12.sp,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFF121212),
      body: Stack(
        children: [
          Column(
            children: [
              Obx(() => Container(
                    width: 1.sw,
                    height: 244.h,
                    padding: EdgeInsets.only(top: 175.h),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: _launchController.rankingBgUrl.value.isNotEmpty
                              ? NetworkImage(
                                  _launchController.rankingBgUrl.value)
                              : const AssetImage(
                                  "assets/purchase/home/ranking_top_bg.png")),
                    ),
                    child: Center(
                      child: GestureDetector(
                        onTap: () {
                          // 使用导航工具类返回并跳转到AI写歌Tab
                          NavigationUtils.backAndNavigateToTab(1);
                          // _launchController.showVipUpgradeDialog();
                        },
                        // child: Image.asset(
                        //   "assets/purchase/home/home_top_btn_bg.png",
                        //   width: 320.w,
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
                  )),
              _tabList(),
            ],
          ),
          _songListPageView(),
          _backButton(),
        ],
      ),
    );
  }
}
