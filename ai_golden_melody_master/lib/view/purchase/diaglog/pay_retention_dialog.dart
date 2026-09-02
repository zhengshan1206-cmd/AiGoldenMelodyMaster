import 'package:ai_golden_melody_master/view/lanuch_page/launch_controller.dart';
import 'package:ai_golden_melody_master/view/publish/widget/scale_transition_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PayRetentionDialog extends StatelessWidget {
  /// 是否新用户弹窗
  final bool isNewUser;

  /// 关闭回调
  final VoidCallback? onClose;

  /// 按钮点击回调
  final VoidCallback? onButtonTap;

  const PayRetentionDialog({
    super.key,
    this.isNewUser = false,
    this.onClose,
    this.onButtonTap,
  });

  @override
  Widget build(BuildContext context) {
    final launchController = Get.find<LaunchController>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: double.infinity,
          height: 494.h,
          decoration: BoxDecoration(
            image: DecorationImage(
              // image: AssetImage(
              //   isNewUser
              //       ? "assets/purchase/home_marketing_4.png"
              //       : "assets/purchase/home_marketing_3.png",
              // ),
              image: isNewUser
                  ? launchController.vipPurchaseNewUserImage.isNotEmpty
                      ? NetworkImage(launchController.vipPurchaseNewUserImage)
                      : AssetImage("assets/purchase/home_marketing_4.png")
                  : launchController.vipPurchaseRetentionImage.isNotEmpty
                      ? NetworkImage(launchController.vipPurchaseRetentionImage)
                      : AssetImage("assets/purchase/home_marketing_3.png"),
              fit: BoxFit.fitHeight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  onButtonTap?.call();
                  Get.back();
                },
                child: ScaleTransitionWidget(
                  min: 0.95,
                  max: 1.05,
                  period: 500,
                  child: Image.asset(
                    "assets/purchase/home_marketing_btn_1.png",
                    fit: BoxFit.fitHeight,
                    height: 52.h,
                  ),
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              GestureDetector(
                onTap: () {
                  onClose?.call();
                  Get.back();
                },
                child: Text(
                  "稍后高价购买",
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ),
              SizedBox(
                height: 40.h,
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10.h,
        ),
        GestureDetector(
          onTap: () {
            onClose?.call();
            Get.back();
          },
          child: Image.asset(
            "assets/purchase/home/dialog_close.png",
            width: 24.w,
            height: 24.h,
          ),
        ),
      ],
    );
  }
}
