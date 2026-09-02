import 'package:ai_golden_melody_master/common/lib/app_ui/byhy_screen_utils.dart';
import 'package:ai_golden_melody_master/common/lib/app_ui/video/byhy_video_player_view.dart';
import 'package:ai_golden_melody_master/view/lanuch_page/launch_controller.dart';
import 'package:ai_golden_melody_master/view/publish/controller/strategy_details_controller.dart';
import 'package:ai_golden_melody_master/view/publish/widget/member_contdown.dart';
import 'package:ai_golden_melody_master/view/publish/widget/muti_status_view.dart';
import 'package:ai_golden_melody_master/view/purchase/vip/vip_purchase_controller.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';

// 攻略类型1.图文 2.视频
class StrategyDetailsPage extends StatelessWidget {
  StrategyDetailsPage({super.key});
  final _controller = Get.find<StrategyDetailsController>();

  final userInfo = Get.find<LaunchController>().user;

  ///视频详情返回按钮
  Widget videoBackButton() {
    return Positioned(
      top: ByScreenUtils.topSafeHeight,
      child: IconButton(
        onPressed: () {
          Get.back();
        },
        icon: Container(
          width: 32.w,
          height: 32.h,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
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

  ///图文返回按钮
  AppBar textBackButton() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: GestureDetector(
        onTap: () {
          Get.back();
        },
        child: Container(
          width: 32,
          height: 32,
          alignment: Alignment.center,
          child: Icon(
            Icons.arrow_back_ios_new,
            size: 18.sp,
            color: const Color(0XFFFFFFFF),
          ),
        ),
      ),
      actions: [playCount(), SizedBox(width: 12.w)],
    );
  }

  /// 播放量
  Widget playCount() {
    return Obx(
      () {
        return Container(
          width: 210.w,
          alignment: Alignment.centerRight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Image.asset(
                "assets/purchase/home/strategy_icon_1.png",
                width: 14.w,
                height: 14.h,
              ),
              SizedBox(width: 5.w),
              Flexible(
                child: Text(
                  _controller.strategyDetails.value?.authorName ?? "",
                  // "sadasdashdoajdajdoaidjoaisjdiajdajdijaiodjiajdioajidojaoisdjio",
                  style: TextStyle(
                    color: const Color(0XFFFFFFFF).withOpacity(0.8),
                    fontSize: 14.sp,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 12.w),
              Container(
                height: 28.h,
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                decoration: BoxDecoration(
                  color: const Color(0XFF121D1E),
                  borderRadius: BorderRadius.circular(16.w),
                  border: Border.all(
                    width: 1.w,
                    color: const Color(0XFF00CB64).withOpacity(0.1),
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      "播放量：",
                      style: TextStyle(
                        color: const Color(0XFFFFFFFF),
                        fontSize: 12.sp,
                      ),
                    ),
                    Text(
                      _controller.formatNumber(int.parse(_controller
                              .strategyDetails.value?.showNumber
                              .toString() ??
                          "0")),
                      style: TextStyle(
                        color: const Color(0XFF00CB64),
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  ///底部悬浮按钮
  Widget bottomButton() {
    final int count =
        _controller.strategyGuideConfig.value?.userAvatar?.length ?? 0;
    final userAvatar = _controller.strategyGuideConfig.value?.userAvatar;
    final learnNumber = _controller.strategyGuideConfig.value?.learnNumber;
    final double overlap = 9.w;
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: _controller.strategyDetails.value != null &&
                      _controller.strategyDetails.value?.type == 1
                  ? 386.h
                  : 80.h,
              alignment: Alignment.bottomCenter,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0XFF121212).withOpacity(0),
                    const Color(0XFF121212).withOpacity(0.8),
                    const Color(0XFF121212),
                  ],
                  stops: const [0, 0.8, 1],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (count > 0 && _controller.strategyDetails.value?.type == 1)
                    Container(
                      height: 30.h,
                      alignment: Alignment.center,
                      width: count > 0 ? (count * 30.w - (count - 1) * 5.w) : 0,
                      child: count > 0
                          ? Stack(
                              alignment: Alignment.center,
                              children: List.generate(
                                count,
                                (index) {
                                  return Positioned(
                                    left: index * 25.w,
                                    child: Container(
                                      width: 30.w,
                                      height: 30.h,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(15.w),
                                        image: DecorationImage(
                                            image: NetworkImage(
                                                userAvatar?[index].avatar ??
                                                    "")),
                                        border: Border.all(
                                          color: const Color(0XFFFFFFFF),
                                          width: 1.w,
                                        ),
                                      ),
                                      child: index == userAvatar!.length - 1
                                          ? Container(
                                              width: double.infinity,
                                              height: double.infinity,
                                              decoration: BoxDecoration(
                                                color: Colors.black
                                                    .withOpacity(0.5),
                                                borderRadius:
                                                    BorderRadius.circular(15.w),
                                              ),
                                              child: Center(
                                                child: Icon(
                                                  Icons.more_horiz,
                                                  color: Colors.white
                                                      .withOpacity(0.8),
                                                  size: 24.sp,
                                                ),
                                              ),
                                            )
                                          : null,
                                    ),
                                  );
                                },
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                  if (count > 0 && _controller.strategyDetails.value?.type == 1)
                    Container(
                      padding: EdgeInsets.only(
                          left: 12.w, right: 12.w, top: 15.h, bottom: 32.h),
                      child: Text(
                        "已有${_controller.formatNumber(learnNumber ?? 0)}位创作者学习了该教程",
                        style: TextStyle(
                          color: const Color(0XFFFFFFFF),
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  Container(
                    width: double.infinity,
                    height: 32.h,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                            "assets/purchase/home/strategy_bg_2.png"),
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/purchase/home/strategy_icon_2.png",
                          height: 14.h,
                          fit: BoxFit.fitHeight,
                        ),
                        SizedBox(width: 12.w),
                        MemberCountdown(
                          fontSize: 14.sp,
                          timeItemWidth: 24.w,
                          borderRadius: 4.w,
                          showMilliseconds: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: const Color(0XFF121212),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      final launchController = Get.find<LaunchController>();
                      launchController.checkPreLogin(
                        actionCallback: () {
                          _controller.buyEvent();
                        },
                        source: "strategy_details_page"
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 28.w),
                      child: Container(
                        width: double.infinity,
                        height: 60.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.w),
                          border: Border.all(
                            width: 1.w,
                            color: const Color(0XFFFFFFFF),
                          ),
                          gradient: const LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              Color(0XFF24FECF),
                              Color(0XFFFFF13C),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0XFF24FECF).withOpacity(0.3),
                              blurRadius: 8.w,
                              offset: Offset(0, 2.w),
                              spreadRadius: 2.w,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            userInfo.value?.isVip == 1 &&
                                    (userInfo.value?.vipLevel ?? 0) <
                                        (_controller.strategyDetails.value
                                                ?.vipLevel ??
                                            0)
                                ? "升级尊享会员解锁全部教程"
                                : "开通尊享会员解锁全部教程",
                            style: TextStyle(
                              color: const Color(0XFF121212),
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  GetBuilder<VipPurchaseController>(
                    builder: (controller) => Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 28.w, vertical: 10.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              controller.agreementCheckedStatusChanged(
                                  !controller.isAgreePrivacy);
                            },
                            child: Container(
                              color: Colors.transparent,
                              alignment: Alignment.center,
                              width: 24.w,
                              height: 24.w,
                              child: Container(
                                width: 12.w,
                                height: 12.w,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.5),
                                  ),
                                  borderRadius: BorderRadius.circular(12.w),
                                ),
                                alignment: Alignment.center,
                                child: controller.isAgreePrivacy
                                    ? Container(
                                        width: 6.w,
                                        height: 6.w,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(6.w)),
                                      )
                                    : null,
                              ),
                            ),
                          ),
                          Flexible(
                            child: Wrap(
                              alignment: WrapAlignment.center,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "我已阅读并同意",
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.5),
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      TextSpan(
                                        text: "《会员服务协议》",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w400,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            controller.openVip();
                                          },
                                      ),
                                      // if (controller.selectedVipTypeBean !=
                                      //         null &&
                                      //     controller.selectedVipTypeBean
                                      //             ?.isSubscribe ==
                                      //         1)
                                      //   TextSpan(
                                      //     text: "《自动订阅协议》",
                                      //     style: TextStyle(
                                      //       color:
                                      //           Colors.white.withOpacity(0.5),
                                      //       fontSize: 12.sp,
                                      //       fontWeight: FontWeight.w400,
                                      //     ),
                                      //     recognizer: TapGestureRecognizer()
                                      //       ..onTap = () {
                                      //         controller.openVip();
                                      //       },
                                      //   ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 16.h,
              color: const Color(0XFF121212),
            ),
          ],
        ),
      ),
    );
  }

  ///视频内容
  Widget videoContent() {
    return Obx(() {
      final details = _controller.strategyDetails.value;
      if (details == null) return Container();

      // 计算底部按钮的高度：渐变区域(80) + 按钮区域(60) + 协议区域(44) + 间距(16) + 安全区域
      final bottomButtonHeight = userInfo.value?.isVip == 0
          ? 200.h + ByScreenUtils.bottomSafeHeight
          : 0.h;

      return Column(
        children: [
          Container(
            width: double.infinity,
            constraints: BoxConstraints(
              maxHeight: 540.h,
              minHeight: 200.h,
            ),
            child: Stack(
              children: [
                VideoPlayerWidget(
                  url: details.videoUrl.isNotEmpty ? details.videoUrl : "",
                  autoPlay: true,
                  maxDuration: userInfo.value?.isVip == 0 &&
                              details.isFree == 2 ||
                          (userInfo.value?.vipLevel ?? 0) < details.vipLevel
                      ? Duration(
                          seconds: details.lookTime > 0 ? details.lookTime : 10)
                      : null,
                ),
                if (userInfo.value?.isVip == 0 && details.isFree == 2 ||
                    (userInfo.value?.vipLevel ?? 0) < details.vipLevel)
                  Positioned(
                    left: 10.w,
                    bottom: 38.h,
                    child: Container(
                      height: 32.h,
                      padding: EdgeInsets.symmetric(horizontal: 7.w),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(6.w),
                      ),
                      child: Row(
                        children: [
                          Container(
                            height: 20.w,
                            padding: EdgeInsets.symmetric(horizontal: 7.w),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: const Color(0XFFFBEB4E),
                              borderRadius: BorderRadius.circular(4.w),
                            ),
                            child: Text(
                              "试看中",
                              style: TextStyle(
                                color: const Color(0XFF121212),
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          SizedBox(width: 6.w),
                          Row(
                            children: [
                              Text(
                                "可试看",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.sp,
                                ),
                              ),
                              Text(
                                "${details.lookTime > 0 ? details.lookTime : 10}秒",
                                style: TextStyle(
                                  color: const Color(0XFFFF4343),
                                  fontSize: 12.sp,
                                ),
                              ),
                              Text(
                                "，",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.sp,
                                ),
                              ),
                              ShaderMask(
                                shaderCallback: (bounds) =>
                                    const LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    Color(0xFF26FECE),
                                    Color(0xFF92F885),
                                    Color(0xFFFEF13D),
                                  ],
                                ).createShader(bounds),
                                child: Text(
                                  "尊享会员专属教程",
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    details.name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: 12.w),
                playCount(),
              ],
            ),
          ),
          Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: HtmlWidget(
                _controller.strategyDetails.value?.content ?? "",
                customStylesBuilder: (element) {
                  if (element.localName == 'img') {
                    return {
                      'width': '100%', // 宽度占满父容器
                      'height': 'auto', // 高度自适应
                      'max-width': '100%', // 最大宽度不超过父容器
                    };
                  }
                  return null; // 使用默认样式
                },
              )),
          // 为底部按钮留出空间
          SizedBox(height: bottomButtonHeight + 20.h),
        ],
      );
    });
  }

  ///图文内容
  Widget textContent() {
    return Obx(() {
      final details = _controller.strategyDetails.value;
      if (details == null) return Container();

      // 计算底部按钮的高度：渐变区域(80) + 按钮区域(60) + 协议区域(44) + 间距(16) + 安全区域
      final bottomButtonHeight = userInfo.value?.isVip == 0
          ? 200.h + ByScreenUtils.bottomSafeHeight
          : 0.h;

      return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),
            // 教程标题
            // Text(
            //   details.name,
            //   style: TextStyle(
            //     color: Colors.white,
            //     fontSize: 16.sp,
            //     fontWeight: FontWeight.bold,
            //   ),
            //   maxLines: 1,
            //   overflow: TextOverflow.ellipsis,
            // ),
            // SizedBox(height: 17.h),
            // if (details.iconUrl.isNotEmpty) ...[
            //   ClipRRect(
            //     borderRadius: BorderRadius.circular(8),
            //     child: Image.network(
            //       details.iconUrl,
            //       width: double.infinity,
            //       fit: BoxFit.fitWidth,
            //       errorBuilder: (context, error, stackTrace) {
            //         return Container(
            //           width: double.infinity,
            //           height: 200.h,
            //           decoration: BoxDecoration(
            //             color: const Color(0XFF1A1A1A),
            //             borderRadius: BorderRadius.circular(8),
            //           ),
            //           child: const Center(
            //             child: Icon(
            //               Icons.image_not_supported,
            //               color: Colors.grey,
            //               size: 40,
            //             ),
            //           ),
            //         );
            //       },
            //     ),
            //   ),
            //   SizedBox(height: 20.h),
            // ],

            HtmlWidget(
              _controller.strategyDetails.value?.content ?? "",
              customStylesBuilder: (element) {
                if (element.localName == 'img') {
                  return {
                    'width': '100%', // 宽度占满父容器
                    'height': 'auto', // 高度自适应
                    'max-width': '100%', // 最大宽度不超过父容器
                  };
                }
                return null; // 使用默认样式
              },
            ),

            // 为底部按钮留出空间
            SizedBox(height: bottomButtonHeight + 20.h),
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final details = _controller.strategyDetails.value;
      final isVip = userInfo.value?.isVip == 1;

      return Scaffold(
        backgroundColor: const Color(0XFF121212),
        appBar: details?.type == 1 ? textBackButton() : null,
        body: MultiStatusView(
          currentStatus: _controller.statusType.value,
          child: details == null
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Color(0XFF00CB64),
                  ),
                )
              : Stack(
                  children: [
                    ListView(
                      padding: EdgeInsets.zero,
                      // 只有图文类型且非VIP用户才禁用滚动
                      physics: details.type == 1 &&
                                  !isVip &&
                                  details.isFree == 2 ||
                              (userInfo.value?.vipLevel ?? 0) < details.vipLevel
                          ? const NeverScrollableScrollPhysics()
                          : const AlwaysScrollableScrollPhysics(),
                      children: [
                        if (details.type == 2) videoContent(),
                        if (details.type == 1) textContent(),
                      ],
                    ),
                    if (details.type == 2) videoBackButton(),
                    // 只有非VIP用户才显示底部按钮
                    if (!isVip && details.isFree == 2 ||
                        (userInfo.value?.vipLevel ?? 0) < details.vipLevel)
                      bottomButton(),
                  ],
                ),
          action: () {
            _controller.getStrategyDetails();
          },
        ),
      );
    });
  }
}
