import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ai_golden_melody_master/view/publish/controller/banner_widget_controller.dart';
import 'package:ai_golden_melody_master/view/publish/beans/banner_beans.dart';
import 'dart:async';

class BannerWidget extends StatefulWidget {
  ///banner高度
  final double? height;

  ///banner位置
  final int? position;

  ///是否自动播放
  final bool? autoPlay;

  ///自动播放间隔时间（秒）
  final int? autoPlayInterval;

  ///是否启用无限滚动
  final bool? enableInfiniteScroll;

  ///banner点击回调
  final Function(BannerBean banner)? onBannerTap;

  ///banner关闭回调
  final Function()? onBannerClose;

  ///banner数据加载完成回调
  final Function(List<BannerBean> banners)? onBannerDataLoaded;

  ///是否显示关闭按钮
  final bool showCloseButton;

  ///关闭按钮图标路径
  final String closeIconPath;

  ///banner圆角
  final double borderRadius;

  ///底部间距
  final double bottomMargin;

  ///顶部间距
  final double topMargin;

  const BannerWidget({
    super.key,
    this.height,
    this.position,
    this.autoPlay,
    this.autoPlayInterval,
    this.enableInfiniteScroll,
    this.onBannerTap,
    this.onBannerClose,
    this.onBannerDataLoaded,
    this.showCloseButton = true,
    this.closeIconPath = "assets/home/main/dialog_close.png",
    this.borderRadius = 10,
    this.bottomMargin = 0,
    this.topMargin = 0,
  });

  @override
  State<BannerWidget> createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<BannerWidget> {
  late BannerWidgetController controller;
  late PageController pageController;
  Timer? autoPlayTimer;
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    // 为每个banner实例创建独立的控制器
    final tag = 'banner_${widget.position ?? 1}';
    controller = Get.put(BannerWidgetController(), tag: tag);
    pageController = PageController();

    // 设置控制器参数
    if (widget.height != null) {
      controller.setBannerHeight(widget.height!);
    }
    if (widget.position != null) {
      // 只有在position发生变化时才重新加载
      if (controller.bannerPosition != widget.position) {
        controller.setBannerPosition(widget.position!);
      }
    } else {
      // 如果没有设置position，设置默认的实例ID
      controller.instanceId = 'banner_1';
    }
    if (widget.autoPlay != null) {
      controller.setAutoPlay(widget.autoPlay!);
    }
    if (widget.autoPlayInterval != null) {
      controller.setAutoPlayInterval(widget.autoPlayInterval!);
    }
    if (widget.enableInfiniteScroll != null) {
      controller.setEnableInfiniteScroll(widget.enableInfiniteScroll!);
    }
    if (widget.onBannerTap != null) {
      controller.setOnBannerTap(widget.onBannerTap!);
    }
    if (widget.onBannerClose != null) {
      controller.setOnBannerClose(widget.onBannerClose!);
    }

    // 监听banner数据变化
    if (widget.onBannerDataLoaded != null) {
      ever(controller.bannerList, (List<BannerBean> banners) {
        // 无论是否有数据都触发回调，让父组件知道数据状态
        Future.delayed(const Duration(milliseconds: 100), () {
          widget.onBannerDataLoaded!(banners);
        });
      });

      // 初始化时也触发一次回调，确保父组件能立即知道当前数据状态
      Future.delayed(const Duration(milliseconds: 200), () {
        widget.onBannerDataLoaded!(controller.bannerList);
      });
    }

    // 启动自动播放
    _startAutoPlay();
  }

  @override
  void dispose() {
    autoPlayTimer?.cancel();
    pageController.dispose();
    super.dispose();
  }

  void _startAutoPlay() {
    if (controller.autoPlay && controller.bannerList.length > 1) {
      autoPlayTimer = Timer.periodic(
        Duration(seconds: controller.autoPlayInterval),
        (timer) {
          if (controller.bannerList.length > 1) {
            if (currentPage < controller.bannerList.length - 1) {
              currentPage++;
            } else {
              currentPage = 0;
            }
            if (pageController.hasClients) {
              pageController.animateToPage(
                currentPage,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            }
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.bannerList.isEmpty || !controller.showBanner.value
          ? const SizedBox.shrink()
          : Stack(
              children: [
                Container(
                  margin: EdgeInsets.only(
                    bottom: widget.bottomMargin.w,
                    top: widget.topMargin.w,
                  ),
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (notification) {
                      // 横向滑动时阻止冒泡
                      if (notification is ScrollStartNotification ||
                          notification is ScrollUpdateNotification) {
                        if (notification.metrics.axis == Axis.horizontal) {
                          return true; // 阻止事件冒泡到父级
                        }
                      }
                      return false;
                    },
                    child: SizedBox(
                      height: controller.bannerHeight.h,
                      child: PageView.builder(
                        controller: pageController,
                        onPageChanged: (index) {
                          currentPage = index;
                        },
                        itemCount: controller.bannerList.length,
                        scrollDirection: Axis.horizontal,
                        physics: const ClampingScrollPhysics(),
                        itemBuilder: (context, index) {
                          final banner = controller.bannerList[index];
                          return GestureDetector(
                            onTap: () {
                              controller.handleBannerTap(banner);
                            },
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(widget.borderRadius),
                              child: Image.network(
                                banner.imgUrl,
                                width: double.infinity,
                                height: controller.bannerHeight.h,
                                fit: BoxFit.fill,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: double.infinity,
                                    height: controller.bannerHeight.h,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.circular(
                                          widget.borderRadius),
                                    ),
                                    child: const Icon(
                                      Icons.image_not_supported,
                                      color: Colors.grey,
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                if (widget.showCloseButton)
                  Positioned(
                    top: 5.w,
                    right: 5.w,
                    child: GestureDetector(
                      onTap: () {
                        controller.closeBanner();
                      },
                      child: Image.asset(
                        "assets/purchase/home/dialog_close.png",
                        width: 20.w,
                        height: 20.w,
                        fit: BoxFit.contain,
                      ),
                    ),
                  )
              ],
            ),
    );
  }
}
