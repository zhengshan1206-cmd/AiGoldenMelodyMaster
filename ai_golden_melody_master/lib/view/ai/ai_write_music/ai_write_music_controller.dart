import 'dart:async';
import 'dart:math';
import 'package:ai_golden_melody_master/common/lib/app_common/event/common_event.dart';
import 'package:ai_golden_melody_master/model/ai_music/ai_exclusive_mode_task_model.dart';
import 'package:ai_golden_melody_master/model/ai_music/ai_write_music_model_response.dart';
import 'package:ai_golden_melody_master/utils/assets.dart';
import 'package:ai_golden_melody_master/utils/common_event.dart';
import 'package:ai_golden_melody_master/view/ai/ai_write_music/record_audio_dialog.dart';
import 'package:ai_golden_melody_master/view/publish/illegal_words/controller/illegal_words_controller.dart';
import 'package:ai_golden_melody_master/view/purchase/vip/vip_purchase_controller.dart';
import 'package:flustars_flutter3/flustars_flutter3.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ai_golden_melody_master/common/lib/app_http/apis.dart';
import 'package:ai_golden_melody_master/common/lib/app_http/http_utils.dart';
import 'package:ai_golden_melody_master/common/lib/app_ui/by_widgets_util.dart';
import 'package:ai_golden_melody_master/common/lib/by_ffmpeg_util.dart';
import 'package:ai_golden_melody_master/common/lib/app_common/consts/const_keys.dart';
import '../../../model/ai_music/ai_music_config_list_model.dart';
import '../../../model/ai_music/ai_music_config_model.dart';
import '../../../model/ai_music/ai_music_detail_model.dart';
import '../../../model/ai_music/ai_music_task_model.dart';
import '../../../model/ai_music/audio_separation_result.dart';
import '../../../model/ai_music/master_music_analysis_model.dart';
import '../../../model/ai_music/music_prompt_response.dart';
import '../../../model/ai_music/music_response.dart';
import '../../../model/ai_music/rights_by_type.dart';
import '../../../model/ai_music/upload_info_bean.dart';
import '../../../model/ai_music/voice_timbre_response.dart';
import '../../../model/launch/app_config.dart';
import '../../../model/user/user_info_bean.dart';
import '../../../navigator/app_pages.dart';
import '../../../utils/by_color_utils.dart';
import '../../../utils/stream_data_mixin.dart';
import '../../lanuch_page/launch_controller.dart';
import 'ai_music_config_dialog.dart';
import 'ai_record_controller.dart';
import 'ai_write_music_event.dart';
import 'exclusive_mode/exclusive_audio_privacy_dialog.dart';
import 'exclusive_mode/exclusive_delete_audio_dialog.dart';
import 'exclusive_mode/exclusive_select_audio_dialog.dart';
import 'exclusive_rename_audio_dialog.dart';

class AiWriteMusicController extends GetxController with StreamDataMixin {
  ///音乐生成需要消耗的权益
  RightsByType? aiMusicSongCreate;

  ///训练音色需要消耗的权益
  RightsByType? aiMusicTrain;

  ///控制右侧营销浮窗显示状态
  RxBool showMarketingView = true.obs;

  static List<AiMusicUiModel> aiMusicUiModelList = [
    const AiMusicUiModel(
      iconPath: Assets.aiMusicIcon,
      aiWriteMusicBg: Assets.aiWriteMusicBg1,
      type: 0,
      title: "灵感写歌",
      iconPath3: Assets.inspireBg1,
    ),
    const AiMusicUiModel(
        iconPath: Assets.aiMusicIcon2,
        aiWriteMusicBg: Assets.aiWriteMusicBg2,
        type: 1,
        title: "大师模式",
        iconPath2: Assets.vip1,
        iconPath3: Assets.aiIcon3),
    const AiMusicUiModel(
        iconPath: Assets.aiMusicIcon3,
        aiWriteMusicBg: Assets.aiWriteMusicBg3,
        type: 2,
        title: "专属模式",
        iconPath2: Assets.vip2,
        iconPath3: Assets.aiIcon2),
  ];

  AiMusicUiModel selectedAiMusicUiModel = aiMusicUiModelList.first;

  HotTopicMusicModel? hotTopicMusicModel;

  ///灵感写歌模式分享过来的数据
  MusicData? inspirationCreateSameMusicData;

  ///大师写歌模式分享过来的数据
  MusicData? masterCreateSameMusicData;

  ///专属写歌模式分享过来的数据
  MusicData? exclusiveCreateSameMusicData;

  List<MusicItem> hotMusicItem = [];
  List<MusicItem> hotMusicItem1 = [];
  List<MusicItem> hotMusicItem2 = [];
  List<MusicItem> hotMusicItem3 = [];

  ///AI 音乐提示词
  String aiMusicHintText = "";

  ///AI 音乐提示词 大师模式
  String aiMusicHintText2 = "";

  ///AI 音乐提示词 专属模式
  String aiMusicHintText3 = "";

  ///AI 音乐名字 大师模式
  String aiMusicMasterName = "";

  ///是否正在随机 灵感写歌
  bool isGetRandom = false;

  ///是否正在随机 大师模式
  bool masterRandom = false;

  ///是否正在随机 专属模式
  bool isGetRandom3 = false;

  ///启动的业务逻辑controller
  LaunchController launchController = Get.find<LaunchController>();

  ///是否打开纯音乐模式
  bool isPure = false;

  ///是否打开纯音乐模式 大师模式
  bool masterPure = false;

  ///灵感写歌模式的输入控制器
  TextEditingController hintTextEditingController = TextEditingController();

  ///大师模式的输入框控制器
  TextEditingController masterTextEditingController = TextEditingController();

  ///专属模式的输入框控制器
  TextEditingController hintTextEditingController3 = TextEditingController();

  ///大师模式的歌名输入框控制器
  TextEditingController masterMusicNameEditingController =
      TextEditingController();

  ///大师模式的不希望呈现出的内容输入框控制器
  TextEditingController masterNoValueTextEditingController =
      TextEditingController();

  ///大师模式的音乐
  MusicOptionsModel? musicOptionsModel;

  ///所有的配置项目
  List<Option> allOptionsList = [];

  ///专属模式配置项目
  // List<Option> instrumentalModeList = [];

  ///大师模式已选择的配置项目
  List<OptionModelEx> selectedMasterModeOptionsList = [];

  ///大师模式纯音乐-已选择的配置项目
  List<OptionModelEx> selectedPureMasterModeOptionsList = [];

  ///专属模式的不希望呈现出的内容输入框控制器
  TextEditingController hintTextEditingController6 = TextEditingController();

  ///专属模式的音乐
  MusicOptionsModel? musicOptionsModel2;

  ///专属模式所有的配置项目
  List<Option> allOptionsList2 = [];

  ///专属已选择的配置项目
  List<OptionModelEx> selectedExclusiveOptionsList = [];

  ///检查歌名
  late StreamSubscription<CheckMusicNameSuccess> musicNameCheckSuccess;
  late StreamSubscription<CheckMusicHintTextSuccess> musicHintTextSuccess;
  late StreamSubscription<CheckAppearMusicDataTextSuccess>
      checkAppearMusicDataTextSuccess;

  /// 大师模式的过长 1 高级设置 2词曲精调 3生成歌曲
  int masterModeStep = 1;

  ///大师模式的任务
  AiMusicTaskModel? aiMusicMasterTaskModel;

  ///专属模式的任务
  AiMusicTaskModel? aiMusicExclusiveTaskModel;

  /// 定时器实例
  Timer? _timer;

  /// 专属模式定时器实例
  Timer? _timer2;

  /// 大师模式标记是否正在执行查询
  bool _isMasterQuerying = false;

  /// 专属模式标记是否正在执行查询
  bool _isExclusiveQuerying = false;

  ///大师模式生成的歌曲model
  MasterMusicAnalysisResponse? masterMusicAnalysisResponse;

  ///大师模式下的时长
  int audioDuration = 180;

  ///专属模式生成的歌曲model
  MasterMusicAnalysisResponse? masterMusicAnalysisResponse2;

  ///专属模式下的时长
  int audioDuration2 = 180;

  ///专属模式 是否同意录制音频
  bool agreeRecordAudio = false;

  ///声音生成服务条款url
  String recordAudioUrl = "";

  /// 专属模式的过长 1
  /// 2开始训练音频
  /// 3选择自己的音频
  /// 4高级设置
  /// 5词曲精调
  /// 6生产歌曲
  /// 7歌曲生产完成 （0-输入特殊步骤 在已有数据的情况下 选择训练新的历史音频）
  /// 8歌曲生成失败
  int exclusiveModeStep = 1;

  ///音乐配置数据
  AIMusicConfigListModel? aiMusicConfigListModel;

  ///当前选中的音乐配置数据
  AiMusicConfigListItem? selectedAiMusicConfigListItem;

  ///是否正在录音中
  bool isRecordVoice = false;

  ///录音完成
  bool isCompleteRecord = false;

  ///音频地址 本地
  String audioFilePath = "";

  ///提交给服务器的音频地址
  String postAudioUrlToServer = "";

  ///从服务器获取的音频任务信息
  AiMusicTaskModel? aiMusicUrlTaskModel;

  ///专属模式定时器实例
  Timer? _exclusiveQueryRecordTimer;

  ///专属模式是否正在查询训练音频任务中
  bool isExclusiveQueryRecord = false;

  Timer? _queryRecordTimer2;

  ///是否正在查询训练音频任务中
  bool isQueryRecord2 = false;

  AudioSeparationResult? _audioSeparationResult;

  AudioSeparationResult? _audioSeparationResult2;

  ///是否有历史训练音频数据
  List<VoiceTimbreItem> voiceTimbreList = [];

  ///是否去选择历史音频
  bool goHistoryMusicPage = false;

  ///专属模式选择的历史音频
  VoiceTimbreItem? selectedVoiceTimbreItem;

  ///大师模式
  List<MusicSection> masterNewMusicSection = [];

  ///专属模式
  List<MusicSection> exclusiveNewMusicSection = [];

  ///专属模式的任务数据
  AiExclusiveModeTaskModel? aiExclusiveModeTaskModel;

  ///历史音频地址
  String historyAudioUrl = "";

  ///专属模式正在提交音频中
  bool isPostAudioToServer = false;

  ///是否有历史训练音频任务 布尔值
  bool isHistoryAudioPractice = false;

