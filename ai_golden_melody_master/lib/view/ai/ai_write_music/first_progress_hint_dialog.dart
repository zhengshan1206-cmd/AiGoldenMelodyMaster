import 'dart:math';

import 'package:ai_golden_melody_master/common/lib/app_common/event/common_event.dart';
import 'package:ai_golden_melody_master/utils/assets.dart';
import 'package:ai_golden_melody_master/utils/common_event.dart';
import 'package:ai_golden_melody_master/view/common/btn_breathing_animation_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../model/ai_music/music_prompt_response.dart';
import '../../../navigator/app_pages.dart';
import '../../../utils/data_service.dart';

class FirstProgressHintDialog extends StatelessWidget {
  final MusicPromptData? musicPromptData;
  const FirstProgressHintDialog({
    super.key,
    this.musicPromptData,
  });
  @override
  Widget build(BuildContext context) {
    DataService.onEvent(DataServiceEventName.obListenShow, {});
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;
        // controller.goBack();
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                Assets.loginBg8,
                width: 375.w,
                height: 407.w,
                fit: BoxFit.fitWidth,
              ),
              Align(
                  child: Stack(
                children: [
                  Image.asset(
                    Assets.musicBg,
                    width: 375.w,
                    height: 407.w,
                  ),
                ],
              )),
              Positioned(
                top: 28.w,
                left: 43.w,
                child: Image.asset(
                  Assets.musicFinishHintText,
                  width: 284.w,
                  height: 38.h,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ],
          ),

          ///立即试听跳转
          BtnBreathingAnimationWidget(
            child: InkResponse(
              onTap: () {
                if (musicPromptData != null) {
                  Get.back();
                  Get.offNamed(
                    Routes.aiPlayMusicPage,
                    arguments: {
                      "type": 0,
                      "id": musicPromptData!.id,
                      "isFirst": true,
                    },
                  );
                  DataService.onEvent(DataServiceEventName.obListenClick, {});
                  eventBus.fire(PlayMusicDataEvent());
                }
              },
              child: Container(
                width: 232.w,
                height: 52.w,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFFAFFE3), // #24FECF
                      Color(0xFFF1FFB1), // #FFF13C
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  // backgroundBlendMode: BlendMode.composite,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFAFFE3)
                          .withOpacity(0.5), // #FAFFE3 半透明
                      blurRadius: 0,
                      spreadRadius: 0,
                    ),
                  ],
                  borderRadius: BorderRadius.circular(32.w),
                ),
                child: Center(
                  child: Text(
                    "立即试听",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.sp,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
