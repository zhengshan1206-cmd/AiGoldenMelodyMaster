import 'dart:async';

import 'package:ai_golden_melody_master/navigator/app_pages.dart';
import 'package:ai_golden_melody_master/view/lanuch_page/launch_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../common/lib/app_ui/by_widgets_util.dart';
import '../../../utils/by_color_utils.dart';
import '../../common/btn_breathing_animation_widget.dart';

///新人抄底支付弹窗
class BuyBottomDialog extends StatefulWidget {
  final String comeBackPayBgUrl;
  const BuyBottomDialog({super.key,required this.comeBackPayBgUrl,});

  @override
  State<BuyBottomDialog> createState() => _BuyBottomDialogState();
}

class _BuyBottomDialogState extends State<BuyBottomDialog> {

  bool isAgreePrivacy = false;


  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 1.sw,
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 120.w,
            ),
            Stack(
              children: [
                widget.comeBackPayBgUrl.isEmpty? Image.asset(
                  "assets/purchase/dialog/pay_dialog_bg_2.png",
                  width: 1.sw,
                  height: 494.w,
                ):CachedNetworkImage(imageUrl: widget.comeBackPayBgUrl,
                  width: 1.sw,
                  height: 494.w,
                ),

                ///立即使用按钮
                Positioned(
                    left: 90.w,
                    bottom: 76.w,
                    child: BtnBreathingAnimationWidget(
                      child: InkResponse(
                        onTap: () {
                          if(isAgreePrivacy){
                            Get.toNamed(Routes.vipPurchasePage);
                          }else{
                            Get.dialog(privacyDialog());
                          }
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Image.asset(
                              "assets/purchase/dialog/pay_dialog_btn_2.png",
                              width: 200.w,
                              height: 52.w,
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                "立即抢购",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.sp,
                                    color: Colors.white),
                              ),
                            )
                          ],
                        ),
                      ),
                    )),

                ///关闭按钮
                Positioned(
                    bottom: 0,
                    left: 174.w,
                    child: InkResponse(
                      onTap: () {
                        Get.back();
                      },
                      child: Image.asset(
                        "assets/purchase/dialog/close_btn.png",
                        width: 28.w,
                        height: 28.w,
                      ),
                    )),

                ///手势按钮
                Positioned(
                    right: 60.w,
                    bottom: 28.w,
                    child: BtnBreathingAnimationWidget(
                      child: Image.asset(
                        "assets/purchase/dialog/hand_icon.png",
                        width: 72.w,
                        height: 72.w,
                      ),
                    )),

                ///文案提示区域
                Positioned(
                  left: 60.w,
                  bottom: 136.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SizedBox(width: 20.w,),
                          MemberCountdownEx(
                            fontSize: 14.sp,
                            textColor: ByColorUtil.colorF1,
                            bgColor: Color(0XFFFF7700),
                            separatorColor: Color(0XFF000000).withOpacity(0.5),
                            timeItemWidth: 24.w,
                            borderRadius: 4.w,
                            showMilliseconds: false,
                          ),
                          Text(
                            "后恢复原价",
                            style: TextStyle(
                              color: const Color(0XFF111111),
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 10.w,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          InkResponse(
                            onTap: (){

                              Get.log("====点击协议同意===");
                             if(mounted){
                               setState(() {
                                 setState(() {
                                   isAgreePrivacy = !isAgreePrivacy;
                                 });
                               });
                             }
                            },
                            child: SizedBox(
                              width: 30.w,
                              height: 30.w,
                              child: Center(
                                child:   Container(
                                  width: 12.w,
                                  height: 12.w,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: const Color(0XFF000000).withOpacity(0.3),
                                    ),
                                    borderRadius: BorderRadius.circular(12.w),
                                  ),
                                  alignment: Alignment.center,
                                  child:isAgreePrivacy? Container(
                                    width: 8.w,
                                    height: 8.w,
                                    decoration: BoxDecoration(
                                      color: Color(0XFF8DAA10),
                                      borderRadius: BorderRadius.circular(8.w),
                                    ),
                                  ):null,
                                ),
                              ),
                            )
                          ),
                          Text("点击购买即表示您同意",style: TextStyle(
                            color: Color(0XFF111111).withOpacity(0.5),
                            fontWeight: FontWeight.w400,
                            fontSize: 12.sp,
                          ),),

                          InkResponse(
                            onTap: (){
                              Get.find<LaunchController>().openVip();
                            },
                            child: Text("《付费服务协议》",style: TextStyle(
                              color: Color(0XFF111111),
                              fontWeight: FontWeight.w400,
                              fontSize: 12.sp,
                            ),),
                          )
                        ],
                      )
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }


  Widget privacyDialog() {
    return Center(
      child: SizedBox(
          width: double.infinity,
          height: 350.w,
          child: Stack(
            children: [
              Container(
                height: 350.w,
                margin: EdgeInsets.only(
                  left: 12.w,
                  right: 12.w,
                  bottom: 90.w,
                  top: 60.w,
                ),
                decoration: BoxDecoration(
                  color: ByColorUtil.color2e2e2e,
                  borderRadius: BorderRadius.circular(16.w),
                ),
              ),
              Positioned(
                top: 60.w,
                child: Image.asset(
                  "assets/common/hint_bg.png",
                  width: 1.sw,
                  height: 120.w,
                ),
              ),
              Positioned(
                left: 36.w,
                right: 36.w,
                top: 60.w,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 30.w,
                    ),
                    ByWidgetsUtil.commonText(
                        text: "服务协议及隐私保护",
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                        textColor: Colors.white),
                    SizedBox(
                      height: 30.w,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 0.w,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            " 我已经阅读并同意",
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 16.sp,
                                color: Colors.white.withOpacity(0.5)),
                          ),
                          InkResponse(
                            onTap: () {
                              Get.find<LaunchController>().openVip();
                            },
                            child: Text(
                              "会员服务协议",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16.sp,
                                  color: Colors.white),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30.w,
                    ),
                    SizedBox(
                      height: 44.h,
                      child: Row(
                        children: [
                          Expanded(
                            child: ByWidgetsUtil.commonBtn(
                              borderRadius: 12.w,
                              title: "不同意",
                              bgColor: ByColorUtil.WhiteColor.withOpacity(0.1),
                              fontWeight: FontWeight.w500,
                              textColor: ByColorUtil.WhiteColor,
                              fontSize: 16.sp,
                              onClick: () async {
                                Get.back();
                              },
                            ),
                          ),
                          SizedBox(width: 20.w),
                          Expanded(
                            child: ByWidgetsUtil.commonBtn(
                              bgColor: ByColorUtil.color00CB64,
                              borderRadius: 12.w,
                              title: "同意并继续",
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              textColor: Colors.white,
                              onClick: () async {
                                setState(() {
                                  isAgreePrivacy = true;
                                });
                                Get.back();
                                Get.back();
                                Get.toNamed(Routes.vipPurchasePage);
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Positioned(
                  top: 74.w,
                  right: 28.w,
                  child: InkResponse(
                    onTap: () {
                      Get.back();
                    },
                    child: Icon(
                      Icons.close,
                      color: Colors.white.withOpacity(0.4),
                    ),
                  ))
            ],
          )),
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
        _buildSeparator(text: "时"),
        _buildTimeBox(minutes),
        _buildSeparator(text: "分"),
        _buildTimeBox(seconds),
        _buildSeparator(text: "秒"),
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

  Widget _buildSeparator({String text = ":"}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widget.padding),
      child: Text(
        text,
        style: TextStyle(
          color: widget.separatorColor,
          fontSize: widget.fontSize,
        ),
      ),
    );
  }
}
