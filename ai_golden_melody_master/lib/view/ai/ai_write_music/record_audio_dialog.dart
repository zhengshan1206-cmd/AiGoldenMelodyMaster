import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:ai_golden_melody_master/common/lib/app_common/event/common_event.dart';
import 'package:ai_golden_melody_master/navigator/app_pages.dart';
import 'package:ai_golden_melody_master/view/ai/ai_write_music/ai_write_music_controller.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ai_golden_melody_master/common/lib/app_time/byhy_time_utils.dart';
import 'package:ai_golden_melody_master/common/lib/app_audio/by_recorder.dart';
import 'package:ai_golden_melody_master/common/lib/app_common/by_common_utils.dart';
import 'package:lottie/lottie.dart';
import '../../../model/ai_music/ai_music_config_list_model.dart';
import '../../../utils/assets.dart';
import '../../../utils/by_color_utils.dart';
import '../../../utils/common_event.dart';
import 'ai_record_controller.dart';

///录制音频提示弹窗
class RecordAudioHintDialog extends StatefulWidget {
  final AiMusicConfigListItem selectedAiMusicConfigListItem;
  final int? costMusicNote;
  final int? remainMusicNote;
  const RecordAudioHintDialog({
    super.key,
    required this.selectedAiMusicConfigListItem,
    this.costMusicNote,
    this.remainMusicNote,
  });

  @override
  State<RecordAudioHintDialog> createState() => _RecordAudioHintDialogState();
}

class _RecordAudioHintDialogState extends State<RecordAudioHintDialog>
    with TickerProviderStateMixin {
  // late AiMusicConfigListItem selectedAiMusicConfigListItem;

  AiRecordController aiRecordController = Get.find<AiRecordController>();

  late final AnimationController _controller;

  @override
  void initState() {
    // selectedAiMusicConfigListItem = widget.selectedAiMusicConfigListItem;
    // aiRecordController.updateSelectedAiMusicConfigListItem(
    //   aiMusicConfigListItem: selectedAiMusicConfigListItem,
    // );

    aiRecordController.initListen();
    _controller = AnimationController(
      vsync: this,
    );

    super.initState();
  }

  @override
  void dispose() {
    aiRecordController.disposeAudioPlayer();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 0.6.sh,
      decoration: BoxDecoration(
          color: ByColorUtil.color2e2e2e,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(12.w),
            topLeft: Radius.circular(12.w),
          )),
      padding: EdgeInsets.only(
        left: 12.w,
        top: 20.w,
        right: 12.w,
      ),
      child: GetBuilder<AiRecordController>(
        builder: (controller) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "录制须知",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                    ),
                  ),
                  const Spacer(),
                  InkResponse(
                    onTap: () {
                      controller.goBack();
                    },
                    child: Container(
                      width: 30.w,
                      height: 30.w,
                      color: Colors.transparent,
                      alignment: Alignment.centerRight,
                      child: Image.asset(
                        Assets.aiClosedIcon,
                        width: 16.w,
                        height: 16.w,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10.w,
              ),
              Image.asset(
                Assets.exclusiveModeIcon3,
                width: 375.w,
                height: 197.w,
              ),
              Text(
                "参考效果",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 14.sp,
                ),
              ),
              Container(
                width: 1.sw,
                height: 52.w,
                margin: EdgeInsets.only(top: 10.w, bottom: 21.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.w),
                  gradient: const LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Color(0xFF5C5C5C), Color(0xFF515151)],
                  ),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 12.w,
                    ),
                    InkResponse(
                      onTap: () async {
                        await controller.playMusic();
                      },
                      child: Container(
                        width: 32.w,
                        height: 32.w,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(32.w),
                            color: ByColorUtil.color000000.withOpacity(0.2)),
                        alignment: Alignment.center,
                        child: Image.asset(
                          controller.playerState == PlayerState.playing
                              ? Assets.pauseIcon2
                              : Assets.play,
                          width: 16.w,
                          height: 16.w,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 12.w,
                    ),
                   Expanded(child:  Lottie.asset(
                     Assets.voiceAnimation,
                     animate:
                     aiRecordController.playerState == PlayerState.playing
                         ? true
                         : false,
                   ),),
                    // SizedBox(
                    //   width: 12.w,
                    // ),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset(
                          Assets.musicIcon3,
                          width: 60.w,
                          height: 52.w,
                          // color: Colors.red,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            ByHyTimeUtils.timeWithSeconds(
                                (controller.musicTotalDuration -
                                    controller.musicPlayDuration)),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13.sp,
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            InkResponse(
              onTap: (){
                Get.toNamed(Routes.meMusicNoteValuePage);
              },
              child:   Row(
                children: [
                  Text(
                    "本次消耗${widget.costMusicNote??""}音符值",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 12.sp,
                    ),
                  ),
                  const Spacer(),
                  Image.asset(
                    Assets.diamondIcon,
                    width: 14.w,
                    height: 14.w,
                  ),
                  SizedBox(
                    width: 4.w,
                  ),
                  Text(
                    "剩余",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 13.sp,
                    ),
                  ),
                  Text(
                    "${widget.remainMusicNote??""}",
                    style: TextStyle(
                      color: ByColorUtil.colorF79B0B,
                      fontSize: 13.sp,
                    ),
                  ),
                  Text(
                    "音符值",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 13.sp,
                    ),
                  ),
                ],
              ),
            ),
              InkResponse(
                onTap: () {
                  controller.startRecord();
                },
                child: Container(
                    alignment: Alignment.center,
                    width: 1.sw,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Color(0xFFFEC57F),
                          Color(0xFFFFE3B4),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: EdgeInsets.only(
                      top: 10.w,
                    ),
                    padding: EdgeInsets.only(
                      top: 13.w,
                      bottom: 13.w,
                    ),
                    child: ShaderMask(
                      blendMode: BlendMode.srcIn,
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [Color(0xFF9F5602), Color(0xFFC17015)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ).createShader(bounds),
                      child: Text(
                        "我知道了,开始录制",
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: ByColorUtil.colorC16515,
                        ),
                      ),
                    )),
              )
            ],
          );
        },
      ),
    );
  }
}

