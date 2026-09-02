import 'dart:async';
import 'package:ai_golden_melody_master/common/lib/app_common/event/common_event.dart';
import 'package:ai_golden_melody_master/utils/common_event.dart';
import 'package:ai_golden_melody_master/view/ai/ai_play_music/share_dialog.dart';
import 'package:ai_golden_melody_master/view/lanuch_page/launch_controller.dart';
import 'package:ai_golden_melody_master/view/main/main_controller.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ai_golden_melody_master/common/lib/app_audio/byhy_audio_player.dart';
import 'package:ai_golden_melody_master/common/lib/app_http/apis.dart';
import 'package:ai_golden_melody_master/common/lib/app_http/http_utils.dart';
import 'package:ai_golden_melody_master/common/lib/app_ui/by_widgets_util.dart';
import 'package:ai_golden_melody_master/common/lib/app_time/byhy_time_utils.dart';
import '../../../model/ai_music/ai_music_detail_model.dart';
import '../../../model/launch/app_config.dart';
import '../../../utils/by_color_utils.dart';
import '../../../utils/data_service.dart';
import '../../../utils/file_download.dart';
import '../../me_center/my_work/down_load_music_dialog_ex.dart';
import '../../me_center/my_work/edit_music_cover/edit_music_cover_controller.dart';
import '../../me_center/my_work/rename_dialog.dart';
import '../free_time_finish_dialog.dart';

class AiPlayMusicController extends GetxController {
  ///从哪个页面来的 0-作品管理
  int type = 0;

  ///总共时长
  int musicTotalDuration = 0;

  ///当前播放时长
  int musicPlayDuration = 0;

  ///当前的播放状态
  PlayerState playerState = PlayerState.stopped;

  late StreamSubscription<ByAudioPlayerStatus> _subscription;

  final ByAudioPlayer audioPlayer = ByAudioPlayer.sharedInstance;

  ///music id
  int musicId = 0;

  MusicData? musicData;

  ///可以分享的平台数据
  List<SharingPlatform> sharingPlatform = [];

  LaunchController launchController = Get.find<LaunchController>();

  ///每次步进时间
  double progress = 5;

  bool isPlayed = false;

  ///是否第一次进入
  bool isFirst = false;

  ///第一次进入播放时间
  int playTime = 10;

  ///试用是否结束
  bool firstUseFinish = false;

  ///监听快速加载音乐数据事件.
  late StreamSubscription<RefreshMusicDataEvent>
      refreshMusicDataStreamSubscription;

  ///监听播放音乐数据事件.
  late StreamSubscription<PlayMusicDataEvent> playMusicDataStreamSubscription;
  @override
  void onInit() {
    initStreamSubscription();
    initData();
    initListen();
    super.onInit();
  }

  ///初始化监听
  initStreamSubscription() {
    refreshMusicDataStreamSubscription =
        eventBus.on<RefreshMusicDataEvent>().listen((e) {
      type = e.type;
      musicId = e.musicId;
      isFirst = e.isFirst;
      HttpUtils.get(APIs.getMusicDetail, {
        "id": musicId,
      }, success: (data) async {
        AiMusicDetailModel aiMusicDetailModel =
            AiMusicDetailModel.fromJson(data);
        if (aiMusicDetailModel.status == 200) {
          musicData = aiMusicDetailModel.data;
          if (musicData != null) {
            await audioPlayer.setSource(musicData!.musicUrl ?? "",
                isFromServer: true);
            Duration? duration = await audioPlayer.getDuration();
            if (duration != null) {
              musicTotalDuration = duration.inSeconds;
              Get.log("===获取到的音频总时长=== $musicTotalDuration");
              update();
            }
          }
        }
        Get.log("===获取歌曲详细数据=== $data");
        update();
      });
      AppConfig? appConfig = launchController.appConfig;
      if (appConfig != null) {
        AppConfigData? appConfigData = appConfig.data;
        if (appConfigData != null) {
          sharingPlatform = appConfigData.sharingPlatform ?? [];
        }
      }
      playTime = launchController.playTime;
      update();
    });
    playMusicDataStreamSubscription =
        eventBus.on<PlayMusicDataEvent>().listen((e) {
      if (musicData != null) {
        playMusic();
      }
    });
  }

