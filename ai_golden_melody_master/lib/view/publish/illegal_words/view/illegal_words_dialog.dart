import 'package:ai_golden_melody_master/common/lib/app_ui/by_widgets_util.dart';
import 'package:ai_golden_melody_master/common/lib/app_ui/byhy_screen_utils.dart';
import 'package:ai_golden_melody_master/view/publish/illegal_words/controller/illegal_words_controller.dart';
import 'package:ai_golden_melody_master/view/publish/illegal_words/view/by_button.dart';
import 'package:ai_golden_melody_master/view/publish/illegal_words/view/colors.dart';
import 'package:ai_golden_melody_master/view/publish/illegal_words/view/highlight_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'illegal_words_replace_dialog.dart';

class IllegalWordsDialog extends StatefulWidget {
  final int type;
  const IllegalWordsDialog({super.key,this.type = 1,});

  @override
  State<IllegalWordsDialog> createState() => _IllegalWordsDialogState();
}

class _IllegalWordsDialogState extends State<IllegalWordsDialog> {
  IllegalWordsController controller = Get.find<IllegalWordsController>();

  String lastDetectedContent = "";

  // 添加TextEditingController和FocusNode
  late TextEditingController _textController;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: controller.content.value);
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: PanToUnfocus(
        child: Column(
          children: [
            const Spacer(),
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(
                bottom: 14.h + ByScreenUtils.bottomSafeHeight,
                left: 11.w,
                right: 11.w,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF2E2E2E),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(18.w),
                  topRight: Radius.circular(18.w),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 13.h),
                  _buildTitle(context),
                  SizedBox(height: 10.h),
                  _buildComplianceTips(context),
                  SizedBox(height: 10.h),
                  _buildInputWidget(context, 320.h),
                  SizedBox(height: 24.h),
                  _buildProhibitedWords(context),
                  SizedBox(height: 10.h),
                  _buildActions(context),
                  SizedBox(
                    height: 52.h,
                    child: ByButton.gradientBtn(
                      title: "确定",
                      textColor: Colors.white,
                      bgColor: const Color(0xFF00CB643),
                      borderRadius: 12.w,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      onClick: () {
                        controller.detectIllegalWords(
                          controller.content.value,
                          isFromDialog: true, // 标识来自弹窗内部
                          onSuccess: () {
                            Get.back(result: {
                              "content": controller.content.value,
                            });
                          },
                          onFail: () {
                            EasyLoading.showToast('当前存在违禁词!');
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///合规提示
  _buildComplianceTips(BuildContext context) {
    return Container(
      height: 36.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: const Color(0xFFFFD595).withOpacity(0.2),
        borderRadius: BorderRadius.circular(8.w),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            "assets/purchase/home/illegal_words_icon_2.png",
            width: 14.w,
            height: 14.h,
          ),
          SizedBox(width: 2.w),
          ByWidgetsUtil.commonText(
            text: "根据法律法规要求，请修改下方违禁词。",
            textColor: const Color(0xFFFFD595),
            fontWeight: FontWeight.w400,
            fontSize: 13.sp,
          ),
        ],
      ),
    );
  }

  /// 文本内容显示组件
  _buildInputWidget(BuildContext context, double? height) {
    return Obx(() => GestureDetector(
          onTap: () {
            controller.toggleEditMode(onEditModeChanged: () {
              if (controller.isEditMode.value) {
                // 切换到编辑模式时，同步文本内容并聚焦
                _textController.text = controller.content.value;
                _focusNode.requestFocus();
              } else {
                // 切换到显示模式时，失去焦点
                _focusNode.unfocus();
              }
            });
          },
          child: Container(
            height: height,
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFFFF).withOpacity(0.05),
              borderRadius: BorderRadius.circular(8.w),
            ),
            child: controller.isEditMode.value
                ? _buildEditMode()
                : _buildDisplayMode(),
          ),
        ));
  }

  /// 显示模式
  Widget _buildDisplayMode() {
    return Column(
      children: [
        SizedBox(
          height: 260.h,
          child: SingleChildScrollView(
            child: Align(
              alignment: Alignment.topLeft,
              child: MultiHighlightText(
                text: controller.content.value,
                highlights: controller.bandedWords,
                normalStyle: const TextStyle(
                  color: ByColorUtil.colorF1,
                ),
                highlightStyle: const TextStyle(color: Color(0XFFFF4343)),
                textAlign: TextAlign.left,
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.only(top: 12.w),
            child: _buildToolBar(context),
          ),
        ),
      ],
    );
  }

  /// 输入模式
  Widget _buildEditMode() {
    return Column(
      children: [
        SizedBox(
          height: 260.h,
          child: SingleChildScrollView(
            child: TextField(
              readOnly: widget.type==0?true:false,
              enableInteractiveSelection: widget.type==0?false:true,
              controller: _textController,
              focusNode: _focusNode,
              style: const TextStyle(
                color: ByColorUtil.colorF1,
                fontSize: 14,
              ),
              maxLines: null,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: '请输入内容...',
                hintStyle: TextStyle(
                  color: Color(0x66FFFFFF),
                  fontSize: 14,
                ),
              ),
              onChanged: (value) {
                // 检查字数限制
                if (controller.checkWordLimit(value)) {
                  controller.content.value = value;
                } else {
                  // 如果超过字数限制，处理限制
                  final truncatedValue = controller.handleWordLimit(value);
                  controller.content.value = truncatedValue;
                  _textController.text = truncatedValue;
                  _textController.selection = TextSelection.fromPosition(
                    TextPosition(offset: truncatedValue.length),
                  );
                }
                // 实时检测违禁词
                // controller.detectIllegalWords(value);
              },
            ),
          ),
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.only(top: 12.w),
            child: _buildToolBar(context),
          ),
        ),
      ],
    );
  }

  ///工具栏
  _buildToolBar(BuildContext context) {
    return Obx(() => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  controller.getWordCount(),
                  style: TextStyle(
                    color: ByColorUtil.colorF1.withOpacity(0.5),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "/2000",
                  style: TextStyle(
                    color: ByColorUtil.colorF1.withOpacity(0.5),
                    fontSize: 12.sp,
                  ),
                )
              ],
            ),
            if(widget.type!=0)
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    // 清空功能
                    controller.clearContent();
                    _textController.clear();
                  },
                  child: Container(
                    width: 62.w,
                    height: 24.w,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12.w),
                    ),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/purchase/home/illegal_words_icon_4.png",
                          width: 14.w,
                          height: 14.w,
                        ),
                        SizedBox(width: 4.w),
                        ByWidgetsUtil.commonText(
                          text: "清空",
                          textColor: ByColorUtil.colorF1.withOpacity(0.5),
                          fontSize: 12.sp,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                GestureDetector(
                  onTap: () async {
                    // 粘贴功能
                    await controller.pasteContent((newText) {
                      _textController.text = newText;

                      // 如果当前是输入模式，将光标移到末尾
                      if (controller.isEditMode.value) {
                        _textController.selection = TextSelection.fromPosition(
                          TextPosition(offset: newText.length),
                        );
                      }
                    });
                  },
                  child: Container(
                    width: 62.w,
                    height: 24.w,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12.w),
                    ),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/purchase/home/illegal_words_icon_5.png",
                          width: 14.w,
                          height: 14.w,
                        ),
                        SizedBox(width: 4.w),
                        ByWidgetsUtil.commonText(
                          text: "粘贴",
                          textColor: ByColorUtil.colorF1.withOpacity(0.5),
                          fontSize: 12.sp,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ));
  }

  ///替换视图
  _buildActions(BuildContext context) {
    return Obx(() => Offstage(
          offstage: controller.bandedWords.isEmpty,
          child: Container(
            margin: EdgeInsets.only(bottom: 10.h),
            height: 52.h,
            child: Row(
              children: [
                Expanded(
                  child: ByButton.gradientBtn(
                    title: "首字母替换",
                    textColor: Colors.white,
                    bgColor: Colors.white.withOpacity(0.1),
                    borderRadius: 12.w,
                    fontSize: 16.sp,
                    onClick: () {
                      controller.replaceWithInitialLetterOfPinyin(
                        onContentUpdated: () {
                          // 同步更新TextField的内容
                          _textController.text = controller.content.value;
                        },
                      );
                      controller.detectIllegalWords(controller.content.value,
                          isFromDialog: true);
                    },
                  ),
                ),
                SizedBox(width: 11.w),
                Expanded(
                  child: ByButton.gradientBtn(
                    title: "批量替换",
                    textColor: Colors.white,
                    bgColor: Colors.white.withOpacity(0.1),
                    borderRadius: 12.w,
                    fontSize: 16.sp,
                    onClick: () {
                      if (controller.bandedWords.isEmpty) {
                        EasyLoading.showToast("暂无违禁词，请重新检测");
                        return;
                      }
                      showDialog(
                        context: context,
                        useSafeArea: false,
                        builder: (ctx) => const IllegalWordsReplaceDialog(),
                      ).then((value) {
                        // 如果内容已更新，同步更新TextField并直接返回结果
                        if (value != null && value["contentUpdated"] == true) {
                          _textController.text = controller.content.value;

                          // 检查是否没有违禁词了
                          if (value["noIllegalWords"] == true) {
                            // 如果没有违禁词了，直接返回更新后的内容
                            Get.back(result: {
                              "content": controller.content.value,
                            });
                          } else {
                            // 如果还有违禁词，继续显示对话框，但更新TextField内容
                            _textController.text = controller.content.value;
                          }
                        }
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  ///顶部视图
  Row _buildTitle(BuildContext context) {
    return Row(
      children: [
        ByWidgetsUtil.commonText(
          text: "违禁词检测",
          textColor: ByColorUtil.colorF1,
          fontWeight: FontWeight.w600,
          fontSize: 17.sp,
        ),
        const Spacer(),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            Get.back();
          },
          child: Container(
            width: 16.w,
            height: 16.w,
            alignment: Alignment.center,
            child: Image.asset(
              "assets/purchase/home/illegal_words_icon.png",
              width: 16,
              height: 16,
            ),
          ),
        ),
      ],
    );
  }

  /// 违禁词列表
  _buildProhibitedWords(BuildContext context) {
    return Obx(() => controller.bandedWords.isEmpty
        ? Container()
        : SizedBox(
            height: 35.h,
            child: ListView.builder(
              padding: EdgeInsets.zero,
              scrollDirection: Axis.horizontal,
              itemCount: controller.bandedWords.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      print('____${controller.bandedWords[index]}');
                      controller.updateSelectedBandedWord(
                          controller.bandedWords[index]);
                    },
                    child: Obx(
                      () => Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        margin: EdgeInsets.only(
                            right: (index == controller.bandedWords.length - 1)
                                ? 0
                                : 10.w),
                        decoration: BoxDecoration(
                          color: controller.bandedWords[index] ==
                                  controller.selectedBandedWord.value
                              ? const Color(0XFFFF4343)
                              : const Color(0XFFFF4343).withOpacity(0.05),
                          borderRadius: BorderRadius.circular(8.w),
                          border: Border.all(
                            color: controller.bandedWords[index] ==
                                    controller.selectedBandedWord.value
                                ? const Color(0XFFFF4343)
                                : const Color(0XFFFF4343).withOpacity(0.4),
                          ),
                        ),
                        child: ByWidgetsUtil.commonText(
                          fontSize: 14.sp,
                          text: controller.bandedWords[index],
                          fontWeight: FontWeight.normal,
                          textColor: controller.bandedWords[index] ==
                                  controller.selectedBandedWord.value
                              ? ByColorUtil.colorF1
                              : const Color(0XFFFF4343),
                        ),
                      ),
                    ));
              },
            ),
          ));
  }
}

class PanToUnfocus extends StatelessWidget {
  const PanToUnfocus({
    super.key,
    this.child,
  });

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      onPanStart: (details) {
        FocusScope.of(context).unfocus();
      },
      child: child,
    );
  }
}
