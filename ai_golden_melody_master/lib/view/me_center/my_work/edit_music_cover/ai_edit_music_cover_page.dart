import 'dart:async';
import 'package:ai_golden_melody_master/common/lib/app_common/by_common_utils.dart';
import 'package:ai_golden_melody_master/common/lib/app_common/event/common_event.dart';
import 'package:ai_golden_melody_master/utils/assets.dart';
import 'package:ai_golden_melody_master/utils/by_color_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ai_golden_melody_master/common/lib/app_http/apis.dart';
import 'package:ai_golden_melody_master/common/lib/result.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import '../../../../common/lib/app_http/http_utils.dart';
import '../../../../model/ai_music/ai_music_cover.dart';
import '../../../../model/ai_music/my_works_data_model.dart';
import '../../../../model/ai_music/rights_by_type.dart';
import '../../../../utils/stream_data_mixin.dart';
import 'conver_select_page.dart';
import 'edit_music_cover_controller.dart';

class AiEditMusicCoverPage extends StatefulWidget {
  const AiEditMusicCoverPage({
    super.key,
  });

  @override
  State<AiEditMusicCoverPage> createState() => _AiEditMusicCoverPageState();
}

class _AiEditMusicCoverPageState extends State<AiEditMusicCoverPage>
    with StreamDataMixin, AutomaticKeepAliveClientMixin {
  bool isGetRandom = false;
  FocusNode focusNode = FocusNode();
  TextEditingController textEditingController = TextEditingController();

  /// 消息流订阅
  StreamSubscription<String>? messageSubscription;

  EditMusicCoverController controller = Get.find<EditMusicCoverController>();

  ///生成封面需要消耗的权益
  RightsByType? aiMusicCover;

  ///输入框控制区域
  Widget _inputArea() {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(10.w),
          ),
          height: 200.w,
          margin: EdgeInsets.only(
            top: 18.w,
          ),
          padding:
              EdgeInsets.only(left: 12.w, right: 12.w, top: 0.w, bottom: 24.w),
          child: Column(
            children: [
              Expanded(
                child: TextField(
                  inputFormatters: [LengthLimitingTextInputFormatter(300)],
                  cursorColor: ByColorUtil.color00CB64,
                  readOnly: isGetRandom,
                  focusNode: focusNode,
                  maxLines: 100,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500),
                  decoration: InputDecoration(
                    hintText: isGetRandom ? "" : '请输入想要的封面图的画面描述，例如：一个古风美女…',
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                      color: Colors.white.withOpacity(0.3),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  onChanged: (value) {
                    print('输入灵感内容: $value');
                  },
                  controller: textEditingController,
                  enabled: !isGetRandom,
                  enableInteractiveSelection: !isGetRandom,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 8.w,
          left: 12.w,
          right: 12.w,
          child: _hintTextArea(),
        ),
      ],
    );
  }

  Widget _hintTextArea() {
    return Row(
      children: [
        Row(
          children: [
            Text(
              "$hintTextLength",
              style: TextStyle(
                color: Colors.white.withOpacity(
                  hintTextLength > 0 ? 0.5 : 0.2,
                ),
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              "/300",
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
              ),
            )
          ],
        ),
        const Spacer(),
        InkResponse(
          onTap: () {
            getAiHintText();
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(
                0.1,
              ),
              borderRadius: BorderRadius.circular(
                12.w,
              ),
            ),
            alignment: Alignment.center,
            padding: EdgeInsets.only(
              left: 10.w,
              right: 10.w,
              top: 2.w,
              bottom: 2.w,
            ),
            child: Text(
              "AI生成",
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontWeight: FontWeight.w500,
                fontSize: 12.sp,
              ),
            ),
          ),
        )
      ],
    );
  }

  ///当前灵感描述的文字长度
  int hintTextLength = 0;

  StreamSubscription<RefreshDataEvent>? messageSubscription2;

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
        textEditingController.text = "";
        messageSubscription?.cancel();
      });
    }
    final stream = await getStream(
        url: "${APIs.apiPrefix}music/music/createAiPrompt",
        body: {
          "id": controller.musicItem.id,
        });
    messageSubscription = stream.listen((data) {
      Get.log("获取灵感词===>$data");
      textEditingController.text += data;
      isGetRandom = true;
      if (mounted) {
        setState(() {});
      }
    }, onDone: () {
      isGetRandom = false;
      messageSubscription?.cancel();
      if (mounted) {
        setState(() {});
      }
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
    });
  }

  Widget _aiCreateBtn() {
    return InkResponse(
      onTap: () {
        if (isGetRandom) {
          EasyLoading.showToast("正在一键生成灵感~",
              maskType: EasyLoadingMaskType.none);
          return;
        }
        ByCommonUtils.throttle(() {
          controller.aiCreateMusic(
            controller: textEditingController,
          );
        }, delay: 1000);
      },
      child: Container(
          decoration: BoxDecoration(
            color: (hintTextLength == 0 || isGetRandom)
                ? Colors.white.withOpacity(0.05)
                : ByColorUtil.color00CB64,
            borderRadius: BorderRadius.circular(12.w),
          ),
          alignment: Alignment.center,
          padding: EdgeInsets.only(
            top: 17.w,
            bottom: 17.w,
          ),
          margin: EdgeInsets.only(
            top: 15.w,
          ),
          child: Text(
            "一键AI生成(${aiMusicCover != null ? aiMusicCover!.currentIntegral : ""}音符值)",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18.sp,
            ),
          )),
    );
  }

  ///历史区域
  Widget _historyArea() {
    List<DataDetailModel> coverModelList = controller.coverModelList;
    return SizedBox(
      height: 80.w,
      width: 1.sw,
      child: coverModelList.isEmpty
          ? Text(
              "暂无封面记录，赶快去生成吧～",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14.sp,
                color: Colors.white,
              ),
            )
          : SmartRefresher(
              physics: const CustomBouncingPhysics(horizontalDamping: 0.6),
              header: CustomHeader(
                height: 78,
                builder: (BuildContext context, RefreshStatus? mode) {
                  Widget body;
                  if (mode == RefreshStatus.idle) {
                    body = Column(
                      mainAxisSize: MainAxisSize.min,
                      children: '右滑刷新'.split('').map((char) {
                        return Text(
                          char,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12.sp,
                            color: Colors.white,
                          ),
                        );
                      }).toList(),
                    );
                  } else if (mode == RefreshStatus.refreshing) {
                    body = const CircularProgressIndicator(
                      color: Colors.white,
                    );
                  } else if (mode == RefreshStatus.canRefresh) {
                    ///释放刷新
                    body = Column(
                      mainAxisSize: MainAxisSize.min,
                      children: '释放刷新'.split('').map((char) {
                        return Text(
                          char,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12.sp,
                            color: Colors.white,
                          ),
                        );
                      }).toList(),
                    );
                  } else if (mode == RefreshStatus.completed) {
                    ///刷新完成
                    body = Column(
                      mainAxisSize: MainAxisSize.min,
                      children: '刷新完成'.split('').map((char) {
                        return Text(
                          char,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12.sp,
                            color: Colors.white,
                          ),
                        );
                      }).toList(),
                    );
                  } else {
                    ///刷新失败
                    body = Column(
                      mainAxisSize: MainAxisSize.min,
                      children: '刷新失败'.split('').map((char) {
                        return Text(
                          char,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12.sp,
                            color: Colors.white,
                          ),
                        );
                      }).toList(),
                    );
                  }
                  return Container(
                    width: 78.0, // 横向指示器宽度
                    height: 78.0,
                    alignment: Alignment.center,
                    child: body,
                  );
                },
              ),
              // 自定义底部指示器（高度减小）
              footer: CustomFooter(
                height: 78.0,
                builder: (context, mode) {
                  Widget body;
                  if (mode == LoadStatus.idle) {
                    body = Column(
                      mainAxisSize: MainAxisSize.min,
                      children: '左滑加载'.split('').map((char) {
                        return Text(
                          char,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12.sp,
                            color: Colors.white,
                          ),
                        );
                      }).toList(),
                    );
                  } else if (mode == LoadStatus.loading) {
                    body = const CircularProgressIndicator(
                      color: Colors.white,
                    );
                  } else if (mode == LoadStatus.canLoading) {
                    body = Column(
                      mainAxisSize: MainAxisSize.min,
                      children: '释放加载'.split('').map((char) {
                        return Text(
                          char,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12.sp,
                            color: Colors.white,
                          ),
                        );
                      }).toList(),
                    );
                  } else {
                    body = Column(
                      mainAxisSize: MainAxisSize.min,
                      children: '加载完成'.split('').map((char) {
                        return Text(
                          char,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12.sp,
                            color: Colors.white,
                          ),
                        );
                      }).toList(),
                    );
                  }
                  return Container(
                    width: 78.0,
                    height: 78.0,
                    alignment: Alignment.center,
                    child: body,
                  );
                },
              ),
              scrollDirection: Axis.horizontal,
              enablePullDown: true,
              enablePullUp: true,
              controller: controller.allMusicCoverController,
              onRefresh: controller.onRefresh,
              onLoading: controller.onLoading,
              child: ListView(
                padding: EdgeInsets.zero,
                scrollDirection: Axis.horizontal,
                children: [
                  ...coverModelList.map(
                    (e) => _coverItemView(model: e),
                  )
                ],
              )),
    );
  }

  @override
  void initState() {
    controller.onRefresh();
    initListen();
    super.initState();
  }

  initListen() {
    textEditingController.addListener(() {
      hintTextLength = textEditingController.text.length;
      if (mounted) {
        setState(() {});
      }
    });
    messageSubscription2 = eventBus.on<RefreshDataEvent>().listen((e) {
      if (e.type == 1) {
        if (mounted) {
          setState(() {});
        }
      }
    });
    // controller.getDataList();
    HttpUtils.post(
      APIs.getRightsByType,
      {
        "type": "app_ai_music_cover",
      },
      success: (data) {
        aiMusicCover = RightsByType.fromJson(data["data"]);
        Get.log("加载音色封面消耗音符数量---$data");
        if (mounted) {
          setState(() {});
        }
      },
      fail: (code, msg) {},
    );
  }

  Widget _coverItemView({
    required DataDetailModel model,
  }) {
    bool selected = false;
    late Widget dataWidget;
    if (controller.coverModelList.isNotEmpty) {
      DataDetailModel selectedModel =
          controller.coverModelList[controller.selectedCoverIndex];
      if (selectedModel.id == model.id) {
        selected = true;
      }
    }

    if (model.status == 0) {
      dataWidget = Image.asset(
        Assets.icon17,
        width: 40.w,
        height: 40.w,
      );
    } else if (model.status == 1) {
      dataWidget = ClipRRect(
        borderRadius: BorderRadius.circular(8.w),
        child: CachedNetworkImage(
          imageUrl: model.coverUrl,
        ),
      );
    } else if (model.status == 2) {
      dataWidget = Image.asset(
        Assets.icon19,
        width: 40.w,
        height: 40.w,
      );
    }

    return InkResponse(
        onTap: () {
          // Get.back();
          Get.log("===当前封面==== ${model.toJson()}");
          Get.to(() => CoverSelectPage(
                dataDetailModel: model,
              ));
        },
        child: SizedBox(
          width: 72.w,
          height: 72.w,
          child: Container(
              width: 72.w,
              height: 72.w,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.w),
                  border: Border.all(
                      color: selected
                          ? ByColorUtil.color00CB64
                          : Colors.transparent,
                      width: 2)),
              alignment: Alignment.center,
              padding: EdgeInsets.all(2.w),
              child: (model.status == 0 || model.status == 2)
                  ? Container(
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(8.w),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.1),
                          )),
                      alignment: Alignment.center,
                      child: dataWidget,
                    )
                  : dataWidget),
        ));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _inputArea(),
        _aiCreateBtn(),
        Padding(
          padding: EdgeInsets.only(top: 24.w, bottom: 16.w),
          child: Text(
            "历史生成记录",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14.sp,
              color: Colors.white,
            ),
          ),
        ),
        _historyArea(),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class CustomBouncingPhysics extends BouncingScrollPhysics {
  final double horizontalDamping; // 水平阻尼系数

  const CustomBouncingPhysics({
    ScrollPhysics? parent,
    this.horizontalDamping = 0.8, // 默认值，越小阻尼越大
  }) : super(parent: parent);

  @override
  CustomBouncingPhysics applyTo(ScrollPhysics? ancestor) {
    return CustomBouncingPhysics(
      parent: buildParent(ancestor),
      horizontalDamping: horizontalDamping,
    );
  }

  @override
  double applyPhysicsToUserOffset(ScrollMetrics position, double offset) {
    // 仅对横向滚动应用自定义阻尼
    if (position.axis == Axis.horizontal) {
      return offset * horizontalDamping;
    }
    return super.applyPhysicsToUserOffset(position, offset);
  }
}
