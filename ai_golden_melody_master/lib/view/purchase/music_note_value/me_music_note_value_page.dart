import 'dart:io';

import 'package:ai_golden_melody_master/model/user/user_info_bean.dart';
import 'package:ai_golden_melody_master/navigator/app_pages.dart';
import 'package:ai_golden_melody_master/utils/by_color_utils.dart';
import 'package:ai_golden_melody_master/view/lanuch_page/launch_controller.dart';
import 'package:ai_golden_melody_master/view/purchase/music_note_value/me_music_note_value_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../model/purchase/integral_pay_list_bean.dart';
import '../../../model/user/user_model.dart';
import '../../../utils/assets.dart';
import '../../publish/widget/member_contdown.dart';

///我的音符值
class MeMusicNoteValuePage extends StatefulWidget {
  const MeMusicNoteValuePage({super.key});

  @override
  State<MeMusicNoteValuePage> createState() => _MeMusicNoteValuePageState();
}

class _MeMusicNoteValuePageState extends State<MeMusicNoteValuePage> {
  @override
  void initState() {
    Get.find<MeMusicNoteValueController>().iniIosPaySuccessSubscription();
    super.initState();
  }

  @override
  void dispose() {
    Get.find<MeMusicNoteValueController>().cancelIosPaySuccessSubscription();
    Get.find<LaunchController>().reloadUserInfo();
    super.dispose();
  }

