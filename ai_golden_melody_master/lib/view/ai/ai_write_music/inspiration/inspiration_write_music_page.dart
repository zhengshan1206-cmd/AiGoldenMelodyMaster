import 'dart:async';
import 'package:ai_golden_melody_master/utils/assets.dart';
import 'package:ai_golden_melody_master/utils/by_color_utils.dart';
import 'package:ai_golden_melody_master/utils/data_service.dart';
import 'package:ai_golden_melody_master/view/ai/ai_write_music/first_progress_page.dart';
import 'package:ai_golden_melody_master/view/common/btn_breathing_animation_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_infinite_marquee/flutter_infinite_marquee.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ai_golden_melody_master/common/lib/app_http/apis.dart';
import 'package:ai_golden_melody_master/common/lib/result.dart';
import 'package:ai_golden_melody_master/common/lib/app_common/event/common_event.dart';
import 'package:ai_golden_melody_master/common/lib/app_ui/by_widgets_util.dart';
import 'package:showcaseview/showcaseview.dart';
import '../../../../model/ai_music/music_response.dart';
import '../../../../utils/common_event.dart';
import '../../../../utils/stream_data_mixin.dart';
import '../../../lanuch_page/launch_controller.dart';
import '../../../publish/widget/svga_player.dart';
import '../../../purchase/vip/vip_purchase_controller.dart';
import '../ai_write_music_controller.dart';

///灵感写歌页面
class InspirationWriteMusicPage extends StatefulWidget {
  const InspirationWriteMusicPage({
    super.key,
  });

  @override
  State<InspirationWriteMusicPage> createState() =>
      _InspirationWriteMusicPageState();
}