  ///监听登录成功.
  late StreamSubscription<LoginEvent> loginSubscription;

  ///当前的初始化页面
  int initialPage = 0;

  ///监听刷新用户数据事件
  late StreamSubscription<RefreshMusicNoteEvent> refreshMusicNoteSubscription;

  ///是否第一次进入
  bool isFirstJoin = false;

  MusicPromptData? musicPromptData;

  ///灵感模式提交按钮状态
  bool isInspirationCreateAiMusic = false;

  ///是否登录
  bool isLogin = false;

  ///是否vip
  bool isVip = false;

  ///当前用户
  UserInfoBean? userInfo;


  @override
  void onInit() {
    initData();

    loginSubscription = eventBus.on<LoginEvent>().listen((e) {
      if (e.type == 1) {
        initData();
      }
    });

    refreshMusicNoteSubscription =
        eventBus.on<RefreshMusicNoteEvent>().listen((e) {
      loadAiMusicSongRights();
    });

    super.onInit();
  }

  updateSelectedAiMusicConfigListItem({
    required AiMusicConfigListItem item,
  }) {
    selectedAiMusicConfigListItem = item;
    update();
  }

  initData() async {
    getHotTopic();
    getAiMusicConfig();
    getMusicStrategyGuideList();
    loadAiMusicSongRights();
    isFirstJoin = ConstKeys.isFirst;
    isLogin = Get.find<LaunchController>().isLogin;
    isVip = Get.find<LaunchController>().isVip;
    userInfo = Get.find<LaunchController>().user.value;
    Get.log("===isFirstJoin===$isFirstJoin  ===isLogin===$isLogin  ===isVip===$isVip  ===userInfo===${userInfo?.toJson()}");
    await checkAudioPracticeState();
    await getTrainTimbreList();
    agreeRecordAudio = SpUtil.getBool(ConstKeys.audioAgree) ?? false;
    musicNameCheckSuccess =
        eventBus.on<CheckMusicNameSuccess>().listen((e) async {
      Get.log("===大师模式歌名检查通过===");
      await checkAiMusicHintText2();
    });
    musicHintTextSuccess =
        eventBus.on<CheckMusicHintTextSuccess>().listen((e) async {
      if (e.type == 1) {
        Get.log("===大师模式提示词检查通过===");
        await checkAiMusicHintText3();
      } else {
        Get.log("===专属模式提示词检查通过===");
        checkAiMusicHintText5();
      }
    });

    checkAppearMusicDataTextSuccess =
        eventBus.on<CheckAppearMusicDataTextSuccess>().listen((e) async {
      if (e.type == 1) {
        await createMasterModeLyric();
        Get.log("===大师模式不希望出现的内容检查通过===");
      } else {
        await createExclusiveLyric();
        Get.log("===专属模式不希望出现的内容检查通过===");
      }
    });

    HttpUtils.get(
      APIs.getPresetMusic,
      {},
      success: (data) {
        List<MusicPromptData>? dataList;
        MusicPromptResponse? musicPromptResponse =
            MusicPromptResponse.fromJson(data);
        if (musicPromptResponse != null) {
          dataList = musicPromptResponse!.data;
          if (dataList != null) {
            if (dataList.isNotEmpty) {
              int length = dataList.length;
              int random = Random().nextInt(length - 1);
              musicPromptData = dataList[random];
            }
          }
        }
        Get.log("获取的配置的数据===> ${musicPromptResponse?.toJson()}");
      },
      fail: (code, msg) {},
    );

    update();
  }

  updateHintTextEditingController() {
    if (isFirstJoin) {
      if (musicPromptData != null) {
        hintTextEditingController.text = musicPromptData!.prompt ?? "";
        update();
      }
    }
  }

  updateIsFirst() {
    isFirstJoin = false;
    update();
  }

  ///获取热门话题
  getHotTopic() {
    HttpUtils.get(
      APIs.hotTopic,
      {},
      success: (data) {
        hotTopicMusicModel = HotTopicMusicModel.fromJson(data);
        Get.log("===获取热门主题数据===$data");
        if (hotTopicMusicModel != null) {
          hotMusicItem = hotTopicMusicModel!.data;
          if (hotMusicItem.length > 3) {
            for (int i = 0; i < hotMusicItem.length; i++) {
              final mod = i % 3;
              if (mod == 0) {
                hotMusicItem1.add(hotMusicItem[i]);
              } else if (mod == 1) {
                hotMusicItem2.add(hotMusicItem[i]);
              } else {
                hotMusicItem3.add(hotMusicItem[i]);
              }
            }
          } else {
            hotMusicItem1 = hotMusicItem;
          }
        }
        eventBus.fire(const RefreshMarqueeEvent());
        update();
      },
      fail: (code, msg) {},
    );
  }

  ///更新灵感模式提示词
  updateInspirationAiMusicHintText({
    required String data,
  }) {
    String data1 = data.replaceAll(' ', "");
    aiMusicHintText = data1;
    Get.log("===灵感模式更新Ai文本=== $data");
    update();
  }

  ///更新大师模式提示词
  updateMasterAiMusicHintText({
    required String data,
  }) {
    String data1 = data.replaceAll(' ', "");
    aiMusicHintText2 = data1;
    Get.log("===大师模式更新Ai文本=== $data");
    update();
  }

  ///更新专属模式提示词
  updateExclusiveAiMusicHintText({
    required String data,
  }) {
    String data1 = data.replaceAll(' ', "");
    aiMusicHintText3 = data1;
    Get.log("===专属模式更新Ai文本=== $data");
    update();
  }

  ///灵感模式更新是否正在随机
  updateInspirationRandom({
    required bool random,
  }) {
    isGetRandom = random;
    Get.log("灵感模式是否正在随机==> $isGetRandom ");
    update();
  }

  ///大师模式更新是否正在随机
  updateMasterRandom({
    required bool random,
  }) {
    masterRandom = random;
    Get.log("大师模式是否正在随机==> $masterRandom ");
    update();
  }

  ///专属模式更新是否正在随机
  updateExclusiveRandom({
    required bool random,
  }) {
    isGetRandom3 = random;
    Get.log("专属模式是否正在随机==> $isGetRandom3 ");
    update();
  }

  ///灵感模式更新
  updateIsPure({required bool data}) {
    if (selectedAiMusicUiModel.type == 0) {
      isPure = data;
    }
    Get.log("${selectedAiMusicUiModel.title}==>  开启纯音乐模式 $data ");
  }

  ///大师模式纯音乐模式选择
  updateMasterIsPure({required bool data}) {
    masterPure = data;
    if (masterPure) {
      selectedPureMasterModeOptionsList = [];
      for (var e in selectedMasterModeOptionsList) {
        Get.log("===e====> ${e.option!.instrumentalMode} ");
        Option? optionModelEx = e.option;
        if (optionModelEx != null) {
          if (optionModelEx.instrumentalMode == true) {
            selectedPureMasterModeOptionsList.add(e);
          }
        }
      }
    }
    update();
  }

  ///灵感写歌一键生成音乐
  createInspirationAiMusic() {
    if (isInspirationCreateAiMusic) {
      return;
    }
    isInspirationCreateAiMusic = true;
    if (launchController.isLogin) {
      if (aiMusicHintText.isEmpty) {
        isInspirationCreateAiMusic = false;
        EasyLoading.showToast(
          "请描述你的歌曲灵感~",
          maskType: EasyLoadingMaskType.none,
        );
        return;
      } else {
        Get.log("一键Ai写歌=== $isGetRandom");
        if (isGetRandom) {
          isInspirationCreateAiMusic = false;
          EasyLoading.showToast(
            "正在生成灵感，请稍等~",
            maskType: EasyLoadingMaskType.none,
          );
          return;
        } else {
          ///违禁词坚持
          IllegalWordsController illegalWordsController =
              Get.put<IllegalWordsController>(IllegalWordsController());
          illegalWordsController.detectIllegalWords(aiMusicHintText,
              onFail: () {
            isInspirationCreateAiMusic = false;
          }, onSuccess: () {
            postAiHintTextToServer();
          }, onSuccessValue: (value) {
            Get.log("value===>$value");
            // isInspirationCreateAiMusic = false;
            hintTextEditingController.text = value;
            update();
          });
        }
      }
      Get.log("===isVip===");
    } else {
      isInspirationCreateAiMusic = false;
      launchController.login(source: "ai_write_music");
    }
  }

  Future clickNextMasterStep() async {
    if (launchController.isLogin) {
      nextMasterStep();
    } else {
      launchController.login(
          source: "ai_write_music",
          loginSuccess: () {
            nextMasterStep();
          });
    }
  }

  ///大师模式的下一步
  Future nextMasterStep() async {
    Get.log("==大师模式的下一步== $masterModeStep");
    aiMusicHintText2 = masterTextEditingController.text;
    if (aiMusicHintText2.isEmpty) {
      EasyLoading.showToast(
        "请描述你的歌曲灵感~",
        maskType: EasyLoadingMaskType.none,
      );
      return;
    }

    if (launchController.is90Vip || launchController.is365Vip) {
      if (masterModeStep == 2) {
        EasyLoading.showToast(
          "正在生成歌曲中~",
          maskType: EasyLoadingMaskType.none,
        );
        return;
      } else if (masterModeStep == 3) {
        createMasterMusic();
        Get.log("===立即生成歌曲1111===");
      } else {
        if (_isMasterQuerying) {
          EasyLoading.showToast(
            "正在生成歌曲中~",
            maskType: EasyLoadingMaskType.none,
          );
          return;
        }
        await checkMasterMusicName();
      }
    } else {
      if (launchController.is30Vip) {
        launchController.showVipUpgradeDialog();
      } else {
        // Get.put(VipPurchaseController());
        // Get.find<VipPurchaseController>().loadData();
        // Get.toNamed(Routes.vipPurchasePage);
        Get.find<LaunchController>().openNoFreeTimeBg();

      }
    }
  }

  Future nextStep2() async {
    Get.log("===下一步===  $exclusiveModeStep  ");

    if (exclusiveModeStep == 6) {
      createExclusiveMusic();
      Get.log("===立即生成歌曲===");
    } else {
      if (_isExclusiveQuerying) {
        EasyLoading.showToast(
          "正在生成歌曲中~",
          maskType: EasyLoadingMaskType.none,
        );
        return;
      }

      await checkMusicName2();
    }
  }

