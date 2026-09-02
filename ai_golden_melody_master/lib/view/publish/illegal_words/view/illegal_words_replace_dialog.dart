import 'package:ai_golden_melody_master/common/lib/app_ui/by_widgets_util.dart';
import 'package:ai_golden_melody_master/common/lib/app_ui/byhy_screen_utils.dart';
import 'package:ai_golden_melody_master/view/publish/illegal_words/view/by_button.dart';
import 'package:ai_golden_melody_master/view/publish/illegal_words/view/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controller/illegal_words_controller.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class IllegalWordsReplaceDialog extends StatefulWidget {
  const IllegalWordsReplaceDialog({super.key});

  @override
  State<IllegalWordsReplaceDialog> createState() =>
      _IllegalWordsReplaceDialogState();
}

class _IllegalWordsReplaceDialogState extends State<IllegalWordsReplaceDialog> {
  IllegalWordsController controller = Get.find<IllegalWordsController>();
  final TextEditingController wordsEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
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
                SizedBox(height: 15.h),
                _buildComplianceTips(context),
                SizedBox(height: 24.h),
                _buildProhibitedWords(context),
                SizedBox(height: 12.h),
                _buildSelectedWord(context),
                SizedBox(height: 2.h),
                Image.asset(
                  "assets/purchase/home/illegal_words_icon_3.png",
                  width: 24.w,
                  height: 24.w,
                ),
                SizedBox(height: 2.h),
                _buildInput(),
                SizedBox(height: 24.h),
                SizedBox(
                  height: 52.h,
                  child: Obx(() => ByButton.gradientBtn(
                        title: controller.isDetecting.value ? "替换中..." : "替换",
                        textColor: Colors.white,
                        bgColor: controller.isDetecting.value
                            ? const Color(0xFF00CB643).withOpacity(0.6)
                            : const Color(0xFF00CB643),
                        borderRadius: 12.w,
                        fontSize: 18.sp,
                        onClick: () {
                          if (controller.isDetecting.value) return;

                          if (wordsEditingController.text.trim().isEmpty) {
                            EasyLoading.showToast('请输入替换内容');
                            return;
                          }

                          final replacedWord =
                              controller.selectedBandedWord.value;
                          controller.replaceWord(
                            wordsEditingController.text.trim(),
                            () {
                              // 更新违禁词列表
                              controller
                                  .updateBandedWordsAfterReplace(replacedWord);

                              // 替换完成后自动检测违禁词
                              controller.detectIllegalWords(
                                controller.content.value,
                                isFromDialog: true, // 标识来自弹窗内部
                                onSuccess: () {
                                  // 如果没有违禁词了，直接返回更新后的内容
                                  Get.back(result: {
                                    "contentUpdated": true,
                                    "content": controller.content.value,
                                    "noIllegalWords": true,
                                  });
                                },
                                onFail: () {
                                  // 如果还有违禁词，返回更新信号让主对话框处理
                                  Get.back(result: {
                                    "contentUpdated": true,
                                    "content": controller.content.value,
                                    "noIllegalWords": false,
                                  });
                                },
                              );
                            },
                            onContentUpdated: () {
                              // 通知主对话框更新TextField
                            },
                          );
                        },
                      )),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Row _buildTitle(BuildContext context) {
    return Row(
      children: [
        ByWidgetsUtil.commonText(
          text: "批量替换",
          textColor: ByColorUtil.colorF1,
          fontSize: 17,
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
        children: [
          Image.asset(
            "assets/purchase/home/illegal_words_icon_2.png",
            width: 14.w,
            height: 14.h,
          ),
          SizedBox(width: 10.w),
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

  _buildSelectedWord(BuildContext context) {
    return Container(
        height: 52,
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xFFFFFFFF).withOpacity(0.1),
          borderRadius: BorderRadius.circular(12.w),
        ),
        child: Obx(
          () => ByWidgetsUtil.commonText(
            text: controller.selectedBandedWord.value,
            textColor: ByColorUtil.colorF1,
            fontSize: 15.sp,
          ),
        ));
  }

  _buildInput() {
    return Container(
      height: 52.h,
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.w),
      ),
      child: Center(
        child: TextField(
          controller: wordsEditingController,
          textAlign: TextAlign.center,
          style: const TextStyle(color: ByColorUtil.colorF1, fontSize: 16),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.zero,
            border: InputBorder.none,
            labelStyle: const TextStyle(
              fontSize: 16,
              color: ByColorUtil.colorF1,
            ),
            hintStyle: TextStyle(
              fontSize: 16,
              color: ByColorUtil.colorF1.withOpacity(0.3),
            ),
            hintText: "请输入替换内容",
          ),
          cursorColor: const Color(0XFF00CB64),
        ),
      ),
    );
  }
}
