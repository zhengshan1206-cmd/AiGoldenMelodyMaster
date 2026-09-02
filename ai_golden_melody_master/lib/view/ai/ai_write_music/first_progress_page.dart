import 'dart:async';
import 'dart:math';
import 'package:ai_golden_melody_master/common/lib/app_common/event/common_event.dart';
import 'package:ai_golden_melody_master/utils/assets.dart';
import 'package:ai_golden_melody_master/utils/by_color_utils.dart';
import 'package:ai_golden_melody_master/utils/common_event.dart';
import 'package:ai_golden_melody_master/view/ai/ai_write_music/ai_write_music_controller.dart';
import 'package:ai_golden_melody_master/view/ai/ai_write_music/first_progress_hint_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'package:ai_golden_melody_master/common/lib/app_http/apis.dart';
import 'package:ai_golden_melody_master/common/lib/app_http/http_utils.dart';

import '../../../common/lib/app_common/consts/const_keys.dart';
import '../../../model/ai_music/music_prompt_response.dart';
import '../ai_play_music/ai_play_music_controller.dart';
import '../free_time_finish_dialog.dart';

///第一次用户进入 引导性进度页面
class FirstProgressPage extends StatefulWidget {
  final MusicPromptData? musicPromptData;
  const FirstProgressPage({
    super.key,
    this.musicPromptData,
  });

  @override
  State<FirstProgressPage> createState() => _FirstProgressPageState();
}

class _FirstProgressPageState extends State<FirstProgressPage> {
  int count = 10;
  Timer? _timer;
  String firstProgressPath = Assets.progress2;
  String secondProgressPath = Assets.progress4;
  String thirdProgressPath = Assets.progress7;
  String fourthProgressPath = Assets.progress10;
  MusicPromptResponse? musicPromptResponse;