  Future checkAiMusicHintText2() async {
    IllegalWordsController illegalWordsController =
        Get.put<IllegalWordsController>(IllegalWordsController());
    if (aiMusicHintText2.isNotEmpty) {
      await illegalWordsController.detectIllegalWords(aiMusicHintText2,
          onFail: () {}, onSuccess: () {}, onSuccessValue: (value) {
        Get.log("歌曲灵感违禁词检测===>$value");
        masterTextEditingController.text = value;
        eventBus.fire(
          CheckMusicHintTextSuccess(
            type: selectedAiMusicUiModel.type,
          ),
        );
      });
    } else {
      EasyLoading.showToast(
        "请描述你的歌曲灵感~",
        maskType: EasyLoadingMaskType.none,
      );
    }
  }

  ///大师模式  检查音乐名称
  Future checkMasterMusicName() async {
    Get.log("===检查音乐名称===${aiMusicHintText2}");

    if (launchController.isLogin) {
      if (launchController.user.value?.isVip == 1) {
        if (aiMusicHintText2.isEmpty) {
          EasyLoading.showToast(
            "请描述你的歌曲灵感~",
            maskType: EasyLoadingMaskType.none,
          );
          return;
        } else {
          if (masterRandom) {
            EasyLoading.showToast(
              "正在生成灵感，请稍等~",
              maskType: EasyLoadingMaskType.none,
            );
            return;
          } else {
            ///违禁词坚持
            ///首先检查歌名
            IllegalWordsController illegalWordsController =
                Get.put<IllegalWordsController>(IllegalWordsController());
            if (aiMusicMasterName.isNotEmpty) {
              await illegalWordsController.detectIllegalWords(aiMusicMasterName,
                  onFail: () {}, onSuccess: () {}, onSuccessValue: (value) {
                Get.log("歌名违禁词检测成功===>$value");
                masterMusicNameEditingController.text = value;
                eventBus.fire(
                    CheckMusicNameSuccess(type: selectedAiMusicUiModel.type));
              });
            } else {
              eventBus.fire(
                  CheckMusicNameSuccess(type: selectedAiMusicUiModel.type));
            }
          }
        }
        Get.log("===isVip===");
      } else {
        Get.toNamed(Routes.vipPurchasePage);
      }
    } else {
      launchController.login(source: "ai_write_music");
    }
  }

  ///专属模式  检查音乐名称
  Future checkMusicName2() async {
    if (launchController.isLogin) {
      if (launchController.user.value?.isVip == 1) {
        if (aiMusicHintText3.isEmpty) {
          EasyLoading.showToast(
            "请描述你的歌曲灵感~",
            maskType: EasyLoadingMaskType.none,
          );
        } else {
          if (isGetRandom) {
            EasyLoading.showToast(
              "正在生成灵感，请稍等~",
              maskType: EasyLoadingMaskType.none,
            );
          } else {
            ///违禁词坚持
            ///首先检查歌名
            IllegalWordsController illegalWordsController =
                Get.put<IllegalWordsController>(IllegalWordsController());
            if (aiMusicHintText3.isNotEmpty) {
              await illegalWordsController.detectIllegalWords(aiMusicHintText3,
                  onFail: () {}, onSuccess: () {}, onSuccessValue: (value) {
                Get.log("专属模式提示词检测成功===>$value");
                hintTextEditingController3.text = value;
                eventBus.fire(CheckMusicHintTextSuccess(
                    type: selectedAiMusicUiModel.type));
              });
            } else {
              eventBus.fire(
                  CheckMusicHintTextSuccess(type: selectedAiMusicUiModel.type));
            }
          }
        }
        Get.log("===isVip===");
      } else {
        Get.toNamed(Routes.vipPurchasePage);
      }
    } else {
      launchController.login(source: "ai_write_music");
    }
  }

  ///提交
  postAiHintTextToServer() {
    Get.log("智能模式==>$isPure 提示词==>$aiMusicHintText ");
    HttpUtils.post(
      APIs.aiCreateMusic,
      {
        "isPure": isPure,
        "prompt": aiMusicHintText,
      },
      showMsgWhenFailed: false,
      success: (data) {
        isInspirationCreateAiMusic = false;
        AiMusicResponseModel aiMusicResponseModel =
            AiMusicResponseModel.fromJson(data);
        if (aiMusicResponseModel.status == 200) {
          hintTextEditingController.text = "";
          Get.toNamed(Routes.myWorkPage);
        } else {
          if (aiMusicResponseModel.status == 1000001) {
            Get.toNamed(Routes.meMusicNoteValuePage);
            return;
          }

          if (aiMusicResponseModel.status == 1000002) {
            // Get.toNamed(Routes.vipPurchasePage);
            Get.find<LaunchController>().openNoFreeTimeBg();
            return;
          }
        }
        EasyLoading.showToast(aiMusicResponseModel.message,
            maskType: EasyLoadingMaskType.none);
        Get.log("data===>$data");
        update();
      },
      fail: (code, msg) {
        isInspirationCreateAiMusic = false;
        Get.log("请求失败===>$code");
        // EasyLoading.showToast(msg, maskType: EasyLoadingMaskType.none);
        if (code == 1000001) {
          Get.toNamed(Routes.meMusicNoteValuePage);
          return;
        }

        if (code == 1000002) {
          // Get.toNamed(Routes.vipPurchasePage);
          Get.find<LaunchController>().openNoFreeTimeBg();

          return;
        }
      },
    );
  }

  ///更新选中的音乐model
  updateSelectedAiMusicUiModel({
    required AiMusicUiModel model,
  }) {
    if (model.type == 0 || model.type == 1) {
      eventBus.fire(const StopMusicButtonEvent());
    }

    selectedAiMusicUiModel = model;
    bool isAiWriteMusicController = Get.isRegistered<AiWriteMusicController>();
    if (!isAiWriteMusicController) {
      Get.lazyPut<AiWriteMusicController>(() => AiWriteMusicController());
    }
    update();
  }

  ///更新歌名
  updateAiMusicName({
    required String text,
  }) {
    String text1 = text.replaceAll(' ', "");
    Get.log("===更新的歌名$text===");
    aiMusicMasterName = text1;
  }

  ///获取高级设置
  getAiMusicConfig() {
    HttpUtils.get(
      APIs.getAiMusicConfig,
      {},
      success: (data) {
        musicOptionsModel = MusicOptionsModel.fromJson(data);
        if (musicOptionsModel != null) {
          if (musicOptionsModel!.data != null) {
            List<Option>? optionsList = musicOptionsModel!.data!.options;
            if (optionsList != null) {
              allOptionsList = [];
              selectedMasterModeOptionsList = [];
              selectedExclusiveOptionsList = [];
              allOptionsList.addAll(optionsList);

              ///这里去默认给用户配置一个选项
              for (var e in allOptionsList) {
                List<Item>? items = e.items;
                String? selectedContent;
                String? selectedContent2;
                if (items != null) {
                  if (items.isNotEmpty) {
                    selectedContent = items.first.zh;
                    selectedContent2 = items.first.en;
                  }
                }
                if (e.en == "audio_duration") {
                  selectedContent = e.defaultVal.toString();
                  selectedContent2 = e.max.toString();
                }

                OptionModelEx optionModelEx = OptionModelEx(
                  option: e,
                  selectContent: selectedContent ?? "",
                  selectContent2: selectedContent2 ?? '',
                );
                Get.log(
                    "===selectedContent=== $selectedContent  ===selectedContent2=== $selectedContent2  ");
                selectedMasterModeOptionsList.add(optionModelEx);
                selectedExclusiveOptionsList.add(optionModelEx);
              }
            }
          }
        }
        Get.log("===获取高级设置=== $data");
        update();
      },
      fail: (code, msg) {},
    );

    AppConfig? appConfig = launchController.appConfig;
    if (appConfig != null) {
      recordAudioUrl = appConfig.data!.agreement!.soundProtocol ?? "";
    }
  }

