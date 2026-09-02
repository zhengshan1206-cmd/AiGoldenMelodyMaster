import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../reward_controller.dart';

///实名认证弹窗
class RealNameAuthenticationDialog extends StatefulWidget {
  const RealNameAuthenticationDialog({super.key});

  @override
  State<RealNameAuthenticationDialog> createState() =>
      _RealNameAuthenticationDialogState();
}

class _RealNameAuthenticationDialogState
    extends State<RealNameAuthenticationDialog> {
  late StreamSubscription<bool> keyboardSubscription;
  final KeyboardVisibilityController keyboardVisibilityController =
      KeyboardVisibilityController();
  bool keyboard = false;

  ///滑动控制器
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    keyboardSubscription =
        keyboardVisibilityController.onChange.listen((bool visible) {
      Get.find<RewardController>().updateContainerHeight(keyboard: visible);
      Get.log('Keyboard visibility update. Is visible: $visible');
    });
    super.initState();
  }

  @override
  void dispose() {
    keyboardSubscription.cancel();
    Get.find<RewardController>().clearData();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.transparent,
        child: InkResponse(
          splashColor: Colors.transparent, // 水波纹透明
          highlightColor: Colors.transparent, // 高亮透明
          radius: 0.0, // 水波纹半径为0
          onTap: () {
            Get.find<RewardController>().unFocusRealNameFocusNode();
          },
          child: SizedBox(
            width: 1.sw,
            height: 1.sh,
            child: GetBuilder<RewardController>(
              builder: (controller) {
                Get.log("height====>${controller.height}");

                return ListView(
                  /// 禁止滑动
                  physics: const NeverScrollableScrollPhysics(),
                  controller: scrollController,
                  padding: EdgeInsets.zero,
                  children: [
                    SizedBox(
                      height:(1.sh-controller.height),
                    ),
                    Material(
                      color: Colors.transparent,
                      child: Container(
                        width: 1.sw,
                        height: 454.w,
                        decoration: BoxDecoration(
                            color: const Color(0XFF1E1F24),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12.w),
                              topRight: Radius.circular(12.w),
                            )),
                        padding: EdgeInsets.only(
                          left: 12.w,
                          right: 9.w,
                          top: 13.w,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "实名认证",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17.sp,
                                  ),
                                ),
                                const Spacer(),
                                InkResponse(
                                  onTap: () {
                                    Get.back();
                                  },
                                  child: Container(
                                    width: 30.w,
                                    height: 30.w,
                                    alignment: Alignment.centerRight,
                                    child: Image.asset(
                                      "assets/home/share_sales/close_icon.png",
                                      width: 16.w,
                                      height: 16.w,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 14.w,
                            ),
                            Text(
                              "根据国家法律法规要求,需先完成实名认证后才可继续提现。",
                              style: TextStyle(
                                color: const Color(0XFFA0A0A7),
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            SizedBox(
                              height: 11.w,
                            ),
                            Container(
                              height: 54.w,
                              decoration: BoxDecoration(
                                color: const Color(0XFFFFD595).withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8.w),
                              ),
                              padding: EdgeInsets.only(
                                  top: 7.w, bottom: 7.w, left: 13.w),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(top: 3.w),
                                    child: Image.asset(
                                      "assets/home/share_sales/warning_icon.png",
                                      width: 14.w,
                                      height: 14.w,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 2.w,
                                  ),
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 1.sw - 66.w,
                                            child: Text(
                                              "您实名认证的信息、手机号必须和提现对应的支付宝、微信实名信息保持一致，否则不能提现成功",
                                              style: TextStyle(
                                                color: Color(0XFFFFD595),
                                                fontWeight: FontWeight.w400,
                                                fontSize: 13.sp,
                                              ),
                                              textAlign: TextAlign.left,
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 12.w,
                            ),
                            Container(
                              width: 1.sw,
                              height: 44.w,
                              decoration: BoxDecoration(
                                  color: const Color(0XFF2E3038),
                                  border: Border.all(
                                      color: const Color(0XFF4D4E56)),
                                  borderRadius: BorderRadius.circular(8.w)),
                              padding: EdgeInsets.only(left: 12.w, bottom: 3.w),
                              child: TextField(
                                cursorColor: const Color(0XFF98FC4A),
                                focusNode: controller.userNameFocusNode,
                                // keyboardType: TextInputType.number,
                                // inputFormatters: [
                                //   FilteringTextInputFormatter.digitsOnly
                                // ],
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold),
                                decoration: InputDecoration(
                                  hintText: '请输入您的姓名',
                                  border: InputBorder.none,
                                  hintStyle: TextStyle(
                                      color: Colors.white.withOpacity(0.3),
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w400),
                                ),
                                onChanged: (value) {
                                  Get.log('输入的用户姓名: $value');
                                },
                                controller: controller.userNameController,
                              ),
                            ),
                            SizedBox(
                              height: 12.w,
                            ),
                            Container(
                              width: 1.sw,
                              height: 44.w,
                              decoration: BoxDecoration(
                                  color: const Color(0XFF2E3038),
                                  border: Border.all(
                                    color: controller.idCardError
                                        ? const Color(0XFFFE5024)
                                        : const Color(0XFF4D4E56),
                                  ),
                                  borderRadius: BorderRadius.circular(8.w)),
                              padding: EdgeInsets.only(left: 12.w, bottom: 3.w),
                              child: TextField(
                                cursorColor: const Color(0XFF98FC4A),
                                focusNode: controller.userIdFocusNode,
                                inputFormatters: [
                                  IdCardTextInputFormatter(),
                                ],
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold),
                                decoration: InputDecoration(
                                  hintText: '请输入您的身份证号码',
                                  border: InputBorder.none,
                                  hintStyle: TextStyle(
                                      color: Colors.white.withOpacity(0.3),
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w400),
                                ),
                                onChanged: (value) {
                                  Get.log('输入的身份证号码: $value');
                                },
                                controller: controller.idController,
                              ),
                            ),
                            SizedBox(
                              height: 12.w,
                            ),
                            Container(
                              width: 1.sw,
                              height: 44.w,
                              decoration: BoxDecoration(
                                  color: const Color(0XFF2E3038),
                                  border: Border.all(
                                    color: controller.phoneNumberError
                                        ? const Color(0XFFFE5024)
                                        : const Color(0XFF4D4E56),
                                  ),
                                  borderRadius: BorderRadius.circular(8.w)),
                              padding: EdgeInsets.only(left: 12.w, bottom: 3.w),
                              child: TextField(
                                cursorColor: const Color(0XFF98FC4A),
                                focusNode: controller.phoneFocusNode,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(11),
                                ],
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold),
                                decoration: InputDecoration(
                                  hintText: '请输入您的手机号码',
                                  border: InputBorder.none,
                                  hintStyle: TextStyle(
                                      color: Colors.white.withOpacity(0.3),
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w400),
                                ),
                                onChanged: (value) {
                                  Get.log('输入的手机号码: $value');
                                },
                                controller: controller.phoneController,
                              ),
                            ),
                            SizedBox(
                              height: 11.w,
                            ),
                            _errorMessage(controller: controller),
                            SizedBox(
                              height: 24.w,
                            ),
                            InkResponse(
                              onTap: () {
                                controller.authentication();
                              },
                              child: Opacity(
                                opacity: (controller.userName.isNotEmpty &&
                                    controller.idCard.length == 18 &&
                                    controller.phoneNumber.length == 11)
                                    ? 1
                                    : 0.3,
                                child: SizedBox(
                                  width: 1.sw,
                                  height: 48.w,
                                  child: Container(
                                    width: 1.sw,
                                    height: 48.0.w,
                                    decoration: BoxDecoration(
                                      // gradient: const LinearGradient(
                                      //   begin: Alignment.centerLeft,
                                      //   end: Alignment.centerRight,
                                      //   colors: [
                                      //     Color(0xFF98FC4A),
                                      //     Color(0xFFD7F97D),
                                      //   ],
                                      //   stops: [0.38, 1.0],
                                      // ),
                                      borderRadius: BorderRadius.circular(15.0.w),
                                      color: Color(0XFF00CB64)
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      "立即认证",
                                      style: TextStyle(
                                        color: const Color(0XFF162408),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17.sp,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 38.w,
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                );
              },
            ),
          ),
        ));
  }

  Widget _errorMessage({
    required RewardController controller,
  }) {
    if (controller.idCardError) {
      return Text(
        "*身份证号输入有误",
        style: TextStyle(
          color: Color(0XFFFE5024),
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.left,
      );
    }

    if (controller.phoneNumberError) {
      return Text(
        "*手机号码输入有误",
        style: TextStyle(
          color: Color(0XFFFE5024),
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.left,
      );
    }

    if (controller.notMatch) {
      return Text(
        controller.notMatchMessage,
        style: TextStyle(
          color: Color(0XFFFE5024),
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.left,
      );
    }
    return const SizedBox();
  }
}

/// 自定义身份证输入格式化器
class IdCardTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // 限制总长度不超过18位
    if (newValue.text.length > 18) {
      return oldValue;
    }

    // 前17位只能是数字
    if (newValue.text.length <= 17) {
      if (!RegExp(r'^\d*$').hasMatch(newValue.text)) {
        return oldValue;
      }
    } else {
      // 第18位可以是数字或X/x
      final String lastChar = newValue.text.substring(17);
      if (!RegExp(r'^[\dXx]$').hasMatch(lastChar)) {
        return oldValue;
      }
    }

    return newValue;
  }
}
