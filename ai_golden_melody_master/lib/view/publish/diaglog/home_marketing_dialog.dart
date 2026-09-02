import 'package:ai_golden_melody_master/view/lanuch_page/launch_controller.dart';
import 'package:ai_golden_melody_master/view/publish/widget/scale_transition_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

// ignore: must_be_immutable
class HomeMarketingDialog extends StatelessWidget {
  HomeMarketingDialog({super.key});

  LaunchController launchController = Get.find<LaunchController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 303.w,
          height: 482.h,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  "assets/purchase/home/home_marketing_dialog_bg.png"),
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Ai音乐变现门槛低，效率高",
                style: TextStyle(
                  color: const Color(0XFF9A4D0F),
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 6.h),
              Text(
                "领取后一键AI写歌+发行，获得变现",
                style: TextStyle(
                  color: const Color(0XFF9A4D0F),
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 18.h),
              GestureDetector(
                onTap: () {
                  Get.back();
                  launchController.goToVipPage();
                },
                child: ScaleTransitionWidget(
                  child: SizedBox(
                    width: 232.w,
                    height: 48.h,
                    child: Image.asset(
                      "assets/purchase/home/home_marketing_dialog_btn.png",
                      width: 232.w,
                      height: 48.h,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Text(
                  "不领取, 甘愿落后",
                  style: TextStyle(
                    color: const Color(0XFF9A4D0F).withOpacity(0.4),
                    fontSize: 14.sp,
                  ),
                ),
              ),
              SizedBox(height: 12.h),
            ],
          ),
        ),
        SizedBox(height: 40.h),
        GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Image.asset(
            "assets/purchase/home/dialog_close.png",
            width: 28.w,
            height: 28.h,
          ),
        ),
        SizedBox(height: 40.h),
      ],
    );
  }
}