  ///初始化数据
  initData() async {
    final dynamic arguments = Get.arguments;
    if (arguments != null) {
      type = arguments["type"];
      musicId = arguments["id"];
      isFirst = arguments["isFirst"] ?? false;
      Get.log("===进入播放页面的参数arguments=== $arguments");
      HttpUtils.get(APIs.getMusicDetail, {
        "id": musicId,
      }, success: (data) async {
        AiMusicDetailModel aiMusicDetailModel =
            AiMusicDetailModel.fromJson(data);
        if (aiMusicDetailModel.status == 200) {
          musicData = aiMusicDetailModel.data;
          if (musicData != null) {
            await audioPlayer.setSource(musicData!.musicUrl ?? "",
                isFromServer: true);
            Duration? duration = await audioPlayer.getDuration();
            if (duration != null) {
              musicTotalDuration = duration.inSeconds;
              Get.log("===获取到的音频总时长=== $musicTotalDuration");
              update();
            }
            // if (isFirst) {
            //   playMusic();
            // }

            playMusic();
          }
        }
        Get.log("===获取歌曲详细数据=== $data");
        update();
      });
    }

    AppConfig? appConfig = launchController.appConfig;
    if (appConfig != null) {
      AppConfigData? appConfigData = appConfig.data;
      if (appConfigData != null) {
        sharingPlatform = appConfigData.sharingPlatform ?? [];
      }
    }

    playTime = launchController.playTime;
    update();
  }

