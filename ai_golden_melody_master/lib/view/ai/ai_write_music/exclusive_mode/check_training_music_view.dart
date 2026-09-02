import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:ai_golden_melody_master/common/lib/app_http/apis.dart';
import 'package:ai_golden_melody_master/common/lib/app_http/http_utils.dart';
import 'package:lottie/lottie.dart';
import '../../../../model/ai_music/ai_exclusive_mode_task_model.dart';
import '../../../../model/ai_music/voice_timbre_response.dart';
import '../../../../utils/assets.dart';
import '../../../../utils/by_color_utils.dart';
import '../ai_write_music_controller.dart';

class CheckTrainingMusicView extends StatefulWidget {
  const CheckTrainingMusicView({super.key});

  @override
  State<CheckTrainingMusicView> createState() => _CheckTrainingMusicViewState();
}

class _CheckTrainingMusicViewState extends State<CheckTrainingMusicView> {
  AiWriteMusicController controller = Get.find<AiWriteMusicController>();

  ///定时器
  Timer? timer;

  ///是否正在查询
  bool isQuerying = false;

  ///最后一条训练中的音频状态
  String state = "0";

  ///当前训练音色数据
  VoiceTimbreItem? currentVoiceTimbreItem;

  ///历史训练音频数据
  List<VoiceTimbreItem> voiceTimbreList = [];

  ///开始查询
  startQuery() {
    stopQuery();
    performQuery();

    /// 启动周期性定时器
    timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      performQuery();
    });
  }

  ///停止查询
  stopQuery() {
    if (timer != null) {
      timer!.cancel();
      timer = null;
    }
  }

  ///立即查询
  performQuery() {
    if (isQuerying) {
      return;
    }

    isQuerying = true;
    try {
      checkAudioPracticeState();
    } catch (e) {
      stopQuery();
    } finally {
      isQuerying = false;
    }
    if (mounted) {
      setState(() {});
    }
  }

  ///检查音频训练状态
  checkAudioPracticeState() async {
    String taskId = "";
    String audioUrl = "";
    await HttpUtils.get(APIs.getLastTimbre, {}, success: (data) {
      AiExclusiveModeTaskModel? aiExclusiveModeTaskModel;
      aiExclusiveModeTaskModel = AiExclusiveModeTaskModel.fromJson(data);
      AiExclusiveModeTaskData? aiExclusiveModeTaskData;
      aiExclusiveModeTaskData = aiExclusiveModeTaskModel.data;
      if (aiExclusiveModeTaskData != null) {
        state = aiExclusiveModeTaskData.status.toString();
        taskId = aiExclusiveModeTaskData.taskId.toString();
        audioUrl = aiExclusiveModeTaskData.sourceAudioUrl.toString();
      }

      if (state == "0") {}

      if (state == "1") {
        stopQuery();
        getTrainTimbreList();
        Get.log("===进行中的历史音色任务 成功===");
      }

      if (state == "2") {
        stopQuery();
        getTrainTimbreList();
        Get.log("===进行中的历史音色任务失败===");
      }

      if (mounted) {
        setState(() {});
      }

      Get.log(
          "===查询历史音色任务===  state==$state  taskId==$taskId  audioUrl==$audioUrl");
    });
  }

  @override
  void initState() {
    super.initState();
    startQuery();
  }

  Widget _buildItem() {
    bool selected = false;
    if (state == "1" && currentVoiceTimbreItem != null) {
      if (controller.selectedVoiceTimbreItem != null) {
        if (controller.selectedVoiceTimbreItem!.id ==
            currentVoiceTimbreItem!.id) {
          selected = true;
        }
      }
      return InkResponse(
        onTap: () {
          controller.updateVoiceTimbreItem(item: currentVoiceTimbreItem!);
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
                "${currentVoiceTimbreItem!.name}",
                style: TextStyle(
                  color: selected ? ByColorUtil.colorCCA869 : Colors.white,
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

    if (state == "2" && currentVoiceTimbreItem != null) {
      if (controller.selectedVoiceTimbreItem != null) {
        if (controller.selectedVoiceTimbreItem!.id ==
            currentVoiceTimbreItem!.id) {
          selected = true;
        }
      }
      return InkResponse(
        onTap: () {
          controller.updateVoiceTimbreItem(item: currentVoiceTimbreItem!);
          EasyLoading.showToast("声音训练失败，请选择其他音频创作");
        },
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(right: 4.w),
              decoration: BoxDecoration(
                  border: Border.all(
                    width: 2.w,
                    color: selected
                        ? ByColorUtil.colorCCA869
                        : Colors.transparent,
                  ),
                  borderRadius: BorderRadius.circular(
                    8.w,
                  )),
              padding: EdgeInsets.all(2.w),
              alignment: Alignment.center,
              child: currentVoiceTimbreItem!.status == 1
                  ? Image.asset(
                Assets.exclusiveModeIcon5,
                width: 68.w,
                height: 68.w,
              )
                  : Container(
                width: 68.w,
                height: 68.w,
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(8.w),
                    border: Border.all(
                        color: Colors.white.withOpacity(0.1))),
                alignment: Alignment.center,
                child: Image.asset(
                  Assets.icon19,
                  width: 40.w,
                  height: 40.w,
                ),
              ),
            ),
            const Spacer(),
            Container(
              width: 60.w,
              alignment: Alignment.center,
              child: Text(
                "${currentVoiceTimbreItem!.name}",
                style: TextStyle(
                  color: selected ? ByColorUtil.colorCCA869 : Colors.white,
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

    return InkResponse(
      onTap: () {
        ///todo 未来音色事件
        EasyLoading.showToast("当前音色正在训练中~");
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
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF423C32), Color(0xFF373128)],
                ),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: const Color(0xFFFFFFFF).withOpacity(0.1),
                  width: 1,
                )),
            width: 68.w,
            height: 68.w,
            alignment: Alignment.center,
            // child: Image.asset(
            //   Assets.icon24,
            //   width: 24.w,
            //   height: 24.w,
            // ),
            child: SizedBox(
              width: 50.w,
              height: 50.w,
              child: Lottie.asset(
                Assets.data1Json,
                animate: true,
              ),
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
              "未来音色",
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

  ///获取已有的音频数据集合
  getTrainTimbreList() async {
    await HttpUtils.post(
      APIs.getTrainTimbreList,
      {
        "page": 1,
        "page_size": 999,
      },
      success: (data) {
        VoiceTimbreResponse voiceTimbreResponse =
            VoiceTimbreResponse.fromJson(data);
        if (voiceTimbreResponse.data != null) {
          List<VoiceTimbreItem>? data = voiceTimbreResponse.data!.data;
          if (data != null) {
            voiceTimbreList = data;
            if (voiceTimbreList.isNotEmpty) {
              currentVoiceTimbreItem = voiceTimbreList.first;
            }
          }
        }
        if (mounted) {
          setState(() {});
        }
      },
      fail: (code, msg) {
        EasyLoading.dismiss();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
   return _buildItem();
  }
}
