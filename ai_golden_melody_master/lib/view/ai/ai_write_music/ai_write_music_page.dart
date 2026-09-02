import 'dart:async';

import 'package:ai_golden_melody_master/common/lib/app_common/by_common_utils.dart';
import 'package:ai_golden_melody_master/common/lib/app_common/consts/const_keys.dart';
import 'package:ai_golden_melody_master/common/lib/app_common/event/common_event.dart';
import 'package:ai_golden_melody_master/navigator/app_pages.dart';
import 'package:ai_golden_melody_master/utils/assets.dart';
import 'package:ai_golden_melody_master/view/ai/ai_write_music/master/master_write_music_page.dart';
import 'package:ai_golden_melody_master/view/ai/ai_write_music/play_music_button.dart';
import 'package:ai_golden_melody_master/view/ai/ai_write_music/record_audio_dialog.dart';
import 'package:ai_golden_melody_master/view/lanuch_page/launch_controller.dart';
import 'package:ai_golden_melody_master/view/publish/beans/banner_beans.dart';
import 'package:ai_golden_melody_master/view/publish/widget/banner_widget.dart';
import 'package:ai_golden_melody_master/view/publish/widget/member_contdown.dart';
import 'package:ai_golden_melody_master/view/publish/widget/right_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_download_manager/flutter_download_manager.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:showcaseview/showcaseview.dart';
import '../../../utils/by_color_utils.dart';
import '../../../utils/common_event.dart';
import '../../../utils/data_service.dart';
import '../../publish/controller/guide_pop_controller.dart';
import '../../purchase/vip/vip_purchase_controller.dart';
import 'ai_record_controller.dart';
import 'ai_write_music_controller.dart';
import 'exclusive_mode/exclusive_mode_page.dart';
import 'inspiration/inspiration_write_music_page.dart';

///AI写歌页面
class AiWriteMusicPage extends StatefulWidget {
  const AiWriteMusicPage({super.key});

  @override
  State<AiWriteMusicPage> createState() => _AiWriteMusicPageState();
}

