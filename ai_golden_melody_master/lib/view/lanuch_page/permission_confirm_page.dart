import 'dart:io';
import 'package:ai_golden_melody_master/utils/assets.dart';
import 'package:ai_golden_melody_master/utils/data_service.dart';
import 'package:flustars_flutter3/flustars_flutter3.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ai_golden_melody_master/common/lib/app_common/aes/byhy_aes_storage_utils.dart';
import 'package:ai_golden_melody_master/common/lib/app_common/by_nav_router_utils.dart';
import 'package:ai_golden_melody_master/common/lib/app_common/consts/const.dart';
import 'package:ai_golden_melody_master/common/lib/app_ui/by_widgets_util.dart';
import '../../utils/by_color_utils.dart';
import '../common/confirm_dialog.dart';

///权限请求弹窗
class PermissionConfirmPage extends StatelessWidget {
  const PermissionConfirmPage({
    super.key,
    required this.onConfirm,
    this.title,
    this.content,
    this.confirmText,
    this.cancelText,
  });

  final String? title;
  final String? content;
  final String? confirmText;
  final String? cancelText;
  final void Function() onConfirm;

  @override
  Widget build(BuildContext context) {
    DataService.onEvent(DataServiceEventName.appFirstOpen, {});
    DataService.onEvent(DataServiceEventName.privacyShow, {});
    return Center(
      child: SizedBox(
        height: 556.w,
        child: Stack(
          children: [
            Container(
              height: 556.w,
              decoration: BoxDecoration(
                  color: ByColorUtil.color2e2e2e,
                  borderRadius: BorderRadius.circular(16.w)),
              margin: EdgeInsets.only(left: 12.w, right: 12.w),
            ),
            Positioned(
              top: 0.w,
              child: Image.asset(
                "assets/common/hint_bg.png",
                width: 1.sw,
                height: 120.w,
                // fit: BoxFit.fitWidth,
              ),
            ),
            Positioned(
              left: 36.w,
              right: 36.w,
              top: 24.w,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ByWidgetsUtil.commonText(
                      text: title ?? "用户协议与隐私政策提示",
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                      textColor: Colors.white),
                  SizedBox(height: 12.w),
                  ByWidgetsUtil.commonRichText(
                    texts: [
                      TextSpan(
                          text: content ??
                              "感谢您信任并使用Ai金曲大师!\n我们将持续采取互联网行业通行的技术措施和数据安全保护措施，保护您的隐私和个人信息安全您可通过阅读完整的",
                          style: TextStyle(
                            fontSize: 15.sp,
                            color: Colors.white.withOpacity(0.5),
                            fontWeight: FontWeight.normal,
                            height: 1.5,
                          )),
                      TextSpan(
                        text: "《用户协议》",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                          height: 1.5,
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
                            fontSize: 15.sp,
                            color: Colors.white.withOpacity(0.5),
                            fontWeight: FontWeight.normal,
                            height: 1.5,
                          )),
                      TextSpan(
                        text: "《隐私政策》",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                          height: 1.5,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            ByNavRouterUtils.jumpWebViewPage(context, "",
                                "https://inchat.beiyinapp.com/api/common12/privacy");
                          },
                      ),
                      TextSpan(
                        style: TextStyle(
                            height: 1.5,
                            fontSize: 15.sp,
                            color: Colors.white.withOpacity(0.5),
                            fontWeight: FontWeight.normal),
                        text:
                            "了解详情。\n在上述协议中，我们将向您说明我们如何为您提供服务并保障您的用户权益，如何收集、使用、保存、共享和保护您的相关信息，以及为您提供的访问、修改、删除和您相关的信息的方式。我们会严格按照您的授权，在上述协议约定的范围内收集、存储和使用您注册信息、设备信息、日志信息、图片信息或其他经您授权的信息。使用本产品需要接入数据网络或WLAN网络。可能产生流量费用，具体详情需请您咨询当地运营商。如您已经充分阅读、理解并接受以上两份协议的内容，请您点击“同意并继续”开始接受我们的服务。",
                      ),
                    ],
                    fontSize: 12.sp,
                    fontWeight: FontWeight.normal,
                  ),
                  SizedBox(height: 20.h),
                  ByWidgetsUtil.commonBtn(
                    bgColor: ByColorUtil.color00CB64,
                    borderRadius: 12.w,
                    title: confirmText ?? "同意并继续",
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    textColor: Colors.white,
                    padding: EdgeInsets.only(
                      top: 13.w,
                      bottom: 13.w,
                    ),
                    onClick: () async {
                      DataService.onEvent(
                          DataServiceEventName.privacyContinue, {});
                      await SpUtil.putBool(
                          Consts.kAgreementChecked, true);
                      final navigator = Navigator.of(context);
                      navigator.pop();
                      onConfirm.call();
                    },
                  ),
                  SizedBox(height: 5.w),
                  ByWidgetsUtil.commonBtn(
                    borderRadius: 12.w,
                    title: cancelText ?? "不同意",
                    bgColor:Colors.transparent,
                    fontWeight: FontWeight.w500,
                    textColor: ByColorUtil.WhiteColor.withOpacity(0.5),
                    fontSize: 15.sp,
                    onClick: () async {
                      DataService.onEvent(
                          DataServiceEventName.privacyCancel, {});
                      Navigator.of(context).pop();
                      showDialog(
                        context: context,
                        builder: (ctx) {
                          return ConfirmDialogEx(
                            onConfirm: () {
                              onConfirm();
                            },
                          );
                        },
                      );
                    },
                  ),

                ],
              ),
            ),
            Positioned(
                top: 15.w,
                right: 20.w,
                child: InkResponse(
                  onTap: () {
                    Navigator.of(context).pop();
                    showDialog(
                      context: context,
                      builder: (ctx) {
                        // return ExistConfirmPage(
                        //   onConfirm: onConfirm,
                        // );

                        return ConfirmDialogEx(
                          onConfirm: () {
                            onConfirm();
                          },
                        );
                      },
                    );
                  },
                  child: Icon(
                    Icons.close,
                    color: Colors.white.withOpacity(0.4),
                    size: 16.w,
                  ),
                ))
          ],
        ),
      ),
    );
  }
}

