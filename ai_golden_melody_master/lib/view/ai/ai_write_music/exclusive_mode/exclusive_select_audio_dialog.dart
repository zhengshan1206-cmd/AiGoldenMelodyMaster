import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../common/lib/app_ui/by_widgets_util.dart';
import '../../../../model/ai_music/voice_timbre_response.dart';
import '../../../../utils/assets.dart';
import '../../../../utils/by_color_utils.dart';
import '../ai_write_music_controller.dart';
import '../play_music_button.dart';

class ExclusiveSelectAudioDialog extends StatefulWidget {
  const ExclusiveSelectAudioDialog({super.key});

  @override
  State<ExclusiveSelectAudioDialog> createState() =>
      _ExclusiveSelectAudioDialogState();
}

class _ExclusiveSelectAudioDialogState
    extends State<ExclusiveSelectAudioDialog> {
  late AiWriteMusicController controller;

  ///选择历史音频
  Widget _selectHistoryMusicView() {
    List<VoiceTimbreItem> voiceTimbreList = [];
    if(controller.voiceTimbreList.isNotEmpty){
      for (var e in controller.voiceTimbreList) {
        if(e.status==1){
          voiceTimbreList.add(e);
        }
      }
    }
    Get.log("====firstVoiceTimbreItem=== ${voiceTimbreList.length}");

    VoiceTimbreItem firstVoiceTimbreItem = controller.selectedVoiceTimbreItem!;
    Get.log("====firstVoiceTimbreItem=== ${firstVoiceTimbreItem.name}");

    return Column(
      children: [
        Stack(
          children: [
            Container(
              width: 1.sw,
              height: 162,
              decoration: BoxDecoration(
                  image: const DecorationImage(
                      opacity: 0.7,
                      image: AssetImage(
                        Assets.maskerBg1,
                      ),
                      fit: BoxFit.fitWidth),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(12.w),
                    topLeft: Radius.circular(12.w),
                  )),
              padding: EdgeInsets.only(
                top: 10.w,
                left: 12.w,
                right: 12.w,
              ),
            ),
            Positioned(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 12.w,
                      ),
                      ByWidgetsUtil.commonRichText(
                        texts: [
                          TextSpan(
                            text: "声音试听",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp,
                            ),
                          )
                        ],
                        fontSize: 12.sp,
                        textColor:
                            ByColorUtil.LoginTextfieldTextColor.withOpacity(
                                0.6),
                      ),
                      const Spacer(),
                      InkResponse(
                        onTap: () {
                          Get.back();
                        },
                        child: Container(
                          width: 35.w,
                          height: 35.w,
                          color: Colors.transparent,
                          alignment: Alignment.center,
                          child: Image.asset(
                            Assets.iconClose,
                            width: 16.w,
                            height: 16.w,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Image.asset(
                    Assets.maskerBg2,
                    width: 68.w,
                    height: 68.w,
                  ),
                  Text(
                    "${firstVoiceTimbreItem.name}",
                    style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                ],
              ),
            )
          ],
        ),

        if (controller.selectedVoiceTimbreItem!.status == 1)
          Padding(
            padding: EdgeInsets.only(
              left: 12.w,
              right: 12.w,
            ),
            child: PlayMusicButton(
              selectedAiMusicConfigListItem:
                  controller.selectedAiMusicConfigListItem!,
              musicPath: firstVoiceTimbreItem.voiceTimbreUrl ?? "",
              marginTop: 0,
              marginBottom: 0,
              isPlaySource: false,
            ),
          ),

        ///选择您的专属声音
        Container(
          width: 1.sw,
          height: 172.w,
          margin: EdgeInsets.only(
            left: 12.w,
            right: 12.w,
            top: 15.w,
          ),
          padding:
              EdgeInsets.only(left: 12.w, right: 12.w, top: 15.w, bottom: 0.w),
          decoration: BoxDecoration(
            // color: ByColorUtil.color1E1E1E,
            borderRadius: BorderRadius.circular(10.w),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "选择您的专属声音",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 16.w,
              ),

              ///选择音色区域 开始新的 选择已有的数据库
              SizedBox(
                height: 100.w,
                child: ListView(
                  padding: EdgeInsets.zero,
                  scrollDirection: Axis.horizontal,
                  children: [
                    InkResponse(
                      onTap: () {},
                      child: _newVoiceItemView(),
                    ),
                    ...voiceTimbreList.map((e) => _voiceItemView(
                          item: e,
                        )),
                    // _voiceItemView(),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  ///打开音频录制弹窗按钮
  Widget _newVoiceItemView() {
    return InkResponse(
      onTap: () {
        ///重新开始训练音频
        Get.log("===打开音频录制弹窗===");
        Get.back();
        controller.reStartPractice();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 3.w,
          ),
          Container(
            margin: EdgeInsets.only(right: 10.w),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(8.w),
            ),
            width: 68.w,
            height: 68.w,
            alignment: Alignment.center,
            child: Image.asset(
              Assets.exclusiveModeIcon6,
              width: 24.w,
              height: 24.w,
            ),
          ),
          SizedBox(
            height: 10.w,
          ),
          Padding(
            padding: EdgeInsets.only(
              right: 6.w,
            ),
            child: Text(
              "训练新的",
              style: TextStyle(
                color: Colors.white,
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          )
        ],
      ),
    );
  }

  ///
  Widget _voiceItemView({
    required VoiceTimbreItem item,
  }) {
    bool selected = false;
    if (controller.selectedVoiceTimbreItem != null) {
      if (controller.selectedVoiceTimbreItem!.id == item.id) {
        selected = true;
      }
    }

    return InkResponse(
      onTap: () {
        controller.updateVoiceTimbreItem(item: item);
      },
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(right: 4.w),
            decoration: BoxDecoration(
                border: Border.all(
                  width: 2.w,
                  color:
                      selected ? ByColorUtil.colorCCA869 : Colors.transparent,
                ),
                borderRadius: BorderRadius.circular(
                  8.w,
                )),
            padding: EdgeInsets.all(2.w),
            alignment: Alignment.center,
            child: Image.asset(
              Assets.exclusiveModeIcon5,
              width: 68.w,
              height: 68.w,
            ),
          ),
          const Spacer(),
          Container(
            width: 60.w,
            alignment: Alignment.center,
            child: Text(
              "${item.name}",
              style: TextStyle(
                color: Colors.white,
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    controller = Get.find<AiWriteMusicController>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AiWriteMusicController>(builder: (context) {
      return Container(
        height: 0.6.sh,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF2E2E2E).withOpacity(0.2),
              const Color(0xFF2E2E2E).withOpacity(0.72),
              const Color(0xFF2E2E2E).withOpacity(0.88),
              const Color(0xFF2E2E2E),
            ],
            stops: const [0.0, 0.5, 0.75, 1.0],
          ),
        ),
        padding: EdgeInsets.only(
            // left: 12.w,
            // top: 20.w,
            // right: 12.w,
            ),
        child: Column(
          children: [
            _selectHistoryMusicView(),
            InkResponse(
              onTap: () {
                if (controller.selectedVoiceTimbreItem!.status != 1) {
                  EasyLoading.showToast("当前音色已失败，您需要选择成功的音色～");
                  return;
                }
                Get.log(
                    "选中的音频===>${controller.selectedVoiceTimbreItem!.name} ");
                Get.back();
              },
              child: Container(
                width: 1.sw,
                height: 52,
                margin: EdgeInsets.only(
                  left: 12.w,
                  right: 12.w,
                ),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: const LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Color(0xFFFEC57F),
                      Color(0xFFFFE3B4),
                    ],
                  ),
                ),
                child: ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [
                      const Color(0xFF9F5602).withOpacity(1),
                      const Color(0xFFC17015)
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ).createShader(bounds),
                  child: Text(
                    "确认选择",
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      height: 1.0, // 对应 line-
                      // height: 18px必须是纯色才能应用渐变
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            )
          ],
        ),
      );
    });
  }
}