  ///音符值区域
  Widget _musicNoteValueArea() {
    UserInfoBean? userInfoBean = Get.find<LaunchController>().user.value;
    UserProfileResponse? userProfileResponse =
        Get.find<MeMusicNoteValueController>().userProfileResponse;

    return Column(
      children: [
        Text(
          userProfileResponse != null
              ? " ${userProfileResponse.data.notesNumber}"
              : "0",
          style: TextStyle(
            color: const Color.fromRGBO(255, 255, 255, 0.8),
            fontSize: 48.sp,
            fontWeight: FontWeight.w900,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 10.w,
            ),
            Text(
              "总音符值",
              style: TextStyle(
                color: const Color.fromRGBO(255, 255, 255, 0.5),
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(
              width: 2.w,
            ),
            // Image.asset(
            //   Assets.questionIcon,
            //   width: 12.w,
            //   height: 12.w,
            // )
          ],
        ),
        SizedBox(
          height: 20.w,
        ),
        Row(
          children: [
            SizedBox(
              width: 12.w,
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  Assets.purchaseBgItem,
                  width: 170.w,
                ),
                Text(
                  '赠送音符值:${userProfileResponse != null ? " ${userProfileResponse.data.giftNotesNumber}" : "0"}',
                  style: TextStyle(
                      fontSize: 14.sp, color: Colors.white.withOpacity(0.5)),
                ),
              ],
            ),
            const Spacer(),
            Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  Assets.purchaseBgItem,
                  width: 170.w,
                ),
                Text(
                  '单购音符值:${userProfileResponse != null ? " ${userProfileResponse.data.purcNotesNumber}" : "0"}',
                  style: TextStyle(
                      fontSize: 14.sp, color: Colors.white.withOpacity(0.5)),
                ),
              ],
            ),
            SizedBox(
              width: 12.w,
            ),
          ],
        ),
        SizedBox(
          height: 30.w,
        ),
        Row(
          children: [
            SizedBox(
              width: 12.w,
            ),
            Text(
              "选择音符值套餐",
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
                padding: EdgeInsets.only(
                  top: 6.w,
                  left: 5.w,
                ),
                child: Row(
                  children: [
                    Text(
                      "(音符值",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 3.w),
                      child: Image.asset(
                        Assets.musicIcon,
                        width: 12.w,
                        height: 12.w,
                      ),
                    ),
                    Text(
                      ")",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                )),
            const Spacer(),
            if (Platform.isIOS)
              InkResponse(
                onTap: () {
                  Get.find<MeMusicNoteValueController>().iosRepair();
                },
                child: Padding(
                  padding: EdgeInsets.only(right: 10.w),
                  child: Text(
                    "恢复购买",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              )
          ],
        ),
        SizedBox(
          height: 5.w,
        ),
      ],
    );
  }

  ///音符值套餐
  Widget _musicNotePackage({
    required MeMusicNoteValueController controller,
  }) {
    return SizedBox(
      height: 175.w,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.only(top: 20.w, left: 12.w),
        children: [
          ...controller.integralRecords.map(
              (e) => _musicNotePackageItem(model: e, controller: controller)),
        ],
      ),
    );
  }

  ///音符值套餐单项
  Widget _musicNotePackageItem({
    required IntegralPayListBean model,
    required MeMusicNoteValueController controller,
  }) {
    bool isSelected =
        (controller.integralRecords.indexOf(model) == controller.selectedIndex);
    String discountText = "";
    if (model.money.isNotEmpty && model.crossedMoney.isNotEmpty) {
      double money = double.parse(model.money);
      double crossedMoney = double.parse(model.crossedMoney);
      discountText = "立省${(crossedMoney - money).toInt()}元";
    }
    return InkResponse(
      onTap: () {
        controller.integralItemClick(model);
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 122.w,
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E),
              borderRadius: BorderRadius.all(Radius.circular(12.w)),
              border: Border.all(
                color: isSelected
                    ? const Color(0xFF00CB64)
                    : const Color(0XFF173B29),
                width: 2.w,
              ),
              gradient: const LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF111B14),
                  Color(0xFF0F2815),
                ],
              ),
            ),
            margin: EdgeInsets.only(right: 10.w),
            padding: EdgeInsets.only(left: 12.w, right: 12.w, top: 26.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${model.integral}",
                      style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : Colors.white.withOpacity(0.8),
                        fontSize: 30.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 8.w),
                      child: Image.asset(
                        Assets.musicIcon2,
                        width: 12.w,
                        height: 12.w,
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 10.w,
                ),
                // Row(
                //   children: [
                //     Padding(
                //       padding: EdgeInsets.only(top: 6.w),
                //       child: Text(
                //         "¥",
                //         style: TextStyle(
                //           color: isSelected
                //               ? Colors.white
                //               : Colors.white.withOpacity(0.8),
                //           fontSize: 12.sp,
                //           fontWeight: FontWeight.w500,
                //         ),
                //       ),
                //     ),
                //     Text(
                //       model.money,
                //       style: TextStyle(
                //         color: isSelected
                //             ? Colors.white
                //             : Colors.white.withOpacity(0.8),
                //         fontSize: 20.sp,
                //         fontWeight: FontWeight.w500,
                //       ),
                //     ),
                //     SizedBox(
                //       width: 9.w,
                //     ),
                //     Padding(
                //       padding: EdgeInsets.only(top: 3.w),
                //       child: Text(
                //         "¥${model.crossedMoney}",
                //         style: TextStyle(
                //           color: const Color(0XFF687D6E),
                //           fontSize: 14.sp,
                //           fontWeight: FontWeight.w500,
                //           decoration: TextDecoration.lineThrough,
                //         ),
                //       ),
                //     )
                //   ],
                // ),

                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 6.w),
                          child: Text(
                            "¥",
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.8),
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Text(
                          model.money,
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : Colors.white.withOpacity(0.8),
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 3.w),
                      child: Text(
                        "¥${model.crossedMoney}",
                        style: TextStyle(
                          color: const Color(0XFF687D6E),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          Positioned(
              bottom: 0,
              child: Container(
                width: 122.w,
                alignment: Alignment.center,
                padding: EdgeInsets.only(bottom: 4.w),
                decoration: BoxDecoration(
                  color: isSelected
                      ? ByColorUtil.color00CB64
                      : ByColorUtil.color173B29,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(12.w),
                    bottomRight: Radius.circular(12.w),
                  ),
                ),
                child: Text(
                  discountText,
                  style: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : Colors.white.withOpacity(0.5),
                    fontWeight: FontWeight.w500,
                    fontSize: 14.sp,
                  ),
                ),
              )),
          if (model.isDefault == 1)
            Positioned(
              top: -10.w,
              child: Image.asset(
                Assets.newVipPriceIcon,
                width: 96.w,
                height: 20.w,
              ),
            ),
        ],
      ),
    );
  }

  ///支付方式
  Widget _payMethod({
    required MeMusicNoteValueController controller,
  }) {
    if (Platform.isAndroid) {
      ///这里微信 支付宝支付
      if (controller.availablePayMethods.isEmpty) {
        return const SizedBox();
      }
      return InkResponse(
        onTap: () {
          Get.log(
              "selectedIndex==>${controller.selectedPayMethodIndex} length ==>${controller.availablePayMethods.length}  ");
          if (controller.availablePayMethods.length >= 2) {
            if (controller.selectedPayMethodIndex == 0) {
              controller.changeSelectedPayMethodIndex(1);
            } else if (controller.selectedPayMethodIndex == 1) {
              controller.changeSelectedPayMethodIndex(0);
            }
          }
        },
        child: Container(
          width: 1.sw,
          decoration: BoxDecoration(
            color: Color(0XFF252525),
            borderRadius: BorderRadius.circular(8.w),
          ),
          margin: EdgeInsets.only(
            left: 12.w,
            right: 12.w,
            top: 15.w,
          ),
          padding:
              EdgeInsets.only(left: 12.w, right: 12.w, top: 11.w, bottom: 11.w),
          child: Row(
            children: [
              Image.asset(
                controller.availablePayMethods[
                            controller.selectedPayMethodIndex] ==
                        "alipay"
                    ? Assets.aliPayIcon
                    : Assets.wechatIcon,
                width: 18.w,
                height: 18.w,
              ),
              SizedBox(
                width: 8.w,
              ),
              Text(
                controller.availablePayMethods[
                            controller.selectedPayMethodIndex] ==
                        "alipay"
                    ? "支付宝支付"
                    : "微信支付",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontWeight: FontWeight.w500,
                  fontSize: 12.sp,
                ),
              ),
              const Spacer(),
              if (controller.availablePayMethods.length > 1)
                Image.asset(
                  Assets.changePayIcon,
                  width: 18.w,
                  height: 18.w,
                ),
            ],
          ),
        ),
      );
    }
    return const SizedBox();
  }

  ///积分购买按钮
  Widget _buyButton({
    required MeMusicNoteValueController controller,
  }) {
    return Container(
      decoration: const BoxDecoration(
        color: ByColorUtil.color121212,
      ),
      width: 1.sw,
      height: 157.h,
      padding: EdgeInsets.only(
        top: 4.w,
      ),
      child: Column(
        children: [
          ///倒计时区域
          Container(
            height: 32,
            margin: EdgeInsets.only(
              left: 38.w,
              right: 38.w,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(0),
              gradient: const LinearGradient(
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
                colors: [
                  Color.fromRGBO(255, 241, 60, 0),
                  Color.fromRGBO(0, 203, 100, 0.2),
                  Color.fromRGBO(255, 241, 60, 0),
                ],
                stops: [0.0, 0.5, 1.0],
              ),
            ),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  Assets.redEnvelopIcon2,
                  width: 20.w,
                  height: 20.w,
                ),
                MemberCountdown(
                  fontSize: 14.sp,
                  timeItemWidth: 24.w,
                  borderRadius: 4.w,
                  showMilliseconds: true,
                ),
                Text(
                  "后失效",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                  ),
                )
              ],
            ),
          ),
          Container(
            width: 1.sw,
            height: 60.h,
            margin: EdgeInsets.only(
              left: 27.w,
              right: 27.w,
              top: 5.w,
              bottom: 10.w,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              gradient: const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color(0xFF24FECF),
                  Color(0xFFFFF13C),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF24FECF).withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
              border: Border.all(
                color: Colors.white,
                width: 1,
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(30),
                onTap: () {
                  controller.buyEvent();
                },
                child: Center(
                  child: Text(
                    "立即购买",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Row(
            children: [
              InkResponse(
                onTap: () {
                  controller.agreementCheckedStatusChanged(
                      !controller.userAgreementChecked);
                },
                child: Row(
                  children: [
                    SizedBox(
                      width: 40.w,
                    ),
                    Container(
                      color: Colors.transparent,
                      alignment: Alignment.center,
                      width: 24.w,
                      height: 24.w,
                      child: Container(
                        width: 12.w,
                        height: 12.w,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.white.withOpacity(0.5),
                          ),
                          borderRadius: BorderRadius.circular(12.w),
                        ),
                        alignment: Alignment.center,
                        child: controller.userAgreementChecked
                            ? Container(
                                width: 6.w,
                                height: 6.w,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(6.w)),
                              )
                            : null,
                      ),
                    ),
                    Text(
                      "我已阅读并同意",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              InkResponse(
                onTap: () {
                  controller.openIntegral();
                },
                child: Text(
                  "《音符值服务协议》",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Text(
                "不支持退款",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MeMusicNoteValueController>(builder: (controller) {
      return Material(
        child: Container(
          color: const Color(0XFF121212),
          child: Stack(
            children: [
              SizedBox(
                height: 1.sh,
                child: Column(
                  children: [
                    ///导航页面
                    Stack(
                      children: [
                        Image.asset(
                          Assets.meSettingBg,
                          height: 106.w,
                          fit: BoxFit.fill,
                          width: 1.sw,
                        ),
                        Positioned(
                            left: 23.w,
                            top: 60.w,
                            right: 23.w,
                            child: SizedBox(
                              width: 1.sw,
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      controller.goBack();
                                    },
                                    child: const Icon(
                                      Icons.arrow_back_ios_new,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 108.w,
                                  ),
                                  Text(
                                    "我的音符值",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Spacer(),
                                  InkResponse(
                                    onTap: () {
                                      Get.toNamed(
                                          Routes.meMusicNoteValueListPage);
                                    },
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          Assets.purchaseMessage,
                                          width: 14.w,
                                          height: 14.w,
                                        ),
                                        SizedBox(
                                          width: 4.w,
                                        ),
                                        Text(
                                          "明细",
                                          style: TextStyle(
                                            color: const Color.fromRGBO(
                                                255, 255, 255, 0.8),
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )),
                      ],
                    ),

                    SizedBox(
                      height: 0.7.sh,
                      child: ListView(
                        padding: EdgeInsets.only(bottom: 150.w),
                        children: [
                          ///音符值区域
                          _musicNoteValueArea(),

                          ///音符值套餐列表
                          _musicNotePackage(controller: controller),

                          ///支付区域
                          _payMethod(controller: controller),

                          Container(
                            width: 1.sw,
                            decoration: BoxDecoration(
                              color: Color(0XFF252525),
                              borderRadius: BorderRadius.circular(8.w),
                            ),
                            margin: EdgeInsets.only(
                              left: 12.w,
                              right: 12.w,
                              top: 15.w,
                            ),
                            padding: EdgeInsets.only(
                                left: 12.w,
                                right: 12.w,
                                top: 11.w,
                                bottom: 11.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "音符值购买说明",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.sp,
                                  ),
                                ),
                                SizedBox(
                                  height: 12.w,
                                ),
                                Text(
                                  controller
                                          .appConfig?.data?.integralBuyNotice ??
                                      "",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white.withOpacity(0.5),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                child: _buyButton(controller: controller),
              )
            ],
          ),
        ),
      );
    });
  }
}