///录制音频弹窗
class RecordAudioDialog extends StatefulWidget {
  const RecordAudioDialog({
    super.key,
  });

  @override
  State<RecordAudioDialog> createState() => _RecordAudioDialogState();
}


///录制音频弹窗--state
class _RecordAudioDialogState extends State<RecordAudioDialog>
    with TickerProviderStateMixin {
  AiRecordController aiRecordController = Get.find<AiRecordController>();
  late final AnimationController _controller;

  final ByRecorder _audioRecorder = ByRecorder();

  Timer? _timer;
  int _seconds = 0;
  final minSeconds = 0;
  final maxSeconds = 30;
  // final maxSeconds = 60;


  late StreamSubscription<RecordEvent> streamSubscription;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
    );

    _audioRecorder.initialize().then((value) {
    bool isCompleteRecord =   Get.find<AiWriteMusicController>().isCompleteRecord;

    if(isCompleteRecord){
      return;
    }

      Future.delayed(const Duration(milliseconds: 100), () {
        _audioRecorder.startRecording();
        _startTimer();
      });
    });

    streamSubscription = eventBus.on<RecordEvent>().listen((e) {
      if (e.status == 2||e.status==1) {
       if(mounted){
         setState(() {
           _seconds = 0;
         });
       }
        ///开始重新录制
        aiRecordController.updateCompleteRecordVoice(value: false);
        Get.find<AiWriteMusicController>().updateIsRecordVoice(value: true);
        Get.find<AiWriteMusicController>()
            .updateCompleteRecordVoice(value: false);
        _audioRecorder.initialize().then((value) {
          Future.delayed(const Duration(milliseconds: 500), () {
            _audioRecorder.startRecording();
            _startTimer();
          });
        });
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    aiRecordController.disposeAudioPlayer();
    _timer?.cancel();
    _seconds = 0;
    _audioRecorder.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    _seconds = 0;
    _timer = Timer.periodic(const Duration(milliseconds: 1000), (timer) async {
      setState(() {
        _seconds++;
      });
      Get.find<AiWriteMusicController>().updateIsRecordVoice(value: true);
      if (_seconds >= maxSeconds) {
        _finish();
      }
    });
  }

  /// 结束录音
  _finish() async {
    _timer?.cancel();
    final recordingPath = await _audioRecorder.stopRecording();
    _audioRecorder.dispose();
    Get.find<AiWriteMusicController>().updateIsRecordVoice(value: false);
    Get.find<AiWriteMusicController>().updateCompleteRecordVoice(value: true);
    aiRecordController.updateCompleteRecordVoice(value: true);
    Get.find<AiWriteMusicController>()
        .updateAudioFilePath(path: recordingPath ?? "");
    byDebugPrint(recordingPath, tag: "录音路径:");
    bool cannotNext =
        recordingPath == null || File(recordingPath).existsSync() == false;
    if (cannotNext) {
      EasyLoading.showToast(
        "保存录音失败,请稍后重试",
        maskType: EasyLoadingMaskType.none,
      );
      return;
    }
  }

  ///完成录制音频
  Widget _completeRecordView({
    required AiRecordController controller,
  }) {
    if (controller.isCompleteRecord) {
      return Column(
        children: [
          SizedBox(
            height: 82.w,
          ),
          Image.asset(
            Assets.exclusiveModeIcon2,
            width: 100.w,
            height: 40.w,
          ),
          Text(
            "录制完成",
            style: TextStyle(
                color: Colors.white,
                fontSize: 20.sp,
                fontWeight: FontWeight.w800),
          ),
        ],
      );
    }

    return Column(
      children: [
        SizedBox(
          height: 64.w,
        ),
        Text(
          ByHyTimeUtils.timeWithSeconds((maxSeconds-_seconds)),
          style: TextStyle(
              color: Colors.white,
              fontSize: 32.sp,
              fontWeight: FontWeight.normal),
        ),
        SizedBox(height: 16.w,),
        Lottie.asset(
          Assets.voiceAnimation2,
          animate:true,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AiRecordController>(
      builder: (controller) {
        return ClipRect(
          child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 10,
                sigmaY: 10,
              ),
              child: Container(
                width: 1.sw,
                height: 195.w,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color(0xFF121212).withOpacity(0),
                      const Color(0xFF121212).withOpacity(0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(0),
                ),
                child: _completeRecordView(
                  controller: controller,
                ),
              )),
        );
      },
    );
  }
}

class BlurContainer extends StatelessWidget {
  final double blurSigma;
  final Widget? child;

  const BlurContainer({
    Key? key,
    this.blurSigma = 10.0,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // 使用BackdropFilter实现高斯模糊
        BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: blurSigma,
            sigmaY: blurSigma,
          ),
          child: Container(
            color: Colors.transparent,
          ),
        ),
        // 如果有子组件，则显示在模糊层之上
        if (child != null)
          Positioned.fill(
            child: child!,
          ),
      ],
    );
  }
}
