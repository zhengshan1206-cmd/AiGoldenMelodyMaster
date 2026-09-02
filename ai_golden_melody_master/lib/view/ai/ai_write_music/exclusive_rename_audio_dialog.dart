import 'package:ai_golden_melody_master/utils/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:ai_golden_melody_master/common/lib/app_ui/by_widgets_util.dart';
import '../../../utils/by_color_utils.dart';

class ExclusiveRenameAudioDialog extends StatefulWidget {
  final String name;
  final int id;
  final String title;
  const ExclusiveRenameAudioDialog({
    super.key,
    required this.name,
    required this.id,
    this.title = "修改名称",
  });

  @override
  State<ExclusiveRenameAudioDialog> createState() =>
      _ExclusiveRenameAudioDialogState();
}

class _ExclusiveRenameAudioDialogState
    extends State<ExclusiveRenameAudioDialog> {
  String historyName = "";
  late TextEditingController textEditingController;
  bool couldRename = true;

  ///新名字
  String newName = "";

  @override
  void initState() {
    historyName = widget.name;
    textEditingController = TextEditingController(text: historyName);
    textEditingController.addListener(() {

      newName = textEditingController.text.replaceAll(" ", "");

      // if (textEditingController.text.isEmpty) {
      //   couldRename = false;
      // } else {
      //   couldRename = true;
      // }

      if(newName.isEmpty){
        couldRename = false;
      }else{
        couldRename = true;
      }

      if (mounted) {
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
          width: double.infinity,
          height: 370.w,
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
                  Assets.exclusiveBg,
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
                        text: widget.title,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                        textColor: Colors.white),
                    SizedBox(
                      height: 12.w,
                    ),

                    ///输入框
                    Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: ByColorUtil.colorD9D9D9.withOpacity(
                          0.1,
                        ),
                        borderRadius: BorderRadius.circular(
                          12.w,
                        ),
                       border: Border.all(
                         color: couldRename
                             ? ByColorUtil.colorFEC57F
                             : ByColorUtil.colorFEC57F.withOpacity(
                           0.3,
                         ),
                       )
                      ),
                      padding: EdgeInsets.only(left: 16.w, top: 0.w),
                      height: 52.w,
                      child: TextField(
                        maxLines: 1,
                        // maxLength: 30,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          // hintStyle: TextStyle(
                          //   color: Colors.white.withOpacity(0.3),
                          //   fontSize: 14.sp,
                          //   fontWeight: FontWeight.bold,
                          // ),
                          // hintText: "",
                        ),
                        onChanged: (value) {
                          Get.log('输入你不希望出现的内容: $value');
                        },
                        controller: textEditingController,
                        inputFormatters: [LengthLimitingTextInputFormatter(30)],
                        cursorColor: ByColorUtil.color00CB64,
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
                              bgColor: couldRename
                                  ? ByColorUtil.colorFEC57F
                                  : ByColorUtil.colorFEC57F.withOpacity(
                                      0.3,
                                    ),
                              borderRadius: 12.w,
                              title: "确认修改",
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              textColor: couldRename
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.3),
                              onClick: () async {
                                if (couldRename) {
                                  if (textEditingController.text !=
                                      widget.name) {
                                    Get.back(result: {
                                      "newName": textEditingController.text
                                    });
                                  } else {
                                    Get.back();
                                  }
                                } else {
                                  EasyLoading.showToast("歌名不能为空～",
                                      maskType: EasyLoadingMaskType.none);
                                }
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
                top: 64.w,
                right: 20.w,
                child: InkResponse(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                      width: 30.w,
                      height: 30.w,
                      color: Colors.transparent,
                      alignment: Alignment.centerRight,
                      child: Image.asset(
                        Assets.iconClose,
                        width: 16.w,
                        height: 16.w,
                      )),
                ),
              )
            ],
          )),
    );
  }
}
