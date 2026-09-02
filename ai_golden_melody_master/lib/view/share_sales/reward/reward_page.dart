import 'dart:ui';

import 'package:ai_golden_melody_master/view/share_sales/reward/reward_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class RewardPage extends StatelessWidget {


  static Map<String, String>? split(String input) {
    // 定义正则表达式
    final regex = RegExp(r'^(\d+)\.(\d{2})$');

    // 匹配输入字符串
    final match = regex.firstMatch(input);

    if (match != null && match.groupCount == 2) {
      return {
        'integer': match.group(1)!,  // 小数点前部分（如 "1000"）
        'decimal': match.group(2)!   // 小数点后两位（如 "00"）
      };
    }

    return null; // 格式不匹配
  }


  const RewardPage({super.key});

  Widget _itemView({
    String title1 = "0.00",
    String title2 = "可提现(元)",
    required VoidCallback click,
  }) {
    double title1FontSize = 22.sp;
    Map<String,dynamic>? json = split(title1);
    Get.log("===json=== $json");
    String integer = "";
    String decimal = "";
    if(json!=null){
      if(json["integer"]!=null){
        integer = json["integer"];
      }
      if(json["decimal"]!=null){
        decimal = json["decimal"];
      }
    }

    // if(title1.length==7){
    //   title1FontSize = 20.sp;
    // }else if(title1.length>7){
    //   title1FontSize = 16.sp;
    // }
    return InkResponse(
      onTap: () {

      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 30.w,
            // color: Colors.green,
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  integer,
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Padding(padding: EdgeInsets.only(
                  top: 4.w,
                ),child: Text(
                  ".$decimal",
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),)
              ],
            )
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 10.w,
              ),
              Text(
                title2,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0XFFA0A0A7),
                ),
              ),
              // Image.asset(
              //   "assets/home/share_sales/question_icon.png",
              //   width: 10.w,
              //   height: 10.w,
              // )
            ],
          )
        ],
      ),
    );
  }

  ///提现方式
  Widget withdrawMethod({
    required RewardController controller,
  }) {

    if(controller.withdrawType==1){
     return InkResponse(
        onTap: () {
          controller.changePayMethod();
        },
        child: Container(
          height: 44.w,
          decoration: BoxDecoration(
              color: const Color(0XFF2E3038),
              borderRadius:
                  BorderRadius.circular(8.w)),
          alignment: Alignment.center,
          padding: EdgeInsets.all(12.w),
          child: Row(
            children: [
              ///支付icon
              Image.asset(
                "assets/home/share_sales/alipay_icon.png",
                width: 22.w,
                height: 22.w,
              ),
              SizedBox(
                width: 8.w,
              ),

              ///支付名字
              Text(
                "支付宝",
                style: TextStyle(
                  color: const Color(0XFFA0A0A7),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),

              const Spacer(),

              if(controller.payDataList.length==2)
                Image.asset(
                  "assets/home/share_sales/change_icon.png",
                  width: 22.w,
                  height: 22.w,
                ),
            ],
          ),
        ),
      );
    }

    if(controller.withdrawType==2){
      return InkResponse(
        onTap: () {
          controller.changePayMethod();
        },
        child: Container(
          height: 44.w,
          decoration: BoxDecoration(
              color: const Color(0XFF2E3038),
              borderRadius:
              BorderRadius.circular(8.w)),
          alignment: Alignment.center,
          padding: EdgeInsets.all(12.w),
          child: Row(
            children: [
              ///支付icon
              Image.asset(
                "assets/home/share_sales/we_chat_small_icon.png",
                width: 22.w,
                height: 22.w,
              ),
              SizedBox(
                width: 8.w,
              ),

              ///支付名字
              Text(
                "微信",
                style: TextStyle(
                  color: const Color(0XFFA0A0A7),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const Spacer(),
              if(controller.payDataList.length==2)
                Image.asset(
                  "assets/home/share_sales/change_icon.png",
                  width: 22.w,
                  height: 22.w,
                ),
            ],
          ),
        ),
      );
    }

    if(controller.withdrawType==3){

    }

    return InkResponse(
      onTap: () {
        controller.showPayDialog();
        // controller.showSuccessNoticeDialog();
        // controller.showFailureNoticeDialog(errorMsg: "失败了===");
      },
      child: Container(
        width: 1.sw,
        height: 44.w,
        decoration: BoxDecoration(
          color: const Color(0xFF00CB64).withOpacity(0.05),
          border: Border.all(
            color: const Color(0xFF00CB64).withOpacity(0.1),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(8.w),
        ),
        child: Center(
          child: Text(
            "绑定提现方式",
            style: TextStyle(
              color: const Color(0xFF00CB64),
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: GetBuilder<RewardController>(
        builder: (controller) {
          return InkResponse(
            onTap: () {
              controller.unFocusNode();
            },
            child: Stack(
              children: [
                Container(
                  width: 1.sw,
                  height: 1.sh,
                  decoration: const BoxDecoration(
                    color: Color(0XFF000000),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 56.w,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 12.w,
                          ),
                          InkResponse(
                              onTap: () {
                                Get.back();
                              },
                              child: Container(
                                width: 30.w,
                                height: 30.w,
                                alignment: Alignment.center,
                                color: Colors.transparent,
                                child: Image.asset(
                                  "assets/home/share_sales/go_back.png",
                                  width: 16.w,
                                  height: 16.w,
                                ),
                              )),
                          SizedBox(
                            width: 63.w,
                          ),
                          Container(
                            width: 180.w,
                            height: 24.w,
                            alignment: Alignment.center,
                            child: Text(
                              "奖励提现",
                              style: TextStyle(
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 1.sh-120.w,
                        child: ListView(
                          padding: EdgeInsets.zero,
                          children: [
                            ///累计奖励
                            Container(
                              width: 1.sw,
                              decoration: BoxDecoration(
                                color: const Color(0XFF1E1E1E),
                                borderRadius: BorderRadius.circular(10.w),
                              ),
                              margin: EdgeInsets.only(
                                top: 12.w,
                                left: 12.w,
                                right: 12.w,
                              ),
                              padding: EdgeInsets.only(
                                left: 12.w,
                                right: 12.w,
                                top: 14.w,
                                bottom: 11.w,
                              ),
                              child: Column(
                                children: [
                                  InkResponse(
                                    onTap: () {
                                      controller.showWithdrawPageDialog();
                                    },
                                    child: Row(
                                      children: [
                                        Text(
                                          "累计奖励 (元)",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const Spacer(),
                                        Text(
                                          "提现明细",
                                          style: TextStyle(
                                            color:
                                                Colors.white.withOpacity(0.8),
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 14.w,
                                  ),
                                  Center(
                                    child: Text(
                                      controller.cumulativeIncome,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 32.sp,
                                          color: Color(0XFF00CB64)),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 21.w,
                                  ),

                                  ///可提现 待提现 已提现
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _itemView(
                                          title1: controller.canWithdrawCash,
                                          // title1: "50000.00",
                                          title2: "可提现(元)",
                                          click: () {},
                                        ),
                                      ),
                                      Container(
                                        width: 1.0.w,
                                        height: 52.0.w,
                                        margin: EdgeInsets.only(
                                            left: 8.w, right: 8.w),
                                        decoration: const BoxDecoration(
                                          border: Border(
                                            left: BorderSide(
                                              width: 1.0,
                                              color: Colors
                                                  .transparent, // 基础颜色设为透明
                                            ),
                                          ),
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Color.fromRGBO(255, 255, 255, 0),
                                              Color.fromRGBO(255, 255, 255, 1),
                                              Color.fromRGBO(255, 255, 255, 0),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: _itemView(
                                          title1: controller.pending,
                                          // title1: "99900.99",
                                          title2: "待提现(元)",
                                          click: () {},
                                        ),
                                      ),
                                      Container(
                                        width: 1.0.w,
                                        height: 52.0.w,
                                        margin: EdgeInsets.only(
                                            left: 8.w, right: 8.w),
                                        decoration: const BoxDecoration(
                                          border: Border(
                                            left: BorderSide(
                                              width: 1.0,
                                              color: Colors
                                                  .transparent, // 基础颜色设为透明
                                            ),
                                          ),
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Color.fromRGBO(255, 255, 255, 0),
                                              Color.fromRGBO(255, 255, 255, 1),
                                              Color.fromRGBO(255, 255, 255, 0),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: _itemView(
                                          title1: controller.withdrawBalance,
                                          // title1: "99999.99",
                                          title2: "已提现(元)",
                                          click: () {},
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),

                            ///提现金额
                            Container(
                              width: 1.sw,
                              decoration: BoxDecoration(
                                color: const Color(0XFF1E1E1E),
                                borderRadius: BorderRadius.circular(10.w),
                              ),
                              margin: EdgeInsets.only(
                                top: 12.w,
                                left: 12.w,
                                right: 12.w,
                              ),
                              padding: EdgeInsets.only(
                                left: 12.w,
                                right: 12.w,
                                top: 14.w,
                                bottom: 11.w,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "提现金额",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.sp,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 12.w,
                                  ),
                                  Container(
                                    width: 1.sw,
                                    height: 44.w,
                                    decoration: BoxDecoration(
                                        color:  Colors.white.withOpacity(0.05),
                                        border: Border.all(
                                          color:  Colors.white.withOpacity(0.05),
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(8.w)),
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.only(
                                        left: 12.w, bottom: 2.w),
                                    child: TextField(
                                      cursorColor: const Color(0XFF98FC4A),
                                      focusNode: controller.focusNode,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        // FilteringTextInputFormatter.digitsOnly
                                        SixDigitNumberWithDecimalFormatter(),
                                      ],
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.bold),
                                      decoration: InputDecoration(
                                        hintText: '请输入要提现的金额',
                                        border: InputBorder.none,
                                        hintStyle: TextStyle(
                                            color:
                                                Colors.white.withOpacity(0.3),
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      onChanged: (value) {
                                        Get.log('输入的提现金额: $value');
                                      },
                                      controller:
                                          controller.moneyTextEditingController,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15.w,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "提现方式",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.sp,
                                        ),
                                      ),
                                      const Spacer(),
                                      if((controller.withdrawType==1||controller.withdrawType==2)&&controller.payDataList.length==1)
                                        InkResponse(
                                          onTap: (){
                                            controller.showPayDialog();
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            width: 24.w,
                                            height: 24.w,
                                            child: Image.asset("assets/home/share_sales/add_icon.png",
                                              width: 24.w,
                                              height: 24.w,
                                            ),
                                          ),
                                        )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 12.w,
                                  ),
                                  withdrawMethod(controller: controller),
                                ],
                              ),
                            ),

                            ///提现须知
                            Container(
                              width: 1.sw,
                              decoration: BoxDecoration(
                                color: const Color(0XFF1E1E1E),
                                borderRadius: BorderRadius.circular(8.w),
                              ),
                              margin: EdgeInsets.only(
                                top: 12.w,
                                left: 12.w,
                                right: 12.w,
                              ),
                              padding: EdgeInsets.only(
                                left: 12.w,
                                top: 14.w,
                                right: 12.w,
                                bottom: 24.w,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "提现须知",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.sp,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8.w,
                                  ),
                                  Text(
                                    controller.cashNotes,
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0XFFA0A0A7),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: 100.w,),

                          ],
                        ),
                      )
                    ],
                  ),
                ),

                ///底部按钮部分
                Positioned(
                  bottom: 0,
                  child: InkResponse(
                    onTap: () {
                      controller.withdrawPay();
                      // controller.showRealNameAuthDialog();
                    },
                    child: Container(
                        width: 1.sw,
                        height: 113.w,
                        decoration: const BoxDecoration(
                          // color: Color(0XFF0F0F12)
                          color: Color(0XFF121212),
                        ),
                        child: Opacity(
                          opacity:(controller.payDataList.isNotEmpty&&controller.withdrawMoney>0)? 1:0.3,
                          child: Container(
                            width: 1.sw,
                            margin: EdgeInsets.only(top: 27.w,left: 12.w,right: 12.w,bottom:34.w ),
                            decoration: BoxDecoration(
                              color: const Color(0XFF00CB64),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              "立即提现",
                              style: TextStyle(
                                color: const Color(0XFF162408),
                                fontWeight: FontWeight.bold,
                                fontSize: 17.sp,
                              ),
                            ),
                          ),
                        )),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}


/// 自定义输入格式化器：只允许数字和一个小数点，且总长度不超过6
class SixDigitNumberWithDecimalFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    // 限制总长度不超过6
    if (newValue.text.length > 12) {
      return oldValue;
    }

    // 只允许数字和一个小数点
    final regExp = RegExp(r'^(\d+)?(\.)?(\d{0,})?$');
    if (!regExp.hasMatch(newValue.text)) {
      return oldValue;
    }

    // 确保只存在一个小数点
    if (newValue.text.contains('.') &&
        newValue.text.indexOf('.') != newValue.text.lastIndexOf('.')) {
      return oldValue;
    }

    // 不允许以小数点开头
    if (newValue.text.startsWith('.')) {
      return oldValue;
    }

    return newValue;
  }
}