class _InspirationWriteMusicPageState extends State<InspirationWriteMusicPage>
    with StreamDataMixin, AutomaticKeepAliveClientMixin {
  ///开关是否打开
  bool _isSwitched = false;

  ///焦点
  FocusNode focusNode = FocusNode();

  /// 消息流订阅
  StreamSubscription<String>? messageSubscription;

  ///是否正在请求deepSeek一键生成
  bool isGetRandom = false;

  ///当前灵感描述的文字长度
  int hintTextLength = 0;
  late AiWriteMusicController controller;
  ScrollController scrollController = ScrollController();

  final _key1 = GlobalKey();
  final _key2 = GlobalKey();

  LaunchController launchController = Get.find<LaunchController>();

  ///是否执行第二步引导
  bool isSecondStep = false;

  late StreamSubscription<CloseKeyboardEvent> keyboardStreamSubscription;

  final ScrollController totalScrollController = ScrollController();

  late StreamSubscription streamSubscription;

  List<MusicItem> _items = [];
  List<MusicItem> _items1 = [];
  List<MusicItem> _items2 = [];
  List<MusicItem> _items3 = [];

  @override
  void initState() {
    initData();
    super.initState();
  }

  initData() {
    controller = Get.find<AiWriteMusicController>();
    controller.hintTextEditingController.addListener(() {
      if (controller.hintTextEditingController.text.isEmpty) {
        hintTextLength = 0;
      } else {
        if (controller.hintTextEditingController.text.length > 300) {
          controller.hintTextEditingController.text =
              controller.hintTextEditingController.text.substring(0, 300);
        }
        hintTextLength = controller.hintTextEditingController.text.length;
      }
      controller.updateInspirationAiMusicHintText(
        data: controller.hintTextEditingController.text,
      );
      if (mounted) {
        setState(() {});
      }
    });
    streamSubscription = eventBus.on<RefreshMarqueeEvent>().listen((event) {
      _items.clear();
      _items.addAll(controller.hotMusicItem);

      _items1.clear();
      _items1.addAll(controller.hotMusicItem1);

      _items2.clear();
      _items2.addAll(controller.hotMusicItem2);

      _items3.clear();
      _items3.addAll(controller.hotMusicItem3);

      Get.log("===监听到了刷新事件===");
      if (mounted) {
        setState(() {});
      }
    });

    if (controller.isLogin) {
      ///如果用户不是vip
      if (controller.isFirstJoin) {
        if (!controller.isVip) {
          ///用户最后登录是否超过三天
          if (controller.userInfo != null) {
            int? activeDay = controller.userInfo!.activeDay;
            if (activeDay != null) {
              if (activeDay > 3) {
                /// 提示欢迎回来 为您准备99元礼包
                WidgetsBinding.instance.addPostFrameCallback(
                      (_){
                        Future.delayed(const Duration(seconds: 2),(){
                          Get.find<LaunchController>().openComeBackUserBgDialog();
                        });
                      }
                );
              }else{
                DataService.onEvent(DataServiceEventName.obShow, {});
                WidgetsBinding.instance.addPostFrameCallback(
                      (_) => ShowCaseWidget.of(context).startShowCase([
                    _key1,
                    _key2,
                  ]),
                );
              }
            }
          }
        }
      }
    } else {
      if (controller.isFirstJoin) {
        DataService.onEvent(DataServiceEventName.obShow, {});
        WidgetsBinding.instance.addPostFrameCallback(
          (_) => ShowCaseWidget.of(context).startShowCase([
            _key1,
            _key2,
          ]),
        );
      }
    }

    keyboardStreamSubscription = eventBus.on<CloseKeyboardEvent>().listen((e) {
      if (focusNode.hasFocus) {
        focusNode.unfocus();
      }
    });

    totalScrollController.addListener(() {
      // if(totalScrollController.)
      if (focusNode.hasFocus) {
        focusNode.unfocus();
      }
      Get.log("移动的距离===>${totalScrollController.position.maxScrollExtent}");
    });
  }

  ///ai写灵感
  getAiHintText({
    String describe = "",
  }) async {
    ///检查是否需要登录
    if (!Get.find<LaunchController>().isLogin) {
      Get.find<LaunchController>().login(
          loginSuccess: () {
            couldGetAiHintText(
              describe: describe,
            );
          },
          source: "inspiration_write_music_page");
      return;
    }
    couldGetAiHintText();
  }

  couldGetAiHintText({
    String describe = "",
  }) async {
    ///如果正在随机热门灵感 不可点击
    ///
    if (isGetRandom) {
      EasyLoading.showToast("正在一键生成灵感~", maskType: EasyLoadingMaskType.none);
      return;
    }
    if (mounted) {
      setState(() {
        isGetRandom = true;
        controller.hintTextEditingController.text = "";
        messageSubscription?.cancel();
        controller.updateInspirationRandom(random: isGetRandom);
      });
    }

    try {
      final stream =
          await getStream(url: APIs.apiPrefix + APIs.aiMusicHintText, body: {
        "isPure": _isSwitched,
        "describe": describe,
      });
      messageSubscription = stream.listen((data) {
        Get.log("获取热门灵感词===>$data");
        controller.hintTextEditingController.text += data;
        isGetRandom = true;
        if (mounted) {
          setState(() {});
        }
        controller.updateInspirationRandom(random: isGetRandom);
        _scrollToBottom();
      }, onDone: () {
        isGetRandom = false;
        messageSubscription?.cancel();
        if (mounted) {
          setState(() {});
        }
        controller.updateInspirationRandom(random: isGetRandom);
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
        controller.updateInspirationRandom(random: isGetRandom);
      });
    } catch (e) {
      if (mounted) {
        isGetRandom = false;
        messageSubscription?.cancel();
        controller.updateInspirationRandom(random: isGetRandom);
        setState(() {});
      }
    }
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
      controller.hintTextEditingController.text = text;
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

    getAiHintText(describe: controller.hintTextEditingController.text);
  }

  ///功能区域
  functionArea() {
    if (controller.hintTextEditingController.text.isNotEmpty && !isGetRandom) {
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
      iconPath: Assets.deleteIcon,
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

  ///热门主题子组件
  hotTopicItem({required MusicItem model}) {
    return InkResponse(
      onTap: () {
        Get.log("选中了其中的model==> ${model.toJson()}");
        if (isGetRandom) {
          EasyLoading.showToast("正在DeepSeek一键生成中~",
              maskType: EasyLoadingMaskType.none);
          return;
        }
        controller.hintTextEditingController.text = model.detail;
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(
            0.05,
          ),
          borderRadius: BorderRadius.circular(14.w),
        ),
        padding: EdgeInsets.only(
          left: 10.w,
          right: 10.w,
          top: 6.w,
          bottom: 6.w,
        ),
        margin: EdgeInsets.only(left: 12.w),
        child: Text(
          model.title,
          style: TextStyle(
            color: Colors.white.withOpacity(0.5),
            fontWeight: FontWeight.w500,
            fontSize: 12.sp,
          ),
        ),
      ),
    );
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
                                controller.hintTextEditingController.text = "";
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

  void _scrollToBottom() {
    // 确保在下一帧滚动到底部
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.jumpTo(scrollController.position.maxScrollExtent);
        // scrollController.animateTo(
        //   scrollController.position.maxScrollExtent,
        //   duration: const Duration(milliseconds: 70),
        //   curve: Curves.easeOut,
        // );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SizedBox(
      height: 500.w,
      child: ListView(
        controller: totalScrollController,
        padding: EdgeInsets.only(bottom: 180.w),
        children: [
          Stack(
            children: [
              Container(
                height: 245.w,
                margin: EdgeInsets.only(
                  left: 12.w,
                  right: 12.w,
                ),
                padding: EdgeInsets.only(
                  top: 15.w,
                  left: 12.w,
                  right: 12.w,
                  bottom: 18.w,
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
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "灵感描述",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
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
                          value: _isSwitched,
                          onChanged: (bool value) {
                            setState(() => _isSwitched = value);
                            controller.updateIsPure(data: _isSwitched);
                          },
                          width: 32.w, // 自定义宽度
                          height: 16.w, // 自定义高度
                        )
                      ],
                    ),
                    Expanded(
                      child: TextField(
                        scrollController: scrollController,
                        cursorColor: ByColorUtil.color00CB64,
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
                          Get.log('灵感模式输入的内容: $value');
                        },
                        controller: controller.hintTextEditingController,
                        enabled: !isGetRandom,
                        enableInteractiveSelection: !isGetRandom,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(300)
                        ],
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
                  top: 107.w,
                  left: 24.w,
                  child: Showcase.withWidget(
                    targetPadding: EdgeInsets.only(
                      top: 5.w,
                      bottom: 5.w,
                      left: 9.w,
                      right: 9.w,
                    ),
                    targetBorderRadius: BorderRadius.circular(
                      16.w,
                    ),
                    key: _key1,
                    height: 160.w,
                    width: 1.sw,
                    container: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Image.asset(
                          Assets.firstClickStep,
                          width: 1.sw,
                          fit: BoxFit.fitWidth,
                        ),
                        Positioned(
                          top: -30.w,
                          left: 110.w,
                          child: BtnBreathingAnimationWidget(
                            child: Image.asset(
                              Assets.clickHand2,
                              width: 59.w,
                              height: 40.w,
                            ),
                          ),
                        )
                      ],
                    ),
                    onTargetClick: () {
                      ShowCaseWidget.of(context).completed(_key1);
                      DataService.onEvent(
                          DataServiceEventName.obNextClick1, {});
                      controller.updateHintTextEditingController();
                      if (mounted) {
                        isSecondStep = true;
                        setState(() {});
                      }
                    },
                    movingAnimationDuration: const Duration(seconds: 0),
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
                                color: ByColorUtil.color00CB64,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                decoration: TextDecoration.underline),
                          ),
                        )
                      ],
                    ),
                    // enableAutoScroll: false,
                  ),
                ),

              ///生成提示区域
              if (isGetRandom && hintTextLength == 0)
                Positioned(
                  top: 50.w,
                  left: 32.w,
                  child: ByWidgetsUtil.activityIndicator(
                      radius: 13.w, color: Colors.white),
                ),
            ],
          ),

          ///热门主题
          Container(
            decoration: BoxDecoration(
              color: ByColorUtil.color1E1E1E,
              borderRadius: BorderRadius.circular(10.w),
            ),
            padding: EdgeInsets.only(
                // left: 12.w,
                // right: 12.w,
                top: 21.w,
                bottom: 21.w),
            margin: EdgeInsets.only(top: 15.w, left: 12.w, right: 12.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: 12.w,
                    bottom: 8.w,
                  ),
                  child: Text(
                    "想不出来？选择一个热门主题吧！",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                _buildHotTopicView(),
              ],
            ),
          ),
          SizedBox(
            height: 30.w,
          ),

          if (controller.isFirstJoin)
            GetBuilder<AiWriteMusicController>(builder: (controller) {
              if(!controller.isFirstJoin){
                return SizedBox();
              }
              return Showcase.withWidget(
                // overlayOpacity: 1,
                targetPadding: EdgeInsets.only(
                  top: 0.w,
                  bottom: 0.w,
                  left: 0.w,
                  right: 0.w,
                ),
                targetBorderRadius: BorderRadius.circular(
                  0.w,
                ),
                key: _key2,
                height: 90.w,
                width: 1.sw,
                container: Image.asset(
                  Assets.secondClickStep,
                  fit: BoxFit.fill,
                ),
                onTargetClick: () {
                  ShowCaseWidget.of(context).completed(_key2);
                  DataService.onEvent(DataServiceEventName.obNextClick2, {});
                  if (mounted) {
                    isSecondStep = false;
                    setState(() {});
                  }
                  controller.updateIsFirst();
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return FirstProgressPage(
                      musicPromptData: controller.musicPromptData,
                    );
                  }));
                },
                movingAnimationDuration: const Duration(seconds: 0),
                child: Container(
                    width: 1.sw,
                    height: 72.w,
                    padding:
                        EdgeInsets.only(left: 12.w, right: 12.w, bottom: 20.w),
                    decoration: const BoxDecoration(color: Colors.black45),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          width: 1.sw,
                          height: 52.w,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                const Color(0xFF24FECF).withOpacity((1)),
                                const Color(0xFFFFF13C).withOpacity((1)),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
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
                        if (isSecondStep)
                          Positioned(
                              top: 35.w,
                              right: 15.w,
                              child: BtnBreathingAnimationWidget(
                                child: Image.asset(
                                  Assets.clickHand,
                                  width: 52.w,
                                  height: 40.w,
                                ),
                              )),
                      ],
                    )),
              );
            }),
        ],
      ),
    );
  }

  Widget _buildHotTopicView() {
    if (_items1.isNotEmpty && _items2.isNotEmpty && _items3.isNotEmpty) {
      return Column(
        children: [
          if (_items1.isNotEmpty)
            SizedBox(
              height: 30.w,
              child: InfiniteMarquee(
                itemBuilder: (BuildContext context, int index) {
                  MusicItem item = _items1[index % _items1.length];
                  return hotTopicItem(model: item);
                },
                frequency: const Duration(milliseconds: 60),
              ),
            ),
          if (_items2.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(
                top: 12.w,
              ),
              child: SizedBox(
                height: 30.w,
                child: InfiniteMarquee(
                  itemBuilder: (BuildContext context, int index) {
                    MusicItem item = _items2[index % _items2.length];
                    return hotTopicItem(model: item);
                  },
                  frequency: const Duration(milliseconds: 60),
                ),
              ),
            ),
          if (_items3.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(top: 12.w),
              child: SizedBox(
                height: 30.w,
                child: InfiniteMarquee(
                  itemBuilder: (BuildContext context, int index) {
                    MusicItem item = _items3[index % _items3.length];
                    return hotTopicItem(model: item);
                  },
                  frequency: const Duration(milliseconds: 60),
                ),
              ),
            )
        ],
      );
    }
    return Center(
      child: SizedBox(
        width: 56.w,
        height: 56.h,
        child: const SvgaPlayer(
          url: 'assets/home/img_loading.svga',
          isRepeat: true,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class CustomSwitch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final double width; // 自定义宽度
  final double height; // 自定义高度

  const CustomSwitch({
    Key? key,
    required this.value,
    required this.onChanged,
    this.width = 56.0, // 默认 iOS 风格宽度
    this.height = 32.0, // 默认 iOS 风格高度
  }) : super(key: key);

  @override
  _CustomSwitchState createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.onChanged(!widget.value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.height / 2),
          color: widget.value
              ? ByColorUtil.color00CB64
              : Colors.white.withOpacity(0.1),
        ),
        padding: const EdgeInsets.all(2),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 300),
          alignment:
              widget.value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: widget.height - 4,
            height: widget.height - 4,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color:
                  widget.value ? Colors.white : Colors.white.withOpacity(0.5),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 3,
                  offset: Offset(0, 1),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