  @override
  void initState() {
    super.initState();
    Get.put(AiPlayMusicController());
    ConstKeys().updateIsFirst();
    eventBus.fire(RefreshMusicDataEvent(
      isFirst: true,
      type: 0,
      musicId: widget.musicPromptData!.id ?? 0,
    ));
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (count < 6) {
        ///倒计时结束，取消计时器
        _timer?.cancel();
      } else {
        ///减少时间
        count--;
      }
      updatePath();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  updatePath() {
    if (count == 9) {
      firstProgressPath = Assets.progress3;
      secondProgressPath = Assets.progress5;
    }
    if (count == 8) {
      secondProgressPath = Assets.progress6;
      thirdProgressPath = Assets.progress8;
    }
    if (count == 7) {
      thirdProgressPath = Assets.progress9;
      fourthProgressPath = Assets.progress11;
    }
    if (count == 6) {
      fourthProgressPath = Assets.progress12;
    }
    if (mounted) {
      setState(() {});
    }
    if (count == 6) {
      Get.dialog(
          FirstProgressHintDialog(
            musicPromptData: widget.musicPromptData,
          ),
          barrierDismissible: false);
    }
  }

  double getFirstWidth() {
    if (count == 9) {
      return 160.w;
    }

    if (count <= 9) {
      return 128.w;
    }

    return 182.w;
  }

  double getSecondWidth() {
    if (count == 9) {
      return 151.w;
    }

    if (count <= 8) {
      return 128.w;
    }

    return 104.w;
  }

  double getThirdWidth() {
    if (count == 8) {
      return 151.w;
    }

    if (count <= 7) {
      return 206.w;
    }

    return 130.w;
  }

  double getFourthWidth() {
    if (count == 7) {
      return 151.w;
    }

    if (count <= 6) {
      return 128.w;
    }

    return 104.w;
  }

  @override
  Widget build(BuildContext context) {
    Get.log("count====> $count");
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;
        // controller.goBack();
      },
      child: Stack(
        children: [
          Container(
            width: 1.sw,
            height: 1.sh,
            decoration: const BoxDecoration(
              color: ByColorUtil.color121212,
            ),
            child: Column(
              children: [
                Image.asset(
                  Assets.loginBg3,
                  width: 1.sw,
                  height: 400.w,
                  fit: BoxFit.fill,
                ),
              ],
            ),
          ),
          Positioned(
              top: 287.w,
              child: Column(
                children: [
                  ///1
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset(
                        Assets.loginBg7,
                        width: 1.sw,
                        height: 64.w,
                      ),
                      Align(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (count == 10)
                            Image.asset(
                              Assets.headerIcon,
                              width: 26.w,
                              height: 34.w,
                            ),
                          if (count == 10)
                            Image.asset(
                              Assets.headerIcon,
                              width: 26.w,
                              height: 34.w,
                            ),
                          if (count == 10)
                            Image.asset(
                              Assets.headerIcon,
                              width: 26.w,
                              height: 34.w,
                            ),
                          Image.asset(
                            firstProgressPath,
                            width: getFirstWidth(),
                            height: 30.w,
                          ),
                          if (count == 10)
                            Transform.rotate(
                              angle: pi,
                              origin: const Offset(0, 0), // 以左上角为旋转中心
                              child: Image.asset(
                                Assets.headerIcon,
                                width: 26.w,
                                height: 34.w,
                              ),
                            ),
                          if (count == 10)
                            Transform.rotate(
                              angle: pi,
                              origin: const Offset(0, 0), // 以左上角为旋转中心
                              child: Image.asset(
                                Assets.headerIcon,
                                width: 26.w,
                                height: 34.w,
                              ),
                            ),
                          if (count == 10)
                            Transform.rotate(
                              angle: pi,
                              origin: const Offset(0, 0), // 以左上角为旋转中心
                              child: Image.asset(
                                Assets.headerIcon,
                                width: 26.w,
                                height: 34.w,
                              ),
                            ),
                        ],
                      ))
                    ],
                  ),

                  SizedBox(
                    height: 12.w,
                  ),

                  ///2
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset(
                        count <= 9 ? Assets.loginBg7 : Assets.loginBg4,
                        width: 1.sw,
                        height: 64.w,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Row(
                          children: [
                            if (count == 9)
                              Image.asset(
                                Assets.headerIcon,
                                width: 26.w,
                                height: 34.w,
                              ),
                            if (count == 9)
                              Image.asset(
                                Assets.headerIcon,
                                width: 26.w,
                                height: 34.w,
                              ),
                            if (count == 9)
                              Image.asset(
                                Assets.headerIcon,
                                width: 26.w,
                                height: 34.w,
                              ),
                            Image.asset(
                              secondProgressPath,
                              width: getSecondWidth(),
                              height: 30.w,
                            ),
                            if (count == 9)
                              Transform.rotate(
                                angle: pi,
                                origin: const Offset(0, 0), // 以左上角为旋转中心
                                child: Image.asset(
                                  Assets.headerIcon,
                                  width: 26.w,
                                  height: 34.w,
                                ),
                              ),
                            if (count == 9)
                              Transform.rotate(
                                angle: pi,
                                origin: const Offset(0, 0), // 以左上角为旋转中心
                                child: Image.asset(
                                  Assets.headerIcon,
                                  width: 26.w,
                                  height: 34.w,
                                ),
                              ),
                            if (count == 9)
                              Transform.rotate(
                                angle: pi,
                                origin: const Offset(0, 0), // 以左上角为旋转中心
                                child: Image.asset(
                                  Assets.headerIcon,
                                  width: 26.w,
                                  height: 34.w,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(
                    height: 12.w,
                  ),

                  ///3
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset(
                        count <= 8 ? Assets.loginBg7 : Assets.loginBg4,
                        width: 1.sw,
                        height: 64.w,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Row(
                          children: [
                            if (count == 8)
                              Image.asset(
                                Assets.headerIcon,
                                width: 26.w,
                                height: 34.w,
                              ),
                            if (count == 8)
                              Image.asset(
                                Assets.headerIcon,
                                width: 26.w,
                                height: 34.w,
                              ),
                            if (count == 8)
                              Image.asset(
                                Assets.headerIcon,
                                width: 26.w,
                                height: 34.w,
                              ),
                            Image.asset(
                              thirdProgressPath,
                              width: getThirdWidth(),
                              height: 30.w,
                            ),
                            if (count == 8)
                              Transform.rotate(
                                angle: pi,
                                origin: const Offset(0, 0), // 以左上角为旋转中心
                                child: Image.asset(
                                  Assets.headerIcon,
                                  width: 26.w,
                                  height: 34.w,
                                ),
                              ),
                            if (count == 8)
                              Transform.rotate(
                                angle: pi,
                                origin: const Offset(0, 0), // 以左上角为旋转中心
                                child: Image.asset(
                                  Assets.headerIcon,
                                  width: 26.w,
                                  height: 34.w,
                                ),
                              ),
                            if (count == 8)
                              Transform.rotate(
                                angle: pi,
                                origin: const Offset(0, 0), // 以左上角为旋转中心
                                child: Image.asset(
                                  Assets.headerIcon,
                                  width: 26.w,
                                  height: 34.w,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(
                    height: 12.w,
                  ),

                  ///4
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset(
                        count <= 7 ? Assets.loginBg7 : Assets.loginBg4,
                        width: 1.sw,
                        height: 64.w,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Row(
                          children: [
                            if (count == 7)
                              Image.asset(
                                Assets.headerIcon,
                                width: 26.w,
                                height: 34.w,
                              ),
                            if (count == 7)
                              Image.asset(
                                Assets.headerIcon,
                                width: 26.w,
                                height: 34.w,
                              ),
                            if (count == 7)
                              Image.asset(
                                Assets.headerIcon,
                                width: 26.w,
                                height: 34.w,
                              ),
                            Image.asset(
                              fourthProgressPath,
                              width: getFourthWidth(),
                              height: 30.w,
                            ),
                            if (count == 7)
                              Transform.rotate(
                                angle: pi,
                                origin: const Offset(0, 0), // 以左上角为旋转中心
                                child: Image.asset(
                                  Assets.headerIcon,
                                  width: 26.w,
                                  height: 34.w,
                                ),
                              ),
                            if (count == 7)
                              Transform.rotate(
                                angle: pi,
                                origin: const Offset(0, 0), // 以左上角为旋转中心
                                child: Image.asset(
                                  Assets.headerIcon,
                                  width: 26.w,
                                  height: 34.w,
                                ),
                              ),
                            if (count == 7)
                              Transform.rotate(
                                angle: pi,
                                origin: const Offset(0, 0), // 以左上角为旋转中心
                                child: Image.asset(
                                  Assets.headerIcon,
                                  width: 26.w,
                                  height: 34.w,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ))
        ],
      ),
    );
  }
}
