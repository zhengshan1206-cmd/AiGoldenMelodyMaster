import 'dart:async';
import 'package:ai_golden_melody_master/common/lib/app_common/event/common_event.dart';
import 'package:ai_golden_melody_master/utils/assets.dart';
import 'package:ai_golden_melody_master/view/lanuch_page/launch_controller.dart';
import 'package:flexible_wrap/flexible_wrap.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ai_golden_melody_master/common/lib/app_http/apis.dart';
import 'package:ai_golden_melody_master/common/lib/app_ui/by_widgets_util.dart';
import 'package:ai_golden_melody_master/common/lib/result.dart';
import 'package:lottie/lottie.dart';
import '../../../../model/ai_music/ai_music_config_model.dart';
import '../../../../model/ai_music/master_music_analysis_model.dart';
import '../../../../utils/by_color_utils.dart';
import '../../../../utils/common_event.dart';
import '../../../../utils/stream_data_mixin.dart';
import '../ai_write_music_controller.dart';
import '../ai_write_music_event.dart';
import '../inspiration/inspiration_write_music_page.dart';

///大师模式页面
class MasterWriteMusicPage extends StatefulWidget {
  const MasterWriteMusicPage({
    super.key,
  });

  @override
  State<MasterWriteMusicPage> createState() => _MasterWriteMusicPageState();
}

