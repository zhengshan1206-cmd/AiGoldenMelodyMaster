import 'package:ai_golden_melody_master/common/lib/app_ui/by_widgets_util.dart';
import 'package:ai_golden_melody_master/utils/by_color_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PayConfirmationDialog extends StatelessWidget {
  final String title; // 标题
  final String content; // 内容
  final String? subContent; // 副内容（可选）
  final String cancelText; // 取消按钮文案
  final String confirmText; // 确认按钮文案
  final VoidCallback? onCancel; // 取消回调
  final VoidCallback? onConfirm; // 确认回调

  const PayConfirmationDialog({
    super.key,
    this.title = "确认失败",
    this.content = "获取订单失败",
    this.subContent,
    this.cancelText = "取消",
    this.confirmText = "联系客服",
    this.onCancel,
    this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 350.w,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            color: ByColorUtil.color2e2e2e,
            image: const DecorationImage(
                image: AssetImage("assets/common/hint_bg.png"),
                fit: BoxFit.fitWidth,
                alignment: Alignment.topCenter),
            borderRadius: BorderRadius.circular(16.w),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 标题行，包含标题和关闭按钮
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(width: 12.w),
                  ByWidgetsUtil.commonText(
                      text: title,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                      textColor: Colors.white),

                  // 关闭按钮
                  InkResponse(
                    onTap: () {
                      Get.back();
                      // 点击关闭按钮也执行取消回调
                      onCancel?.call();
                    },
                    child: Icon(
                      Icons.close,
                      color: Colors.white.withOpacity(0.4),
                      size: 20.w,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 25.w,
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: 0.w,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      content,
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 16.sp,
                          color: Colors.white.withOpacity(0.5)),
                      textAlign: TextAlign.center,
                    ),
                    if (subContent != null) ...[
                      SizedBox(height: 8.w),
                      Text(
                        subContent!,
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 15.sp,
                            color: Colors.white.withOpacity(0.5)),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ],
                ),
              ),
              SizedBox(
                height: 40.w,
              ),
              SizedBox(
                height: 44.h,
                child: Row(
                  children: [
                    Expanded(
                      child: ByWidgetsUtil.commonBtn(
                        borderRadius: 12.w,
                        title: cancelText,
                        bgColor: ByColorUtil.WhiteColor.withOpacity(0.1),
                        fontWeight: FontWeight.w500,
                        textColor: ByColorUtil.WhiteColor,
                        fontSize: 16.sp,
                        onClick: () async {
                          Get.back();
                          // 执行取消回调
                          onCancel?.call();
                        },
                      ),
                    ),
                    SizedBox(width: 20.w),
                    Expanded(
                      child: ByWidgetsUtil.commonBtn(
                        bgColor: ByColorUtil.color00CB64,
                        borderRadius: 12.w,
                        title: confirmText,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        textColor: Colors.white,
                        onClick: () async {
                          Get.back();
                          // 执行确认回调
                          onConfirm?.call();
                          // 默认跳转到客服页面
                          // Get.find<LaunchController>().goChatOnlinePage();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
