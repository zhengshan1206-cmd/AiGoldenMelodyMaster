import 'dart:async';

import 'package:ai_golden_melody_master/view/lanuch_page/launch_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:ai_golden_melody_master/common/lib/app_common/by_nav_router_utils.dart';
import 'package:ai_golden_melody_master/common/lib/app_ui/by_widgets_util.dart';
import 'package:ai_golden_melody_master/common/lib/app_ui/byhy_screen_utils.dart';
import 'package:wechat_kit/wechat_kit.dart';
import '../../model/launch/launch_info_bean.dart';
import '../../navigator/app_pages.dart';
import '../../utils/by_color_utils.dart';
import 'launch_error_controller.dart';

class LaunchErrorPage extends StatefulWidget {
  const LaunchErrorPage({super.key});

  @override
  State<LaunchErrorPage> createState() => _LaunchErrorPageState();
}

class _LaunchErrorPageState extends State<LaunchErrorPage> {
  final controller = Get.put(LaunchErrorController());

  Timer? _timer;

  /// 超时时间 10s
  int timeout = 10;

  /// 已花费时间
  double timeCost = 0;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _initTimer();
  }

  void _initTimer() {
    _timer?.cancel();

    /// 初始化一个定时器，每0.5秒，让进度增加0.1
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      controller.progress.value += 0.006;
      timeCost += 0.1;
      final faild = controller.launchFaild.value == true && timeCost >= 3.0;
      if (timeCost >= timeout || faild) {
        _timer?.cancel();

        /// 请求超时
        controller.launching.value = false;
        controller.launchFaild.value = false;
        controller.progress.value = 0.0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final maxW = ByScreenUtils.screenWidth - 27.w * 2;
    return Scaffold(
      backgroundColor: ByColorUtil.color121212,
      body: Stack(
        children: [
          Positioned.fill(
              child: Column(
            children: [
              SizedBox(height: 248.w),
              Image.asset(
                "assets/common/no_wifi_data.png",
                width: 120.w,
                height: 120.w,
                fit: BoxFit.fitWidth,
              ),
              SizedBox(height: 10.w),
              ByWidgetsUtil.commonText(
                text: "网络异常，请检查网络后重试",
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                textColor: Colors.white,
              ),

              SizedBox(height: 8.w),

              ByWidgetsUtil.commonText(
                text: "如有问题,可拨打客服热线协助您解决",
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                textColor: Colors.white.withOpacity(0.5),
              ),

              SizedBox(height: 5.h),
              ByWidgetsUtil.commonText(
                text: "（人工客服时间 早9:00-晚23:00）",
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                textColor: Colors.white.withOpacity(0.5),
              ),
              SizedBox(height: 8.w),
              GestureDetector(
                onTap: () async {
                  ///todo 拨打电话
                  final Uri launchUri = Uri(
                    scheme: 'tel',
                    path: "4008698538",
                  );
                  if (await canLaunchUrl(launchUri)) {
                    await launchUrl(launchUri);
                  }
                },
                child: ByWidgetsUtil.commonText(
                    text: "400-869-8538",
                    fontSize: 21.sp,
                    fontWeight: FontWeight.bold,
                    textColor: Colors.white),
              ),
              SizedBox(height: 20.h),
              Obx(() => Offstage(
                    offstage: controller.launching.value == true,
                    child: controller.reTryCount.value >= 3
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildRetryBtn(context),
                              SizedBox(width: 10.w),
                              SizedBox(
                                width: 104.w,
                                height: 48.w,
                                child: ByWidgetsUtil.commonBtn(
                                  title: "在线客服",
                                  textColor: Colors.white,
                                  bgColor: ByColorUtil.color00CB64,
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 12.w),
                                  fontSize: 14.sp,
                                  borderRadius: 12.w,
                                  fontWeight: FontWeight.bold,
                                  onClick: () async {
                                    const wechatUrl = 'weixin://';
                                    if (await canLaunchUrl(
                                        Uri.parse(wechatUrl))) {
                                      bool canWechat = await WechatKitPlatform
                                          .instance
                                          .isInstalled();
                                      if (!canWechat) {
                                        EasyLoading.showToast(
                                            "由于您未安装微信，无法跳转微信客服");
                                        return;
                                      }
                                      ByNavRouterUtils.jumpWebViewPage(
                                        context,
                                        "",
                                        "https://work.weixin.qq.com/kfid/kfc7398d99d5133f1c2",
                                        isRisk: false,
                                      );
                                    } else {
                                      // EasyLoading.showToast("由于您未安装微信，无法直接跳转客服。");
                                      ByNavRouterUtils.jumpWebViewPage(
                                        context,
                                        "",
                                        "https://work.weixin.qq.com/kfid/kfc7398d99d5133f1c2",
                                        isRisk: false,
                                      );
                                    }
                                  },
                                ),
                              ),
                            ],
                          )
                        : Row(
                            children: [
                              const Spacer(),
                              _buildRetryBtn(context),
                              const Spacer(),
                            ],
                          ),
                  )),
              // SizedBox(height: 18.h),
              Obx(() => Offstage(
                    offstage: controller.launching.value == false,
                    child: Container(
                        width: 104.w,
                        height: 50.w,
                        decoration: BoxDecoration(
                          color: ByColorUtil.color00CB64,
                          borderRadius: BorderRadius.circular(12.w),
                        ),
                        alignment: Alignment.center,
                        child: SizedBox(
                          width: 20.w,
                          height: 20.w,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3.0.w,
                          ),
                        )
                        // child: ByWidgetsUtil.commonContainer(
                        //   bgColor: const Color(0xFFEAEEFF),
                        //   padding: EdgeInsets.zero,
                        //   borerRadius: 8.w,
                        //   child: ByWidgetsUtil.activityIndicator(
                        //     radius: 9.w,
                        //     color: ByColorUtil.LoginBtnBgColor,
                        //   ),
                        // ),
                        ),
                  )),

              const Spacer(),
              Obx(() => Offstage(
                    offstage: controller.launching.value == false,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      alignment: Alignment.centerLeft,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          SizedBox(
                            width: 28.w,
                            height: 28.w,
                          ),
                          Obx(() => Positioned(
                                top: 10.w,
                                left: (maxW - 0.w) * controller.progress.value,
                                child: Image.asset(
                                  "assets/common/network_progress.png",
                                  height: 28.w,
                                  width: 28.w,
                                  // fit: BoxFit.fitHeight,
                                ),
                              )),
                          // SizedBox(
                          //   width: maxW - 88.w,
                          //   height: 10.h,
                          // )
                        ],
                      ),
                    ),
                  )),
              SizedBox(height: 5.h),
              SizedBox(
                width: maxW,
                height: 5.h,
                child: Obx(() => Offstage(
                      offstage: controller.launching.value == false,
                      child: AiCommentaryProgressBar(
                          progress: controller.progress.value),
                    )),
              ),
              SizedBox(height: 120.h),
            ],
          ))
        ],
      ),
    );
  }

  SizedBox _buildRetryBtn(BuildContext context) {
    return SizedBox(
      width: 104.w,
      height: 48.w,
      child: ByWidgetsUtil.commonBtn(
        title: "点击重试",
        textColor: Colors.white,
        bgColor: ByColorUtil.color00CB64,
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        fontSize: 14.sp,
        borderRadius: 12.w,
        fontWeight: FontWeight.bold,
        onClick: () {
          timeCost = 0;
          controller.launching.value = true;
          controller.progress.value = 0.0;
          controller.reTryCount.value = controller.reTryCount.value + 1;

          _initTimer();

          bool isLaunch = Get.isRegistered<LaunchController>();
          if (!isLaunch) {
            Get.put(LaunchController());
          }
          LaunchController launchController = Get.find<LaunchController>();

          launchController.launch(
            onSuccess: (LaunchInfoBean bean) {
              timeCost = 0;
              _timer?.cancel();
              launchController.reloadUserInfo(
                successAction: (userInfo) {
                  controller.progress.value = 1.0;
                  Future.delayed(const Duration(milliseconds: 50), () {
                    controller.launching.value = false;
                    controller.progress.value = 0.0;
                    final launchPage = bean.verConfig.launchPage;
                    if (launchPage == 1 || bean.isVip == 1) {
                      Get.offNamed(Routes.main);
                    } else {
                      Get.offNamed(Routes.main);
                    }
                  });
                },
              );
            },
            onFail: () {
              controller.launchFaild.value = true;
              if (timeCost >= 3.0) {
                timeCost = 0;
                controller.launching.value = false;
                controller.launchFaild.value = false;
                controller.progress.value = 0.0;
                _timer?.cancel();
              }
            },
          );
        },
      ),
    );
  }
}

class AiCommentaryProgressBar extends StatelessWidget {
  const AiCommentaryProgressBar({
    super.key,
    this.progressColor,
    this.trackColor,
    this.progress,
  });

  final Color? progressColor;
  final Color? trackColor;
  final double? progress;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(100),
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              color: trackColor ?? Colors.white.withOpacity(0.05),
            ),
          ),
          FractionallySizedBox(
            widthFactor: progress ?? 0.5,
            heightFactor: 1,
            child: Container(
              decoration: BoxDecoration(
                  color: progressColor ?? ByColorUtil.color00CB64,
                  borderRadius: BorderRadius.circular(100)),
            ),
          ),
        ],
      ),
    );
  }
}
