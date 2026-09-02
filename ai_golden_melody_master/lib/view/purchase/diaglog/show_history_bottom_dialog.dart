import 'dart:async';
import 'dart:ui';

import 'package:ai_golden_melody_master/navigator/app_pages.dart';
import 'package:ai_golden_melody_master/view/common/btn_breathing_animation_widget.dart';
import 'package:ai_golden_melody_master/view/lanuch_page/launch_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flustars_flutter3/flustars_flutter3.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../common/lib/app_common/event/common_event.dart';
import '../../../utils/by_color_utils.dart';
import '../vip/vip_purchase_controller.dart';

///展示底部付费弹窗
class ShowHistoryBottomDialog extends StatelessWidget {
  const ShowHistoryBottomDialog({super.key});
  @override
  Widget build(BuildContext context) {
    String orderShowBg = Get.find<LaunchController>().orderShowBg;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            InkResponse(
              onTap: () {
                SpUtil.putBool("show_history_order", false);
                eventBus.fire(const ShowHistoryOrderEvent());
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.w),
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 5,
                    sigmaY: 5,
                  ),
                  child: Container(
                    width: 14.w,
                    height: 14.w,
                    decoration: BoxDecoration(
                      color: const Color(0XFF000000).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(15.w),
                    ),
                    alignment: Alignment.center,
                    child: Image.asset(
                      "assets/purchase/dialog/close_icon.png",
                      width: 8.w,
                      height: 8.w,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 4.w,
            ),
          ],
        ),
        Row(
          children: [
            const Spacer(),
            Container(
              height: 32.h,
              padding: EdgeInsets.symmetric(horizontal: 2.w),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFEDFF87), // #E9FD37
                    Color(0xFFFE9731), // #FEBF31
                  ],
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(6),
                  topRight: Radius.circular(6),
                ),
              ),
              child: MemberCountdownEx(
                fontSize: 14.sp,
                textColor: ByColorUtil.colorF1,
                bgColor: Colors.black,
                separatorColor: ByColorUtil.colorF1,
                timeItemWidth: 24.w,
                borderRadius: 4.w,
                showMilliseconds: true,
              ),
            ),
            SizedBox(
              width: 15.w,
            ),
          ],
        ),
        Stack(
          children: [
            orderShowBg.isEmpty
                ? Image.asset(
                    "assets/purchase/dialog/uncompleted_order.png",
                    width: 1.sw,
                    height: 48.w,
                  )
                : CachedNetworkImage(
                    imageUrl: orderShowBg,
                    width: 1.sw,
                    height: 48.w,
                  ),
            Positioned(
                top: 11.w,
                right: 11.w,
                child: InkResponse(
                  onTap: () {
                    Get.toNamed(Routes.vipPurchasePage, arguments: {
                      "buy_vip": true,
                    });
                  },
                  child: BtnBreathingAnimationWidget(
                    child: Image.asset(
                      "assets/purchase/dialog/bug_vip_btn.png",
                      width: 78.w,
                      height: 28.w,
                    ),
                  ),
                )),
          ],
        )
      ],
    );
  }
}

///折扣弹窗
class DiscountDialog extends StatelessWidget {
  const DiscountDialog({super.key});