class _AiWriteMusicPageState extends State<AiWriteMusicPage>
    with SingleTickerProviderStateMixin {
  LaunchController launchController = Get.find<LaunchController>();
  late TabController _tabController;
  List<Widget> tabBarPages = const [
    InspirationWriteMusicPage(),
    MasterWriteMusicPage(),
    ExclusiveModePage(),
  ];
  int currentTabIndex = 0;

  ///监听一键同款事件.
  late StreamSubscription<CreateSampleEvent> createSampleStreamSubscription;

  late StreamSubscription<bool> keyboardSubscription;
  final KeyboardVisibilityController keyboardVisibilityController = KeyboardVisibilityController();

  // bool isKeyboard = false;


  /// 监听发送展示抄底事件弹窗
  late StreamSubscription<ShowBottomPayDialogEvent> showBottomPayDialogEventStreamSubscription;


  @override
  void initState() {
    _tabController = TabController(
      length: 3,
      vsync: this,
      animationDuration: const Duration(milliseconds: 100),
    );

    createSampleStreamSubscription = eventBus.on<CreateSampleEvent>().listen(
      (e) {
        currentTabIndex = (e.mode - 1);
        _tabController.animateTo(
          currentTabIndex,
        );
        Get.find<AiWriteMusicController>().updateSelectedAiMusicUiModel(
          model: AiWriteMusicController.aiMusicUiModelList[e.mode - 1],
        );
        if (e.mode == 1) {
          Get.find<AiWriteMusicController>()
              .updateCreateSame(musicData: e.musicData);
        }

        if (e.mode == 2) {
          Get.find<AiWriteMusicController>()
              .updateCreateSame(musicData: e.musicData);
        }

        // if (e.mode == 3) {
        //   Get.find<AiWriteMusicController>().updateCreateSame(musicData: e.musicData);
        //
        // }

        if (mounted) {
          setState(() {});
        }
      },
    );

    keyboardSubscription =
        keyboardVisibilityController.onChange.listen((bool visible) {
          // if(mounted){
          //   setState(() {
          //     isKeyboard = visible;
          //
          //   });
          // }
          Get.log('Keyboard visibility update. Is visible: $visible');
        });

    showBottomPayDialogEventStreamSubscription = eventBus.on<ShowBottomPayDialogEvent>().listen((e){
      Get.find<LaunchController>().openComeBackPayBgDialog();
    });

    super.initState();
  }

  ///购买按钮
  _buyBtn() {
    return GetBuilder<AiWriteMusicController>(
        // id: const ["aiMusicHintText"],
        builder: (controller) {
      ///需要消耗的音符值
      int? costMusicNote;

      ///剩余音符值
      int? remainMusicNote;
      if (controller.aiMusicSongCreate != null) {
        costMusicNote = controller.aiMusicSongCreate!.currentIntegral;
        remainMusicNote = controller.aiMusicSongCreate!.userIntegral;
      }

      if (controller.selectedAiMusicUiModel.type == 1) {
        return _masterModeBtn(
          controller: controller,
          costMusicNote: costMusicNote,
          remainMusicNote: remainMusicNote,
        );
      }
      if (controller.selectedAiMusicUiModel.type == 2) {
        return _exclusiveModeBtn(
          controller: controller,
          costMusicNote: costMusicNote,
          remainMusicNote: remainMusicNote,
        );
      }

      if (controller.isFirstJoin) {
        return const SizedBox();
      }
      return Container(
        width: 1.sw,
        decoration: const BoxDecoration(
          color: ByColorUtil.color121212,
        ),
        padding:
            EdgeInsets.only(left: 12.w, right: 12.w, bottom: 20.w, top: 10.w),
        child: Column(
          children: [
            InkResponse(
              onTap: () {
                if (launchController.isLogin) {
                  if (launchController.isVip) {
                    Get.toNamed(Routes.meMusicNoteValueListPage);
                  } else {
                    Get.toNamed(Routes.vipPurchasePage);
                  }
                } else {
                  launchController.login(source: "ai_write_music");
                }
              },
              child: Row(
                children: [
                  Text(
                    "使用该功能需要消耗${costMusicNote ?? ""}音符值",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const Spacer(),
                  if (launchController.isVip)
                    Row(
                      children: [
                        Image.asset(
                          Assets.diamondIcon,
                          width: 14.w,
                          height: 14.w,
                        ),
                        Text(
                          "剩余",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          "${remainMusicNote ?? ""}",
                          style: TextStyle(
                            color: ByColorUtil.colorF79B0B,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "音符值",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  SizedBox(
                    width: 4.w,
                  ),
                  if (!launchController.isVip)
                    Text(
                      "开通会员赠送音符值",
                      style: TextStyle(
                        color: ByColorUtil.colorF79B0B,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                ],
              ),
            ),
            InkResponse(
              onTap: () {
                ByCommonUtils.throttle((){
                  controller.createInspirationAiMusic();
                });
              },
              child: Container(
                alignment: Alignment.center,
                width: 1.sw,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      const Color(0xFF24FECF).withOpacity(
                          (controller.aiMusicHintText.isNotEmpty &&
                                  !controller.isGetRandom)
                              ? 1
                              : 0.3),
                      const Color(0xFFFFF13C).withOpacity(
                          (controller.aiMusicHintText.isNotEmpty &&
                                  !controller.isGetRandom)
                              ? 1
                              : 0.3),
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
                child: Text(
                  "一键Ai写歌",
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: ByColorUtil.color121212,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  ///大师模式的按钮
  _masterModeBtn({
    required AiWriteMusicController controller,

    ///需要消耗的音符值
    int? costMusicNote,

    ///剩余音符值
    int? remainMusicNote,
  }) {
    if (controller.masterModeStep == 2 && controller.masterPure) {
      return const SizedBox();
    }

    return Container(
      width: 1.sw,
      decoration: const BoxDecoration(
        color: ByColorUtil.color121212,
      ),
      padding:
          EdgeInsets.only(left: 12.w, right: 12.w, bottom: 20.w, top: 10.w),
      child: Column(
        children: [
          InkResponse(
            onTap: () {
              if (launchController.isLogin) {
                if (launchController.isVip) {
                  Get.toNamed(Routes.meMusicNoteValueListPage);
                } else {
                  Get.toNamed(Routes.vipPurchasePage);
                }
              } else {
                launchController.login(source: "ai_write_music");
              }
            },
            child: Row(
              children: [
                Text(
                  "使用该功能需要消耗${costMusicNote ?? ""}音符值",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const Spacer(),
                if (launchController.isVip)
                  Row(
                    children: [
                      Image.asset(
                        Assets.diamondIcon,
                        width: 14.w,
                        height: 14.w,
                      ),
                      Text(
                        "剩余",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        "${remainMusicNote ?? ""}",
                        style: TextStyle(
                          color: ByColorUtil.colorF79B0B,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        "音符值",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                SizedBox(
                  width: 4.w,
                ),
                if (!launchController.isVip)
                  Text(
                    "开通会员赠送音符值",
                    style: TextStyle(
                      color: ByColorUtil.colorF79B0B,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ),
          InkResponse(
            onTap: () async {
              Get.log(
                  "===random==> ${controller.masterRandom}  ${controller.aiMusicHintText2}");
              ByCommonUtils.throttle(() async {
                // await controller.nextMasterStep();
                await controller.clickNextMasterStep();
              }, delay: 500);
            },
            child:Opacity(
              opacity: (controller.aiMusicHintText2.isNotEmpty &&
                  !controller.masterRandom)
                  ? 1
                  : 0.3,
              child:  Container(
                  alignment: Alignment.center,
                  width: 1.sw,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Color(0xFFF99A6E),
                        Color(0xFFFFE5CB),
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
                    shaderCallback: (Rect bounds) {
                      return  LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [Color(0xFF9F3E02), Color(0xFFC16515)],
                      ).createShader(bounds);
                    },
                    child: Text(
                      controller.masterModeStep == 3 ? "立即生成歌曲" : "下一步",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.sp,
                          // height: 1.0,
                          color: Colors.white),
                    ),
                  ),),
            )
          ),
        ],
      ),
    );
  }

  ///专属模式的按钮
  _exclusiveModeBtn({
    required AiWriteMusicController controller,

    ///需要消耗的音符值
    int? costMusicNote,

    ///剩余音符值
    int? remainMusicNote,
  }) {
    if (controller.isRecordVoice) {
      return InkResponse(
        onTap: () {
          // controller.startRecord();
          EasyLoading.showToast("请专心录制音频～", maskType: EasyLoadingMaskType.none);
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
                "录制中...",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: ByColorUtil.colorC16515,
                ),
              ),
            )),
      );
    }
    if (controller.isCompleteRecord) {
      Get.log("===selectedAiMusicConfigListItem ${controller.audioFilePath}");
      int? musicTrainCostMusicNote;
      if (controller.aiMusicTrain != null) {
        musicTrainCostMusicNote = controller.aiMusicTrain!.currentIntegral;
      }

      return Container(
        width: 1.sw,
        decoration: const BoxDecoration(
          color: ByColorUtil.color121212,
        ),
        padding:
            EdgeInsets.only(left: 12.w, right: 12.w, bottom: 20.w, top: 10.w),
        child: Column(
          children: [
            ///录制完成的播放按钮
            PlayMusicButton(
              selectedAiMusicConfigListItem:
                  controller.selectedAiMusicConfigListItem!,
              musicPath: controller.audioFilePath,
            ),

            InkResponse(
              onTap: () {
                Get.toNamed(Routes.meMusicNoteValuePage);
              },
              child: Row(
                children: [
                  Text(
                    "本次消耗${musicTrainCostMusicNote ?? ""}音符值",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const Spacer(),
                  Image.asset(
                    Assets.diamondIcon,
                    width: 14.w,
                    height: 14.w,
                  ),
                  Text(
                    "剩余",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    "${remainMusicNote ?? ""}",
                    style: TextStyle(
                      color: ByColorUtil.colorF79B0B,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    "音符值",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(
              height: 10.w,
            ),

            ///重新录制 开始训练
            Row(
              children: [
                InkResponse(
                  onTap: () {
                    // eventBus.fire(const RecordEvent(status: 2));
                    controller.isCompleteRecord = false;
                    controller.updateExclusiveModeStep(1);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12.w),
                    ),
                    padding: EdgeInsets.only(
                      top: 17.w,
                      bottom: 17.w,
                      left: 25.w,
                      right: 25.w,
                    ),
                    child: Text(
                      "重新录制",
                      style: TextStyle(fontSize: 18.sp, color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10.w,
                ),
                Expanded(
                    child: InkResponse(
                  onTap: () {
                    ///开始训练事件
                    ByCommonUtils.throttle(() {
                      controller.startPractice();
                    }, delay: 500);
                  },
                  child: Container(
                    padding: EdgeInsets.only(
                      top: 17.w,
                      bottom: 17.w,
                    ),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Color(0xFFFEC57F), // 对应#FFE3B4的较亮起始色
                            Color(0xFFFFE3B4), // 对应#FEC57F的较暗结束色
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12.w)),
                    child: ShaderMask(
                      blendMode: BlendMode.srcIn,
                      shaderCallback: (bounds) => const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFF9F5602),
                          Color(0xFFC17015),
                        ],
                      ).createShader(bounds),
                      child: Text(
                        "开始训练",
                        style: TextStyle(
                            fontSize: 18.sp, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ))
              ],
            )
          ],
        ),
      );
    }

    if (controller.exclusiveModeStep == 2) {
      if (controller.goHistoryMusicPage) {
        return InkResponse(
          onTap: () {
            // controller.startRecord();
            controller.selectMusicToCreate();
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
                "使用该声音开始创作",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: ByColorUtil.colorC16515,
                ),
              ),
            ),
          ),
        );
      }

      return const SizedBox();
    }

    if (controller.exclusiveModeStep == 3) {
      return InkResponse(
        onTap: () {
          controller.selectMusicToCreate();
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
                "使用该声音开始创作",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: ByColorUtil.colorC16515,
                ),
              ),
            )),
      );
    }

    if (controller.exclusiveModeStep == 4 ||
        controller.exclusiveModeStep == 6 ||
        (controller.exclusiveModeStep == 3 &&
            controller.voiceTimbreList.isNotEmpty)) {
      return Container(
        width: 1.sw,
        decoration: const BoxDecoration(
          color: ByColorUtil.color121212,
        ),
        padding:
            EdgeInsets.only(left: 12.w, right: 12.w, bottom: 20.w, top: 10.w),
        child: Column(
          children: [
            InkResponse(
              onTap: () {
                if (launchController.isLogin) {
                  if (launchController.isVip) {
                    Get.toNamed(Routes.meMusicNoteValueListPage);
                  } else {
                    Get.toNamed(Routes.vipPurchasePage);
                  }
                } else {
                  launchController.login(source: "ai_write_music");
                }
              },
              child: Row(
                children: [
                  Text(
                    "使用该功能需要消耗${costMusicNote ?? ""}音符值",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const Spacer(),
                  if (launchController.isVip)
                    Row(
                      children: [
                        Image.asset(
                          Assets.diamondIcon,
                          width: 14.w,
                          height: 14.w,
                        ),
                        Text(
                          "剩余",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          "${remainMusicNote ?? ""}",
                          style: TextStyle(
                            color: ByColorUtil.colorF79B0B,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "音符值",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  SizedBox(
                    width: 4.w,
                  ),
                  if (!launchController.isVip)
                    Text(
                      "开通会员赠送音符值",
                      style: TextStyle(
                        color: ByColorUtil.colorF79B0B,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                ],
              ),
            ),
            InkResponse(
              onTap: () {
                ByCommonUtils.throttle(() {
                  controller.nextStep2();
                }, delay: 500);
              },
              child: Container(
                alignment: Alignment.center,
                width: 1.sw,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      const Color(0xFFFEC57F).withOpacity(
                          (controller.aiMusicHintText3.isNotEmpty &&
                                  !controller.isGetRandom3)
                              ? 1
                              : 0.3),
                      const Color(0xFFFFE3B4).withOpacity(
                          (controller.aiMusicHintText3.isNotEmpty &&
                                  !controller.isGetRandom3)
                              ? 1
                              : 0.3),
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
                child: Text(
                  controller.exclusiveModeStep == 6 ? "立即生成歌曲" : "下一步",
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: ByColorUtil.color121212,
                  ),
                ),
              ),
            )
          ],
        ),
      );
    }

    if (controller.exclusiveModeStep == 5) {
      return SizedBox();
    }

    if (controller.exclusiveModeStep == 8) {
      return SizedBox();
    }

    return Container(
      width: 1.sw,
      decoration: const BoxDecoration(
        color: ByColorUtil.color121212,
      ),
      padding:
          EdgeInsets.only(left: 12.w, right: 12.w, bottom: 20.w, top: 10.w),
      child: Column(
        children: [
          Row(
            children: [
              InkResponse(
                onTap: () {
                  controller.agreeRecordEvent();
                },
                child: Row(
                  children: [
                    Container(
                      width: 20.w,
                      height: 20.w,
                      alignment: Alignment.center,
                      color: Colors.transparent,
                      child: Container(
                        width: 12.w,
                        height: 12.w,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.w),
                            border: Border.all(
                              color: ByColorUtil.color6c6c6c,
                            )),
                        alignment: Alignment.center,
                        child: controller.agreeRecordAudio
                            ? Container(
                                width: 8.w,
                                height: 8.w,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10.w),
                                ),
                              )
                            : null,
                      ),
                    ),
                    SizedBox(
                      width: 4.w,
                    ),
                    Text(
                      "我已阅读并同意 ",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              InkResponse(
                onTap: () {
                  controller.openRecordAudio();
                },
                child: Text(
                  "声音生成服务条款",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              )
            ],
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
                    "开始录制",
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: ByColorUtil.colorC16515,
                    ),
                  ),
                )),
          )
        ],
      ),
    );
  }

  ///banner
  _bannerView() {
    return Padding(
      padding: EdgeInsets.only(left: 12.w, right: 12.w),
      child: BannerWidget(
        height: 80.0,
        position: 11,
        bottomMargin: 12,
        onBannerTap: (BannerBean banner) {},
        onBannerClose: () {},
      ),
    );
  }

  ///右边营销浮窗
  _marketingView() {
    return GetBuilder<AiWriteMusicController>(builder: (controller) {
      return Positioned(
        bottom: 120.h,
        right: 0,
        child: GestureDetector(
          onTap: () {
            // 跳转付费页面
            // launchController.checkIsNewUser(true);
            // launchController.goToVipPage();

            launchController.checkPreLogin(
              actionCallback: () {
                launchController.checkIsNewUser(true);
                launchController.goToVipPage();
              },
              source: "ai_write_music_page"
            );
          },
          child: Stack(
            children: [
              SizedBox(
                width: 100.w,
                height: 80.h,
              ),
              Positioned(
                top: 0,
                right: 0,
                child: // 主图片，居中显示
                    Padding(
                  padding: EdgeInsets.only(right: 8.w),
                  child: launchController.writeSongFloatingImage.isNotEmpty
                      ? Image.network(
                          launchController.writeSongFloatingImage,
                          // width: 76.w,
                          height: 80.h,
                          fit: BoxFit.fitHeight,
                        )
                      : Image.asset(
                          "assets/purchase/home_marketing_2.png",
                          // width: 76.w,
                          height: 80.h,
                          fit: BoxFit.fitHeight,
                        ),
                ),
              ),

              // 倒计时容器，底部居中
              Positioned(
                bottom: 0,
                right: 8,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.w),
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFFFFE0AC),
                        Color(0xFFFFCE7C),
                      ],
                    ),
                  ),
                  child: MemberCountdown(
                    fontSize: 12.sp,
                    textColor: const Color(0xFFCD1C1C),
                    bgColor: Colors.transparent,
                    separatorColor: const Color(0xFFCD1C1C),
                    borderColor: Colors.transparent,
                    timeItemWidth: 20.w,
                    borderRadius: 0.w,
                    showMilliseconds: false,
                    padding: 0,
                  ),
                ),
              ),
              // 关闭按钮，右上角
              Positioned(
                top: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () {
                    // 点击关闭按钮，关闭右侧营销浮窗
                    controller.closeMarketingView();
                  },
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 12.w,
                      bottom: 12.h,
                      right: 4.w,
                    ),
                    child: Image.asset(
                      "assets/purchase/home_marketing_close_icon.png",
                      width: 12.w,
                      height: 12.w,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AiWriteMusicController>(builder: (controller) {
      bool showHistoryList = false;
      if (controller.voiceTimbreList.isNotEmpty) {
        for (var e in controller.voiceTimbreList) {
          if (e.status == 1) {
            showHistoryList = true;
          }
        }
      }
      return Stack(
        children: [
          ShowCaseWidget(
            builder: (context) {
              return Material(
                child: Container(
                  color: ByColorUtil.color121212,
                  child: SizedBox(
                    width: 1.sw,
                    height: 1.sh,
                    child: Stack(
                      children: [
                        SizedBox(
                          width: 1.sw,
                          height: 1.sh,
                        ),
                        Positioned(
                            top: 0,
                            child: Stack(
                              // fit: StackFit.expand,
                              // alignment: Alignment.center,
                              children: [
                                Image.asset(
                                  controller
                                      .selectedAiMusicUiModel.aiWriteMusicBg,
                                  height: 400.w,
                                  fit: BoxFit.fill,
                                  width: 1.sw,
                                ),
                                Positioned(
                                  top: 110.w,
                                  right: 0.w,
                                  left: 12.w,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      ...AiWriteMusicController
                                          .aiMusicUiModelList
                                          .map(
                                        (e) {
                                          Color selectedColor =
                                              Colors.white.withOpacity(0.05);

                                          if (controller.selectedAiMusicUiModel
                                                  .type ==
                                              e.type) {
                                            if (e.type == 0) {
                                              selectedColor =
                                                  ByColorUtil.color3A3A3C;
                                            }
                                            if (e.type == 1) {
                                              selectedColor =
                                                  ByColorUtil.color3A3A3C;
                                            }
                                            if (e.type == 2) {
                                              selectedColor =
                                                  ByColorUtil.color3A3A3C;
                                            }
                                          }

                                          return Stack(
                                            clipBehavior: Clip.none,
                                            children: [
                                              InkResponse(
                                                onTap: () {

                                                  eventBus.fire(CloseKeyboardEvent());
                                                  if (currentTabIndex ==
                                                      e.type) {
                                                    return;
                                                  }

                                                  currentTabIndex = e.type;
                                                  _tabController.animateTo(
                                                      currentTabIndex);
                                                  controller
                                                      .updateSelectedAiMusicUiModel(
                                                          model: e);
                                                  if (mounted) {
                                                    setState(() {});
                                                  }
                                                  Get.find<
                                                          AiWriteMusicController>()
                                                      .loadAiMusicSongRights();
                                                  if (controller
                                                          .exclusiveModeStep ==
                                                      3) {
                                                    ///todo 加载训练音色数据
                                                    if (!controller
                                                            .isExclusiveQueryRecord &&
                                                        !controller
                                                            .isQueryRecord2) {
                                                      Get.find<
                                                              AiWriteMusicController>()
                                                          .getTrainTimbreList();
                                                    }
                                                  }
                                                },
                                                child: (controller
                                                            .selectedAiMusicUiModel
                                                            .type ==
                                                        e.type)
                                                    ? Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                right: 12.w),
                                                        child: Stack(
                                                          alignment:
                                                              Alignment.center,
                                                          children: [
                                                            Image.asset(
                                                              e.iconPath3!,
                                                              width: 109.w,
                                                              height: 44.w,
                                                              fit: BoxFit.fill,
                                                            ),
                                                            Align(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: e.type == 0
                                                                  ? Text(
                                                                      e.title,
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            14.sp,
                                                                        fontWeight:
                                                                            FontWeight.w600,
                                                                        color: ByColorUtil
                                                                            .color121212,
                                                                      ),
                                                                    )
                                                                  : ShaderMask(
                                                                      blendMode:
                                                                          BlendMode
                                                                              .srcIn,
                                                                      shaderCallback:
                                                                          (bounds) =>
                                                                              LinearGradient(
                                                                        colors: e.type ==
                                                                                1
                                                                            ? [
                                                                                const Color(0xFF9F3E02),
                                                                                const Color(0xFFC16515)
                                                                              ]
                                                                            : [
                                                                                const Color(0xFF9F5602),
                                                                                const Color(0xFFC17015)
                                                                              ],
                                                                        begin: Alignment
                                                                            .topCenter,
                                                                        end: Alignment
                                                                            .bottomCenter,
                                                                      ).createShader(bounds),
                                                                      child:
                                                                          Text(
                                                                        e.title,
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              14.sp,
                                                                          fontWeight:
                                                                              FontWeight.w600,
                                                                          color:
                                                                              ByColorUtil.colorC16515,
                                                                        ),
                                                                      ),
                                                                    ),
                                                            )
                                                          ],
                                                        ))
                                                    : Container(
                                                        width: 109.w,
                                                        height: 44.w,
                                                        margin: EdgeInsets.only(
                                                            right: 12.w),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                          color: controller
                                                                      .selectedAiMusicUiModel
                                                                      .type ==
                                                                  e.type
                                                              ? ByColorUtil
                                                                  .color3A3A3C
                                                              : Colors.white
                                                                  .withOpacity(
                                                                  0.05,
                                                                ),
                                                        ),
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(
                                                          e.title,
                                                          style: TextStyle(
                                                            color: controller
                                                                        .selectedAiMusicUiModel
                                                                        .type ==
                                                                    e.type
                                                                ? Colors.white
                                                                : Colors.white
                                                                    .withOpacity(
                                                                        0.5),
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 14.sp,
                                                          ),
                                                        ),
                                                      ),
                                              ),
                                              if (e.iconPath2 != null)
                                                Positioned(
                                                  left: 0.w,
                                                  top: -7.w,
                                                  child: Image.asset(
                                                    e.iconPath2!,
                                                    width: 72.w,
                                                    height: 21.w,
                                                  ),
                                                )
                                            ],
                                          );
                                        },
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            )),
                        Positioned(
                          top: 54.w,
                          left: 12.w,
                          child: Row(
                            children: [
                              Image.asset(
                                controller.selectedAiMusicUiModel.iconPath,
                                width: 24.w,
                                height: 24.w,
                              ),
                              SizedBox(
                                width: 6.w,
                              ),
                              Text(
                                "AI写歌 发行赚钱",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20.sp,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(
                                width: 107.w,
                              ),
                              if (!controller.isFirstJoin)
                                SizedBox(
                                  height: 28.h,
                                  child: RightNavigationBar(
                                    key: ValueKey(
                                        controller.selectedAiMusicUiModel.type),
                                    entranceType: controller
                                                .selectedAiMusicUiModel.type ==
                                            0
                                        ? GuideEntranceType.aiMusicInspiration
                                        : controller.selectedAiMusicUiModel
                                                    .type ==
                                                1
                                            ? GuideEntranceType.aiMusicMaster
                                            : GuideEntranceType
                                                .aiMusicExclusive,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        // Positioned(
                        //   top: 110.w,
                        //   left: 12.w,
                        //   child: Row(
                        //     children: [
                        //       ...AiWriteMusicController.aiMusicUiModelList.map(
                        //         (e) {
                        //           Color selectedColor = Colors.white.withOpacity(0.05);
                        //
                        //           if (controller.selectedAiMusicUiModel.type ==
                        //               e.type) {
                        //             if (e.type == 0) {
                        //               selectedColor = ByColorUtil.color3A3A3C;
                        //             }
                        //             if (e.type == 1) {
                        //               selectedColor = ByColorUtil.color3A3A3C;
                        //             }
                        //             if (e.type == 2) {
                        //               selectedColor = ByColorUtil.color3A3A3C;
                        //             }
                        //           }
                        //
                        //           return Stack(
                        //             clipBehavior: Clip.none,
                        //             children: [
                        //               InkResponse(
                        //                 onTap: () {
                        //                   currentTabIndex = e.type;
                        //                   _tabController.animateTo(currentTabIndex);
                        //                   controller.updateSelectedAiMusicUiModel(
                        //                       model: e);
                        //                   if (mounted) {
                        //                     setState(() {});
                        //                   }
                        //                   Get.find<AiWriteMusicController>()
                        //                       .loadAiMusicSongRights();
                        //                   if (controller.exclusiveModeStep == 3) {
                        //                     ///todo 加载训练音色数据
                        //                     if (!controller.isExclusiveQueryRecord &&
                        //                         !controller.isQueryRecord2) {
                        //                       Get.find<AiWriteMusicController>()
                        //                           .getTrainTimbreList();
                        //                     }
                        //                   }
                        //                 },
                        //                 child: (controller
                        //                                 .selectedAiMusicUiModel.type ==
                        //                             e.type &&
                        //                         e.type != 0)
                        //                     ? Padding(
                        //                         padding: EdgeInsets.only(left: 12.w),
                        //                         child: Stack(
                        //                           children: [
                        //                             Image.asset(
                        //                               e.iconPath3!,
                        //                               width: 109,
                        //                               height: 49,
                        //                               fit: BoxFit.fill,
                        //                             ),
                        //                             Positioned(
                        //                                 top: 15.w,
                        //                                 left: 23.w,
                        //                                 child: ShaderMask(
                        //                                   blendMode: BlendMode.srcIn,
                        //                                   shaderCallback: (bounds) =>
                        //                                       LinearGradient(
                        //                                     colors: e.type == 1
                        //                                         ? [
                        //                                             const Color(
                        //                                                 0xFF9F3E02),
                        //                                             const Color(
                        //                                                 0xFFC16515)
                        //                                           ]
                        //                                         : [
                        //                                             const Color(
                        //                                                 0xFF9F5602),
                        //                                             const Color(
                        //                                                 0xFFC17015)
                        //                                           ],
                        //                                     begin: Alignment.topCenter,
                        //                                     end: Alignment.bottomCenter,
                        //                                   ).createShader(bounds),
                        //                                   child: Text(
                        //                                     e.title,
                        //                                     style: TextStyle(
                        //                                       fontSize: 14.sp,
                        //                                       fontWeight:
                        //                                           FontWeight.w600,
                        //                                       color: ByColorUtil
                        //                                           .colorC16515,
                        //                                     ),
                        //                                   ),
                        //                                 ))
                        //                           ],
                        //                         ))
                        //                     : Container(
                        //                         width: 109,
                        //                         height: 44,
                        //                         margin: EdgeInsets.only(left: 12.w),
                        //                         decoration: BoxDecoration(
                        //                           borderRadius:
                        //                               BorderRadius.circular(12),
                        //                           color: controller
                        //                                       .selectedAiMusicUiModel
                        //                                       .type ==
                        //                                   e.type
                        //                               ? ByColorUtil.color3A3A3C
                        //                               : Colors.white.withOpacity(
                        //                                   0.05,
                        //                                 ),
                        //                         ),
                        //                         alignment: Alignment.center,
                        //                         child: Text(
                        //                           e.title,
                        //                           style: TextStyle(
                        //                             color: controller
                        //                                         .selectedAiMusicUiModel
                        //                                         .type ==
                        //                                     e.type
                        //                                 ? Colors.white
                        //                                 : Colors.white.withOpacity(0.5),
                        //                             fontWeight: FontWeight.bold,
                        //                             fontSize: 14.sp,
                        //                           ),
                        //                         ),
                        //                       ),
                        //               ),
                        //               if (e.iconPath2 != null)
                        //                 Positioned(
                        //                   left: 12.w,
                        //                   top: -7.w,
                        //                   child: Image.asset(
                        //                     e.iconPath2!,
                        //                     width: 72.w,
                        //                     height: 21.w,
                        //                   ),
                        //                 )
                        //             ],
                        //           );
                        //         },
                        //       )
                        //     ],
                        //   ),
                        // ),

                        // Positioned.fill(
                        //   top: 169.w,
                        //   child: TabBarView(
                        //     controller: _tabController,
                        //     physics: const NeverScrollableScrollPhysics(),
                        //     children: tabBarPages,
                        //   ),
                        // ),
                        Positioned.fill(
                          top: 169.w,
                          child: Column(
                            children: [
                              if (!controller.isRecordVoice &&
                                  !controller.isCompleteRecord &&
                                  !controller.isFirstJoin)
                                _bannerView(),
                              Expanded(
                                child: TabBarView(
                                  controller: _tabController,
                                  physics: const NeverScrollableScrollPhysics(),
                                  children: tabBarPages,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          child: _buyBtn(),
                          bottom: 0,
                        ),
                        if ((controller.isRecordVoice ||
                                controller.isCompleteRecord) &&
                            (controller.selectedAiMusicUiModel.type == 2))
                          const Positioned(top: 0, child: RecordAudioDialog()),
                        Obx(() {
                          return (launchController.user.value?.isVip == 0 &&
                                  launchController.user.value!.activeDay! <=
                                      1 &&
                                  controller.showMarketingView.value &&
                                  !controller.isFirstJoin)
                              ? _marketingView()
                              : const SizedBox.shrink();
                        }),

                        ///历史音频位置
                        if (controller.isCompleteRecord && showHistoryList)
                          Positioned.fill(
                              left: 303.w,
                              top: 432.w,
                              child: InkResponse(
                                onTap: () {
                                  controller.isCompleteRecord = false;
                                  controller.updateGoHistoryMusicPage();
                                },
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Container(
                                      width: 64.w,
                                      height: 64.w,
                                      alignment: Alignment.center,
                                      child: Image.asset(
                                        "assets/common/history_icon.png",
                                        width: 44.w,
                                        height: 44.w,
                                      ),
                                    ),
                                    Positioned(
                                      top: 45.w,
                                      child: Container(
                                        width: 64.w,
                                        height: 24.w,
                                        decoration: BoxDecoration(
                                            color:
                                                Colors.white.withOpacity(0.2),
                                            borderRadius:
                                                BorderRadius.circular(90.w)),
                                        alignment: Alignment.center,
                                        child: Text(
                                          "历史音色",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 11.sp,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )),
                      ],
                    ),
                  ),
                ),
              );
            },
            disableBarrierInteraction: true,
            // hideFloatingActionWidgetForShowcase: [
            // ],
            globalFloatingActionWidget: (context) {
              return FloatingActionWidget(
                width: 68.w,
                height: 28.w,
                top: 52.w,
                right: 12.w,
                child: InkResponse(
                  onTap: () {
                    Get.log("===点击跳过===");
                    ConstKeys().updateIsFirst();
                    controller.initData();
                    DataService.onEvent(DataServiceEventName.obClickSkip, {});
                    ShowCaseWidget.of(context).dismiss();
                    if(!controller.isLogin){
                      Get.find<LaunchController>().login(showPayDialog: true);
                    }
                  },
                  child: Container(
                    width: 68.w,
                    height: 28.w,
                    decoration: BoxDecoration(
                      color: ByColorUtil.color121212,
                      borderRadius: BorderRadius.circular(90.w),
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "跳过",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          // Positioned(
          //     top: 52.w,
          //     right: 12.w,
          //     child: InkResponse(
          //       onTap: () {
          //         Get.log("===点击===");
          //       },
          //       child: Container(
          //         width: 68.w,
          //         height: 28.w,
          //         decoration: BoxDecoration(
          //           // color: ByColorUtil.color121212,
          //           color: Colors.red,
          //           borderRadius: BorderRadius.circular(90.w),
          //           border: Border.all(color: Colors.white.withOpacity(0.1)),
          //         ),
          //         alignment: Alignment.center,
          //         child: Text(
          //           "跳过",
          //           style: TextStyle(
          //             color: Colors.white,
          //             fontSize: 12.sp,
          //             fontWeight: FontWeight.w500,
          //           ),
          //         ),
          //       ),
          //     ))
        ],
      );
    });
  }
}
