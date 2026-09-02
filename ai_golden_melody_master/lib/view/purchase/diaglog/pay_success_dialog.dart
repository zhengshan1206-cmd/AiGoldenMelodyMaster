import 'package:ai_golden_melody_master/common/lib/app_ui/by_widgets_util.dart';
import 'package:ai_golden_melody_master/utils/assets.dart';
import 'package:ai_golden_melody_master/utils/by_color_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PaySuccessDialog extends StatelessWidget {
  final String title;
  final String content;
  final String confirmText;
  final String cancelText;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const PaySuccessDialog({
    super.key,
    this.title = "解锁会员成功",
    this.content = "恭喜您，解锁会员成功，开启Ai音乐创作之旅吧！",
    this.confirmText = "开始创作",
    this.cancelText = "取消",
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: double.infinity,
        height: 450.w,
        child: Stack(
          children: [
            Container(
              height: 450.w,
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
              top: 84.w,
              left: 124.w,
              child: Image.asset(
                Assets.openVipSuccess,
                width: 140.w,
                height: 74.w,
              ),
            ),
            Positioned(
              left: 56.w,
              right: 36.w,
              top: 134.w,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 30.w,
                  ),
                  ByWidgetsUtil.commonText(
                      text: title,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                      textColor: Colors.white),
                  SizedBox(
                    height: 30.w,
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
                            color: Colors.white.withOpacity(0.5),
                          ),
                          textAlign: TextAlign.center,
                        ),
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
                            title: cancelText,
                            bgColor: ByColorUtil.WhiteColor.withOpacity(0.1),
                            fontWeight: FontWeight.w500,
                            textColor: ByColorUtil.WhiteColor,
                            fontSize: 16.sp,
                            onClick: () async {
                              onCancel.call();
                              Get.back();
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
                              onConfirm.call();
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
                  onCancel.call();
                  Get.back();
                },
                child: Icon(
                  Icons.close,
                  color: Colors.white.withOpacity(0.4),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