  @override
  Widget build(BuildContext context) {
    String orderShowRedEnvelop =
        Get.find<LaunchController>().orderShowRedEnvelop;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        InkResponse(
          onTap: () {
            SpUtil.putBool("show_history_order2", false);
            eventBus.fire(const ShowHistoryOrderEvent());
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15.w),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 5,
                sigmaY: 5,
              ),
              child: Container(
                width: 14.w,
                height: 14.w,
                decoration: BoxDecoration(
                  color: const Color(0XFF000000).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15.w),
                ),
                alignment: Alignment.center,
                child: Image.asset(
                  "assets/purchase/dialog/close_icon.png",
                  width: 8.w,
                  height: 8.w,
                ),
              ),
            ),
          ),
        ),
        orderShowRedEnvelop.isEmpty
            ? InkResponse(
                onTap: () {
                  Get.toNamed(Routes.vipPurchasePage, arguments: {
                    "buy_vip": true,
                  });
                },
                child: BtnBreathingAnimationWidget(
                    child: Image.asset(
                  "assets/purchase/dialog/uncompleted_envelop.png",
                  width: 71.w,
                  height: 78.w,
                )),
              )
            : InkResponse(
                onTap: () {
                  Get.toNamed(Routes.vipPurchasePage, arguments: {
                    "buy_vip": true,
                  });
                },
                child: BtnBreathingAnimationWidget(
                    child: CachedNetworkImage(
                  imageUrl: orderShowRedEnvelop,
                  width: 71.w,
                  height: 78.w,
                )),
              )
      ],
    );
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
  State<MemberCountdownEx> createState() => _MemberCountdownState();
}

// 添加一个GlobalKey类型
typedef MemberCountdownKey = GlobalKey<_MemberCountdownState>;

class _MemberCountdownState extends State<MemberCountdownEx> {
  late Duration _duration;
  Timer? _timer;
  int _milliseconds = 0;
  bool _showMilliseconds = true;

  String startTime = "";

  String endTime = "";

  @override
  void initState() {
    super.initState();
    _duration = _getTodayRemain2();
    _showMilliseconds = widget.showMilliseconds;
    _startTimer();
  }

  Duration _getTodayRemain() {
    final now = DateTime.now();
    final end = DateTime(now.year, now.month, now.day, 23, 59, 59);
    return end.difference(now).isNegative ? Duration.zero : end.difference(now);
  }

  Duration _getTodayRemain2() {
    late DateTime now;
    late DateTime end;
    String startTimeFromSp = SpUtil.getString("startTime", defValue: "") ?? "";
    String endTimeFromSp = SpUtil.getString("endTime", defValue: "") ?? "";

    if (startTimeFromSp.isEmpty) {
      startTime = DateTime.now().toString();
      SpUtil.putString("startTime", startTime);
    } else {
      startTime = startTimeFromSp;
    }

    if (endTimeFromSp.isEmpty) {
      // endTime = DateTime.now().add(const Duration(minutes: 30)).toString();

      endTime = DateTime.now().add(const Duration(minutes: 3)).toString();

      SpUtil.putString("endTime", endTime);
    } else {
      endTime = endTimeFromSp;
    }

    if (startTime == "-1") {
      SpUtil.putBool("show_history_order", false);
      SpUtil.putBool("show_history_order2", false);
      eventBus.fire(const ShowHistoryOrderEvent());
      return const Duration(seconds: 0);
    } else {
      now = DateTime.parse(startTime);
    }

    if (endTime == "-1") {
      SpUtil.putBool("show_history_order", false);
      SpUtil.putBool("show_history_order2", false);
      eventBus.fire(const ShowHistoryOrderEvent());
      return const Duration(seconds: 0);
    } else {
      end = DateTime.parse(endTime);
    }

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
        startTime =
            DateTime.now().add(const Duration(milliseconds: 50)).toString();
        SpUtil.putString("startTime", startTime);

        _duration = _getTodayRemain2();
        if (_showMilliseconds) {
          _milliseconds = (1000 - DateTime.now().millisecond) % 1000;
        }

        if (_duration.inSeconds <= 0) {
          SpUtil.putString("startTime", "");
          SpUtil.putString("endTime", "");
          SpUtil.putBool("show_history_order", false);
          SpUtil.putBool("show_history_order2", false);
          eventBus.fire(const ShowHistoryOrderEvent());
        }

        Get.log("=====剩余时间==== $_duration");
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
        _buildSeparator(),
        _buildTimeBox(minutes),
        _buildSeparator(),
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
        ),
      ),
    );
  }

  Widget _buildSeparator() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widget.padding),
      child: Text(
        ':',
        style: TextStyle(
          color: widget.separatorColor,
          fontSize: widget.fontSize,
        ),
      ),
    );
  }
}
