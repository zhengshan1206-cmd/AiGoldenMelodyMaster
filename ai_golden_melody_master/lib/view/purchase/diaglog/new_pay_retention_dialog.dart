import 'dart:async';

import 'package:ai_golden_melody_master/view/lanuch_page/launch_controller.dart';
import 'package:ai_golden_melody_master/view/publish/widget/scale_transition_widget.dart';
import 'package:ai_golden_melody_master/view/purchase/vip/vip_purchase_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../utils/by_color_utils.dart';

class NewPayRetentionDialog extends StatelessWidget {
  /// 按钮点击回调
  final VoidCallback? onButtonTap;

  final String musicMoney;

  const NewPayRetentionDialog({
    super.key,
    this.onButtonTap,
    required this.musicMoney,
  });

  @override
  Widget build(BuildContext context) {
    String vipPurchaseKeepDialog = Get.find<LaunchController>().vipPurchaseKeepDialog;

    return SizedBox(
        width: 1.sw,
        height: 1.sh,
        child: GetBuilder<VipPurchaseController>(
          builder: (controller) {
            return Column(
              children: [
                const Spacer(),
                Stack(
                  children: [
                    vipPurchaseKeepDialog.isEmpty
                        ? Image.asset(
                            "assets/purchase/dialog/again_open_vip_dialog.png",
                            width: 1.sw,
                            height: 566.w,
                            fit: BoxFit.fill,
                          )
                        : CachedNetworkImage(
                            imageUrl: vipPurchaseKeepDialog,
                            width: 1.sw,
                            height: 566.w,
                            fit: BoxFit.fill,
                          ),
                    Positioned(
                        top: 142.w,
                        right: 12.w,
                        child: InkResponse(
                          onTap: () {
                            Get.back();
                            Get.back();
                          },
                          child: Image.asset(
                            "assets/purchase/dialog/close_icon2.png",
                            width: 16.w,
                            height: 16.w,
                          ),
                        )),
                    Positioned(
                        top: 288.w,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "≈",
                                  style: TextStyle(
                                    color: Color(0XFFFE5024),
                                    fontSize: 34.sp,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                Text(
                                  musicMoney,
                                  style: TextStyle(
                                    color: Color(0XFFFE5024),
                                    fontSize: 72.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    bottom: 2.w,
                                  ),
                                  child: Text(
                                    "/首歌",
                                    style: TextStyle(
                                      color: Color(0XFFFE5024),
                                      fontSize: 34.sp,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 18.w,
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                bottom: 20.w,
                              ),
                              child: MemberCountdownEx(
                                fontSize: 24.sp,
                                textColor: Color(0XFFFEEF4A),
                                bgColor: Color(0XFF673501),
                                separatorColor: Color(0XFF673501),
                                timeItemWidth: 42.w,
                                borderRadius: 9.w,
                                showMilliseconds: false,
                              ),
                            ),
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                InkResponse(
                                  onTap: () {
                                    controller.buyEvent(clickEvent: () {
                                      Get.back();
                                    });
                                  },
                                  child: Image.asset(
                                    "assets/purchase/dialog/pay_dialog_btn_5.png",
                                    width: 1.sw,
                                    height: 46.h,
                                    fit: BoxFit.fitHeight,
                                  ),
                                ),
                                InkResponse(
                                  onTap: () {
                                    controller.buyEvent(clickEvent: () {
                                      Get.back();
                                    });
                                  },
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      "下一步",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17.sp,
                                          color: Colors.white),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 13.w,
                            ),
                            Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  InkResponse(
                                    onTap: () {
                                      controller.agreementCheckedStatusChanged(
                                          !controller.isAgreePrivacy);
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 12.w,
                                        ),
                                        Container(
                                          width: 12.w,
                                          height: 12.w,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12.w),
                                              border: Border.all(
                                                  color: Color(0XFF000000)
                                                      .withOpacity(
                                                    0.4,
                                                  ),
                                                  width: 1.w)),
                                          alignment: Alignment.center,
                                          child: controller.isAgreePrivacy
                                              ? Container(
                                                  width: 8.w,
                                                  height: 8.w,
                                                  decoration: BoxDecoration(
                                                      color: Color(0XFFFF8208),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6.w)),
                                                )
                                              : null,
                                        ),
                                        SizedBox(
                                          width: 4.w,
                                        ),
                                        Text(
                                          "我已阅读并同意",
                                          style: TextStyle(
                                            color:
                                                Color(0XFF000000).withOpacity(
                                              0.4,
                                            ),
                                            fontWeight: FontWeight.w400,
                                            fontSize: 12.sp,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  InkResponse(
                                    onTap: () {
                                      controller.openVip();
                                    },
                                    child: Text(
                                      " 会员服务协议",
                                      style: TextStyle(
                                        color: Color(0XFF000000),
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12.sp,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ))
                  ],
                )
              ],
            );
          },
        ));
  }
}

class MemberCountdownEx extends StatefulWidget {
  final double fontSize;
  final Color textColor;
  final Color bgColor;
  final Color separatorColor;
  final double timeItemWidth;
  final double borderRadius;
  final Color borderColor;
  final bool showMilliseconds;
  final double padding;

  const MemberCountdownEx({
    super.key,
    this.fontSize = 12,
    this.textColor = const Color(0XFFFFFFFF),
    this.bgColor = Colors.transparent,
    this.separatorColor = const Color(0XFFFFFFFF),
    this.borderColor = const Color(0x1A00CB64), // 使用十六进制透明度值替代 withOpacity(0.1)
    this.timeItemWidth = 21,
    this.borderRadius = 6,
    this.showMilliseconds = false,
    this.padding = 2,
  });

  @override
  State<MemberCountdownEx> createState() => _MemberCountdownExState();
}

// 添加一个GlobalKey类型
typedef MemberCountdownKey = GlobalKey<_MemberCountdownExState>;

class _MemberCountdownExState extends State<MemberCountdownEx> {
  late Duration _duration;
  Timer? _timer;
  int _milliseconds = 0;
  bool _showMilliseconds = true;

  @override
  void initState() {
    super.initState();
    _duration = _getTodayRemain();
    _showMilliseconds = widget.showMilliseconds;
    _startTimer();
  }

  Duration _getTodayRemain() {
    final now = DateTime.now();
    final end = DateTime(now.year, now.month, now.day, 23, 59, 59);
    return end.difference(now).isNegative ? Duration.zero : end.difference(now);
  }

  void _startTimer() {
    _timer?.cancel();
    // 如果显示毫秒，则每50毫秒更新一次，否则每秒更新一次
    final interval = _showMilliseconds
        ? const Duration(milliseconds: 50)
        : const Duration(seconds: 1);

    _timer = Timer.periodic(interval, (timer) {
      setState(() {
        _duration = _getTodayRemain();
        if (_showMilliseconds) {
          _milliseconds = (1000 - DateTime.now().millisecond) % 1000;
        }
      });
    });
  }

  // 切换毫秒显示状态
  void toggleMilliseconds() {
    setState(() {
      _showMilliseconds = !_showMilliseconds;
    });
    _startTimer(); // 重新启动计时器以调整更新频率
  }

  // 设置毫秒显示状态
  void setMillisecondsVisible(bool visible) {
    if (_showMilliseconds != visible) {
      setState(() {
        _showMilliseconds = visible;
      });
      _startTimer(); // 重新启动计时器以调整更新频率
    }
  }

  // 获取当前毫秒显示状态
  bool get isMillisecondsVisible => _showMilliseconds;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hours = _duration.inHours.toString().padLeft(2, '0');
    final minutes = (_duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (_duration.inSeconds % 60).toString().padLeft(2, '0');
    final milliseconds =
        (_milliseconds / 10).floor().toString().padLeft(2, '0');

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildTimeBox(hours),
        _buildSeparator(text: ":"),
        _buildTimeBox(minutes),
        _buildSeparator(text: ":"),
        _buildTimeBox(seconds),
        if (_showMilliseconds) ...[
          _buildSeparator(),
          _buildTimeBox(milliseconds),
        ],
      ],
    );
  }

  Widget _buildTimeBox(String time) {
    return Container(
      width: widget.timeItemWidth,
      height: widget.timeItemWidth,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: widget.bgColor,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        border: Border.all(
          width: 1.w,
          color: widget.borderColor,
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        time,
        style: TextStyle(
          color: widget.textColor,
          fontSize: widget.fontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSeparator({String text = ":"}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widget.padding),
      child: Text(
        text,
        style: TextStyle(
            color: widget.separatorColor,
            fontSize: 40.sp,
            fontWeight: FontWeight.w400),
      ),
    );
  }
}
