import 'dart:ui';
import 'package:ai_golden_melody_master/common/lib/app_audio/byhy_audio_player.dart';
import 'package:ai_golden_melody_master/common/lib/app_time/byhy_time_utils.dart';
import 'package:ai_golden_melody_master/navigator/app_pages.dart';
import 'package:ai_golden_melody_master/utils/assets.dart';
import 'package:ai_golden_melody_master/utils/by_color_utils.dart';
import 'package:ai_golden_melody_master/view/common/btn_breathing_animation_widget.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../model/ai_music/ai_music_detail_model.dart';
import '../../../utils/data_service.dart';
import '../../lanuch_page/launch_controller.dart';
import 'ai_play_music_controller.dart';

///音乐播放器页面
class AiPlayMusicPage extends StatefulWidget {
  const AiPlayMusicPage({super.key});

  @override
  State<AiPlayMusicPage> createState() => _AiPlayMusicPageState();
}

class _AiPlayMusicPageState extends State<AiPlayMusicPage>
    with SingleTickerProviderStateMixin {
  AiPlayMusicController controller = Get.find<AiPlayMusicController>();
  late AnimationController _controller;
  late Animation<double> _animation;
  LaunchController launchController = Get.find<LaunchController>();

  ///构建头部区域
  Widget _buildHeaderView({
    required MusicData model,
  }) {
    ///type-2 为纯音乐
    if (model.type == 2) {
      return const SizedBox();
    }

    return Row(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 35.w, top: 10.w),
              child: Image.asset(
                Assets.aiMusicBg1,
                width: 62.w,
                height: 62.w,
              ),
            ),
            Positioned(
                top: 0.w,
                // right: 17.w,
                child: model.coverUrl != ""
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(
                          8.w,
                        ),
                        child: CachedNetworkImage(
                          imageUrl: model.coverUrl!,
                          width: 80.w,
                          height: 80.w,
                          fit: BoxFit.fill,
                        ),
                      )
                    : Image.asset(
                        _modeHeaderIcon(model: model),
                        width: 80.w,
                        height: 80.w,
                      )),
            Positioned(
              left: 4.w,
              right: 4.w,
              child: Text(
                "AI生成",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 8.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          ],
        ),
        SizedBox(
          width: 16.w,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10.w,
            ),
            SizedBox(
              width: 200.w,
              child: Text(
                softWrap: true,
                model.name ?? "",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16.sp,
                ),
                overflow: TextOverflow.clip,
              ),
            ),
            SizedBox(
              height: controller.isFirst ? 16.w : 8.w,
            ),
            if (!controller.isFirst)
              model.musicAuthor == ""
                  ? InkResponse(
                      onTap: () {
                        if(controller.type!=0){
                          return;
                        }
                        controller.editMusicAuthorName();
                      },
                      child: Row(
                        children: [
                          Text(
                            "作者:   ",
                            style:
                                TextStyle(color: Colors.white.withOpacity(0.5)),
                          ),
                          if (controller.type == 0)
                            Container(
                              margin: EdgeInsets.only(top: 0.5.w),
                              width: 16.w,
                              height: 16.w,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4.w),
                              ),
                              alignment: Alignment.center,
                              child: Image.asset(
                                Assets.editMusicName,
                                width: 12.w,
                                height: 12.w,
                              ),
                            ),
                        ],
                      ),
                    )
                  : Padding(
                      padding: EdgeInsets.only(
                        right: 0.w,
                      ),
                      child: SizedBox(
                        width: 200.w,
                        child: Text(
                          "作者:${model.musicAuthor ?? ""}",
                          style:
                              TextStyle(color: Colors.white.withOpacity(0.5)),
                          // textAlign: TextAlign.center,
                        ),
                      ),
                    )
          ],
        )
      ],
    );
  }

  ///作品模式和状态
  String _modeHeaderIcon({
    required MusicData model,
  }) {
    if (model.status == 0) {
      return Assets.musicIcon1;
    } else if (model.status == 1) {
      return Assets.aiMusicBg2;
    } else if (model.status == 2) {
      return Assets.aiMusicBg4;
    }
    return Assets.aiMusicBg1;
  }

  ///构建底部区域
  Widget _buildHintBottom({
    required AiPlayMusicController controller,
  }) {
    return _bottomArea(controller: controller);
  }

  ///
  Widget _bottomArea({
    required AiPlayMusicController controller,
  }) {
    if (controller.type == 1) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkResponse(
              onTap: () {
                controller.createSame();
              },
              child: Center(
                child: Container(
                  width: 1.sw,
                  height: 50.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: const LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [Color(0xFF24FECF), Color(0xFFFFF13C)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF24FECF).withOpacity(0.1),
                        blurRadius: 8,
                        spreadRadius: 4,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(
                    top: 24.w,
                    bottom: 16.w,
                  ),
                  child: Text(
                    "一键同款",
                    style: TextStyle(
                      color: ByColorUtil.color121212,
                      fontWeight: FontWeight.w600,
                      fontSize: 18.sp,
                    ),
                  ),
                ),
              )),
          Text(
            "一键AI生成热门同类作品，发布到以下平台",
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(
            height: 15.w,
          ),
          if (controller.sharingPlatform.isNotEmpty)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ...controller.sharingPlatform.map((e) => Padding(
                      padding: EdgeInsets.only(
                        right: 7.w,
                      ),
                      child: CachedNetworkImage(
                        imageUrl: e.icon,
                        width: 24.w,
                        height: 24.w,
                      ),
                    ))
              ],
            ),
          SizedBox(
            height: 25.w,
          ),
        ],
      );
    }

    if (controller.type == 0) {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                Assets.icon12,
                width: 12.w,
                height: 12.w,
              ),
              SizedBox(
                width: 2.w,
              ),
              Text(
                "音乐内容由AI生成，禁止利用功能从事违法活动。",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          Container(
            width: 1.sw,
            decoration: BoxDecoration(
                color: ByColorUtil.color2e2e2e,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.w),
                  topRight: Radius.circular(12.w),
                )),
            padding: EdgeInsets.only(left: 12.w, top: 20.w, bottom: 35.w),
            margin: EdgeInsets.only(
              top: 6.w,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      "发行作品",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    if (controller.sharingPlatform.isNotEmpty)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ...controller.sharingPlatform.map((e) => Padding(
                                padding: EdgeInsets.only(
                                  right: 6.w,
                                ),
                                child: CachedNetworkImage(
                                  imageUrl: e.icon,
                                  width: 16.w,
                                  height: 16.w,
                                ),
                              ))
                        ],
                      ),
                  ],
                ),
                SizedBox(
                  height: 12.w,
                ),
                Row(
                  children: [
                    Text(
                      "把作品发布至四大音乐平台，赚取版权费",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                    Image.asset(
                      Assets.icon11,
                      width: 12.w,
                      height: 12.w,
                    )
                  ],
                ),
                SizedBox(
                  height: 20.w,
                ),
                SizedBox(
                  width: 1.sw,
                  child: controller.isFirst
                      ? InkResponse(
                          onTap: () {
                            /// type-0 代表著作权申请教程 type-1代表学习发行教程
                            if (controller.isFirst) {
                              DataService.onEvent(DataServiceEventName.obListenStudyClick, {});
                              controller.showFirstUseDialog(couldAwait: true);
                              return;
                            }
                            Get.toNamed(Routes.strategyZonePage, arguments: {
                              "type": 1,
                            });
                          },
                          child: BtnBreathingAnimationWidget(
                            child: Container(
                                height: 48.w,
                                decoration: BoxDecoration(
                                  color: ByColorUtil.color00CB64,
                                  borderRadius: BorderRadius.circular(12.w),
                                ),
                                padding: EdgeInsets.only(
                                  left: 65.w,
                                  right: 65.w,
                                ),
                                margin: EdgeInsets.only(
                                  right: 12.w,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  "学习发行教程",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.sp,
                                  ),
                                )),
                          ))
                      : Row(
                          children: [
                            InkResponse(
                              onTap: () {
                                controller.createSame();
                              },
                              child: Container(
                                width: 48.w,
                                height: 48.w,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12.w),
                                ),
                                alignment: Alignment.center,
                                child: Image.asset(
                                  Assets.icon4,
                                  width: 20.w,
                                  height: 20.w,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            InkResponse(
                              onTap: () {
                                controller.shareDialog();
                              },
                              child: Container(
                                width: 48.w,
                                height: 48.w,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12.w),
                                ),
                                alignment: Alignment.center,
                                child: Image.asset(
                                  Assets.icon5,
                                  width: 20.w,
                                  height: 20.w,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            InkResponse(
                              onTap: () {
                                /// type-0 代表著作权申请教程 type-1代表学习发行教程
                                Get.toNamed(Routes.strategyZonePage,
                                    arguments: {
                                      "type": 1,
                                    });
                              },
                              child: Container(
                                  height: 48.w,
                                  decoration: BoxDecoration(
                                    color: ByColorUtil.color00CB64,
                                    borderRadius: BorderRadius.circular(12.w),
                                  ),
                                  padding: EdgeInsets.only(
                                    left: 65.w,
                                    right: 65.w,
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "学习发行教程",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.sp,
                                    ),
                                  )),
                            )
                          ],
                        ),
                )
              ],
            ),
          ),
        ],
      );
    }

    return Padding(
      padding: EdgeInsets.only(top: 7.w, left: 18.w, bottom: 12.w),
      child: Text(
        "音乐内容由AI生成，禁止利用功能从事违法活动。",
        style: TextStyle(
          color: Colors.white.withOpacity(0.5),
          fontSize: 12.sp,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  ///底部播放区域
  Widget _playArea({
    required AiPlayMusicController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: 22.w,
            bottom: 8.w,
          ),
          child: Text(
            "${ByHyTimeUtils.timeWithSeconds(controller.musicPlayDuration)}/${ByHyTimeUtils.timeWithSeconds(controller.musicTotalDuration)}",
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              // color: Colors.red,
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        Container(
            width: 1.sw,
            margin: EdgeInsets.only(
              bottom: 14.w,
              left: 18.w,
              right: 18.w,
            ),
            // color: Colors.red,
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                  thumbShape: RoundSliderThumbShape(
                    enabledThumbRadius: 4.0.w, // 滑块半径（默认 10.0）
                    disabledThumbRadius: 4.0.w,
                  ),
                  overlayShape: const RoundSliderOverlayShape(
                    overlayRadius: 6.0, // 滑块按下时的光晕半径（默认 18.0）
                  ),
                  activeTrackColor: Colors.white,
                  inactiveTrackColor: Colors.white.withOpacity(0.3),
                  thumbColor: Colors.white,
                  trackHeight: 2.w),
              child: Slider(
                  max: controller.musicTotalDuration.toDouble(),
                  value: controller.musicPlayDuration.toDouble(),
                  onChanged: (value) async {
                    Get.log("===改变的进度条value==== $value");
                    controller.changePlayMusicProgress(
                      value: (value as double).toInt(),
                    );
                  }),
            )),

        ///播放区域
        SizedBox(
          width: 1.sw,
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            ///播放器左边区域
            (controller.type == 0 && !controller.isFirst)
                ? InkResponse(
                    onTap: () {
                      if (launchController.is90Vip ||
                          launchController.is365Vip) {
                        controller.downloadUrl(type: 3);
                      } else {
                        if (launchController.is30Vip) {
                          launchController.showVipUpgradeDialog();
                        } else {
                          Get.toNamed(Routes.vipPurchasePage);
                        }
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 32.w),
                      child: Column(
                        children: [
                          Image.asset(
                            Assets.icon9,
                            width: 20.w,
                            height: 20.w,
                          ),
                          SizedBox(
                            height: 4.w,
                          ),
                          Text(
                            "获取分轨",
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.5),
                                fontWeight: FontWeight.w400,
                                fontSize: 11.sp),
                          ),
                        ],
                      ),
                    ),
                  )
                // : InkResponse(
                //     onTap: () {
                //       controller.changePlayMusicProgressByProgress();
                //     },
                //     child: Container(
                //       width: 40.w,
                //       height: 40.w,
                //       alignment: Alignment.center,
                //       color: Colors.transparent,
                //       margin: EdgeInsets.only(right: 33.w),
                //       child: Image.asset(
                //         Assets.musicBack,
                //         width: 20.w,
                //         height: 20.w,
                //       ),
                //     ),
                //   ),
                : const SizedBox(),

            InkResponse(
              onTap: () async {
                await controller.playMusic();
              },
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      90.w,
                    ),
                    border: Border.all(
                      width: 2.w,
                      color: Colors.white,
                    )),
                padding: EdgeInsets.only(
                  top: 17.w,
                  bottom: 17.w,
                  left: 33.w,
                  right: 33.w,
                ),
                alignment: Alignment.center,
                child: Image.asset(
                  controller.playerState == PlayerState.playing
                      ? Assets.pauseIcon2
                      : Assets.play,
                  width: 24.w,
                  height: 24.w,
                ),
              ),
            ),

            ///播放器右边区域
            (controller.type == 0 && !controller.isFirst)
                ? InkResponse(
                    onTap: () {
                      if (launchController.is90Vip ||
                          launchController.is365Vip) {
                        controller.downloadUrl(type: 2);
                      } else {
                        if (launchController.is30Vip) {
                          launchController.showVipUpgradeDialog();
                        } else {
                          Get.toNamed(Routes.vipPurchasePage);
                        }
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: 32.w),
                      child: Column(
                        children: [
                          Image.asset(
                            Assets.icon8,
                            width: 20.w,
                            height: 20.w,
                          ),
                          SizedBox(
                            height: 4.w,
                          ),
                          Text(
                            "获取伴奏",
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.5),
                                fontWeight: FontWeight.w400,
                                fontSize: 11.sp),
                          ),
                        ],
                      ),
                    ),
                  )
                // : InkResponse(
                //     onTap: () {
                //       controller.changePlayMusicProgressByProgress(type: 1);
                //     },
                //     child: Container(
                //       width: 40.w,
                //       height: 40.w,
                //       alignment: Alignment.center,
                //       color: Colors.transparent,
                //       margin: EdgeInsets.only(left: 33.w),
                //       child: Image.asset(
                //         Assets.musicGo,
                //         width: 20.w,
                //         height: 20.w,
                //       ),
                //     ),
                //   ),
                : const SizedBox(),
          ]),
        ),
      ],
    );
  }

  ///著作权申请教程
  Widget _courseIcon() {
    return GestureDetector(
      onTap: () {
        /// type-0 代表著作权申请教程 type-1代表学习发行教程
        Get.toNamed(Routes.strategyZonePage, arguments: {
          "type": 0,
        });
      },
      child: Image.asset(
        Assets.courseIcon,
        width: 88.w,
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    /// 创建动画控制器，设置为3秒完成一周的旋转
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    );

    /// 创建从0到2π（360度）的动画
    _animation = Tween<double>(begin: 0, end: 2 * 3.14159).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.linear, // 线性动画，保持匀速旋转
      ),
    );
  }

  @override
  void dispose() {
    ByAudioPlayer.sharedInstance.audioPlayer.pause();
    _controller.dispose();
    controller.disposeAudioPlayer();
    Get.delete<AiPlayMusicController>();
    super.dispose();
  }

  ///纯音乐模式界面
  pureMusicView({required MusicData musicData}) {
    Get.log("===音乐类似===${musicData.name}");
    if (musicData.type == 2) {
      return Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              AnimatedBuilder(
                // key: ValueKey(musicData.id),
                  animation: _animation,
                  builder: (context, child) {
                    return Transform.rotate(
                        angle: _animation.value,
                        child: Container(
                          width: 272.w,
                          height: 272.w,
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              shape: BoxShape.circle),
                          alignment: Alignment.center,
                          child: Container(
                            width: 264.w,
                            height: 264.w,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: musicData.coverUrl != ""
                                      ? NetworkImage(
                                    musicData.coverUrl!,
                                  )
                                      : const AssetImage(Assets.aiMusicBackground),
                                  fit: BoxFit.cover,
                                )),
                            // child: musicData.coverUrl != ""
                            //     ? CachedNetworkImage(
                            //         imageUrl: musicData.coverUrl!,
                            //         width: 272.w,
                            //         height: 272.w,
                            //         fit: BoxFit.fill,
                            //       )
                            //     : Image.asset(
                            //         Assets.aiMusicBackground,
                            //         width: 272.w,
                            //         height: 272.w,
                            //       ),
                          ),
                        ));
                  }),
              // Align(
              //   child: Container(
              //     width: 64.w,
              //     height: 64.w,
              //     decoration: BoxDecoration(
              //       color: ByColorUtil.color121212.withOpacity(0.9),
              //       border: Border.all(
              //         color: Colors.white.withOpacity(0.1,),
              //         width: 4.w
              //       ),
              //       shape: BoxShape.circle
              //     ),
              //   ),
              // )
            ],
          ),
          SizedBox(
            height: 22.w,
          ),
          InkResponse(
            onTap: () {
              Get.log("==点击了==");
            },
            child: Text(
              musicData.name ?? "",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20.sp,
              ),
            ),
          ),
          SizedBox(
            height: 6.w,
          ),
          if (controller.musicData != null &&
              controller.musicData!.type == 2 &&
              !controller.isFirst)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                controller.musicData!.musicAuthor == ""
                    ? GestureDetector(
                        onTap: () {
                          if(controller.type!=0){
                            return;
                          }
                          Get.log("===点击编辑=== ");
                          controller.editMusicAuthorName();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "作者:  ",
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.5),
                                fontWeight: FontWeight.w400,
                                fontSize: 14.sp,
                              ),
                            ),
                            if (controller.type == 0)
                              Container(
                                margin: EdgeInsets.only(top: 0.5.w),
                                width: 16.w,
                                height: 16.w,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(4.w),
                                ),
                                alignment: Alignment.center,
                                child: Image.asset(
                                  Assets.editMusicName,
                                  width: 12.w,
                                  height: 12.w,
                                ),
                              ),
                          ],
                        ),
                      )
                    : SizedBox(
                        // width: 200.w,
                        width: 200.w,
                        child: Text(
                          "作者:${controller.musicData!.musicAuthor}",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                            fontWeight: FontWeight.w400,
                            fontSize: 14.sp,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )
              ],
            ),
        ],
      );
    }

    return const SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;
        // controller.goBack();
      },
      child: Container(
        decoration: const BoxDecoration(color: ByColorUtil.color121212),
        child: GetBuilder<AiPlayMusicController>(
          builder: (controller) {
            if (controller.playerState == PlayerState.playing) {
              _controller.repeat();
            } else {
              _controller.stop();
            }
            Widget topAreaWidget = Image.asset(
              Assets.aiMusicBackground,
              width: 1.sw,
              height: 375.w,
              // fit: BoxFit.fill,
            );
            if (controller.musicData != null) {
              if (controller.musicData!.coverUrl != "") {
                topAreaWidget = CachedNetworkImage(
                  imageUrl: controller.musicData!.coverUrl!,
                  width: 1.sw,
                  height: 375.w,
                  fit: BoxFit.fill,
                );
              }
            }
            return Stack(
              clipBehavior: Clip.none,
              children: [
                SizedBox(
                  width: 1.sw,
                  height: 1.sh,
                ),
                Positioned(
                  top: 0,
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          Stack(
                            children: [
                              Opacity(
                                opacity: 0.4,
                                child: SizedBox(
                                  width: 1.sw,
                                  height: 375.w,
                                  child: Stack(
                                    // fit: StackFit.expand,
                                    children: [
                                      topAreaWidget,
                                      BackdropFilter(
                                        filter: ImageFilter.blur(
                                            sigmaX: 10, sigmaY: 10),
                                        blendMode: BlendMode.srcIn,
                                        child: Container(
                                          width: 1.sw,
                                          height: 375.w,
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                                const Color(0x00121212).withOpacity(
                                                    0.4), // 180deg, rgba(18,18,18,0)
                                                const Color(
                                                    0xFF121212), // #121212
                                              ],
                                            ),
                                            // borderRadius: BorderRadius.circular(0), // 等同于CSS中的border-radius: 0px 0px 0px 0px;
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                  top: 56.w,
                                  left: 23.w,
                                  right: 23.w,
                                  child: SizedBox(
                                    width: 1.sw,
                                    child: Row(
                                      children: [
                                        InkResponse(
                                          onTap: () {
                                            if (controller.isFirst) {
                                              DataService.onEvent(DataServiceEventName.obListenBackClick, {});
                                              controller.showFirstUseDialog(
                                                couldAwait: false,
                                              );
                                            } else {
                                              Get.back();
                                            }
                                          },
                                          child: SizedBox(
                                            width: 20.w,
                                            height: 20.w,
                                            child: Image.asset(
                                              Assets.goBack,
                                              width: 20.w,
                                              height: 20.w,
                                              fit: BoxFit.fitHeight,
                                              // color: Colors.red,
                                            ),
                                          ),
                                        ),
                                        const Spacer(),
                                        if (controller.type == 0 &&
                                            !controller.isFirst)
                                          GestureDetector(
                                            onTap: () {
                                              controller.showDownDialog();
                                            },
                                            child: Image.asset(
                                              Assets.downLoadIcon,
                                              width: 28.w,
                                              height: 28.w,
                                            ),
                                          )
                                      ],
                                    ),
                                  )),
                              if (controller.musicData != null)
                                Positioned(
                                  top: 106.w,
                                  left: 20.w,
                                  child: _buildHeaderView(
                                    model: controller.musicData!,
                                  ),
                                ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),

                ///只有纯音乐模式会显示的ui效果
                if (controller.musicData != null)
                  Positioned(
                    left: 52.w,
                    top: 105.w,
                    child: pureMusicView(
                      musicData: controller.musicData!,
                    ),
                  ),

                ///播放区域
                Positioned.fill(
                  top: controller.type == 1 ? (1.sh - 300.h) : (1.sh - 325.h),
                  child: _playArea(controller: controller),
                ),

                ///底部提示区域
                Positioned(
                  left: controller.type == 1 ? 27.w : 0,
                  bottom: controller.type == 1 ? 20.w : 0,
                  right: controller.type == 1 ? 27.w : 0,
                  child: _buildHintBottom(
                    controller: controller,
                  ),
                ),

                ///歌词部分 这里与纯音乐ui有冲突 已经解决
                if(controller.musicData!=null&&controller.musicData!.type!=2)
                Positioned.fill(
                    top: 210.w,
                    left: 23.w,
                    bottom: controller.type == 1 ? 310.w : 330.w,
                    child: SizedBox(
                      height: 0.5.sh,
                      child: ListView(
                        padding: EdgeInsets.zero,
                        children: [
                          if (controller.musicData != null)
                            Text(
                              controller.removeTags(
                                  controller.musicData!.lyrics ?? ""),
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.5),
                                fontWeight: FontWeight.w500,
                                fontSize: 18.sp,
                              ),
                            )
                        ],
                      ),
                    )),

                // if (controller.musicData != null &&
                //     controller.musicData!.type == 2)
                // Positioned.fill(
                //   bottom: -55.w,
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //       controller.musicData!.musicAuthor == ""
                //           ? InkResponse(
                //               onTap: () {
                //                 controller.editMusicAuthorName();
                //               },
                //               child: Row(
                //                 mainAxisAlignment: MainAxisAlignment.start,
                //                 children: [
                //                   Text(
                //                     "作者:  ",
                //                     style: TextStyle(
                //                       color: Colors.white.withOpacity(0.5),
                //                       fontWeight: FontWeight.w400,
                //                       fontSize: 14.sp,
                //                     ),
                //                   ),
                //                   if(controller.type==0)
                //                   Container(
                //                     margin: EdgeInsets.only(top: 0.5.w),
                //                     width: 16.w,
                //                     height: 16.w,
                //                     decoration: BoxDecoration(
                //                       color: Colors.white.withOpacity(0.1),
                //                       borderRadius: BorderRadius.circular(4.w),
                //                     ),
                //                     alignment: Alignment.center,
                //                     child: Image.asset(
                //                       Assets.editMusicName,
                //                       width: 12.w,
                //                       height: 12.w,
                //                     ),
                //                   ),
                //                 ],
                //               ),
                //             )
                //           : SizedBox(
                //               // width: 200.w,
                //               width: 200.w,
                //               child: Text(
                //                 "作者:${controller.musicData!.musicAuthor}",
                //                 style: TextStyle(
                //                   color: Colors.white.withOpacity(0.5),
                //                   fontWeight: FontWeight.w400,
                //                   fontSize: 14.sp,
                //                 ),
                //                 textAlign: TextAlign.center,
                //               ),
                //             )
                //     ],
                //   ),
                // ),

                ///著作权申请教程
                Positioned(
                  right: 0,
                  bottom: 362.w,
                  // child: _courseIcon(),
                  child: BtnBreathingAnimationWidget(
                    child: _courseIcon(),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