class ExistConfirmPage extends StatelessWidget {
  const ExistConfirmPage({
    super.key,
    required this.onConfirm,
    this.title,
    this.content,
    this.confirmText,
    this.cancelText,
  });

  final String? title;
  final String? content;
  final String? confirmText;
  final String? cancelText;
  final void Function() onConfirm;

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        onPopInvoked: (didPop) async {
          if (didPop) return;
          // controller.goBack();
        },
        child: Scaffold(
          body: Stack(
            children: [
              Container(),
              Positioned.fill(
                child: Image.asset(
                  Assets.launchBg,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned.fill(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 27.w),
                  color: ByColorUtil.BlackColor.withOpacity(0.5),
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: double.infinity,
                    child: ByWidgetsUtil.commonContainer(
                        margin: EdgeInsets.symmetric(horizontal: 27.w),
                        padding: EdgeInsets.only(
                            left: 16.w, right: 16.w, top: 30.h, bottom: 20.h),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ByWidgetsUtil.commonText(
                              text: title ?? "确认提示",
                              fontWeight: FontWeight.bold,
                              fontSize: 14.sp,
                            ),
                            SizedBox(height: 20.h),
                            ByWidgetsUtil.commonRichText(
                              texts: [
                                TextSpan(
                                  text: content ?? "进入应用前，请先同意",
                                ),
                                TextSpan(
                                  text: "《用户协议》",
                                  style: const TextStyle(
                                    color: ByColorUtil.TabTextColorSelected,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      ByNavRouterUtils.jumpWebViewPage(
                                          context,
                                          "",
                                          "https://inchat.beiyinapp.com/api/common12/protocol");
                                    },
                                ),
                                const TextSpan(
                                  text: "和",
                                ),
                                TextSpan(
                                  text: "《隐私政策》",
                                  style: const TextStyle(
                                    color: ByColorUtil.TabTextColorSelected,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      ByNavRouterUtils.jumpWebViewPage(
                                          context,
                                          "",
                                          "https://inchat.beiyinapp.com/api/common12/privacy");
                                    },
                                ),
                                const TextSpan(
                                  text: "，否则将退出应用。",
                                ),
                              ],
                              fontSize: 12.sp,
                              fontWeight: FontWeight.normal,
                            ),
                            SizedBox(height: 20.h),
                            SizedBox(
                              height: 44.h,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: ByWidgetsUtil.commonBtn(
                                      borderColor:
                                          ByColorUtil.TabTextColorSelected,
                                      borderRadius: 12.w,
                                      title: cancelText ?? "退出应用",
                                      bgColor: ByColorUtil.WhiteColor,
                                      fontWeight: FontWeight.normal,
                                      textColor:
                                          ByColorUtil.TabTextColorSelected,
                                      fontSize: 16.sp,
                                      onClick: () async {
                                        // if (Platform.isAndroid) {
                                        //   SystemNavigator.pop();
                                        // } else {
                                        //   // await ChannelOperate.exitApp();
                                        //
                                        // }

                                        exit(0);
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 20.w),
                                  Expanded(
                                    child: ByWidgetsUtil.commonBtn(
                                      borderRadius: 12.w,
                                      title: confirmText ?? "同意并继续",
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500,
                                      onClick: () async {
                                        final navigator = Navigator.of(context);
                                        await ByStorageUtils.saveBool(
                                            Consts.kAgreementChecked, true);
                                        navigator.pop();
                                        onConfirm.call();
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        )),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
