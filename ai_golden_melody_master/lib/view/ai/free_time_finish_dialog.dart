import 'dart:io';

import 'package:ai_golden_melody_master/navigator/app_pages.dart';
import 'package:ai_golden_melody_master/utils/assets.dart';
import 'package:ai_golden_melody_master/utils/by_color_utils.dart';
import 'package:ai_golden_melody_master/view/common/btn_breathing_animation_widget.dart';
import 'package:ai_golden_melody_master/view/lanuch_page/launch_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../utils/data_service.dart';

///免费使用弹窗
class FreeTimeFinishDialog extends StatelessWidget {
  final bool couldAwait;
  final bool autoBack;
  const FreeTimeFinishDialog({
    super.key,
    required this.couldAwait,
    this.autoBack = false,
  });
  @override
  Widget build(BuildContext context) {
    LaunchController launchController = Get.find<LaunchController>();
    String btnText = launchController.btnText;
    DataService.onEvent(DataServiceEventName.obListenContinueShow, {});
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              Assets.freeTimeFinishBg,
              width: 375.w,
              height: 311.w,
            ),
            Positioned(
                top: 162.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "试用已结束，快来创作你的\n专属音乐吧！",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white.withOpacity(0.85),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    InkResponse(
                        onTap: () {
                          Get.back();
                          DataService.onEvent(DataServiceEventName.obListenContinueClick, {});
                          if (launchController.isLogin) {
                            if (launchController.isVip) {
                              if (Platform.isIOS) {
                                Get.back();
                                Get.back();
                                return;
                              }

                              if (Platform.isAndroid) {
                                Get.back();
                                return;
                              }
                            } else {
                              Get.back();
                              Get.toNamed(Routes.vipPurchasePage,arguments: {
                                "show_bottom_pay_dialog":true,
                              });
                            }
                          } else {
                            launchController.login(loginSuccess: () {
                              if (launchController.isVip) {
                                if (Platform.isIOS) {
                                  Get.back();
                                  Get.back();
                                  return;
                                }
                                if (Platform.isAndroid) {
                                  Get.back();
                                  return;
                                }
                              } else {
                                if(Platform.isIOS){
                                  Get.back();
                                  Get.back();
                                  Get.toNamed(Routes.vipPurchasePage,
                                  arguments: {
                                    "show_bottom_pay_dialog":true,
                                  }
                                  );
                                }

                                if(Platform.isAndroid){
                                  Get.back();
                                  Get.toNamed(Routes.vipPurchasePage,arguments: {
                                    "show_bottom_pay_dialog":true,

                                  });
                                }

                              }
                            },source: "free_use_dialog");
                          }
                        },
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              width: 297.w,
                              height: 52.w,
                              margin: EdgeInsets.only(
                                top: 24.w,
                              ),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    Color(0xFF24FECF),
                                    Color(0xFFFFF13C),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(70.w),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                btnText.isEmpty ? "继续使用" : btnText,
                                style: TextStyle(
                                  color: ByColorUtil.color121212,
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Positioned(
                              right: 9.w,
                              top: 50.w,
                              child: BtnBreathingAnimationWidget(
                                child: Image.asset(
                                  Assets.handHint,
                                  width: 68.w,
                                  height: 59.w,
                                ),
                              ),
                            )
                          ],
                        )),
                  ],
                ))
          ],
        ),
        InkResponse(
          onTap: () {
            DataService.onEvent(DataServiceEventName.obListenCloseClick, {});
            if (couldAwait) {
              if (autoBack) {
                if (Platform.isIOS) {
                  Get.back();
                  Get.back();
                  return;
                }

                if (Platform.isAndroid) {
                  Get.back();
                  return;
                }
              } else {
                Get.back();
              }
            } else {
              Get.back();
              Get.back();
            }
          },
          child: Container(
            width: 90.w,
            height: 52.h,
            decoration: BoxDecoration(
                // color: Colors.white,
                borderRadius: BorderRadius.circular(90.w),
                border: Border.all(
                  width: 1,
                  color: Colors.white.withOpacity(0.3),
                )),
            alignment: Alignment.center,
            child: Image.asset(
              Assets.closeDialog,
              width: 28.w,
              height: 28.w,
            ),
          ),
        )
      ],
    );
  }
}