  ///初始化监听
  initListen() {
    try {
      audioPlayer.listener((s) {
        playerState = s;
        update();
      });
    } catch (e) {
      Get.log("===播放器状态监听异常");
    }

    try {
      audioPlayer.onPositionChanged(
        (duration) {
          musicPlayDuration = duration.inSeconds;
          isPlayed = true;

          ///检测第一次用户试用情况
          if (isFirst) {
            if (musicPlayDuration == playTime) {
              firstUseFinish = true;
              showFirstUseDialog(
                couldAwait: true,
                autoBack: true,
              );
              update();
              return;
            }
          }
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
    if (firstUseFinish) {
      DataService.onEvent(DataServiceEventName.obListenPlayClick, {});
      showFirstUseDialog(couldAwait: true);
      return;
    }
    try {
      if (musicData != null) {
        if (playerState == PlayerState.stopped) {
          await audioPlayer.play(musicData!.musicUrl ?? "");
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
    audioPlayer.playerDispose();
  }

  ///暂停播放
  pausePlayMusic() {
    audioPlayer.pause();
  }

  ///拖动音乐播放器
  void changePlayMusicProgress({
    required int value,
  }) async {
    if (firstUseFinish) {
      // showFirstUseDialog(couldAwait: true);
      return;
    }

    if (value > 0) {
      await ByAudioPlayer.sharedInstance.seekTo(value);
      if (musicData != null) {
        await ByAudioPlayer.sharedInstance.play(
          musicData!.musicUrl ?? "",
          releaseMode: ReleaseMode.stop,
          position: Duration(seconds: value),
        );
      }
    }
  }

  ///0- 减少  1-增加
  void changePlayMusicProgressByProgress({int type = 0}) async {
    int value = 0;
    if (type == 0) {
      if (musicPlayDuration >= 5) {
        value = musicPlayDuration - 5;
      }
    } else {
      int data = musicTotalDuration - musicPlayDuration;
      if (data >= 5) {
        value = musicPlayDuration + 5;
      } else {
        value = musicTotalDuration;
      }
    }

    if (value == 0 && !isPlayed) {
      return;
    }

    if (value >= 0) {
      await ByAudioPlayer.sharedInstance.seekTo(value);
      if (musicData != null) {
        await ByAudioPlayer.sharedInstance.play(
          musicData!.musicUrl ?? "",
          releaseMode: ReleaseMode.stop,
          position: Duration(seconds: value),
        );
      }
    }
  }

  String removeTags(String lyrics) {
    if (lyrics.isEmpty) {
      return "";
    }

    /// 匹配方括号及其内容的正则表达式
    final RegExp tagRegex = RegExp(r'\[.*?\]');

    /// 移除所有匹配到的标签，并去除多余的空白行
    return lyrics
        .replaceAll(tagRegex, '')
        .replaceAll(RegExp(r'\n\s*\n'), '\n\n')
        .trim();
  }

  ///展示下载弹窗
  showDownDialog() {
    pausePlayMusic();
    // Get.dialog(downDialog());
    if (musicData == null) {
      return;
    }
    Get.log("===点击打开下载弹窗===");
    showModalBottomSheet(
        context: Get.context!,
        builder: (c) {
          // return ShareDialog(sharePath: shareUrl);
          return DownloadMusicDialogEx(
            musicItem: musicData!,
          );
        },
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ));
  }

  ///下载弹窗
  Widget downDialog() {
    String downLoadUrl = "";
    if (musicData != null) {
      downLoadUrl = musicData!.musicUrl ?? "";
    }
    return Center(
      child: SizedBox(
          width: double.infinity,
          height: 430.w,
          child: Stack(
            children: [
              Container(
                height: 430.w,
                margin: EdgeInsets.only(
                  left: 12.w,
                  right: 12.w,
                  bottom: 90.w,
                  top: 60.w,
                ),
                decoration: BoxDecoration(
                  color: ByColorUtil.color2e2e2e,
                  borderRadius: BorderRadius.circular(16.w),
                ),
              ),
              Positioned(
                top: 60.w,
                child: Image.asset(
                  "assets/common/hint_bg.png",
                  width: 1.sw,
                  height: 120.w,
                ),
              ),
              Positioned(
                left: 36.w,
                right: 36.w,
                top: 60.w,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 30.w,
                    ),
                    ByWidgetsUtil.commonText(
                        text: "下载提示",
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                        textColor: Colors.white),
                    SizedBox(
                      height: 30.w,
                    ),
                    Padding(
                        padding: EdgeInsets.only(left: 6.w, bottom: 12.w),
                        child: Text(
                          "点击下面按钮复制下载链接到电脑或者浏览器中下载查看。",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.normal,
                          ),
                          textAlign: TextAlign.center,
                        )),
                    Container(
                      height: 44.w,
                      padding: EdgeInsets.only(
                        left: 12.w,
                        right: 12.w,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12.w),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        downLoadUrl,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 14.sp,
                        ),
                        maxLines: 1,
                      ),
                    ),
                    InkResponse(
                      onTap: () {
                        copyDownLoadUrl(
                          url: downLoadUrl,
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 32.w),
                        decoration: BoxDecoration(
                          color: ByColorUtil.color00CB64,
                          borderRadius: BorderRadius.circular(12.w),
                        ),
                        padding: EdgeInsets.only(
                          top: 13.w,
                          bottom: 13.w,
                          left: 56.w,
                          right: 56.w,
                        ),
                        child: Text(
                          "复制链接",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Positioned(
                  top: 74.w,
                  right: 28.w,
                  child: InkResponse(
                    onTap: () {
                      Get.back();
                    },
                    child: Icon(
                      Icons.close,
                      color: Colors.white.withOpacity(0.4),
                    ),
                  ))
            ],
          )),
    );
  }

  ///复制下载地址
  copyDownLoadUrl({
    required String url,
  }) async {
    if (url.isEmpty) {
      EasyLoading.showToast(
        "复制链接地址不能为空~",
        maskType: EasyLoadingMaskType.none,
      );
      return;
    }
    ClipboardData data = ClipboardData(text: url);
    await Clipboard.setData(data);
    EasyLoading.showToast(
      "复制链接地址成功～",
      maskType: EasyLoadingMaskType.none,
    );
  }

  ///生成一键同款
  createSame() {
    int mode = 1;
    if (musicData != null) {
      mode = musicData!.mode ?? 1;
    }
    if (musicData == null) {
      return;
    }
    Get.log("===一键同款=== ${musicData!.audioUrl}");
    Get.back();
    Get.back();
    Get.find<MainController>().tabChanged(index: 1);
    eventBus.fire(CreateSampleEvent(
      mode: mode,
      musicData: musicData!,
    ));
    Get.log("一键同款的音乐模式==>${mode}");
  }

  ///
  shareDialog() {
    showModalBottomSheet(
        context: Get.context!,
        builder: (c) {
          return ShareDialog(
            sharePath: musicData!.shareUrl ?? "",
            musicData: musicData,
          );
        },
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ));
  }

  /// type 0-mp3 1-wav 2-伴奏文件 3-分轨文件
  void downloadUrl({
    required int type,
  }) {
    if (musicData == null) {
      return;
    }

    Get.log("${musicData!.musicUrl} ");
    Get.log("${ByHyTimeUtils.timeFromDateTime(DateTime.now())}");
    String url = musicData!.musicUrl ?? "";
    String suffix = ".mp3";
    if (type == 0) {
      url = musicData!.musicUrl ?? "";
      suffix = ".mp3";
    } else if (type == 1) {
      url = musicData!.musicWavUrl ?? "";
      suffix = ".wav";
    } else if (type == 2) {
      url = musicData!.musicBackUrl ?? "";
      suffix = ".mp3";
    } else if (type == 3) {
      url = musicData!.musicMidiUrl ?? "";
      suffix = ".mid";
    }

    String date = "${ByHyTimeUtils.timeFromDateTime(DateTime.now())}";
    String musicName = musicData!.name ?? "";
    if (url.isNotEmpty) {
      EasyLoading.show();
      FileDownloader.downloadWordFile(
          url: url,
          fileName: "$musicName-$date$suffix",
          onProgress: (progress) {
            Get.log("==当前进度=== $progress");
          },
          done: (path) {
            Get.log("==完成后的地址=== $path");
            EasyLoading.dismiss();
            ShareService.shareFile(
              path,
            );
          },
          failed: () {
            EasyLoading.dismiss();
          });
    } else {
      String fileText = "MP3文件";
      if (type == 0) {
        fileText = "MP3文件";
      } else if (type == 1) {
        fileText = "WAV文件";
      } else if (type == 2) {
        fileText = "伴奏文件";
      } else if (type == 3) {
        fileText = "分轨文件";
      }
      EasyLoading.showToast("当前$fileText地址为空");
    }
  }

  void editMusicAuthorName() {
    Get.log("===纯音乐模式播放=== ${musicData?.name}");

    if (musicData == null) {
      return;
    }

    Get.dialog(
      RenameDialog(
        name: "",
        id: musicData!.id!,
        title: "修改作者名",
      ),
    ).then((value) {
      if (value != null) {
        Get.log("===newName=== ${value["newName"]}");
        if (value["newName"] != null) {
          renameAuthorNameEvent(
            name: value["newName"],
            id: musicData!.id!,
          );
        }
      }
    });
  }

  ///给服务器提交修改的音乐名称
  renameAuthorNameEvent({required String name, required int id}) {
    HttpUtils.post(APIs.reNameAuthor, {
      "id": musicId, "name": name,
      "type": 1, // 1.演唱者 2.词作者 3.曲作者
    }, success: (value) {
      musicData!.musicAuthor = name;
      EasyLoading.showToast("修改作者名成功~", maskType: EasyLoadingMaskType.none);
      eventBus.fire(const CoverSuccessEvent());
      update();
    }, fail: (code, msg) {
      EasyLoading.showToast(msg, maskType: EasyLoadingMaskType.none);
    });
  }

  ///挽留弹窗
  showFirstUseDialog({
    required bool couldAwait,
    bool autoBack = false,
  }) {
    pausePlayMusic();
    Get.dialog(
        FreeTimeFinishDialog(
          couldAwait: couldAwait,
          autoBack: autoBack,
        ),
        barrierDismissible: false,
        barrierColor: const Color(0XFF000000).withOpacity(1));
  }

  @override
  void dispose() {
    disposeAudioPlayer();
    super.dispose();
  }
}
