import 'dart:async';
import 'package:ai_golden_melody_master/utils/by_color_utils.dart';
import 'package:ai_golden_melody_master/view/ai/ai_write_music/play_music_button.dart';
import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:flexible_wrap/flexible_wrap.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ai_golden_melody_master/common/lib/app_ui/by_widgets_util.dart';
import 'package:ai_golden_melody_master/common/lib/app_http/apis.dart';
import 'package:ai_golden_melody_master/common/lib/result.dart';
import 'package:lottie/lottie.dart';
import 'package:ai_golden_melody_master/common/lib/app_common/event/common_event.dart';
import '../../../../model/ai_music/ai_music_config_list_model.dart';
import '../../../../model/ai_music/ai_music_config_model.dart';
import '../../../../model/ai_music/master_music_analysis_model.dart';
import '../../../../model/ai_music/voice_timbre_response.dart';
import '../../../../utils/assets.dart';
import '../../../../utils/common_event.dart';
import '../../../../utils/stream_data_mixin.dart';
import '../ai_write_music_controller.dart';

///专属模式的页面
class ExclusiveModePage extends StatefulWidget {
  const ExclusiveModePage({super.key});

  @override
  State<ExclusiveModePage> createState() => _ExclusiveModePageState();
}

class _ExclusiveModePageState extends State<ExclusiveModePage>
    with StreamDataMixin, AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController = ScrollController();

  late AiWriteMusicController controller;

  ///焦点
  FocusNode focusNode = FocusNode();

  ///焦点
  FocusNode focusNode2 = FocusNode();

  ///焦点
  FocusNode _lastFocusNode = FocusNode();

  /// 消息流订阅
  StreamSubscription<String>? messageSubscription;

  ///是否正在请求deepSeek一键生成
  bool isGetRandom = false;

  ///当前灵感描述的文字长度
  int hintTextLength = 0;

  late StreamSubscription streamSubscription;

  List<Widget> itemsList = [];

  ///新增：标记是否正在滚动
  bool _isScrolling = false;

  ///进度提示部分
  Widget _progressHintArea() {
    int exclusiveModeStep = controller.exclusiveModeStep;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              Assets.exclusiveModeIcon,
              width: 12.w,
              height: 12.w,
            ),
            Text(
              "训练音色",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w400,
                fontSize: 14.sp,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 6.w,
                right: 6.w,
              ),
              child: Image.asset(
                Assets.nextIcon,
                width: 12.w,
                height: 12.w,
                color: (exclusiveModeStep >= 3 && exclusiveModeStep != 8)
                    ? Colors.white
                    : Colors.white.withOpacity(0.5),
              ),
            ),
            Image.asset(
              Assets.exclusiveModeIcon,
              width: 12.w,
              height: 12.w,
              color: (exclusiveModeStep >= 4 && exclusiveModeStep != 8)
                  ? Colors.white
                  : Colors.white.withOpacity(0.5),
            ),
            Text(
              "高级设置",
              style: TextStyle(
                color: (exclusiveModeStep >= 4 && exclusiveModeStep != 8)
                    ? Colors.white
                    : Colors.white.withOpacity(0.5),
                fontWeight: FontWeight.w400,
                fontSize: 14.sp,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 6.w, right: 6.w),
              child: Image.asset(
                Assets.nextIcon,
                width: 12.w,
                height: 12.w,
                color: (exclusiveModeStep >= 5 && exclusiveModeStep != 8)
                    ? Colors.white
                    : Colors.white.withOpacity(0.5),
              ),
            ),
            Image.asset(
              Assets.exclusiveModeIcon,
              color: (exclusiveModeStep >= 4 && exclusiveModeStep != 8)
                  ? Colors.white
                  : Colors.white.withOpacity(0.5),
              width: 12.w,
              height: 12.w,
            ),
            Text(
              "词曲精调",
              style: TextStyle(
                color: (exclusiveModeStep >= 6 && exclusiveModeStep != 8)
                    ? Colors.white
                    : Colors.white.withOpacity(0.5),
                fontWeight: FontWeight.w400,
                fontSize: 14.sp,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 6.w, right: 6.w),
              child: Image.asset(
                Assets.nextIcon,
                width: 12.w,
                height: 12.w,
                color: (exclusiveModeStep >= 6 && exclusiveModeStep != 8)
                    ? Colors.white
                    : Colors.white.withOpacity(0.5),
              ),
            ),
            Image.asset(
              Assets.exclusiveModeIcon,
              width: 12.w,
              height: 12.w,
              color: (exclusiveModeStep >= 7 && exclusiveModeStep != 8)
                  ? Colors.white
                  : Colors.white.withOpacity(0.5),
            ),
            Text(
              "生成歌曲",
              style: TextStyle(
                color: (exclusiveModeStep >= 7 && exclusiveModeStep != 8)
                    ? Colors.white
                    : Colors.white.withOpacity(0.5),
                fontWeight: FontWeight.w400,
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
      ],
    );
  }

  ///生成区域
  Widget _buildBody() {
    Get.log("==专属模式当前的步骤=== ${controller.exclusiveModeStep}"
        " ${controller.goHistoryMusicPage} "
        "${controller.voiceTimbreList.length}  ");
    AIMusicConfigListModel? aiMusicConfigListModel =
        controller.aiMusicConfigListModel;
    List<AiMusicConfigListItem> data = [];
    itemsList.clear();
    if (aiMusicConfigListModel != null) {
      if (aiMusicConfigListModel.data.isNotEmpty) {
        data = aiMusicConfigListModel.data;
        for (var e in aiMusicConfigListModel.data) {
          itemsList.add(_buildItem(item: e));
        }
      }
    }

    if (controller.goHistoryMusicPage &&
        !controller.isCompleteRecord &&
        !controller.isRecordVoice) {
      return _selectHistoryMusicView();
    }

    if (controller.exclusiveModeStep == 8) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 80.w,
          ),
          Image.asset(
            Assets.exclusiveModeIcon10,
            width: 120.w,
            height: 120.w,
          ),
          SizedBox(
            height: 12.w,
          ),
          Text(
            "训练失败音符值已返",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(
            height: 16.w,
          ),
          Column(
            children: [
              InkResponse(
                onTap: () {
                  controller.againPractice();
                },
                child: Container(
                  width: 184.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.w),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "重新训练",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (controller.voiceTimbreList.isNotEmpty)
            Column(
              children: [
                SizedBox(
                  height: 16.w,
                ),
                InkResponse(
                  onTap: () {
                    controller.updateGoHistoryMusicPage();
                  },
                  child: Container(
                    width: 184.w,
                    height: 40.h,
                    decoration: BoxDecoration(
                      color: ByColorUtil.colorFEC57F.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(8.w),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "选择历史音频创作",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                )
              ],
            ),
        ],
      );
    }
    if (controller.exclusiveModeStep == 0) {
      return Column(
        children: [
          SizedBox(
            height: 9.w,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "清唱30s",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                ),
              ),
              Text(
                " 即可训练您的专属音色",
                style: TextStyle(
                  color: ByColorUtil.colorCCA869,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                ),
              ),
            ],
          ),

          ///todo 需要做成卡片数据
          SizedBox(
            height: 9.w,
          ),
          if (itemsList.isNotEmpty)
            CarouselSlider(
                items: itemsList,
                options: CarouselOptions(
                  height: 450.h,
                  aspectRatio: 1.0,
                  enlargeCenterPage: false,
                  enlargeStrategy: CenterPageEnlargeStrategy.zoom,
                  enlargeFactor: 0.3,
                  initialPage: controller.initialPage,
                  viewportFraction: 0.7,
                  enableInfiniteScroll: true,
                  reverse: false,
                  autoPlay: false,
                  autoPlayInterval: const Duration(seconds: 3),
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  onPageChanged: (index, reason) {},
                  scrollDirection: Axis.horizontal,
                  scrollPhysics: const NeverScrollableScrollPhysics(),
                )),
        ],
      );
    }
    if (controller.exclusiveModeStep == 4 ||
        controller.exclusiveModeStep == 5 ||
        controller.exclusiveModeStep == 6) {
      return Column(
        children: [
          _inputArea(),
          if (controller.exclusiveModeStep == 4)
            Container(
              width: 1.sw,
              decoration: BoxDecoration(
                color: ByColorUtil.color1E1E1E,
                borderRadius: BorderRadius.circular(10.w),
              ),
              margin: EdgeInsets.only(top: 15.w, left: 12.w, right: 12.w),
              padding: EdgeInsets.only(
                top: 21.w,
                left: 12.w,
                right: 12.w,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "专属声音",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                    ),
                  ),
                  InkResponse(
                    onTap: () {
                      controller.openHistoryAudioDialog();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            8.w,
                          ),
                          border: Border.all(
                            color: Colors.white.withOpacity(
                              0.1,
                            ),
                          )),
                      padding: EdgeInsets.all(10.w),
                      margin: EdgeInsets.only(
                        top: 16.w,
                        bottom: 12.w,
                      ),
                      child: Row(
                        children: [
                          Image.asset(
                            Assets.exclusiveModeIcon5,
                            width: 36.w,
                            height: 36.w,
                          ),
                          SizedBox(
                            width: 4.w,
                          ),
                          SizedBox(
                            width: 210.w,
                            child: Text(
                              controller.selectedVoiceTimbreItem!.name ?? "",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.grey.withOpacity(0.3),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          _highLevelSetting(),
          // if (focusNode3.hasFocus)
          //   SizedBox(
          //     height: 200.w,
          //   ),
        ],
      );
    }

    if (controller.exclusiveModeStep == 2) {
      return Column(
        children: [
          SizedBox(
            height: 80.w,
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              Opacity(
                opacity: 0.3,
                child: Image.asset(
                  Assets.aiMusicBg1,
                  width: 120.w,
                  height: 120.w,
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Lottie.asset(
                  width: 80.w,
                  height: 80.w,
                  "assets/custom_animation/data.json",
                  animate: true,
                ),
              )
            ],
          ),
          SizedBox(
            height: 11.w,
          ),
          Text(
            "训练中...",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(
            height: 16.w,
          ),
          if (controller.voiceTimbreList.isEmpty)
            Column(
              children: [
                Text(
                  "检测到您首次训练声音，训练预计40分钟后完成",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                ///检测到您首次训练声音，训练预计40分钟后完成
                ByWidgetsUtil.commonRichText(
                  texts: [
                    TextSpan(
                        text: "您可以先去使用",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 14.sp)),
                    TextSpan(
                        text: "灵感写歌",
                        style: TextStyle(
                            color: ByColorUtil.colorCCA869,
                            fontWeight: FontWeight.w500,
                            fontSize: 14.sp)),
                    TextSpan(
                        text: "或",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 14.sp)),
                    TextSpan(
                        text: "大师模式",
                        style: TextStyle(
                            color: ByColorUtil.colorCCA869,
                            fontWeight: FontWeight.w500,
                            fontSize: 14.sp))
                  ],
                  fontSize: 12.sp,
                  textColor:
                      ByColorUtil.LoginTextfieldTextColor.withOpacity(0.6),
                ),
              ],
            ),
          if (controller.voiceTimbreList.isNotEmpty)
            Column(
              children: [
                Text(
                  "声音训练中，训练预计40分钟后完成 \n您可以选择之前已经训练好的其他音色先进行创作哦",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 24.w,
                ),
                selectHistoryVoiceBtn(),
              ],
            ),
        ],
      );
    }

    if (controller.exclusiveModeStep == 3 &&
        !controller.goHistoryMusicPage &&
        (!controller.isCompleteRecord)) {
      return _selectHistoryMusicView();
    }

    return Column(
      children: [
        SizedBox(
          height: 24.w,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "清唱30s",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16.sp,
              ),
            ),
            Text(
              " 即可训练您的专属音色",
              style: TextStyle(
                color: ByColorUtil.colorCCA869,
                fontWeight: FontWeight.bold,
                fontSize: 16.sp,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 16.w,
        ),
        if (itemsList.isNotEmpty)
          CarouselSlider(
              items: itemsList,
              options: CarouselOptions(
                height: 400.h,
                // aspectRatio: 1.0,
                enlargeCenterPage: false,
                enlargeStrategy: CenterPageEnlargeStrategy.zoom,
                enlargeFactor: 0.3,
                initialPage: controller.initialPage,
                viewportFraction: 0.65,
                enableInfiniteScroll: true,
                reverse: false,
                autoPlay: false,
                autoPlayInterval: const Duration(seconds: 3),
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                onPageChanged: (index, reason) {
                  Get.log("移动===$index  ${reason.index}");
                  controller.updateSelectedAiMusicConfigListItem(
                      item: data[index]);
                },
                scrollDirection: Axis.horizontal,
              )),
      ],
    );
  }

  Widget _buildItem({
    required AiMusicConfigListItem item,
  }) {
    return Container(
      // width: 247.w,
      // height: 352.w,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            Assets.exclusiveModeIcon9,
          ),
          fit: BoxFit.fill,
        ),
      ),
      padding: EdgeInsets.only(
        bottom: 76.w,
        top: 0.w,
      ),
      alignment: Alignment.center,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: 57.w,
              right: 57.w,
              top: 26.w,
            ),
            child: Text(
              item.content,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          )
        ],
      ),
    );
  }

  ///选择历史音频
  Widget _selectHistoryMusicView() {
    ///
    List<VoiceTimbreItem> voiceTimbreList = [];
    for (var e in controller.voiceTimbreList) {
      voiceTimbreList.add(e);
    }
    Get.log("====历史音频长度=== ${voiceTimbreList.length}");
    VoiceTimbreItem? selectedVoiceTimbreItem =
        controller.selectedVoiceTimbreItem;
    Get.log(
        "====selectedVoiceTimbreItem=== ${selectedVoiceTimbreItem?.status}");
    if (selectedVoiceTimbreItem == null) {
      return const SizedBox();
    }
    int? status = selectedVoiceTimbreItem.status;
    DecorationImage? decorationImage;
    Gradient? gradient;
    BorderRadiusGeometry? borderRadius;
    late final Widget hearWidget;
    late final playerWidget;
    if (status == 0) {
      decorationImage = const DecorationImage(
          image: AssetImage(
            Assets.maskerBg1,
          ),
          fit: BoxFit.fill,
          opacity: 0.3);
      gradient = null;
      borderRadius = const BorderRadius.only(
        topLeft: Radius.circular(12),
        topRight: Radius.circular(12),
      );
      hearWidget = Opacity(
        opacity: 0.7,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              Assets.maskerBg2,
              width: 68.w,
              height: 68.w,
            ),
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: 50.w,
                height: 50.w,
                child: Lottie.asset(
                  Assets.data1Json,
                  animate: true,
                ),
              ),
            )
          ],
        ),
      );
      playerWidget = Opacity(
        opacity: 1,
        child: Container(
          width: 1.sw,
          height: 78.w,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: ByColorUtil.color1E1E1E,
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(12.w),
                bottomLeft: Radius.circular(12.w),
              )),
          margin: EdgeInsets.only(left: 12.w, right: 12.w),
          child: Container(
            width: 1.sw,
            height: 52.w,
            margin: EdgeInsets.only(left: 12.w, right: 12.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.w),
              gradient: const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0xFF5C5C5C), Color(0xFF515151)],
              ),
            ),
            padding: EdgeInsets.only(left: 16.w),
            alignment: Alignment.center,
            child: Row(
              children: [
                Container(
                  width: 32.w,
                  height: 32.w,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32.w),
                      color: ByColorUtil.color000000.withOpacity(0.2)),
                  alignment: Alignment.center,
                  child: Image.asset(
                    Assets.play,
                    width: 16.w,
                    height: 16.w,
                  ),
                ),
                SizedBox(
                  width: 4.w,
                ),
                Text(
                  "音频训练中...",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                Image.asset(
                  Assets.musicIcon3,
                  width: 60.w,
                  height: 52.w,
                  // color: Colors.red,
                ),
              ],
            ),
          ),
        ),
      );
    } else if (status == 1) {
      decorationImage = const DecorationImage(
          image: AssetImage(
            Assets.maskerBg1,
          ),
          fit: BoxFit.fill,
          opacity: 0.7);
      hearWidget = Image.asset(
        Assets.maskerBg2,
        width: 68.w,
        height: 68.w,
      );
      playerWidget = Opacity(
        opacity: 0.7,
        child: Container(
          width: 1.sw,
          height: 78.w,
          decoration: BoxDecoration(
              color: ByColorUtil.color1E1E1E,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12.w),
                  bottomRight: Radius.circular(12.w))),
          margin: EdgeInsets.only(
            left: 12.w,
            right: 12.w,
          ),
          padding: EdgeInsets.only(
            left: 12.w,
            right: 12.w,
            top: 15.w,
          ),
          child: Column(
            children: [
              PlayMusicButton(
                selectedAiMusicConfigListItem:
                    controller.selectedAiMusicConfigListItem!,
                musicPath: selectedVoiceTimbreItem.voiceTimbreUrl ?? "",
                marginTop: 0,
                marginBottom: 0,
                isPlaySource: false,
              ),
            ],
          ),
        ),
      );
    } else if (status == 2) {
      gradient = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFF545454),
          const Color(0xB8545454).withOpacity(0.72), // 72% opacity
          const Color(0xE0545454).withOpacity(0.88), // 88% opacity
          const Color(0xFF1E1E1E),
        ],
        stops: const [0.0, 0.5, 0.75, 1.0],
      );
      borderRadius = const BorderRadius.only(
        topLeft: Radius.circular(12),
        topRight: Radius.circular(12),
      );
      hearWidget = Container(
        width: 68.w,
        height: 68.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(68.w),
          border: Border.all(
            color: Colors.white.withOpacity(0.1),
          ),
          color: Colors.white.withOpacity(0.05),
        ),
        alignment: Alignment.center,
        child: Image.asset(
          Assets.icon19,
          width: 40.w,
          height: 40.w,
        ),
      );
      playerWidget = Container(
        width: 1.sw,
        height: 78.w,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: ByColorUtil.color1E1E1E,
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(12.w),
              bottomLeft: Radius.circular(12.w),
            )),
        margin: EdgeInsets.only(left: 12.w, right: 12.w),
        child: Container(
          width: 1.sw,
          height: 52.w,
          margin: EdgeInsets.only(left: 12.w, right: 12.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.w),
            gradient: const LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Color(0xFF5C5C5C), Color(0xFF515151)],
            ),
          ),
          padding: EdgeInsets.only(left: 16.w),
          alignment: Alignment.center,
          child: Row(
            children: [
              Image.asset(
                "assets/common/audio_error_icon.png",
                width: 16.w,
                height: 16.w,
              ),
              SizedBox(
                width: 4.w,
              ),
              Text(
                "生成音频失败",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Image.asset(
                Assets.musicIcon3,
                width: 60.w,
                height: 52.w,
                // color: Colors.red,
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        Container(
          width: 1.sw,
          height: 162,
          decoration: BoxDecoration(
            image: decorationImage,
            gradient: gradient,
            borderRadius: borderRadius,
          ),
          margin: EdgeInsets.only(
            top: 15.w,
            left: 12.w,
            right: 12.w,
          ),
          padding: EdgeInsets.only(
            top: 10.w,
            left: 12.w,
            right: 12.w,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  ByWidgetsUtil.commonRichText(
                    texts: [
                      TextSpan(
                          text: "声音试听",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp))
                    ],
                    fontSize: 12.sp,
                    textColor:
                        ByColorUtil.LoginTextfieldTextColor.withOpacity(0.6),
                  ),
                  const Spacer(),
                  InkResponse(
                    onTap: () {
                      if (selectedVoiceTimbreItem.status != 0) {
                        controller.editExclusiveAudioName();
                      }
                    },
                    child: Container(
                      width: 35.w,
                      height: 35.w,
                      color: Colors.transparent,
                      alignment: Alignment.centerRight,
                      child: selectedVoiceTimbreItem.status != 0
                          ? Image.asset(
                              Assets.editIcon,
                              width: 14.w,
                              height: 14.w,
                              color: Colors.white,
                            )
                          : null,
                    ),
                  ),
                  InkResponse(
                    onTap: () {
                      if (selectedVoiceTimbreItem.status != 0) {
                        controller.deleteExclusiveAudio();
                      }
                    },
                    child: Container(
                      width: 35.w,
                      height: 35.w,
                      color: Colors.transparent,
                      alignment: Alignment.centerRight,
                      child: selectedVoiceTimbreItem.status != 0
                          ? Image.asset(
                              Assets.deleteIcon,
                              width: 14.w,
                              height: 14.w,
                              color: Colors.white,
                            )
                          : null,
                    ),
                  )
                ],
              ),
              hearWidget,
              SizedBox(
                height: 6.w,
              ),
              Text(
                "${selectedVoiceTimbreItem.name}",
                style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
            ],
          ),
        ),
        playerWidget,

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
            color: ByColorUtil.color1E1E1E,
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

  late StreamSubscription<CloseKeyboardEvent> keyboardStreamSubscription;

  ///最后一个输入框的全局键（用于获取位置信息）
  final GlobalKey _lastTextFieldKey = GlobalKey();

  ///新增：记录键盘弹出前的滚动位置，用于焦点失去时恢复
  double _preKeyboardScrollOffset = 0;

  ///新增：记录最后一个输入框获得焦点时的滚动位置
  double _lastFocusScrollOffset = 0;

  @override
  void initState() {
    controller = Get.find<AiWriteMusicController>();
    initData();
    super.initState();
  }

  // 优化焦点变化监听，处理获得和失去焦点的滚动逻辑
  void _onLastFocusChange() {
    if (_lastFocusNode.hasFocus) {
      // 获得焦点时：记录当前滚动位置，用于后续恢复
      _preKeyboardScrollOffset = _scrollController.offset;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToLastTextField();
      });
    } else {
      // 失去焦点时：键盘收起，触发向下滚动平衡布局
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollDownAfterFocusLost();
      });
    }
  }

  // 新增：最后一个输入框失去焦点时向下滚动
  void _scrollDownAfterFocusLost() {
    // 避免滚动冲突
    if (_isScrolling) return;

    // 计算目标滚动位置：恢复到键盘弹出前的位置
    // 如果没有记录初始位置，则滚动到内容自然底部
    double targetOffset = _preKeyboardScrollOffset;

    // 确保目标位置在合理范围内
    if (targetOffset < 0) targetOffset = 0;
    if (targetOffset > _scrollController.position.maxScrollExtent) {
      targetOffset = _scrollController.position.maxScrollExtent;
    }

    // 只有当需要滚动的距离超过10像素时才执行动画，避免微小抖动
    if ((_scrollController.offset - targetOffset).abs() > 10) {
      _isScrolling = true;
      _scrollController
          .animateTo(
        targetOffset,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut, // 向下滚动使用easeOut曲线更自然
      )
          .then((_) {
        _isScrolling = false;
      });
    }
  }

  // 上滑到最后一个输入框（保持原功能）
  void _scrollToLastTextField() {
    Get.log("===自动上滑===");
    final RenderBox? renderBox =
        _lastTextFieldKey.currentContext?.findRenderObject() as RenderBox?;

    if (renderBox == null) return;

    final position = renderBox.localToGlobal(Offset.zero);
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final screenHeight = MediaQuery.of(context).size.height;

    // 计算目标位置，确保输入框在键盘上方留有足够空间
    final targetOffset = position.dy - (screenHeight - keyboardHeight - 120);
    final safeOffset = targetOffset > 0 ? targetOffset : 0;

    // 记录获得焦点时的滚动位置
    _lastFocusScrollOffset = _scrollController.offset + safeOffset;

    _isScrolling = true;

    Get.log("===自动上滑距离===  ${_lastFocusScrollOffset}");
    _scrollController
        .animateTo(
      _lastFocusScrollOffset+180.w,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn, // 向上滚动使用easeIn曲线
    )
        .then((_) {
      _isScrolling = false;
    });
  }



  /// 取消所有输入框的焦点
  void _unFocusAll() {
    if (focusNode.hasFocus) {
      focusNode.unfocus();
    }
    if (focusNode2.hasFocus) {
      focusNode2.unfocus();
    }
    // if (_lastFocusNode.hasFocus) {
    //   _lastFocusNode.unfocus();
    // }
  }

  initData() {
    controller.hintTextEditingController3.addListener(() {
      if (controller.hintTextEditingController3.text.isEmpty) {
        hintTextLength = 0;
      } else {
        if (controller.hintTextEditingController3.text.length > 300) {
          controller.hintTextEditingController3.text =
              controller.hintTextEditingController3.text.substring(0, 300);
        }

        hintTextLength = controller.hintTextEditingController3.text.length;
      }
      controller.updateExclusiveAiMusicHintText(
        data: controller.hintTextEditingController3.text,
      );
      if (mounted) {
        setState(() {});
      }
    });
    _lastFocusNode.addListener(_onLastFocusChange);

    _scrollController.addListener(() {
      Get.log("移动的距离===>${_scrollController.position}");
      _unFocusAll();
    });
    keyboardStreamSubscription = eventBus.on<CloseKeyboardEvent>().listen((e) {
      if (focusNode.hasFocus) {
        focusNode.unfocus();
      }

      if (focusNode2.hasFocus) {
        focusNode2.unfocus();
      }

      if (_lastFocusNode.hasFocus) {
        _lastFocusNode.unfocus();
      }
    });
  }

  ///打开音频录制弹窗按钮
  Widget _newVoiceItemView() {
    return InkResponse(
      onTap: () {
        ///重新开始训练音频
        Get.log("===重新开始训练音频===");
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

    if (item.status == 0) {
      return InkResponse(
        onTap: () {
          controller.updateVoiceTimbreItem(item: item);
          EasyLoading.showToast("当前音色正在训练中~");
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                  border: Border.all(
                    width: 2.w,
                    color:
                        selected ? ByColorUtil.colorCCA869 : Colors.transparent,
                  ),
                  borderRadius: BorderRadius.circular(
                    8.w,
                  )),
              alignment: Alignment.center,
              padding: EdgeInsets.all(2.w),
              margin: EdgeInsets.only(
                right: 8.w,
              ),
              child: Container(
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
            ),
            const Spacer(),
            Text(
              "训练中...",
              style: TextStyle(
                color: ByColorUtil.colorCCA869,
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    if (item.status == 2) {
      return InkResponse(
        onTap: () {
          controller.updateVoiceTimbreItem(item: item);
          EasyLoading.showToast("声音训练失败，请选择其他音频创作");
          // EasyLoading.show(indicator:ErrorDialog() );
          // Get.dialog();

          // Get.dialog(ErrorDialog(),transitionDuration: Duration(seconds: 1));
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
              child: item.status == 1
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
                          border:
                              Border.all(color: Colors.white.withOpacity(0.1))),
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
                "${item.name}",
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

  ///
  Widget selectHistoryVoiceBtn() {
    return InkResponse(
      onTap: () {
        controller.updateGoHistoryMusicPage();
      },
      child: Container(
        decoration: BoxDecoration(
          color: ByColorUtil.colorFEC57F.withOpacity(0.8),
          borderRadius: BorderRadius.circular(12.w),
        ),
        alignment: Alignment.center,
        padding: EdgeInsets.only(
          top: 17.w,
          bottom: 17.w,
        ),
        margin: EdgeInsets.only(
          left: 38.w,
          right: 38.w,
        ),
        child: Text(
          "选择之前训练好的声音开始创作",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
          ),
        ),
      ),
    );
  }

  ///输入歌名 文字区域
  Widget _inputArea() {
    if (controller.exclusiveModeStep == 5) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 122.w,
          ),
          Container(
            width: 80.w,
            height: 80.w,
            alignment: Alignment.center,
            child: Lottie.asset(
              Assets.data1Json,
              animate: true,
            ),
          ),
          Center(
            child: Text(
              "歌词生成中...",
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          )
        ],
      );
    }

    if (controller.exclusiveModeStep == 6) {
      MasterMusicAnalysisResponse? masterMusicAnalysisResponse =
          controller.masterMusicAnalysisResponse2;
      List<MusicSection> parse = [];
      MusicAnalysisData? data;
      if (masterMusicAnalysisResponse != null) {
        data = masterMusicAnalysisResponse.data;
      }

      if (data != null) {
        parse = data.parse ?? [];
      }

      if (controller.exclusiveNewMusicSection.isNotEmpty) {
        parse = controller.exclusiveNewMusicSection;
      }

      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 15.w,
          ),
          if (parse.isNotEmpty)
            ...parse.map((e) {
              int index = parse.indexOf(e);
              bool isFirst = false;
              if (index == 0) {
                isFirst = true;
              }
              return _musicSectionItemView(musicSection: e, first: isFirst);
            }),
          if (parse.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 11.w,
                    ),
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
                SizedBox(
                  height: 22.w,
                ),
                Row(
                  children: [
                    const Spacer(),
                    InkResponse(
                      onTap: () {
                        controller.createExclusiveLyric();
                      },
                      child: Container(
                        width: 86.w,
                        height: 24.w,
                        // padding: EdgeInsets.only(
                        //   left: 10.w,
                        //   right: 10.w,
                        //   top: 5.w,
                        //   bottom: 5.w
                        // ),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: ByColorUtil.color3A3A3C,
                          borderRadius: BorderRadius.circular(12.w),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              Assets.icon25,
                              width: 12.w,
                              height: 12.w,
                            ),
                            SizedBox(
                              width: 4.w,
                            ),
                            Text(
                              "重新生成",
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.5),
                                fontWeight: FontWeight.w500,
                                fontSize: 12.sp,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 12.w,
                    )
                  ],
                )
              ],
            ),
        ],
      );
    }

    Get.log("==当前的步骤=== ${controller.exclusiveModeStep}");

    return Stack(
      children: [
        Container(
          height: 245.w,
          margin: EdgeInsets.only(
            left: 12.w,
            right: 12.w,
            top: 15.w,
          ),
          padding: EdgeInsets.only(
            top: 15.w,
            left: 12.w,
            right: 12.w,
            bottom: 18.w,
          ),
          decoration: BoxDecoration(
            image: const DecorationImage(
                image: AssetImage(
                  Assets.exclusiveEditHintTextBg,
                ),
                fit: BoxFit.fitHeight),
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF1E1E1E),
                Color(0xFF1E1E1E),
              ],
            ),
            borderRadius: BorderRadius.circular(10.w),
            border: Border.all(
              color: const Color(0xFF1E1E1E),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              Expanded(
                child: TextField(
                  inputFormatters: [LengthLimitingTextInputFormatter(300)],
                  readOnly: isGetRandom,
                  focusNode: focusNode,
                  maxLines: 100,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500),
                  decoration: InputDecoration(
                    hintText: isGetRandom
                        ? ""
                        : '请输入您想要的歌曲灵感，例如：失恋后的暗无天日，流行歌曲风格，男生，钢琴音',
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                      color: Colors.white.withOpacity(0.3),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  onChanged: (value) {
                    Get.log('大师模式输入的内容: $value');
                  },
                  controller: controller.hintTextEditingController3,
                  enabled: !isGetRandom,
                  enableInteractiveSelection: !isGetRandom,
                ),
              ),
              Row(
                children: [
                  Text(
                    "$hintTextLength",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 12.sp,
                      color: Colors.white.withOpacity(
                        hintTextLength > 0 ? 0.5 : 0.2,
                      ),
                    ),
                  ),
                  Text(
                    "/300",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 12.sp,
                      color: Colors.white.withOpacity(
                        0.5,
                      ),
                    ),
                  ),
                  const Spacer(),
                  functionArea(),
                ],
              )
            ],
          ),
        ),
        if (hintTextLength == 0 && !isGetRandom)
          Positioned(
              top: 136.w,
              left: 24.w,
              child: Row(
                children: [
                  Text(
                    "不想写?",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  InkResponse(
                    onTap: () {
                      getAiHintText();
                    },
                    child: Text(
                      "DeepSeek一键生成",
                      style: TextStyle(
                          color: ByColorUtil.colorC98465,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.underline),
                    ),
                  )
                ],
              )),

        ///生成提示区域
        if (isGetRandom && hintTextLength == 0)
          Positioned(
            top: 76.w,
            left: 32.w,
            child: ByWidgetsUtil.activityIndicator(
                radius: 13.w, color: Colors.white),
          ),
      ],
    );
  }

  ///ai写灵感
  getAiHintText({
    String describe = "",
  }) async {
    ///如果正在随机热门灵感 不可点击
    if (isGetRandom) {
      EasyLoading.showToast("正在一键生成灵感~", maskType: EasyLoadingMaskType.none);
      return;
    }
    if (mounted) {
      setState(() {
        isGetRandom = true;
        controller.hintTextEditingController3.text = "";
        messageSubscription?.cancel();
        controller.updateExclusiveRandom(random: isGetRandom);
      });
    }
    final stream =
        await getStream(url: APIs.apiPrefix + APIs.aiMusicHintText, body: {
      "describe": describe,
    });
    messageSubscription = stream.listen((data) {
      Get.log("获取热门灵感词===>$data");
      controller.hintTextEditingController3.text += data;
      isGetRandom = true;
      if (mounted) {
        setState(() {});
      }
      controller.updateExclusiveRandom(random: isGetRandom);
    }, onDone: () {
      isGetRandom = false;
      messageSubscription?.cancel();
      if (mounted) {
        setState(() {});
      }
      controller.updateExclusiveRandom(random: isGetRandom);
    }, onError: (error) {
      if (error is APIError) {
        isGetRandom = false;
        if (mounted) {
          setState(() {});
        }
        EasyLoading.showToast(error.message,
            maskType: EasyLoadingMaskType.none);
        messageSubscription?.cancel();
      }
      controller.updateExclusiveRandom(random: isGetRandom);
    });
  }

  ///功能区域
  functionArea() {
    if (controller.hintTextEditingController3.text.isNotEmpty && !isGetRandom) {
      return Row(
        children: [
          functionItemView(
            iconPath: Assets.deleteIcon,
            text: "清空",
            clickEvent: () {
              clearEvent();
            },
          ),
          SizedBox(
            width: 8.w,
          ),
          functionItemView(
            iconPath: Assets.copyIcon,
            text: "粘贴",
            clickEvent: () {
              pasteEvent();
            },
          ),
          SizedBox(
            width: 8.w,
          ),
          functionItemView(
            iconPath: Assets.botIcon,
            text: "改写",
            clickEvent: () {
              aiWriteEvent();
            },
          ),
        ],
      );
    }

    return functionItemView(
      iconPath: Assets.aiCopyIcon,
      text: "粘贴",
      clickEvent: () {
        pasteEvent();
      },
    );
  }

  ///功能区域小组件
  Widget functionItemView({
    required String iconPath,
    required String text,
    required VoidCallback clickEvent,
  }) {
    return InkResponse(
      onTap: () {
        clickEvent();
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12.w),
        ),
        padding:
            EdgeInsets.only(left: 11.w, right: 11.w, top: 4.w, bottom: 4.w),
        child: Row(
          children: [
            Image.asset(
              iconPath,
              width: 14.w,
              height: 14.w,
            ),
            SizedBox(
              width: 4.w,
            ),
            Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12.sp,
                color: Colors.white.withOpacity(
                  0.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///清空文本
  clearEvent() {
    if (hintTextLength == 0) {
      EasyLoading.showToast("请先描述一段灵感~", maskType: EasyLoadingMaskType.none);
      return;
    }
    if (isGetRandom) {
      EasyLoading.showToast("正在DeepSeek一键生成中~",
          maskType: EasyLoadingMaskType.none);
      return;
    }
    Get.dialog(clearDataDialog());
  }

  ///粘贴
  pasteEvent() async {
    String? text = await getClipboardText();
    if (isGetRandom) {
      EasyLoading.showToast("正在DeepSeek一键生成中~",
          maskType: EasyLoadingMaskType.none);
      return;
    }
    if (text != null) {
      controller.hintTextEditingController3.text = text;
    } else {
      EasyLoading.showToast("请先复制一段文本~", maskType: EasyLoadingMaskType.none);
      return;
    }
    Get.log("===text===$text");
  }

  ///Ai改写事件
  aiWriteEvent() {
    if (hintTextLength == 0) {
      EasyLoading.showToast("请先描述一段灵感~", maskType: EasyLoadingMaskType.none);
      return;
    }

    getAiHintText(describe: controller.hintTextEditingController3.text);
  }

  ///读取剪贴板文本
  Future<String?> getClipboardText() async {
    try {
      final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
      return clipboardData?.text;
    } catch (e) {
      print('获取剪贴板内容失败: $e');
      return null;
    }
  }

  ///清楚数据弹窗
  Widget clearDataDialog() {
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
                        text: "确定要清空吗？",
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                        textColor: Colors.white),
                    SizedBox(
                      height: 30.w,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 6.w,
                      ),
                      child: ByWidgetsUtil.commonText(
                        text: "清空后内容无法恢复哦",
                        fontWeight: FontWeight.w400,
                        fontSize: 16.sp,
                        textColor: Colors.white.withOpacity(0.5),
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
                              title: "取消",
                              bgColor: ByColorUtil.WhiteColor.withOpacity(0.1),
                              fontWeight: FontWeight.w500,
                              textColor: ByColorUtil.WhiteColor,
                              fontSize: 16.sp,
                              onClick: () async {
                                Get.back();
                              },
                            ),
                          ),
                          SizedBox(width: 20.w),
                          Expanded(
                            child: ByWidgetsUtil.commonBtn(
                              bgColor: ByColorUtil.color00CB64,
                              borderRadius: 12.w,
                              title: "确定",
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              textColor: Colors.white,
                              onClick: () async {
                                controller.hintTextEditingController3.text = "";
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

  ///高级设置
  Widget _highLevelSetting() {
    List<OptionModelEx> allOptionsList =
        controller.selectedExclusiveOptionsList;
    if (allOptionsList.isNotEmpty) {}

    if (controller.exclusiveModeStep == 5 ||
        controller.exclusiveModeStep == 6) {
      return const SizedBox();
    }
    return Container(
      margin: EdgeInsets.only(
        top: 15.w,
        left: 12.w,
        right: 12.w,
      ),
      decoration: BoxDecoration(
        color: ByColorUtil.color1E1E1E,
        borderRadius: BorderRadius.circular(10.w),
      ),
      padding: EdgeInsets.only(
        top: 21.w,
        left: 12.w,
        right: 12.w,
        bottom: 15.w,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "高级设置",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                ),
              ),
              const Spacer(),
              InkResponse(
                onTap: () {
                  ///随机选项
                  Get.log("==点击了==");
                  _unFocusAll();
                  controller.exclusiveHighLevelSettingEvent();
                },
                child: Image.asset(
                  Assets.settingIcon,
                  width: 14.w,
                  height: 14.w,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 16.w,
          ),
          if (allOptionsList.isNotEmpty)
            FlexibleWrap(
              spacing: 10.0.w, // 子组件之间的间距
              runSpacing: 12.0.w,
              isOneRowExpanded: false, // 行间距
              children: [
                ...allOptionsList.map(
                  (e) => _settingItemView(
                    option: e,
                  ),
                ),
              ],
            ),
          SizedBox(
            height: 16.w,
          ),
          Text(
            "不希望呈现的内容(可选填)",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 14.sp,
            ),
          ),
          TextField(
            key: _lastTextFieldKey,
            focusNode: _lastFocusNode,
            maxLines: 5,
            inputFormatters: [LengthLimitingTextInputFormatter(100)],
            style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500),
            decoration: InputDecoration(
              hintText: '写下你不希望出现的内容，例如：模糊、变形、低质量等。',
              border: InputBorder.none,
              hintStyle: TextStyle(
                color: Colors.white.withOpacity(0.3),
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            onChanged: (value) {
              Get.log('输入你不希望出现的内容: $value');
            },
            controller: controller.hintTextEditingController6,
          ),
        ],
      ),
    );
  }

  Widget _settingItemView({
    required OptionModelEx option,
  }) {
    return InkResponse(
      onTap: () async {
        _unFocusAll();
        controller.openExclusiveAiMusicItemDialog(option: option).then((value) {
          if (mounted) {
            setState(() {});
          }
        });
      },
      child: Container(
        width: 96.w,
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8.w),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${option.option!.zh}",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14.sp,
              ),
            ),
            Row(
              children: [
                Text(
                  option.selectContent,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontWeight: FontWeight.bold,
                    fontSize: 12.sp,
                  ),
                ),
                Image.asset(
                  Assets.openMore,
                  width: 14.w,
                  height: 14.w,
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  ///音乐内容
  Widget _musicSectionItemView({
    required MusicSection musicSection,
    bool first = false,
  }) {
    return Container(
      width: 1.sw,
      decoration: BoxDecoration(
          color: ByColorUtil.color1E1E1E,
          borderRadius: BorderRadius.circular(10.w),
          image: first
              ? const DecorationImage(
                  image: AssetImage(Assets.masterBg1), fit: BoxFit.fill)
              : null),
      margin: EdgeInsets.only(
        bottom: 15.w,
        left: 12.w,
        right: 12.w,
      ),
      padding: EdgeInsets.only(
        left: 12.w,
        right: 12.w,
        top: 21.w,
        bottom: 12.w,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${musicSection.title}",
            style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 16.w,
          ),
          Text(
            "${musicSection.content}",
            style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 14.sp,
                fontWeight: FontWeight.w400),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SizedBox(
      height:1.sh,
      child: GetBuilder<AiWriteMusicController>(
        builder: (context) {
          return ListView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(), // 允许滚动
            shrinkWrap: true,
            padding: EdgeInsets.only(bottom: 300.w),
            children: [
              ///进度提示部分
              _progressHintArea(),

              ///生成区域
              _buildBody(),
            ],
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
