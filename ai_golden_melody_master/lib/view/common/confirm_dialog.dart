import 'dart:io';

import 'package:ai_golden_melody_master/utils/assets.dart';
import 'package:flustars_flutter3/flustars_flutter3.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ai_golden_melody_master/common/lib/app_ui/by_widgets_util.dart';
import 'package:ai_golden_melody_master/common/lib/app_common/aes/byhy_aes_storage_utils.dart';
import 'package:ai_golden_melody_master/common/lib/app_common/by_nav_router_utils.dart';
import 'package:ai_golden_melody_master/common/lib/app_common/consts/const.dart';
import '../../utils/by_color_utils.dart';

///确认弹窗
class ConfirmDialogEx extends StatelessWidget {

  final VoidCallback onConfirm;
  const ConfirmDialogEx({super.key,required this.onConfirm,});

  Widget confirmDialog({required BuildContext context,}) {
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
                        text: "确认提示",
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
                      child:     ByWidgetsUtil.commonRichText(
                        texts: [
                          TextSpan(
                            text:  "进入应用前，请先同意",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w400,
                            )
                          ),
                          TextSpan(
                            text: "《用户协议》",
                            style:  TextStyle(
                              color: Colors.white,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w400,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                ByNavRouterUtils.jumpWebViewPage(context, "",
                                    "https://inchat.beiyinapp.com/api/common12/protocol");
                              },
                          ),
                           TextSpan(
                            text: "和",
                               style: TextStyle(
                                 color: Colors.white.withOpacity(0.5),
                                 fontSize: 15.sp,
                                 fontWeight: FontWeight.w400,
                               )
                          ),
                          TextSpan(
                            text: "《隐私政策》",
                            style:  TextStyle(
                              color: Colors.white,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w400,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                ByNavRouterUtils.jumpWebViewPage(context, "",
                                    "https://inchat.beiyinapp.com/api/common12/privacy");
                              },
                          ),
                           TextSpan(
                            text: "，否则将退出应用。",
                               style: TextStyle(
                                 color: Colors.white.withOpacity(0.5),
                                 fontSize: 15.sp,
                                 fontWeight: FontWeight.w400,
                               )
                          ),
                        ],
                        fontSize: 12.sp,
                        fontWeight: FontWeight.normal,
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
                              title: "退出应用",
                              bgColor: ByColorUtil.WhiteColor.withOpacity(0.1),
                              fontWeight: FontWeight.w500,
                              textColor: ByColorUtil.WhiteColor,
                              fontSize: 16.sp,
                              onClick: () async {
                                exit(0);
                              },
                            ),
                          ),
                          SizedBox(width: 20.w),
                          Expanded(
                            child: ByWidgetsUtil.commonBtn(
                              bgColor: ByColorUtil.color00CB64,
                              borderRadius: 12.w,
                              title: "同意并继续",
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              textColor: Colors.white,
                              onClick: () async {
                                await SpUtil.putBool(
                                    Consts.kAgreementChecked, true);
                                onConfirm();
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
              //     top: 63.w,
              //     right:11.w,
              //     child: InkResponse(
              //       onTap: () {
              //         Get.back();
              //       },
              //       child: Container(
              //         width: 27.w,
              //         height: 27.w,
              //         alignment: Alignment.center,
              //         color: Colors.transparent,
              //         child: Image.asset(Assets.iconClose,
              //         width: 16.w,
              //           height: 16.w,
              //         ),
              //       ),
              //     ))
            ],
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return confirmDialog(context: context);
  }
}
