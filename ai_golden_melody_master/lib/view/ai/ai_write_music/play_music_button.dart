import 'dart:async';

import 'package:ai_golden_melody_master/common/lib/app_common/event/common_event.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ai_golden_melody_master/common/lib/app_audio/byhy_audio_player.dart';
import 'package:ai_golden_melody_master/common/lib/app_time/byhy_time_utils.dart';
import 'package:lottie/lottie.dart';
import '../../../model/ai_music/ai_music_config_list_model.dart';
import '../../../utils/assets.dart';
import '../../../utils/by_color_utils.dart';
import '../../../utils/common_event.dart';
import 'ai_write_music_controller.dart';

class PlayMusicButton extends StatefulWidget {
  final AiMusicConfigListItem selectedAiMusicConfigListItem;
  final String musicPath;
  final double marginTop;
  final double marginBottom;
  final bool isPlaySource;
  const PlayMusicButton({
    super.key,
    required this.selectedAiMusicConfigListItem,
    required this.musicPath,
    this.marginTop = 10,
    this.marginBottom = 21,
    this.isPlaySource = true,
  });

  @override
  State<PlayMusicButton> createState() => _PlayMusicButtonState();
}

class _PlayMusicButtonState extends State<PlayMusicButton>
    with TickerProviderStateMixin {
  ///当前的播放状态
  PlayerState playerState = PlayerState.stopped;
  late StreamSubscription<ByAudioPlayerStatus> _subscription;
  final ByAudioPlayer audioPlayer = ByAudioPlayer.sharedInstance;
  AiMusicConfigListItem? selectedAiMusicConfigListItem;

  ///当前音频时长
  int musicTotalDuration = 30;

  ///当前播放时长 type1
  int musicPlayDuration = 0;
  AiWriteMusicController aiWriteMusicController =
      Get.find<AiWriteMusicController>();

  ///录音完成
  bool isCompleteRecord = false;

  late final AnimationController _controller;

  String musicPath = "";

  late StreamSubscription<UpdateVoiceTimbreItemEvent> streamSubscription;

  late StreamSubscription<StopMusicButtonEvent> streamSubscription2;

  ///更新当前选中的音乐条目
  updateSelectedAiMusicConfigListItem({
    required AiMusicConfigListItem? aiMusicConfigListItem,
  }) {
    selectedAiMusicConfigListItem = aiMusicConfigListItem;
    if (selectedAiMusicConfigListItem != null) {
      Get.log("===当前的参考音频数据===  ${selectedAiMusicConfigListItem!.toString()}");
    }

    musicPath = widget.musicPath;
    setState(() {});
  }

  ///初始化监听
  initListen() {
    streamSubscription2 = eventBus.on<StopMusicButtonEvent>().listen((e) async {
      Get.log("===当前按钮播放器的状态=== ${playerState}");

      if (playerState == PlayerState.playing) {
        await audioPlayer.stop();
        if (mounted) {
          setState(() {
            playerState = PlayerState.stopped;
          });
        }
      }
    });

    try {
      audioPlayer.listener((s) {
        Get.log("===按钮播放器播放器状态1===${audioPlayer.type}");

        if (audioPlayer.type == 1) {
          return;
        }

        if (mounted) {
          playerState = s;
          setState(() {});
        }
      });
    } catch (e) {
      Get.log("===播放器状态监听异常");
    }

    try {
      audioPlayer.onPositionChanged(
        (duration) {
          Get.log("===按钮播放器播放器状态2===${audioPlayer.type}");
          if (audioPlayer.type == 1) {
            return;
          }
          if (mounted) {
            musicPlayDuration = duration.inSeconds;
            setState(() {});
          }
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

    streamSubscription = eventBus.on<UpdateVoiceTimbreItemEvent>().listen((e) {
      // if (playerState == PlayerState.playing) {
      //
      // }

      pausePlayMusic();
      musicPath = e.item.voiceTimbreUrl!;
      musicTotalDuration = 30;
      if (mounted) {
        setState(() {
          musicPlayDuration = 0;
        });
      }
      audioPlayer.setSource(musicPath,isFromServer: widget.isPlaySource);
      if (mounted) {
        setState(() {});
      }
    });
  }

  ///播放音乐
  playMusic() async {
    Get.log("musicPath===> $musicPath   state==>${playerState}");
    audioPlayer.type = 2;
    try {
      if (musicPath.isNotEmpty) {
        if (playerState == PlayerState.stopped) {
          await audioPlayer.play(musicPath, isPlaySource: widget.isPlaySource);
        } else if (playerState == PlayerState.paused) {
          // await audioPlayer.play(musicPath, isPlaySource: widget.isPlaySource);

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
    audioPlayer.playerDispose();
  }

  ///暂停播放
  pausePlayMusic() {
    audioPlayer.pause();
  }

  @override
  void initState() {
    updateSelectedAiMusicConfigListItem(
        aiMusicConfigListItem: widget.selectedAiMusicConfigListItem);
    _controller = AnimationController(
      vsync: this,
    );
    initListen();
    super.initState();
  }

  @override
  void dispose() {
    disposeAudioPlayer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.sw,
      height: 52.w,
      margin: EdgeInsets.only(
          top: widget.marginTop.w, bottom: widget.marginBottom.w),
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
              await playMusic();
            },
            child: Container(
              width: 32.w,
              height: 32.w,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32.w),
                  color: ByColorUtil.color000000.withOpacity(0.2)),
              alignment: Alignment.center,
              child: Image.asset(
                playerState == PlayerState.playing
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
          Expanded(
            child: Lottie.asset(
              Assets.voiceAnimation,
              animate: playerState == PlayerState.playing ? true : false,
            ),
          ),
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
                      (musicTotalDuration - musicPlayDuration)),
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
    );
  }
}