class _MasterWriteMusicPageState extends State<MasterWriteMusicPage>
    with StreamDataMixin, AutomaticKeepAliveClientMixin {
  ///开关是否打开
  bool _isSwitched = false;

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

  late AiWriteMusicController controller;
  final ScrollController _scrollController = ScrollController();
  final ScrollController textEditingScrollController = ScrollController();

  late StreamSubscription<CloseKeyboardEvent> keyboardStreamSubscription;

  bool _isScrolling = false;


  ///进度提示部分
  Widget _progressHintArea() {
    int masterModeStep = controller.masterModeStep;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          Assets.masterMusic,
          width: 12.w,
          height: 12.w,
        ),
        Text(
          "高级设置",
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
          ),
        ),
        if (!controller.masterPure)
          Image.asset(
            Assets.masterMusic,
            width: 12.w,
            height: 12.w,
            color: (masterModeStep == 2 || masterModeStep == 3)
                ? ByColorUtil.colorC98465
                : ByColorUtil.colorC98465.withOpacity(0.5),
          ),
        if (!controller.masterPure)
          Text(
            "词曲精调",
            style: TextStyle(
              color: (masterModeStep == 2 || masterModeStep == 3)
                  ? Colors.white
                  : Colors.white.withOpacity(0.5),
              fontWeight: FontWeight.w400,
              fontSize: 14.sp,
            ),
          ),
        if (!controller.masterPure)
          Padding(
            padding: EdgeInsets.only(
              left: 6.w,
              right: 6.w,
            ),
            child: Image.asset(
              Assets.nextIcon,
              width: 12.w,
              height: 12.w,
              color: (masterModeStep == 4)
                  ? Colors.white
                  : Colors.white.withOpacity(0.5),
            ),
          ),
        Image.asset(
          Assets.masterMusic,
          width: 12.w,
          height: 12.w,
          color: (masterModeStep == 4)
              ? ByColorUtil.colorC98465
              : ByColorUtil.colorC98465.withOpacity(0.5),
        ),
        Text(
          "生成歌曲",
          style: TextStyle(
            color: (masterModeStep == 4)
                ? Colors.white
                : Colors.white.withOpacity(0.5),
            fontWeight: FontWeight.w400,
            fontSize: 14.sp,
          ),
        ),
      ],
    );
  }

  ///输入歌名 文字区域
  Widget _inputArea() {
    hintTextLength = controller.masterTextEditingController.text.length;
    if (controller.masterModeStep == 2) {
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
              controller.masterPure == true ? "歌曲生成中..." : "歌词生成中...",
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

    if (controller.masterModeStep == 3) {
      MasterMusicAnalysisResponse? masterMusicAnalysisResponse =
          controller.masterMusicAnalysisResponse;
      List<MusicSection> parse = [];
      MusicAnalysisData? data;
      if (masterMusicAnalysisResponse != null) {
        data = masterMusicAnalysisResponse.data;
      }

      if (data != null) {
        parse = data.parse ?? [];
      }

      if (controller.masterNewMusicSection.isNotEmpty) {
        parse = controller.masterNewMusicSection;
      }

      Get.log("章节生成数据=======>${data!.parse.toString()}");

      Get.log("data=======>${data.parse.toString()}");
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
                        controller.createMasterModeLyric();
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
            top: 5.w,
            left: 12.w,
            right: 12.w,
            bottom: 8.w,
          ),
          decoration: BoxDecoration(
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
            image: const DecorationImage(
                image: AssetImage(
                  Assets.masterEditHintTextBg,
                ),
                fit: BoxFit.fitHeight),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                      child: Stack(
                    children: [
                      TextField(
                        inputFormatters: [LengthLimitingTextInputFormatter(30)],
                        cursorColor: ByColorUtil.color00CB64,
                        focusNode: focusNode2,
                        maxLines: 1,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500),
                        decoration: InputDecoration(
                          hintText: '请输入歌名',
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            color: Colors.white.withOpacity(0.3),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onChanged: (value) {
                          Get.log('输入灵感内容: $value');
                        },
                        controller: controller.masterMusicNameEditingController,
                      ),
                      Positioned(
                          bottom: 10,
                          child: Container(
                            width: 1.sw,
                            height: 1,
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1)),
                          ))
                    ],
                  )),
                  SizedBox(
                    width: 24.w,
                  ),
                  Text(
                    "纯音乐",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(
                    width: 6.w,
                  ),
                  CustomSwitch(
                    value: controller.masterPure,
                    onChanged: (bool value) {
                      setState(() => controller.masterPure = value);
                      controller.updateMasterIsPure(data: value);
                    },
                    width: 32.w, // 自定义宽度
                    height: 16.w, // 自定义高度
                  )
                ],
              ),
              SizedBox(
                height: 155.w,
                child: TextField(
                  scrollController: textEditingScrollController,
                  cursorColor: ByColorUtil.color00CB64,
                  // readOnly: isGetRandom,
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
                  controller: controller.masterTextEditingController,
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
    ///检查是否需要登录
    if (!Get.find<LaunchController>().isLogin) {
      Get.find<LaunchController>().login(loginSuccess: () {
        couldGetAiHintText(describe: describe);
      },source: "master_write_music_page");
      return;
    }

    couldGetAiHintText(describe: describe);
  }

  couldGetAiHintText({
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
        controller.masterTextEditingController.text = "";
        messageSubscription?.cancel();
        controller.updateMasterRandom(random: isGetRandom);
      });
    }
    final stream =
        await getStream(url: APIs.apiPrefix + APIs.aiMusicHintText, body: {
      "isPure": _isSwitched,
      "describe": describe,
    });
    messageSubscription = stream.listen((data) {
      Get.log("获取热门灵感词===>$data");
      controller.masterTextEditingController.text += data;
      isGetRandom = true;
      if (mounted) {
        setState(() {});
      }
      controller.updateMasterRandom(random: isGetRandom);
      _scrollToBottom();
    }, onDone: () {
      isGetRandom = false;
      messageSubscription?.cancel();
      if (mounted) {
        setState(() {});
      }
      controller.updateMasterRandom(random: isGetRandom);
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
      controller.updateMasterRandom(random: isGetRandom);
    });
  }

  ///功能区域
  functionArea() {
    if (controller.masterTextEditingController.text.isNotEmpty &&
        !isGetRandom) {
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
      controller.masterTextEditingController.text = text;
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

    getAiHintText(describe: controller.masterTextEditingController.text);
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

  initData() {
    controller = Get.find<AiWriteMusicController>();
    controller.masterTextEditingController.addListener(() {
      Get.log("监听到文本数据更新====${controller.masterTextEditingController.text}");

      if (controller.masterTextEditingController.text.isEmpty) {
        hintTextLength = 0;
      } else {
        if (controller.masterTextEditingController.text.length > 300) {
          controller.masterTextEditingController.text =
              controller.masterTextEditingController.text.substring(0, 300);
        }

        hintTextLength = controller.masterTextEditingController.text.length;
      }
      controller.updateMasterAiMusicHintText(
        data: controller.masterTextEditingController.text,
      );
      if (mounted) {
        setState(() {});
      }
    });
    controller.masterMusicNameEditingController.addListener(() {
      controller.updateAiMusicName(
          text: controller.masterMusicNameEditingController.text.trim());
    });
    _lastFocusNode.addListener(_onLastFocusChange);

    _scrollController.addListener(() {
      Get.log("移动的距离===>${_scrollController.position}");
      _unFocusAll();
    });
  }


  _unFocusAll(){
    if(focusNode.hasFocus){
      focusNode.unfocus();
    }
    if(focusNode2.hasFocus){
      focusNode2.unfocus();
    }
    // if(_lastFocusNode.hasFocus){
    //   if(_isScrolling){
    //     return;
    //   }
    //   _lastFocusNode.unfocus();
    // }
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
      _scrollController.animateTo(
        targetOffset,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut, // 向下滚动使用easeOut曲线更自然
      ).then((_) {
        _isScrolling = false;
      });
    }
  }

  // 上滑到最后一个输入框（保持原功能）
  void _scrollToLastTextField() {
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
    _scrollController.animateTo(
      _lastFocusScrollOffset+180.w,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn, // 向上滚动使用easeIn曲线
    ).then((_) {
      _isScrolling = false;
    });
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
                                controller.masterTextEditingController.text =
                                    "";
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
    List<OptionModelEx> allOptionsList = [];
    if (!controller.masterPure) {
      allOptionsList = controller.selectedMasterModeOptionsList;
    } else {
      allOptionsList = controller.selectedPureMasterModeOptionsList;
    }

    if (allOptionsList.isNotEmpty) {}

    if (controller.masterModeStep == 2 || controller.masterModeStep == 3) {
      return const SizedBox();
    }

    for (var e in allOptionsList) {
      Get.log("构建的选项===> ${e.selectContent}");
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
                  controller.clickHighLevelSettingEvent();
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
            inputFormatters: [LengthLimitingTextInputFormatter(100)],
            cursorColor: ByColorUtil.color00CB64,
            focusNode: _lastFocusNode,
            maxLines: 5,
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
            controller: controller.masterNoValueTextEditingController,
          ),
        ],
      ),
    );
  }

  Widget _settingItemView({
    required OptionModelEx option,
  }) {
    Get.log("selectContent==> ${option.selectContent}");

    return InkResponse(
      onTap: () async {
        _unFocusAll();
        controller.openAiMusicItemDialog(option: option).then((value) {
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

  late StreamSubscription<ClearPureEvent> clearPureEventStreamSubscription;

  ///最后一个输入框的全局键（用于获取位置信息）
  final GlobalKey _lastTextFieldKey = GlobalKey();

  ///新增：记录键盘弹出前的滚动位置，用于焦点失去时恢复
  double _preKeyboardScrollOffset = 0;
  ///新增：记录最后一个输入框获得焦点时的滚动位置
  double _lastFocusScrollOffset = 0;

  @override
  void initState() {
    initData();
    clearPureEventStreamSubscription = eventBus.on<ClearPureEvent>().listen((e) {
      if (e.type == 2) {
        _isSwitched = false;
        if (mounted) {
          setState(() {});
        }
      }
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
    super.initState();
  }

  @override
  void dispose() {
    clearPureEventStreamSubscription.cancel();
    super.dispose();
  }

  void _scrollToBottom() {
    // 确保在下一帧滚动到底部
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (textEditingScrollController.hasClients) {
        textEditingScrollController
            .jumpTo(textEditingScrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SizedBox(
      height: 1.sh,
      child: GetBuilder<AiWriteMusicController>(
        builder: (context) {
          return ListView(
            controller: _scrollController,
            padding: EdgeInsets.only(bottom: 300.w),
            children: [
              ///进度提示部分
              _progressHintArea(),

              ///输入歌名 文字区域
              _inputArea(),

              ///高级设置
              _highLevelSetting(),
            ],
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
