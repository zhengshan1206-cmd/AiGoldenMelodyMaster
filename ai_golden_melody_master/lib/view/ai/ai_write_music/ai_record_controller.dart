import 'dart:async';
import 'package:ai_golden_melody_master/common/lib/app_common/event/common_event.dart';
import 'package:ai_golden_melody_master/utils/by_color_utils.dart';
import 'package:ai_golden_melody_master/view/ai/ai_write_music/record_audio_dialog.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';
import 'package:ai_golden_melody_master/common/lib/app_audio/byhy_audio_player.dart';
import 'package:ai_golden_melody_master/common/lib/app_permisson/byhy_permission_utils.dart';
import '../../../model/ai_music/ai_music_config_list_model.dart';
import 'ai_write_music_controller.dart';

///ai 录音业务逻辑处理
class AiRecordController extends GetxController {
  ///当前的播放状态
  PlayerState playerState = PlayerState.stopped;

  late StreamSubscription<ByAudioPlayerStatus> _subscription;

  final ByAudioPlayer audioPlayer = ByAudioPlayer.sharedInstance;

  AiMusicConfigListItem? selectedAiMusicConfigListItem;

  ///当前音频时长
  int musicTotalDuration = 0;

  ///当前播放时长
  int musicPlayDuration = 0;

  AiWriteMusicController aiWriteMusicController =
      Get.find<AiWriteMusicController>();

  ///录音完成
  bool isCompleteRecord = false;

  ///更新当前选中的音乐条目
  updateSelectedAiMusicConfigListItem({
    required AiMusicConfigListItem? aiMusicConfigListItem,
  }) async {
    selectedAiMusicConfigListItem = aiMusicConfigListItem;
    if (selectedAiMusicConfigListItem != null) {
      // musicTotalDuration = selectedAiMusicConfigListItem!.duration;
     await audioPlayer.setSource(selectedAiMusicConfigListItem!.musicUrl ?? "");
      Duration? duration = await audioPlayer.getDuration();
      if(duration!=null){
        musicTotalDuration = duration.inSeconds;
        update();
      }

      Get.log("===当前的参考音频数据时长===  $musicTotalDuration   音频数据id===${selectedAiMusicConfigListItem!.id}");
    }
    update();
  }

  ///初始化监听
  initListen() {
    try {
      audioPlayer.listener((s) {
        if(audioPlayer.type==2){
          return;
        }
        playerState = s;
        update();
      });
    } catch (e) {
      Get.log("===播放器状态监听异常");
    }

    try {
      audioPlayer.onPositionChanged(
        (duration) {
          if(audioPlayer.type==2){
            return;
          }
          musicPlayDuration = duration.inSeconds;
          // Get.log("===音乐播放进度===$musicPlayDuration");
          update();
        },
      );
    } catch (e) {
      Get.log("===播放器进度监听异常");
    }
    _subscription = audioPlayer
        .audioStream()
        .asBroadcastStream()
        .listen((audioPlayStatus) {}, onDone: () {
      _subscription.cancel();
    }, onError: (error) {
      Get.log('onError ... $error');
    });
  }

  ///播放音乐
  playMusic() async {
    try {
      audioPlayer.type =1;
      if (selectedAiMusicConfigListItem != null) {
        if (playerState == PlayerState.stopped) {
          await audioPlayer.play(selectedAiMusicConfigListItem!.musicUrl ?? "");
        } else if (playerState == PlayerState.paused) {
          await audioPlayer.resume();
        } else {
          await audioPlayer.pause();
        }
      }
    } catch (e) {
      Get.log("播放器监听异常2====");
    }
  }

  ///释放播放器资源
  disposeAudioPlayer() {
    // audioPlayer.playerDispose();
    audioPlayer.playerDispose();
  }

  ///暂停播放
  pausePlayMusic() {
    audioPlayer.pause();
  }

  ///开始录制
  void startRecord() async {
    pausePlayMusic();
    final permission = await ByPermissionUtils.microphone();
    if (permission == false) return;
    aiWriteMusicController.updateIsRecordVoice(value: true);
    eventBus.fire(const RecordEvent(status: 1));
    Get.back();
  }

  ///更新录音完成状态
  updateCompleteRecordVoice({required bool value,}){
    isCompleteRecord = value;
    update();
  }

  void goBack(){
    pausePlayMusic();
    Get.back();
  }

  @override
  void dispose() {
    disposeAudioPlayer();
    super.dispose();
  }
}

class RecordEvent {
  ///1 开始录音 0暂停录音 2重新开始录制
  final int status;
  const RecordEvent({
    this.status = 1,
  });
}
