import 'package:ai_golden_melody_master/view/lanuch_page/launch_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../utils/by_color_utils.dart';
import '../reward_controller.dart';


///提现说明弹窗
class WithdrawNoticeDialog extends StatelessWidget {
  const WithdrawNoticeDialog({super.key});
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: 1.sw - 76.w,
        height: 216.w,
        child: Center(
          child: Container(
            width: 1.sw - 76.w,
            height: 216.w,
            decoration: BoxDecoration(
                color: const Color(0XFF404044),
                borderRadius: BorderRadius.circular(24.w)),
            alignment: Alignment.center,
            padding: EdgeInsets.only(
              bottom: 20.w,
              top: 30.w,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "说明",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 18.w,
                ),
                Text(
                  "提现说明具体内容",
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                    fontSize: 12.sp,
                  ),
                ),
                const Spacer(),
                InkResponse(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    width: 1.sw - 136.w,
                    height: 44.w,
                    decoration: BoxDecoration(
                        color: const Color(0XFF98FC4A),
                        borderRadius: BorderRadius.circular(12.w)),
                    alignment: Alignment.center,
                    child: Text(
                      "我知道了",
                      style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0XFF000000)),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

///提现成功弹窗
class WithdrawSuccessNoticeDialog extends StatelessWidget {
  const WithdrawSuccessNoticeDialog({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: double.infinity,
        height: 288.w,
        child: Stack(
          children: [
            Container(
              width: 1.sw,
              height: 288.w,
              margin: EdgeInsets.only(
                left: 12.w,
                right: 12.w,
              ),
              decoration: BoxDecoration(
                color: ByColorUtil.color2e2e2e,
                // color: Colors.red,
                borderRadius: BorderRadius.circular(16.w),
              ),
            ),
            Positioned(
              top: 0.w,
              left: 12.w,
              right: 12.w,
              child: Image.asset(
                "assets/common/hint_bg.png",
                // width: 1.sw-24.w,
                height: 120.w,
                fit: BoxFit.fitWidth,
              ),
            ),
            Positioned(
              left: 24.w,
              right: 24.w,
              top: 24.w,
              child:SizedBox(

                width: 1.sw,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/home/share_sales/pass_icon.png",
                      width: 140.w,
                      height: 74.w,
                    ),
                    SizedBox(
                      height: 22.w,
                    ),
                    Text(
                      "提现申请成功",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 16.sp,
                      ),
                    ),
                    SizedBox(
                      height: 10.w,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 35.w,
                        right: 35.w,
                      ),
                      child: Text(
                        "提现申请成功，请耐心等待，奖励将在7个工作日到账",
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 15.sp,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 32.w,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkResponse(
                          onTap: () {
                            Get.back();
                            Get.find<RewardController>().showWithdrawPageDialog();
                          },
                          child: Container(
                            width: 144.w,
                            height: 48.w,
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12.w)),
                            alignment: Alignment.center,
                            child: Text(
                              "奖励提现明细",
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 15.w,),
                        InkResponse(
                            onTap: () {
                              Get.back();
                            },
                            child: Container(
                              width: 144.w,
                              height: 48.w,
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
                                color:const Color(0XFF00CB64) ,
                                borderRadius: BorderRadius.circular(12.0.w),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                "我知道了",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            )),
                      ],
                    )
                  ],
                ),
              )),
            Positioned(
                top: 10.w,
                right: 20.w,
                child: InkResponse(
                  onTap: () {
                    Get.back();
                  },
                  child: Icon(
                    Icons.close,
                    color: Colors.white.withOpacity(0.4),
                  ),
                ))
          ],
        )
      ),
    );
  }
}


///提现失败弹窗
class WithdrawFailureNoticeDialog extends StatelessWidget {
  final String errorMsg;
  const WithdrawFailureNoticeDialog({super.key,required this.errorMsg,});
  @override
  Widget build(BuildContext context) {

    return     Center(
      child: SizedBox(
          width: double.infinity,
          height: 288.w,
          child: Stack(
            children: [
              Container(
                width: 1.sw,
                height: 288.w,
                margin: EdgeInsets.only(
                  left: 12.w,
                  right: 12.w,
                ),
                decoration: BoxDecoration(
                  color: ByColorUtil.color2e2e2e,
                  // color: Colors.red,
                  borderRadius: BorderRadius.circular(16.w),
                ),
              ),
              Positioned(
                top: 0.w,
                left: 12.w,
                right: 12.w,
                child: Image.asset(
                  "assets/common/hint_bg.png",
                  // width: 1.sw-24.w,
                  height: 120.w,
                  fit: BoxFit.fitWidth,
                ),
              ),
              Positioned(
                  left: 24.w,
                  right: 24.w,
                  top: 24.w,
                  child:SizedBox(

                    width: 1.sw,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/home/share_sales/no_pass_icon.png",
                          width: 140.w,
                          height: 74.w,
                        ),
                        SizedBox(
                          height: 22.w,
                        ),
                        Text(
                          "提现申请失败",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 16.sp,
                          ),
                        ),
                        SizedBox(
                          height: 10.w,
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: 35.w,
                            right: 35.w,
                          ),
                          child: Text(
                            "$errorMsg",
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Colors.white.withOpacity(0.5),
                              fontSize: 15.sp,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: 32.w,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkResponse(
                              onTap: () {
                                ///todo 跳转客服
                                Get.find<LaunchController>().openCustomerService();
                              },
                              child: Container(
                                width: 144.w,
                                height: 48.w,
                                decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12.w)),
                                alignment: Alignment.center,
                                child: Text(
                                  "咨询客服",
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 15.w,),
                            InkResponse(
                                onTap: () {
                                  Get.back();
                                },
                                child: Container(
                                  width: 144.w,
                                  height: 48.w,
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
                                    color:const Color(0XFF00CB64) ,
                                    borderRadius: BorderRadius.circular(12.0.w),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "我知道了",
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                )),
                          ],
                        )
                      ],
                    ),
                  )),
              Positioned(
                  top: 10.w,
                  right: 20.w,
                  child: InkResponse(
                    onTap: () {
                      Get.back();
                    },
                    child: Icon(
                      Icons.close,
                      color: Colors.white.withOpacity(0.4),
                    ),
                  ))
            ],
          )
      ),
    );
  }
}
