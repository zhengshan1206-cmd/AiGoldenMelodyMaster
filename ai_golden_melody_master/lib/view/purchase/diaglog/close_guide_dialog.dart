import 'package:ai_golden_melody_master/navigator/app_pages.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../common/btn_breathing_animation_widget.dart';

///关闭引导提示红包弹窗
class CloseGuideDialog extends StatelessWidget {
  final String closeGuideBg;
  const CloseGuideDialog({
    super.key,
    required this.closeGuideBg,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 1.sw,
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 120.w,
            ),
            Stack(
              children: [
                closeGuideBg.isEmpty
                    ? Image.asset(
                        "assets/purchase/dialog/pay_dialog_bg_3.png",
                        width: 1.sw,
                        height: 494.w,
                      )
                    : CachedNetworkImage(
                        imageUrl: closeGuideBg,
                        width: 1.sw,
                        height: 494.w,
                      ),

                ///开红包按钮
                Positioned(
                  left: 136.w,
                  bottom: 114.w,
                  child: InkResponse(
                    onTap: () {
                      Get.back();
                      Get.toNamed(Routes.vipPurchasePage);
                    },
                    child: Image.asset(
                      "assets/purchase/dialog/open_btn.png",
                      width: 104.w,
                      height: 104.w,
                    ),
                  ),
                ),

                ///关闭按钮
                Positioned(
                    bottom: 0,
                    left: 174.w,
                    child: InkResponse(
                      onTap: () {
                        Get.back();
                      },
                      child: Image.asset(
                        "assets/purchase/dialog/close_btn.png",
                        width: 28.w,
                        height: 28.w,
                      ),
                    )),

                ///手势按钮
                Positioned(
                    right: 95.w,
                    bottom: 93.w,
                    child: BtnBreathingAnimationWidget(
                      child: Image.asset(
                        "assets/purchase/dialog/hand_icon.png",
                        width: 72.w,
                        height: 72.w,
                      ),
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }
}
