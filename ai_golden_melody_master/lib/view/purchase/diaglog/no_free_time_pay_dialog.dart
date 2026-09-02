

import 'package:ai_golden_melody_master/navigator/app_pages.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../common/btn_breathing_animation_widget.dart';


///免费次数已经用完的付费弹窗
class NoFreeTimePayDialog extends StatelessWidget{
  final String noFreeTimeBg;
  const NoFreeTimePayDialog({super.key,required this.noFreeTimeBg,});

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
                noFreeTimeBg.isEmpty? Image.asset(
                  "assets/purchase/dialog/pay_dialog_bg_4.png",
                  width: 1.sw,
                  height: 494.w,
                ):CachedNetworkImage(imageUrl: noFreeTimeBg,
                  width: 1.sw,
                  height: 494.w,
                ),

                ///立即使用按钮
                Positioned(
                    left: 90.w,
                    bottom: 76.w,
                    child: BtnBreathingAnimationWidget(
                      child:  InkResponse(
                        onTap: () {
                          Get.back();
                          Get.toNamed(Routes.vipPurchasePage);
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Image.asset(
                              "assets/purchase/dialog/pay_dialog_btn_3.png",
                              width: 200.w,
                              height: 52.w,
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                "立即解锁",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.sp,
                                    color: const Color(0XFF121212)),
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
                    child:BtnBreathingAnimationWidget(child:  Image.asset("assets/purchase/dialog/hand_icon.png",
                      width: 72.w,
                      height: 72.w,
                    ),)

                )
              ],
            )
          ],
        ),
      ),
    );

  }
}