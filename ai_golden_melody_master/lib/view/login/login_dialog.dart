import 'dart:async';

import 'package:ai_golden_melody_master/common/lib/app_common/by_common_utils.dart';
import 'package:ai_golden_melody_master/common/lib/app_common/event/common_event.dart';
import 'package:ai_golden_melody_master/utils/assets.dart';
import 'package:ai_golden_melody_master/utils/by_color_utils.dart';
import 'package:ai_golden_melody_master/view/login/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../utils/data_service.dart';

///登录弹窗
class LoginDialog extends StatefulWidget {
  const LoginDialog({super.key});

  @override
  State<LoginDialog> createState() => _LoginDialogState();
}

class _LoginDialogState extends State<LoginDialog> {
  ///滑动控制器
  final ScrollController scrollController = ScrollController();

  ///初始化登录controller
  LoginController loginController = Get.put<LoginController>(LoginController());

  late StreamSubscription<bool> keyboardSubscription;

  final KeyboardVisibilityController keyboardVisibilityController =
      KeyboardVisibilityController();

  late StreamSubscription<RefreshPhoneNodeEvent> streamSubscription;

  @override
  void initState() {
    keyboardSubscription =
        keyboardVisibilityController.onChange.listen((bool visible) {
      if (!visible) {
        if (loginController.codeNode.hasFocus) {
          loginController.codeNode.unfocus();
        }

        if (loginController.phoneNode.hasFocus) {
          loginController.phoneNode.unfocus();
        }
      }
      Get.log('Keyboard visibility update. Is visible: $visible');
    });
    streamSubscription = eventBus.on<RefreshPhoneNodeEvent>().listen((e) {
      Get.log("===监听到了刷新事件===");
      loginController.phoneNode.requestFocus();
      if (mounted) {
        setState(() {});
      }
    });
    initFocusNode();
    super.initState();
  }

  @override
  void dispose() {
    keyboardSubscription.cancel();
    streamSubscription.cancel();
    super.dispose();
  }

  void initFocusNode() {
    Get.log("===初始化登录焦点===  ${loginController.phoneNode.hasFocus}");
    if (!loginController.phoneNode.hasFocus) {
      eventBus.fire(const RefreshPhoneNodeEvent());
      Get.log("===请求焦点===");
    }
  }

