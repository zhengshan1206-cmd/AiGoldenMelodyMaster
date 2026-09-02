import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:ai_golden_melody_master/common/lib/app_ui/by_widgets_util.dart';
import '../../../utils/assets.dart';
import '../../../utils/by_color_utils.dart';

class DeleteConfirmDialog extends StatefulWidget {
  final String name;
  final int id;
  final String title;
  const DeleteConfirmDialog({
    super.key,
    required this.name,
    required this.id,
    this.title = "删除确认",
  });

  @override
  State<DeleteConfirmDialog> createState() => _DeleteConfirmDialogState();
}

class _DeleteConfirmDialogState extends State<DeleteConfirmDialog> {
  String historyName = "";
  @override
  void initState() {
    historyName = widget.name;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                        text: widget.title,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                        textColor: Colors.white),
                    SizedBox(
                      height: 12.w,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 42.w,
                        right: 42.w,
                      ),
                      child: Column(
                        children: [
                          Text(
                            "确认要删除${widget.name}吗，删除后不支持找回",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                              fontWeight: FontWeight.w400,
                              fontSize: 15.sp,
                            ),
                            textAlign: TextAlign.center,
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
                              title: "确认删除",
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              textColor: Colors.white,
                              onClick: () async {
                                Get.back(result: {"confirmDelete": true});
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              // Positioned(
              //     top: 74.w,
              //     right: 28.w,
              //     child: InkResponse(
              //       onTap: () {
              //         Get.back();
              //       },
              //       child: Icon(
              //         Icons.close,
              //         color: Colors.white.withOpacity(0.4),
              //       ),
              //     ))

              Positioned(
                  top: 63.w,
                  right: 15.w,
                  child: InkResponse(
                      onTap: () {
                        Get.back();
                      },
                      child:Container(
                        width: 27.w,
                        height: 27.w,
                        alignment: Alignment.center,
                        color: Colors.transparent,
                        child: Image.asset(Assets.iconClose,
                          width: 16.w,
                          height: 16.w,
                        ),
                      )
                  ))
            ],
          )),
    );
  }
}