  ///大师模式打开配置选项弹窗
  Future openAiMusicItemDialog({required OptionModelEx option}) async {
    await showModalBottomSheet(
        isScrollControlled: true,
        context: Get.context!,
        builder: (context) {
          return AiMusicConfigDialog(
            option: option,
            borderColor: ByColorUtil.colorC98465.withOpacity(0.6),
            backgroundColor: ByColorUtil.colorC98465.withOpacity(0.1),
            selectedContent: option.selectContent,
            selectedContent2: option.selectContent2,
          );
        },
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        )).then((value) {
      if (value != null) {
        OptionModelEx? optionModelEx;
        if (value["option"] != null) {
          optionModelEx = value["option"];
        }

        if (optionModelEx != null && selectedMasterModeOptionsList.isNotEmpty) {
          int index = selectedMasterModeOptionsList.indexOf(optionModelEx);
          if (index != -1) {
            selectedMasterModeOptionsList[index] = OptionModelEx(
              option: optionModelEx.option,
              selectContent2: value["selectContent2"],
              selectContent: value["selectContent"],
            );
            Get.log(
                "选中的内容==>${value["selectContent"]}  ${optionModelEx.option?.toJson()}");
          }

          ///如果开了纯音乐模式
          if (masterPure) {
            int index =
                selectedPureMasterModeOptionsList.indexOf(optionModelEx);
            if (index != -1) {
              selectedPureMasterModeOptionsList[index] = OptionModelEx(
                option: optionModelEx.option,
                selectContent2: value["selectContent2"],
                selectContent: value["selectContent"],
              );
              Get.log(
                  "纯音乐模式选中的内容==>${value["selectContent"]}  ${optionModelEx.option?.toJson()}");
            }
          }
        }
      }
    });
  }

  ///检查不希望出现的内容
  Future checkAiMusicHintText3() async {
    String textData = masterNoValueTextEditingController.text;
    IllegalWordsController illegalWordsController =
        Get.put<IllegalWordsController>(IllegalWordsController());
    if (textData.isNotEmpty) {
      await illegalWordsController.detectIllegalWords(textData,
          onFail: () {}, onSuccess: () {}, onSuccessValue: (value) {
        Get.log("不希望呈现的内容===>$value");
        masterNoValueTextEditingController.text = value;
        eventBus.fire(
          CheckAppearMusicDataTextSuccess(
            type: selectedAiMusicUiModel.type,
          ),
        );
      });
    } else {
      createMasterModeLyric();
    }
  }

  ///检查不希望出现的内容
  Future checkAiMusicHintText4() async {
    String textData = hintTextEditingController6.text;
    IllegalWordsController illegalWordsController =
        Get.put<IllegalWordsController>(IllegalWordsController());
    if (textData.isNotEmpty) {
      await illegalWordsController.detectIllegalWords(textData,
          onFail: () {}, onSuccess: () {}, onSuccessValue: (value) {
        Get.log("不希望呈现的内容===>$value");
        hintTextEditingController6.text = value;
        eventBus.fire(
          CheckAppearMusicDataTextSuccess(
            type: selectedAiMusicUiModel.type,
          ),
        );
      });
    } else {
      ///todo 准备提交数据
      createExclusiveLyric();
    }
  }

  /// 大师模式-生成歌词
  Future createMasterModeLyric() async {
    String musicGenres = "";
    String instruments = "";
    String tempoBPM = "";
    String moodAtmosphere = "";
    String musicalTexture = "";
    String vocalCharacteristics = "";
    String vocalTimbre = "";
    String languages = "";
    audioDuration = 180;
    if (selectedMasterModeOptionsList.isNotEmpty) {
      for (var e in selectedMasterModeOptionsList) {
        final Option? option = e.option;
        final String selectContent2 = e.selectContent2;
        final String selectContent = e.selectContent;
        if (option != null) {
          if (option.en == "Music Genres") {
            musicGenres = selectContent2;
          }
          if (option.en == "Instruments") {
            instruments = selectContent2;
          }
          if (option.en == "Tempo/BPM") {
            tempoBPM = selectContent2;
          }
          if (option.en == "Mood/Atmosphere") {
            moodAtmosphere = selectContent2;
          }
          if (option.en == "Musical Texture") {
            musicalTexture = selectContent2;
          }
          if (option.en == "Vocal Characteristics") {
            vocalCharacteristics = selectContent2;
          }
          if (option.en == "Vocal Timbre") {
            vocalTimbre = selectContent2;
          }
          if (option.en == "Languages") {
            languages = selectContent2;
          }
          if (option.en == "audio_duration") {
            audioDuration = int.parse(selectContent);
          }
        }

        Get.log(
            "selectContent===${selectContent} selectedContent2===${selectContent2}      ===option===  ${option?.toJson()}");
      }
    }
    Map<String, dynamic> options = {
      "Music Genres": musicGenres,
      "Instruments": instruments,
      "Tempo/BPM": tempoBPM,
      "Mood/Atmosphere": moodAtmosphere,
      "Musical Texture": musicalTexture,
      "Vocal Characteristics": vocalCharacteristics,
      "Vocal Timbre": vocalTimbre,
      "Languages": languages,
      "audio_duration": audioDuration.toString(),
    };

    Get.log(
        "=isPure=$masterPure  =prompt= $aiMusicHintText2 =exclude_prompt=${masterNoValueTextEditingController.text} options==$options  ");
    HttpUtils.post(
      APIs.createLyric,
      {
        "isPure": masterPure,
        "prompt": aiMusicHintText2,
        "exclude_prompt": masterNoValueTextEditingController.text,
        "options": options,
        "mode": 2,
      },
      success: (data) {
        aiMusicMasterTaskModel = AiMusicTaskModel.fromJson(data);
        if (aiMusicMasterTaskModel != null) {
          if (aiMusicMasterTaskModel!.status == 200) {
            if (aiMusicMasterTaskModel!.data.taskId.isNotEmpty) {
              masterModeStep = 2;

              ///开始定时查询任务
              startQuerying();
            }
          }
          Get.log("大师模式生成歌词请求下来的数据===> ${aiMusicMasterTaskModel!.toJson()}");
        }
        update();
      },
      fail: (code, msg) {
        Get.log("大师模式生成歌词失败请求下来的数据===> $msg $code");
      },
    );
  }

  /// 开始定时查询 (5秒间隔)
  void startQuerying() {
    /// 先取消已有的定时器，避免重复
    stopQuerying();

    /// 立即执行一次查询，再开始定时
    _performQuery();

    // 启动周期性定时器
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _performQuery();
    });
  }

  /// 停止定时查询
  void stopQuerying() {
    if (_timer != null) {
      _timer?.cancel();
      _timer = null;
    }
  }

  /// 执行实际的查询任务
  Future<void> _performQuery() async {
    // 防止并发请求
    if (_isMasterQuerying) return;

    _isMasterQuerying = true;
    try {
      HttpUtils.get(
        APIs.taskQuery,
        {
          "taskType": aiMusicMasterTaskModel!.data.taskType,
          "taskId": aiMusicMasterTaskModel!.data.taskId,
        },
        success: (data) {
          final MusicAnalysisData? musicAnalysisData;
          final MusicContentData? musicContentData;
          Get.log("大师模式查询任务成功请求下来的数据===> $data");
          masterMusicAnalysisResponse =
              MasterMusicAnalysisResponse.fromJson(data);
          if (masterMusicAnalysisResponse != null) {
            musicAnalysisData = masterMusicAnalysisResponse!.data;
            if (musicAnalysisData != null) {
              musicContentData = musicAnalysisData.data;
              if (musicContentData != null) {
                ///todo 立即生成歌曲
                if (masterPure) {
                  createMasterMusic();
                } else {
                  masterModeStep = 3;
                }

                stopQuerying();
              }
            }
          }

          update();
        },
        fail: (code, msg) {
          stopQuerying();
          Get.log("大师模式查询任务失败请求下来的数据===> $msg $code");
        },
      );
    } catch (e) {
      // 捕获所有可能的错误 (网络错误、解析错误等)
    } finally {
      _isMasterQuerying = false;
    }
  }

  /// 释放资源
  void disposeTimer() {
    stopQuerying();
  }

  ///专属模式 开始定时查询 (5秒间隔)
  void exclusiveStartQueryRecordTimer({
    bool reload = false,
    String taskId = "",
  }) {
    /// 先取消已有的定时器，避免重复
    stopExclusiveModeQueryingRecord();

    /// 立即执行一次查询，再开始定时
    _performExclusiveQueryRecord(
      reload: reload,
      taskId: taskId,
    );

    /// 启动周期性定时器
    _exclusiveQueryRecordTimer =
        Timer.periodic(const Duration(seconds: 5), (timer) {
      _performExclusiveQueryRecord(
        reload: reload,
        taskId: taskId,
      );
    });
  }

  ///专属模式定时器查询
  Future<void> _performExclusiveQueryRecord({
    bool reload = false,
    String taskId = "",
  }) async {
    // 防止并发请求
    if (isExclusiveQueryRecord) return;

    isExclusiveQueryRecord = true;
    try {
      HttpUtils.get(
        APIs.taskQuery,
        {
          "taskType": 2,
          "taskId": reload ? taskId : aiMusicUrlTaskModel!.data.taskId,
        },
        success: (data) {
          _audioSeparationResult = AudioSeparationResult.fromJson(data);
          if (_audioSeparationResult != null) {
            if (exclusiveModeStep <= 2) {
              exclusiveModeStep = 2;
            }

            AudioSeparationResultData? data = _audioSeparationResult!.data;
            if (data != null) {
              ///状态为1 成功进入第二次查询
              if (data.status == 1) {
                isHistoryAudioPractice = true;
                stopExclusiveModeQueryingRecord();
                startExclusiveQueryRecordTimer2(
                  taskId: taskId,
                  reload: reload,
                );
              }

              ///失败结束任务
              if (data.status == 2) {
                exclusiveModeStep = 8;
                isHistoryAudioPractice = false;
                stopExclusiveModeQueryingRecord();
              }

              ///todo 超过最大期限结束任务
            }
          }

          Get.log("专属模式查询音乐训练任务成功请求下来的数据===> $data");
        },
        fail: (code, msg) {
          stopExclusiveModeQueryingRecord();
          exclusiveModeStep = 8;
          Get.log("专属模式查询音乐训练任务失败请求下来的数据===> $msg $code");
        },
      );
    } catch (e) {
      /// 捕获所有可能的错误 (网络错误、解析错误等)
    } finally {
      isExclusiveQueryRecord = false;
    }
  }

  /// 停止专属模式定时查询
  void stopExclusiveModeQueryingRecord() {
    if (_exclusiveQueryRecordTimer != null) {
      isExclusiveQueryRecord = false;
      _exclusiveQueryRecordTimer?.cancel();
      _exclusiveQueryRecordTimer = null;
    }
    update();
  }

  /// 释放资源
  void disposeQueryTimer() {
    stopExclusiveModeQueryingRecord();
  }

  /// 开始专属模式第二轮定时查询 (5秒间隔)
  void startExclusiveQueryRecordTimer2({
    bool reload = false,
    String taskId = "",
  }) {
    /// 先取消已有的定时器，避免重复
    stopExclusiveQueryingRecord();

    /// 立即执行一次查询，再开始定时
    _performExclusiveQueryRecord2(reload: reload, taskId: taskId);

    /// 启动周期性定时器
    _queryRecordTimer2 = Timer.periodic(const Duration(seconds: 5), (timer) {
      _performExclusiveQueryRecord2(reload: reload, taskId: taskId);
    });
  }

  ///专属模式第二次查询
  Future<void> _performExclusiveQueryRecord2({
    bool reload = false,
    String taskId = "",
  }) async {
    // 防止并发请求
    if (isQueryRecord2) return;

    isQueryRecord2 = true;
    try {
      HttpUtils.get(
        APIs.taskQuery,
        {
          // "taskType": aiMusicUrlTaskModel!.data.taskType,
          "taskType": 6,
          "taskId": reload ? taskId : aiMusicUrlTaskModel!.data.taskId,
        },
        success: (data) async {
          _audioSeparationResult2 = AudioSeparationResult.fromJson(data);
          if (_audioSeparationResult2 != null) {
            AudioSeparationResultData? data = _audioSeparationResult2!.data;
            if (data != null) {
              ///状态为1 音色生成成功
              if (data.status == 1) {
                exclusiveModeStep = 3;
                Get.log("查询发起==> ${DateTime.now()}");
                await Future.delayed(const Duration(seconds: 15), () async {
                  Get.log("查询服务发起==> ${DateTime.now()}");
                  await getTrainTimbreList();
                  isHistoryAudioPractice = false;
                  stopExclusiveQueryingRecord();
                });
              }

              ///todo 失败结束任务
              if (data.status == 2) {
                isHistoryAudioPractice = false;
                exclusiveModeStep = 8;
                stopExclusiveQueryingRecord();
              }

              ///todo 超过最大期限结束任务
              if (!goHistoryMusicPage) {
                Get.log("执行刷新操作===> $data");
                update();
              }
            }
          }
          // Get.log("专属模式查询音乐训练任务成功请求下来的数据2===> $data");
          // update();
        },
        fail: (code, msg) {
          exclusiveModeStep = 8;
          stopExclusiveQueryingRecord();
          Get.log("专属模式查询音乐训练任务成功请求下来的数据2===> $msg $code");
        },
      );
    } catch (e) {
      /// 捕获所有可能的错误 (网络错误、解析错误等)
    } finally {
      isQueryRecord2 = false;
    }
  }

  /// 停止专属模式定时查询
  void stopExclusiveQueryingRecord() {
    if (_queryRecordTimer2 != null) {
      isQueryRecord2 = false;
      _queryRecordTimer2?.cancel();
      _queryRecordTimer2 = null;
    }
  }

  /// 释放资源
  void disposeQueryTimer2() {
    stopExclusiveQueryingRecord();
  }

  ///大师模式生成歌曲
  void createMasterMusic() async {
    // Get.log(
    //     "duration===>$audioDuration prompt==${masterMusicAnalysisResponse!.data!.data!.prompt}  lyrics==${{
    //   masterMusicAnalysisResponse!.data!.data!.lyrics
    // }}  ");
    String title = masterMusicNameEditingController.text.replaceAll(' ', "");
    Map<String, dynamic> dataJson = {};

    dataJson = {
      "mode": 2,
      "isPure": masterPure,
      "timbreId": 0,
      "duration": audioDuration,
      "title": title.isEmpty
          ? "${masterMusicAnalysisResponse!.data!.data!.title}"
          : title,
      "prompt": "${masterMusicAnalysisResponse!.data!.data!.prompt}",
      "lyrics": "${masterMusicAnalysisResponse!.data!.data!.lyrics}",
      "taskId": "${masterMusicAnalysisResponse!.data!.taskId}",
    };

    if (masterMusicAnalysisResponse!.data!.data!.lyrics != null) {
      ///这里对歌词进行鉴黄
      String textData = masterMusicAnalysisResponse!.data!.data!.lyrics ?? "";
      IllegalWordsController illegalWordsController =
          Get.put<IllegalWordsController>(IllegalWordsController());
      if (textData.isNotEmpty) {
        await illegalWordsController.detectIllegalWords(textData, onFail: () {},
            onSuccess: () {
          Get.log("大师模式希望呈现的内容===>");
          HttpUtils.post(
            APIs.createMusic,
            dataJson,
            success: (data) {
              AiMusicTaskModel aiMusicTaskModel =
                  AiMusicTaskModel.fromJson(data);
              if (aiMusicTaskModel.status == 200) {
                /// 清除大师模式数据
                masterRandom = false;
                masterPure = false;
                masterNewMusicSection = [];
                masterTextEditingController.text = "";
                masterMusicNameEditingController.text = "";
                masterNoValueTextEditingController.text = "";
                masterModeStep = 1;
                _timer = null;
                _isMasterQuerying = false;
                masterMusicAnalysisResponse = null;
                eventBus.fire(const ClearPureEvent());
                update();
                EasyLoading.showToast("生成歌曲成功",
                    maskType: EasyLoadingMaskType.none);
                Get.toNamed(Routes.myWorkPage);
              }
              Get.log("生成的数据===> $data");
              update();
            },
            fail: (code, msg) {
              EasyLoading.showToast(msg);
              if (code == 1000001) {
                masterModeStep = 1;
                _timer = null;
                _isMasterQuerying = false;
                masterMusicAnalysisResponse = null;
                update();
                Get.toNamed(Routes.meMusicNoteValuePage);
              }
            },
          );
        }, onSuccessValue: (value) {
          masterNewMusicSection = LyricsParser.parse(value);
          masterMusicAnalysisResponse!.data!.data!.lyrics = value;
          Get.log("大师模式希望呈现的内容===>${masterNewMusicSection.first.title}");
          update();
        }, type: 0);
      } else {}
    }
  }

  ///专属模式生成歌曲
  void createExclusiveMusic() async {
    Get.log(
        "duration===>$audioDuration prompt==${masterMusicAnalysisResponse2!.data!.data!.prompt}  lyrics==${{
      masterMusicAnalysisResponse2!.data!.data!.lyrics
    }}  ");

    if (masterMusicAnalysisResponse2!.data!.data!.lyrics != null) {
      ///这里对歌词进行鉴黄
      String textData = masterMusicAnalysisResponse2!.data!.data!.lyrics ?? "";
      IllegalWordsController illegalWordsController =
          Get.put<IllegalWordsController>(IllegalWordsController());

      if (textData.isNotEmpty) {
        await illegalWordsController.detectIllegalWords(textData,
            onSuccess: () {
          HttpUtils.post(
            APIs.createMusic,
            {
              "mode": 3,
              "isPure": false,
              "timbreId": selectedVoiceTimbreItem!.id,
              "duration": audioDuration,
              "title": "${masterMusicAnalysisResponse2!.data!.data!.title}",
              "prompt": "${masterMusicAnalysisResponse2!.data!.data!.prompt}",
              "lyrics": "${masterMusicAnalysisResponse2!.data!.data!.lyrics}",
              "taskId": "${masterMusicAnalysisResponse2!.data!.taskId}",
            },
            success: (data) {
              AiMusicTaskModel aiMusicTaskModel =
                  AiMusicTaskModel.fromJson(data);
              if (aiMusicTaskModel.status == 200) {
                /// 清除专属模式数据
                isGetRandom3 = false;
                hintTextEditingController3.text = "";
                hintTextEditingController6.text = "";

                if (historyAudioUrl.isNotEmpty) {
                  exclusiveModeStep = 3;
                } else {
                  if (voiceTimbreList.isEmpty) {
                    exclusiveModeStep = 1;
                  } else {
                    exclusiveModeStep = 3;
                  }
                }

                _timer2 = null;
                _isExclusiveQuerying = false;
                masterMusicAnalysisResponse2 = null;
                goHistoryMusicPage = false;
                exclusiveNewMusicSection = [];
                update();
                EasyLoading.showToast("生成歌曲成功",
                    maskType: EasyLoadingMaskType.none);
                Get.toNamed(Routes.myWorkPage);
              }
              Get.log("生成的数据===> $data");
              update();
            },
            fail: (code, msg) {
              EasyLoading.showToast(msg);
              if (code == 1000001) {
                Get.toNamed(Routes.meMusicNoteValuePage);
              }
            },
          );
        }, onSuccessValue: (value) {
          exclusiveNewMusicSection = LyricsParser.parse(value);
          masterMusicAnalysisResponse2!.data!.data!.lyrics = value;
          Get.log("专属模式希望呈现的内容===>${exclusiveNewMusicSection.first.title}");
          update();
        }, type: 0);
      }
    }
  }

  ///重新开始训练
  void reStartPractice() async {
    EasyLoading.show();
    String state = "";
    String taskId = "";
    String audioUrl = "";
    await HttpUtils.get(APIs.getLastTimbre, {}, success: (data) {
      EasyLoading.dismiss();
      AiExclusiveModeTaskModel aiExclusiveModeTaskModel2 =
          AiExclusiveModeTaskModel.fromJson(data);
      AiExclusiveModeTaskData? aiExclusiveModeTaskData =
          aiExclusiveModeTaskModel2.data;
      if (aiExclusiveModeTaskData != null) {
        state = aiExclusiveModeTaskData.status.toString();
        taskId = aiExclusiveModeTaskData.taskId.toString();
        audioUrl = aiExclusiveModeTaskData.sourceAudioUrl.toString();
        historyAudioUrl = audioUrl;
      }
      if (state == "0") {
        EasyLoading.showToast("当前有音色正在训练中，请耐心等待~");
        Get.log(
            "===查询进行中的历史音色任务===state==$state  taskId==$taskId  audioUrl==$audioUrl");
      } else {
        // openAgreeRecordAudioDialog();
        isCompleteRecord = false;
        goHistoryMusicPage = false;
        updateExclusiveModeStep(1);
      }
    }, fail: (code, msg) {
      EasyLoading.dismiss();
    });
  }

  ///打开录制提示弹窗
  openAgreeRecordAudioDialog() {
    eventBus.fire(const StopMusicButtonEvent());
    int? costMusicNote;
    int? remainMusicNote;
    if (aiMusicTrain != null) {
      costMusicNote = aiMusicTrain!.currentIntegral;
      remainMusicNote = aiMusicTrain!.userIntegral;
    }

    showModalBottomSheet(
        isScrollControlled: true,
        context: Get.context!,
        builder: (c) {
          Get.put(AiRecordController());
          Get.find<AiRecordController>().audioPlayer.type = 1;
          Get.find<AiRecordController>().updateSelectedAiMusicConfigListItem(
              aiMusicConfigListItem: selectedAiMusicConfigListItem);
          return RecordAudioHintDialog(
            // key: ValueKey(selectedAiMusicConfigListItem!.id),
            selectedAiMusicConfigListItem: selectedAiMusicConfigListItem!,
            costMusicNote: costMusicNote,
            remainMusicNote: remainMusicNote,
          );
        },
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ));
  }

  Widget privacyDialog() {
    return Center(
      child: SizedBox(
          width: double.infinity,
          height: 350.w,
          child: Stack(
            children: [
              Container(
                height: 350.w,
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
                        text: "声音生成服务条款",
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                        textColor: Colors.white),
                    SizedBox(
                      height: 30.w,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 0.w,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            " 我已经阅读并同意",
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 16.sp,
                                color: Colors.white.withOpacity(0.5)),
                          ),
                          InkResponse(
                            onTap: () {
                              launchController.openRecordAudio();
                            },
                            child: Text(
                              "声音生成服务条款",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16.sp,
                                  color: Colors.white),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30.w,
                    ),
                    SizedBox(
                      height: 44.h,
                      child: Row(
                        children: [
                          Expanded(
                            child: ByWidgetsUtil.commonBtn(
                              borderRadius: 12.w,
                              title: "不同意",
                              bgColor: ByColorUtil.WhiteColor.withOpacity(0.1),
                              fontWeight: FontWeight.w500,
                              textColor: ByColorUtil.WhiteColor,
                              fontSize: 16.sp,
                              onClick: () async {
                                SpUtil.putBool(ConstKeys.audioAgree, false);
                                Get.back();
                              },
                            ),
                          ),
                          SizedBox(width: 20.w),
                          Expanded(
                            child: ByWidgetsUtil.commonBtn(
                              bgColor: ByColorUtil.color00CB64,
                              borderRadius: 12.w,
                              title: "同意并继续",
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              textColor: Colors.white,
                              onClick: () async {
                                SpUtil.putBool(ConstKeys.audioAgree, true);
                                agreeRecordAudio = true;
                                update();
                                Get.back();
                              },
                            ),
                          ),
                        ],
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

  ///开始录制
  startRecord() {
    if (!launchController.isLogin) {
      launchController.login(
          loginSuccess: () {
            // startRecordEvent();
          },
          source: "ai_write_music");
      return;
    } else {
      startRecordEvent();
    }
  }

  startRecordEvent() {
    bool? isAgreeRecordAudio = SpUtil.getBool(ConstKeys.audioAgree) ?? false;
    agreeRecordAudio = isAgreeRecordAudio;
    if (exclusiveModeStep == 1 || exclusiveModeStep == 8) {
      if (agreeRecordAudio) {
        openAgreeRecordAudioDialog();
      } else {
        Get.dialog(privacyDialog()).then((value) {
          Get.log("是否同意声音服务条款===> $agreeRecordAudio");
          if (agreeRecordAudio) {
            openAgreeRecordAudioDialog();
          }
        });
      }
    }
    if (exclusiveModeStep == 2) {
      exclusiveModeStep = 4;
      update();
    }
  }

  ///同意声音生成服务条款事件
  agreeRecordEvent() {
    agreeRecordAudio = !agreeRecordAudio;
    SpUtil.putBool(ConstKeys.audioAgree, agreeRecordAudio);
    update();
  }

  ///打开声音生成服务条款url
  openRecordAudio() {
    launchController.openRecordAudio();
  }

  ///获取音频数据
  getMusicStrategyGuideList() {
    HttpUtils.get(
      APIs.getMusicStrategyGuideList,
      {},
      success: (data) {
        aiMusicConfigListModel = AIMusicConfigListModel.fromJson(data);
        if (aiMusicConfigListModel != null) {
          if (aiMusicConfigListModel!.data.isNotEmpty) {
            selectedAiMusicConfigListItem = aiMusicConfigListModel!.data.first;
            if (aiMusicConfigListModel!.data.length >= 2) {
              initialPage = 1;
              update();
            }
            Get.log("===获取推荐清唱音频的数据=== ${aiMusicConfigListModel!.data.length}");
          }
        }
        Get.log("===获取推荐清唱音频的数据=== $data");
        update();
      },
      fail: (code, msg) {},
    );
  }

  ///更新录音状态
  updateIsRecordVoice({
    required bool value,
  }) {
    isRecordVoice = value;
    exclusiveModeStep = 0;
    update();
  }

  ///更新录音完成状态
  updateCompleteRecordVoice({
    required bool value,
  }) {
    isCompleteRecord = value;
    update();
  }

  ///开始训练
  void startPractice() async {
    ///这里需要检查用户是否同意音频数据提示权限
    bool? isAgreeRecordAudio =
        SpUtil.getBool(ConstKeys.audioAgreePrivacy) ?? false;
    if (isAgreeRecordAudio) {
      startPracticeEvent();
    } else {
      Get.dialog(ExclusiveAudioPrivacyDialog()).then((value) {
        isAgreeRecordAudio =
            SpUtil.getBool(ConstKeys.audioAgreePrivacy) ?? false;
        Get.log("是否同意声音训练服务条款===> $isAgreeRecordAudio");
        if (isAgreeRecordAudio == true) {
          startPracticeEvent();
        }
      });
    }
  }

  void startPracticeEvent() {
    if (isPostAudioToServer) {
      return;
    }

    isPostAudioToServer = true;
    if (launchController.isVip) {
      if (launchController.is365Vip) {
        Get.log("===用户是专属会员===");

        /// 上传录音
        ByFfmpegUtil.loadUploadInfo(
            type: MediaType.audio,
            onSuccess: (UploadInfoBean infoBean) {
              /// 上传
              ByFfmpegUtil.uploadFile(
                  infoBean: infoBean,
                  filePath: audioFilePath,
                  showLoading: true,
                  onSuccess: (resp) {
                    postAudioUrlToServer = infoBean.objectUrl;
                    HttpUtils.post(
                      APIs.trainTimbre,
                      {
                        "audio_url": postAudioUrlToServer,
                      },
                      success: (data) async {
                        EasyLoading.dismiss();
                        aiMusicUrlTaskModel = AiMusicTaskModel.fromJson(data);
                        Get.log("===提交训练数据成功=== $data");
                        exclusiveModeStep = 2;
                        isCompleteRecord = false;
                        isHistoryAudioPractice = true;
                        isPostAudioToServer = false;
                        await getTrainTimbreList();

                        ///开始查询任务
                        Future.delayed(const Duration(seconds: 10))
                            .then((value) {
                          exclusiveStartQueryRecordTimer();
                        });
                        update();
                      },
                      fail: (code, msg) {
                        isPostAudioToServer = false;
                        Get.log("请求失败===>$code");
                        EasyLoading.showToast(msg,
                            maskType: EasyLoadingMaskType.none);
                        if (code == 1000001) {
                          Get.toNamed(Routes.meMusicNoteValuePage);
                        }
                        EasyLoading.dismiss();
                      },
                    );
                  },
                  onFailed: () {
                    isPostAudioToServer = false;
                  });
            },
            onFailed: () {
              isPostAudioToServer = false;
            });
        return;
      }
      if (launchController.is90Vip || launchController.is30Vip) {
        Get.log("===用户是大师会员===");
        launchController.showVipUpgradeDialog();
      }
    } else {
      ///todo 这里还需要补一个付费引导弹窗
      EasyLoading.showToast("需要开通专属会员，才可以使用哦～");
      Get.toNamed(Routes.vipPurchasePage);
    }
  }

  ///录音完成 更新音频地址
  void updateAudioFilePath({
    required String path,
  }) {
    Get.log("更新本地音频地址======= $path");
    audioFilePath = path;
    update();
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
              // if(voiceTimbreList.first.status==1){
              // }
              selectedVoiceTimbreItem = voiceTimbreList.first;
              exclusiveModeStep = 3;
            } else {
              ///如果状态为8 有历史错误没生成成功的数据
              if (exclusiveModeStep == 8) {
                return;
              }
              selectedVoiceTimbreItem = null;
              goHistoryMusicPage = false;
              exclusiveModeStep = 1;
            }
          }
        }
        Get.log("===请求下来的音频数据=== ${data}");

        Get.log("===请求下来的音频数据集合=== ${voiceTimbreList.length}");

        update();
      },
      fail: (code, msg) {
        EasyLoading.dismiss();
      },
    );
  }

  ///test
  // testAi() {
  //   HttpUtils.post(
  //     APIs.trainTimbre,
  //     {
  //       "audio_url": postAudioUrlToServer,
  //     },
  //     success: (data) {
  //       EasyLoading.dismiss();
  //       aiMusicUrlTaskModel = AiMusicTaskModel.fromJson(data);
  //       Get.log("===提交训练数据成功=== $data");
  //       exclusiveModeStep = 2;
  //       isCompleteRecord = false;
  //
  //       ///开始查询任务
  //       Future.delayed(const Duration(seconds: 10)).then((value) {
  //         exclusiveStartQueryRecordTimer();
  //       });
  //       update();
  //     },
  //     fail: (code, msg) {
  //       EasyLoading.dismiss();
  //     },
  //   );
  // }

  updateGoHistoryMusicPage() async {
    Get.log("更新=== $goHistoryMusicPage");
    goHistoryMusicPage = true;
    exclusiveModeStep = 3;
    await getTrainTimbreList();
    update();
  }

  updateVoiceTimbreItem({
    required VoiceTimbreItem item,
  }) {
    Get.log("更新=== ${item.name}");
    selectedVoiceTimbreItem = item;
    eventBus.fire(UpdateVoiceTimbreItemEvent(item: item));
    update();
  }

  ///使用该声音开始创作
  selectMusicToCreate() {
    if (selectedVoiceTimbreItem != null) {
      if (selectedVoiceTimbreItem!.status != 1) {
        EasyLoading.showToast("当前音色未训练成功,请选择已训练成功的音色~");
        return;
      }
    }
    goHistoryMusicPage = false;
    exclusiveModeStep = 4;
    Get.log("===点击了===");
    update();
  }

  ///专属模式
  ///专属模式打开配置选项弹窗
  Future openExclusiveAiMusicItemDialog({required OptionModelEx option}) async {
    await showModalBottomSheet(
        isScrollControlled: true,
        context: Get.context!,
        builder: (context) {
          return AiMusicConfigDialog(
            option: option,
            borderColor: ByColorUtil.colorC98465.withOpacity(0.6),
            backgroundColor: ByColorUtil.colorC98465.withOpacity(0.1),
            selectedContent: option.selectContent,
            selectedContent2: option.selectContent2,
          );
        },
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        )).then((value) {
      if (value != null) {
        OptionModelEx? optionModelEx;
        if (value["option"] != null) {
          optionModelEx = value["option"];
        }

        if (optionModelEx != null && selectedExclusiveOptionsList.isNotEmpty) {
          int index = selectedExclusiveOptionsList.indexOf(optionModelEx);
          if (index != -1) {
            selectedExclusiveOptionsList[index] = OptionModelEx(
              option: optionModelEx.option,
              selectContent2: value["selectContent2"],
              selectContent: value["selectContent"],
            );
            Get.log(
                "专属模式选中的内容==>${value["selectContent"]}  ${optionModelEx.option?.toJson()}");
          }
        }
      }
    });
  }

  /// 专属检查不希望出现的内容
  Future checkAiMusicHintText5() async {
    String textData = hintTextEditingController6.text;
    IllegalWordsController illegalWordsController =
        Get.put<IllegalWordsController>(IllegalWordsController());
    if (textData.isNotEmpty) {
      await illegalWordsController.detectIllegalWords(textData,
          onFail: () {}, onSuccess: () {}, onSuccessValue: (value) {
        Get.log("不希望呈现的内容===>$value");
        hintTextEditingController6.text = value;
        eventBus.fire(
          CheckAppearMusicDataTextSuccess(
            type: selectedAiMusicUiModel.type,
          ),
        );
      });
    } else {
      ///todo 准备提交数据
      createExclusiveLyric();
    }
  }

  ///专属模式生成歌词
  Future createExclusiveLyric() async {
    String musicGenres = "";
    String instruments = "";
    String tempoBPM = "";
    String moodAtmosphere = "";
    String musicalTexture = "";
    String vocalCharacteristics = "";
    String vocalTimbre = "";
    String languages = "";
    audioDuration2 = 180;
    if (selectedExclusiveOptionsList.isNotEmpty) {
      for (var e in selectedExclusiveOptionsList) {
        final Option? option = e.option;
        final String selectContent2 = e.selectContent2;
        final String selectContent = e.selectContent;
        if (option != null) {
          if (option.en == "Music Genres") {
            musicGenres = selectContent2;
          }
          if (option.en == "Instruments") {
            instruments = selectContent2;
          }
          if (option.en == "Tempo/BPM") {
            tempoBPM = selectContent2;
          }
          if (option.en == "Mood/Atmosphere") {
            moodAtmosphere = selectContent2;
          }
          if (option.en == "Musical Texture") {
            musicalTexture = selectContent2;
          }
          if (option.en == "Vocal Characteristics") {
            vocalCharacteristics = selectContent2;
          }
          if (option.en == "Vocal Timbre") {
            vocalTimbre = selectContent2;
          }
          if (option.en == "Languages") {
            languages = selectContent2;
          }
          if (option.en == "audio_duration") {
            audioDuration2 = int.parse(selectContent);
          }
        }

        Get.log(
            "selectContent===${selectContent} selectedContent2===${selectContent2}      ===option===  ${option?.toJson()}");
      }
    }
    Map<String, dynamic> options = {
      "Music Genres": musicGenres,
      "Instruments": instruments,
      "Tempo/BPM": tempoBPM,
      "Mood/Atmosphere": moodAtmosphere,
      "Musical Texture": musicalTexture,
      "Vocal Characteristics": vocalCharacteristics,
      "Vocal Timbre": vocalTimbre,
      "Languages": languages,
      "audio_duration": audioDuration.toString(),
    };

    Get.log(
        "=isPure=$masterPure  =prompt= $aiMusicHintText3 =exclude_prompt=${hintTextEditingController6.text} options==$options  ");
    HttpUtils.post(
      APIs.createLyric,
      {
        "isPure": false,
        "prompt": aiMusicHintText3,
        "exclude_prompt": hintTextEditingController6.text,
        "options": options,
        "mode": 3,
      },
      success: (data) {
        aiMusicExclusiveTaskModel = AiMusicTaskModel.fromJson(data);
        if (aiMusicExclusiveTaskModel != null) {
          if (aiMusicExclusiveTaskModel!.status == 200) {
            if (aiMusicExclusiveTaskModel!.data.taskId.isNotEmpty) {
              exclusiveModeStep = 5;

              ///开始定时查询任务
              exclusiveModeStartQuerying();
            }
          }
          Get.log("专属模式生成歌词请求下来的数据===> ${aiMusicExclusiveTaskModel!.toJson()}");
        }
        update();
      },
      fail: (code, msg) {
        Get.log("专属模式生成歌词失败请求下来的数据===> $msg $code");
      },
    );
  }

  updateExclusiveModeStep(int step) {
    exclusiveModeStep = step;
    update();
  }

  ///专属模式 开始定时查询 (5秒间隔)
  void exclusiveModeStartQuerying() {
    /// 先取消已有的定时器，避免重复
    stopExclusiveModeQuerying();

    /// 立即执行一次查询，再开始定时
    _performExclusiveModeQuerying();

    // 启动周期性定时器
    _timer2 = Timer.periodic(const Duration(seconds: 5), (timer) {
      _performExclusiveModeQuerying();
    });
  }

  /// 停止专属模式定时查询
  void stopExclusiveModeQuerying() {
    if (_timer2 != null) {
      _timer2?.cancel();
      _timer2 = null;
    }
  }

  /// 执行专属模式实际查询任务
  Future<void> _performExclusiveModeQuerying() async {
    // 防止并发请求
    if (_isExclusiveQuerying) return;

    _isExclusiveQuerying = true;
    try {
      HttpUtils.get(
        APIs.taskQuery,
        {
          "taskType": aiMusicExclusiveTaskModel!.data.taskType,
          "taskId": aiMusicExclusiveTaskModel!.data.taskId,
        },
        success: (data) {
          final MusicAnalysisData? musicAnalysisData;
          final MusicContentData? musicContentData;
          Get.log("专属模式查询任务成功请求下来的数据===> $data");
          masterMusicAnalysisResponse2 =
              MasterMusicAnalysisResponse.fromJson(data);
          if (masterMusicAnalysisResponse2 != null) {
            musicAnalysisData = masterMusicAnalysisResponse2!.data;
            if (musicAnalysisData != null) {
              musicContentData = musicAnalysisData.data;
              if (musicContentData != null) {
                exclusiveModeStep = 6;
                stopExclusiveModeQuerying();
              }
            }
          }

          update();
        },
        fail: (code, msg) {
          stopExclusiveModeQuerying();
          Get.log("专属模式查询任务失败请求下来的数据===> $msg $code");
        },
      );
    } catch (e) {
      // 捕获所有可能的错误 (网络错误、解析错误等)
    } finally {
      _isExclusiveQuerying = false;
    }
  }

  /// 释放资源
  void disposeTimer2() {
    stopExclusiveModeQuerying();
  }

  ///专属模式修改音色名称
  void editExclusiveAudioName() {
    Get.dialog(
      ExclusiveRenameAudioDialog(
        name: selectedVoiceTimbreItem!.name ?? "",
        id: selectedVoiceTimbreItem!.id ?? 0,
        title: "修改名称",
      ),
    ).then((value) {
      if (value != null) {
        Get.log("===newName=== ${value["newName"]}");
        if (value["newName"] != null) {
          HttpUtils.post(APIs.updateTimbreName, {
            "id": selectedVoiceTimbreItem!.id,
            "name": value["newName"],
          }, success: (value) {
            Get.log("修改名字成功的value==$value");
            getTrainTimbreList();
          }, fail: (code, msg) {
            EasyLoading.showToast(msg);
          });
        }
      }
    });
  }

  ///专属模式删除音色名称
  void deleteExclusiveAudio() {
    Get.dialog(ExclusiveDeleteAudioDialog(
      audioName: "${selectedVoiceTimbreItem!.name}",
    )).then((value) {
      Get.log("===value=== $value");
      if (value != null) {
        if (value["confirm"] == true && selectedVoiceTimbreItem != null) {
          HttpUtils.post(APIs.deleteTimbre, {"id": selectedVoiceTimbreItem!.id},
              success: (value) {
            Get.log("删除成功的value==$value");
            getTrainTimbreList();
          }, fail: (code, msg) {
            EasyLoading.showToast(msg);
          });
        }
      }
    });
  }

  ///训练新的音频点击事件
  void clickNewTrainAudioEvent() {
    exclusiveModeStep = 1;
    update();
  }

  /// 退出登录  清除历史状态
  void clearHistoryState() {
    exclusiveModeStep = 1;
    masterModeStep = 1;
    update();
  }

  ///随机高级设置点击事件
  clickHighLevelSettingEvent() {
    if (masterPure) {
      List<OptionModelEx> randomPureMasterModeOptionsList = [];
      randomPureMasterModeOptionsList.addAll(selectedPureMasterModeOptionsList);
      if (selectedPureMasterModeOptionsList.isNotEmpty) {
        for (var e in selectedPureMasterModeOptionsList) {
          final Option? option = e.option;
          int index = selectedPureMasterModeOptionsList.indexOf(e);
          if (option != null) {
            final List<Item>? items = option.items;
            if (items != null) {
              if (items.isNotEmpty) {
                int length = items.length;
                int random = Random().nextInt(length - 1);
                // Get.log("随机的items==> ${items[random].toJson()}");
                Item randomItm = items[random];
                randomPureMasterModeOptionsList[index] = OptionModelEx(
                    selectContent: randomItm.zh ?? "",
                    selectContent2: randomItm.en ?? "",
                    option: option);
              }
            }
            if (option.type == "int") {
              int min = option.min ?? 60;
              int max = option.max ?? 240;
              int randomTime = Random().nextInt((max - min)) + min;
              // Get.log("==随机的时长===$randomTime");
              randomPureMasterModeOptionsList[index] = OptionModelEx(
                  selectContent: randomTime.toString(),
                  selectContent2: max.toString(),
                  option: option);
            }
          }
          // Get.log("content==>${e.selectContent}  selectContent2===>${e.selectContent2}  option===>${e.option!.toJson()}");
        }
      }
      selectedPureMasterModeOptionsList.clear();
      selectedPureMasterModeOptionsList.addAll(randomPureMasterModeOptionsList);
    } else {
      List<OptionModelEx> randomMasterModeOptionsList = [];
      randomMasterModeOptionsList.addAll(selectedMasterModeOptionsList);
      if (selectedMasterModeOptionsList.isNotEmpty) {
        for (var e in selectedMasterModeOptionsList) {
          final Option? option = e.option;
          int index = selectedMasterModeOptionsList.indexOf(e);
          if (option != null) {
            final List<Item>? items = option.items;
            if (items != null) {
              if (items.isNotEmpty) {
                int length = items.length;
                int random = Random().nextInt(length - 1);
                // Get.log("随机的items==> ${items[random].toJson()}");
                Item randomItm = items[random];
                randomMasterModeOptionsList[index] = OptionModelEx(
                    selectContent: randomItm.zh ?? "",
                    selectContent2: randomItm.en ?? "",
                    option: option);
              }
            }
            if (option.type == "int") {
              int min = option.min ?? 60;
              int max = option.max ?? 240;
              int randomTime = Random().nextInt((max - min)) + min;
              // Get.log("==随机的时长===$randomTime");
              randomMasterModeOptionsList[index] = OptionModelEx(
                  selectContent: randomTime.toString(),
                  selectContent2: max.toString(),
                  option: option);
            }
          }
          // Get.log("content==>${e.selectContent}  selectContent2===>${e.selectContent2}  option===>${e.option!.toJson()}");
        }
      }
      selectedMasterModeOptionsList.clear();
      selectedMasterModeOptionsList.addAll(randomMasterModeOptionsList);
    }

    update();
  }

  ///专属模式 随机高级设置点击事件
  exclusiveHighLevelSettingEvent() {
    List<OptionModelEx> randomExclusiveModeOptionsList = [];
    randomExclusiveModeOptionsList.addAll(selectedExclusiveOptionsList);
    if (selectedExclusiveOptionsList.isNotEmpty) {
      for (var e in selectedExclusiveOptionsList) {
        final Option? option = e.option;
        int index = selectedExclusiveOptionsList.indexOf(e);
        if (option != null) {
          final List<Item>? items = option.items;
          if (items != null) {
            if (items.isNotEmpty) {
              int length = items.length;
              int random = Random().nextInt(length - 1);
              // Get.log("随机的items==> ${items[random].toJson()}");
              Item randomItm = items[random];
              randomExclusiveModeOptionsList[index] = OptionModelEx(
                  selectContent: randomItm.zh ?? "",
                  selectContent2: randomItm.en ?? "",
                  option: option);
            }
          }
          if (option.type == "int") {
            int min = option.min ?? 60;
            int max = option.max ?? 240;
            int randomTime = Random().nextInt((max - min)) + min;
            // Get.log("==随机的时长===$randomTime");
            randomExclusiveModeOptionsList[index] = OptionModelEx(
                selectContent: randomTime.toString(),
                selectContent2: max.toString(),
                option: option);
          }
        }
        // Get.log("content==>${e.selectContent}  selectContent2===>${e.selectContent2}  option===>${e.option!.toJson()}");
      }
    }
    selectedExclusiveOptionsList.clear();
    selectedExclusiveOptionsList.addAll(randomExclusiveModeOptionsList);
    update();
  }

  ///选择历史音频弹窗
  ///打开录制提示弹窗
  openHistoryAudioDialog() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: Get.context!,
      builder: (c) {
        return ExclusiveSelectAudioDialog();
      },
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topRight: Radius.circular(12.w),
        topLeft: Radius.circular(12.w),
      )),
    );
  }

  ///加载歌曲生成消耗音符值
  void loadAiMusicSongRights() {
    HttpUtils.post(
      APIs.getRightsByType,
      {
        "type": "app_ai_music_song",
      },
      success: (data) {
        aiMusicSongCreate = RightsByType.fromJson(data["data"]);
        Get.log("加载消耗音符数量---$data");
        update();
      },
      fail: (code, msg) {
        /// BotToast.showText(text: msg);
      },
    );
    HttpUtils.post(
      APIs.getRightsByType,
      {
        "type": "app_ai_music_train",
      },
      success: (data) {
        Get.log("加载音色训练消耗音符数量---$data");
        aiMusicTrain = RightsByType.fromJson(data["data"]);
        update();
      },
      fail: (code, msg) {},
    );
  }

  ///检查音频训练状态
  checkAudioPracticeState() async {
    String state = "";
    String taskId = "";
    String audioUrl = "";
    await HttpUtils.get(APIs.getLastTimbre, {}, success: (data) {
      aiExclusiveModeTaskModel = AiExclusiveModeTaskModel.fromJson(data);
      AiExclusiveModeTaskData? aiExclusiveModeTaskData;
      if (aiExclusiveModeTaskModel != null) {
        aiExclusiveModeTaskData = aiExclusiveModeTaskModel!.data;
        if (aiExclusiveModeTaskData != null) {
          state = aiExclusiveModeTaskData.status.toString();
          taskId = aiExclusiveModeTaskData.taskId.toString();
          audioUrl = aiExclusiveModeTaskData.sourceAudioUrl.toString();
          historyAudioUrl = audioUrl;
        }

        if (state == "0") {
          if (_isExclusiveQuerying) {
            return;
          }
          exclusiveModeStep = 2;
          isHistoryAudioPractice = true;
          exclusiveStartQueryRecordTimer(reload: true, taskId: taskId);
          Get.log(
              "===查询进行中的历史音色任务===state==$state  taskId==$taskId  audioUrl==$audioUrl");
        }

        if (state == "1") {
          isHistoryAudioPractice = false;

          Get.log("===无进行中的历史音色任务===");
        }

        if (state == "2") {
          exclusiveModeStep = 8;
          isHistoryAudioPractice = false;
          Get.log("===进行中的历史音色任务失败===");
        }

        update();

        Get.log(
            "===查询历史音色任务===  state==$state  taskId==$taskId  audioUrl==$audioUrl");
      }
    });

    update();
  }

  againPractice() {
    HttpUtils.post(
      APIs.trainTimbre,
      {
        "audio_url": historyAudioUrl,
      },
      success: (data) {
        EasyLoading.dismiss();
        aiMusicUrlTaskModel = AiMusicTaskModel.fromJson(data);
        Get.log("===提交训练数据成功=== $data");
        exclusiveModeStep = 2;
        isCompleteRecord = false;

        ///开始查询任务
        Future.delayed(const Duration(seconds: 10)).then((value) {
          exclusiveStartQueryRecordTimer();
        });
        update();
      },
      fail: (code, msg) {
        Get.log("请求失败===>$code");
        EasyLoading.showToast(msg, maskType: EasyLoadingMaskType.none);
        if (code == 1000001) {
          Get.toNamed(Routes.meMusicNoteValuePage);
        }
        EasyLoading.dismiss();
      },
    );
  }

  ///关闭右侧营销浮窗
  void closeMarketingView() {
    showMarketingView.value = false;
  }

  updateCreateSame({required MusicData musicData}) {
    SameData? sameData = musicData.sameData;

    ///灵感模式更新一键同款的数据
    if (musicData.mode == 1 && sameData != null) {
      inspirationCreateSameMusicData = musicData;
      if (isGetRandom) {
        return;
      }
      hintTextEditingController.text = sameData.prompt ?? "";
      isPure = sameData.instrumentalMode ?? false;
      update();
    }

    ///大师模式更新一键同款的数据
    if (musicData.mode == 2 && sameData != null) {
      Get.log("执行一键同款数据更新 高级配置===${musicData.sameData!.options}");
      stopQuerying();
      masterModeStep = 1;
      _isMasterQuerying = false;
      masterMusicAnalysisResponse = null;
      update();
      masterCreateSameMusicData = musicData;
      if (masterRandom) {
        return;
      }
      masterTextEditingController.text = sameData.prompt ?? "";
      masterPure = sameData.instrumentalMode ?? false;
      masterMusicNameEditingController.text = musicData.name ?? "";
      masterNoValueTextEditingController.text = sameData.reversePrompt ?? "";
      Map<String, dynamic>? options = sameData.options;
      if (options != null) {
        if (options.isNotEmpty) {
          List<OptionModelEx> newSelectedMasterModeOptionsList = [];
          String selectContent = "";
          if (masterPure) {
            selectedPureMasterModeOptionsList = [];
            for (var e in selectedMasterModeOptionsList) {
              Get.log("===e====> ${e.option!.instrumentalMode} ");
              Option? optionModelEx = e.option;
              if (optionModelEx != null) {
                if (optionModelEx.instrumentalMode == true) {
                  selectedPureMasterModeOptionsList.add(e);
                }
              }
            }
            options.forEach((e1, e2) {
              for (var e in selectedPureMasterModeOptionsList) {
                if (e.option!.en == e1) {
                  Option? options = e.option;
                  if (options != null) {
                    if (options.en == e1) {
                      List<Item>? items = options.items ?? [];
                      if (options.en != "audio_duration") {
                        if (items.isNotEmpty) {
                          for (var item in items) {
                            if (item.en == e2) {
                              selectContent = item.zh ?? "";
                            }
                          }
                        }
                      }
                    }
                  }
                  if (e1 == "audio_duration") {
                    selectContent = e2;
                  }
                  Get.log("===selectContent2222=== $selectContent");
                  newSelectedMasterModeOptionsList.add(OptionModelEx(
                    option: e.option,
                    selectContent2: e2,
                    selectContent: selectContent,
                  ));
                }
              }
            });
            selectedPureMasterModeOptionsList = [];
            selectedPureMasterModeOptionsList
                .addAll(newSelectedMasterModeOptionsList);
            update();
          } else {
            options.forEach((e1, e2) {
              for (var e in selectedMasterModeOptionsList) {
                if (e.option!.en == e1) {
                  Option? options = e.option;
                  if (options != null) {
                    if (options.en == e1) {
                      List<Item>? items = options.items ?? [];
                      if (options.en != "audio_duration") {
                        if (items.isNotEmpty) {
                          for (var item in items) {
                            if (item.en == e2) {
                              selectContent = item.zh ?? "";
                            }
                          }
                        }
                      }
                    }
                  }
                  if (e1 == "audio_duration") {
                    selectContent = e2;
                  }
                  Get.log("===selectContent2222=== $selectContent");
                  newSelectedMasterModeOptionsList.add(OptionModelEx(
                    option: e.option,
                    selectContent2: e2,
                    selectContent: selectContent,
                  ));
                }
              }
            });

            Get.log(
                "新选项配置数据的长度===> ${newSelectedMasterModeOptionsList.length}");

            selectedMasterModeOptionsList = [];
            selectedMasterModeOptionsList
                .addAll(newSelectedMasterModeOptionsList);
            update();
          }
        }
      }
      updateMasterAiMusicHintText(data: sameData.prompt ?? "");
    }
  }
}

class AiMusicUiModel {
  final String iconPath;
  final String aiWriteMusicBg;
  final int type;
  final String title;
  final String? iconPath2;
  final String? iconPath3;
  const AiMusicUiModel({
    required this.iconPath,
    required this.aiWriteMusicBg,
    required this.type,
    required this.title,
    this.iconPath2,
    this.iconPath3,
  });
}

///检查歌名成功事件
class CheckMusicNameSuccess {
  final int type;
  const CheckMusicNameSuccess({required this.type});
}

///检查提示词事件
class CheckMusicHintTextSuccess {
  final int type;
  const CheckMusicHintTextSuccess({required this.type});
}

///检查不希望呈现的内容事件
class CheckAppearMusicDataTextSuccess {
  final int type;
  const CheckAppearMusicDataTextSuccess({required this.type});
}

///更新音频
class UpdateVoiceTimbreItemEvent {
  final VoiceTimbreItem item;
  const UpdateVoiceTimbreItemEvent({
    required this.item,
  });
}