  ///输入手机号码
  Widget inputPhoneNumberView({
    required LoginController controller,
  }) {
    return Container(
      width: 1.sw,
      margin: EdgeInsets.only(
        left: 12.w,
        right: 12.w,
      ),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(14.w)),
      child: Column(
        children: [
          Container(
            width: 1.sw,
            height: 52.w,
            margin: EdgeInsets.only(
                left: 12.w, right: 12.w, top: 12.w, bottom: 16.w),
            decoration: BoxDecoration(
              color: ByColorUtil.color000000.withOpacity(0.02),
              // color: Colors.red,
              borderRadius: BorderRadius.circular(12.w),
              border: Border.all(
                color: controller.phoneNodeHighlight
                    ? ByColorUtil.color00CB64
                    : ByColorUtil.color000000.withOpacity(0.02),
                width: controller.phoneNodeHighlight ? 2.0 : 1.0,
              ),
            ),
            padding: EdgeInsets.only(
              left: 16.w,
              // top: 4.w,
            ),
            alignment: Alignment.center,
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 0.w),
                  child: Image.asset(
                    Assets.loginPhone,
                    width: 18.w,
                    height: 18.w,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(
                  width: 10.w,
                ),

                ///输入手机号
                Expanded(
                    child: Padding(
                  padding: EdgeInsets.only(bottom: 1.5.w),
                  child: TextField(
                    cursorColor: ByColorUtil.color00CB64,
                    focusNode: controller.phoneNode,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    style: TextStyle(
                        color: ByColorUtil.color121212,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      hintText: '请输入手机号',
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                          color: ByColorUtil.color000000.withOpacity(0.3),
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400),
                    ),
                    onChanged: (value) {
                      print('输入内容: $value');
                    },
                    controller: controller.phoneController,
                  ),
                )),
                if (controller.phoneHasValue)
                  InkResponse(
                    onTap: () {
                      controller.clearPhoneNumber();
                    },
                    child: Image.asset(
                      Assets.loginClose,
                      width: 20.w,
                      height: 20.w,
                      color: ByColorUtil.color000000.withOpacity(0.5),
                    ),
                  ),
                SizedBox(
                  width: 10.w,
                ),
                controller.sendPhoneCode
                    ? Container(
                        width: 30.w,
                        height: 25.w,
                        // color: Colors.red,
                        margin: EdgeInsets.only(right: 16.w),
                        alignment: Alignment.center,
                        child: Text(
                          "${controller.timeLeft}s",
                          style: TextStyle(
                            color: ByColorUtil.color000000.withOpacity(0.5),
                            fontWeight: FontWeight.w400,
                            fontSize: 16.sp,
                          ),
                        ),
                      )
                    : InkResponse(
                        child: Container(
                          // color: Colors.red,
                          height: 52.w,
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(right: 16.w),
                          child: Text(
                            controller.isFirstGetPhoneCode ? "获取验证码" : "立即获取",
                            style: TextStyle(
                                color: controller.getPhoneCode
                                    ? ByColorUtil.color00CB64
                                    : ByColorUtil.color000000.withOpacity(0.25),
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                        onTap: () {
                          controller.getPhoneCodeFromServer();
                        },
                      ),
                // SizedBox(
                //   width: 16.w,
                // ),
              ],
            ),
          ),
          inputPhoneCodeView(controller: controller),
        ],
      ),
    );
  }

  ///输入验证码
  Widget inputPhoneCodeView({
    required LoginController controller,
  }) {
    return Container(
      width: 1.sw,
      height: 52.w,
      margin: EdgeInsets.only(left: 12.w, right: 12.w, top: 12.w, bottom: 16.w),
      decoration: BoxDecoration(
        color: ByColorUtil.color000000.withOpacity(0.02),
        borderRadius: BorderRadius.circular(12.w),
        border: Border.all(
          color: controller.phoneCodeNodeHighlight
              ? ByColorUtil.color00CB64
              : ByColorUtil.color000000.withOpacity(0.02),
          width: controller.phoneCodeNodeHighlight ? 2.0 : 1.0,
        ),
      ),
      padding: EdgeInsets.only(
        left: 16.w,
        // top: 4.w,
      ),
      alignment: Alignment.center,
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 0.w),
            child: Image.asset(
              Assets.phoneCode,
              width: 18.w,
              height: 18.w,
              color: Colors.grey,
            ),
          ),
          SizedBox(
            width: 10.w,
          ),

          ///输入验证码
          Expanded(
              child: Padding(
            padding: EdgeInsets.only(bottom: 1.5.w),
            child: TextField(
              cursorColor: ByColorUtil.color00CB64,
              focusNode: controller.codeNode,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: TextStyle(
                  color: ByColorUtil.color121212,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                hintText: '请输入验证码',
                border: InputBorder.none,
                hintStyle: TextStyle(
                    color: ByColorUtil.color000000.withOpacity(0.3),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400),
              ),
              onChanged: (value) {
                print('输入验证码内容: $value');
              },
              controller: controller.phoneCodeController,
            ),
          )),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 1.sh,
        child: GetBuilder<LoginController>(builder: (controller) {
          Get.log("height====>${controller.height}");
          DataService.onEvent(DataServiceEventName.loginNumber, {
          });
          return ListView(
            /// 禁止滑动
            physics: const NeverScrollableScrollPhysics(),
            controller: scrollController,
            children: [
              SizedBox(
                height: 1.sh - controller.height,
              ),
              SizedBox(
                height: controller.height,
                child: Stack(
                  children: [
                    ///登录弹窗的输入区域
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18.w)),
                      width: double.infinity,
                      padding: EdgeInsets.only(
                        top: 15.w,
                        left: 12.5.w,
                        right: 12.5.w,
                      ),
                    ),

                    Positioned(
                        top: 0,
                        child: Stack(
                          children: [
                            Image.asset(
                              // Assets.loginBg,
                              Assets.newPeopleLoginBg,
                              width: 1.sw,
                              height: 150.w,
                              fit: BoxFit.fitWidth,
                            ),
                            Positioned(
                              right: 0.w,
                              child: InkResponse(
                                onTap: () {
                                  controller.cancel();
                                  Get.back();
                                },
                                child: Container(
                                  padding:
                                      EdgeInsets.only(top: 10.w, right: 6.w),
                                  // color: Colors.red,
                                  alignment: Alignment.centerRight,
                                  child: Icon(
                                    Icons.close,
                                    color: ByColorUtil.color000000
                                        .withOpacity(0.5),
                                  ),
                                ),
                              ),
                            )
                          ],
                        )),

                    Positioned.fill(
                      top: 88.w,
                      child: inputPhoneNumberView(controller: controller),
                    ),

                    ///立即登录
                    Positioned(
                        top: 276.w,
                        left: 24.w,
                        right: 24.w,
                        child: Column(
                          children: [
                            InkResponse(
                              onTap: () {
                                ByCommonUtils.throttle(() {
                                  controller.loginWithVCode(
                                    context,
                                  );
                                }, delay: 1000);
                              },
                              child: Container(
                                width: 1.sw,
                                height: 52.0.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.0.w),
                                  gradient: const LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [
                                      Color(0xFF24FECF),
                                      Color(0xFFFFF13C),
                                    ],
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: Opacity(
                                  opacity: controller.couldLogin ? 1 : 0.3,
                                  child: Text(
                                    '立即登录',
                                    style: TextStyle(
                                        color: ByColorUtil.color121212,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.sp),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 32.w,
                            ),
                            InkResponse(
                                onTap: () {},
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        controller.updateConfirmPrivacy();
                                      },
                                      child: Container(
                                        color: Colors.transparent,
                                        alignment: Alignment.center,
                                        width: 24.w,
                                        height: 24.w,
                                        child: Container(
                                          width: 12.w,
                                          height: 12.w,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: ByColorUtil.color000000
                                                  .withOpacity(0.1),
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(12.w),
                                          ),
                                          alignment: Alignment.center,
                                          child: Container(
                                            width: 6.w,
                                            height: 6.w,
                                            decoration: BoxDecoration(
                                              color: controller.confirmPrivacy
                                                  ? ByColorUtil.color00CB64
                                                  : Colors.transparent,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                6.w,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      "已阅读并同意",
                                      style: TextStyle(
                                        color: ByColorUtil.color000000
                                            .withOpacity(0.5),
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    InkResponse(
                                      onTap: () {
                                        controller.openPrivacy();
                                      },
                                      child: Text(
                                        " 隐私政策、",
                                        style: TextStyle(
                                          color: ByColorUtil.color000000,
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    InkResponse(
                                      onTap: () {
                                        controller.openProtocol();
                                      },
                                      child: Text(
                                        "用户协议",
                                        style: TextStyle(
                                          color: ByColorUtil.color000000,
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
                            SizedBox(
                              height: 29.w,
                            ),
                          ],
                        )),

                    ///一键登录
                    // Positioned(
                    //     top: 350.w,
                    //     left: 24.w,
                    //     right: 24.w,
                    //     child: InkResponse(
                    //       onTap: () {},
                    //       child: Text(
                    //         textAlign: TextAlign.center,
                    //         "一键登录",
                    //         style: TextStyle(
                    //           fontSize: 15.sp,
                    //           color: Colors.white,
                    //         ),
                    //       ),
                    //     )),

                    ///立即登录
                    // Positioned(
                    //     top: 400.w,
                    //     child: InkResponse(
                    //         onTap: () {},
                    //         child: Row(
                    //           mainAxisAlignment: MainAxisAlignment.center,
                    //           children: [
                    //             GestureDetector(
                    //               onTap: () {
                    //                 controller.updateConfirmPrivacy();
                    //               },
                    //               child: Container(
                    //                 color: Colors.transparent,
                    //                 alignment: Alignment.center,
                    //                 width: 24.w,
                    //                 height: 24.w,
                    //                 child: Container(
                    //                   width: 12.w,
                    //                   height: 12.w,
                    //                   decoration: BoxDecoration(
                    //                     border: Border.all(
                    //                       color: Colors.white.withOpacity(0.5),
                    //                     ),
                    //                     borderRadius:
                    //                         BorderRadius.circular(12.w),
                    //                   ),
                    //                   alignment: Alignment.center,
                    //                   child: Container(
                    //                     width: 6.w,
                    //                     height: 6.w,
                    //                     decoration: BoxDecoration(
                    //                       color: controller.confirmPrivacy
                    //                           ? Colors.white
                    //                           : Colors.transparent,
                    //                       borderRadius: BorderRadius.circular(
                    //                         6.w,
                    //                       ),
                    //                     ),
                    //                   ),
                    //                 ),
                    //               ),
                    //             ),
                    //             Text(
                    //               "已阅读并同意",
                    //               style: TextStyle(
                    //                 color: Colors.white.withOpacity(0.5),
                    //                 fontSize: 12.sp,
                    //                 fontWeight: FontWeight.w400,
                    //               ),
                    //             ),
                    //             InkResponse(
                    //               onTap: () {
                    //                 controller.openPrivacy();
                    //               },
                    //               child: Text(
                    //                 " 隐私政策、",
                    //                 style: TextStyle(
                    //                   color: Colors.white,
                    //                   fontSize: 12.sp,
                    //                   fontWeight: FontWeight.w400,
                    //                 ),
                    //               ),
                    //             ),
                    //             InkResponse(
                    //               onTap: () {
                    //                 controller.openProtocol();
                    //               },
                    //               child: Text(
                    //                 "用户协议",
                    //                 style: TextStyle(
                    //                   color: Colors.white,
                    //                   fontSize: 12.sp,
                    //                   fontWeight: FontWeight.w400,
                    //                 ),
                    //               ),
                    //             ),
                    //           ],
                    //         ))),
                  ],
                ),
              ),
            ],
          );
        }));
  }
}
