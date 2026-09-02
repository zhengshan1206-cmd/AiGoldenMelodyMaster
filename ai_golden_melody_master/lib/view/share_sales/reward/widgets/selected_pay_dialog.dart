import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../reward_controller.dart';

class SelectedPayDialog extends StatelessWidget {
  const SelectedPayDialog({super.key});

  Widget _buildPay() {
    int withdrawType = Get.find<RewardController>().withdrawType;
    if (withdrawType == 1) {
      return Center(
        child: InkResponse(
          onTap: () {
            Get.find<RewardController>().bindWechatPay();
          },
          child: Column(
            children: [
              Image.asset(
                "assets/home/share_sales/wechat_icon.png",
                width: 44.w,
                height: 44.w,
              ),
              SizedBox(
                height: 8.w,
              ),
              Text(
                "微信支付",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontWeight: FontWeight.w400,
                  fontSize: 14.sp,
                ),
              )
            ],
          ),
        ),
      );
    }

    if (withdrawType == 2) {
      return Center(
        child: InkResponse(
          onTap: () {
            Get.find<RewardController>().bindAlipay();
          },
          child: Column(
            children: [
              Image.asset(
                "assets/home/share_sales/alipay_icon.png",
                width: 44.w,
                height: 44.w,
              ),
              SizedBox(
                height: 8.w,
              ),
              Text(
                "支付宝支付",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontWeight: FontWeight.w400,
                  fontSize: 14.sp,
                ),
              )
            ],
          ),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkResponse(
          onTap: () {
            Get.find<RewardController>().bindWechatPay();
          },
          child: Column(
            children: [
              Image.asset(
                "assets/home/share_sales/wechat_icon.png",
                width: 44.w,
                height: 44.w,
              ),
              SizedBox(
                height: 8.w,
              ),
              Text(
                "微信支付",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontWeight: FontWeight.w400,
                  fontSize: 14.sp,
                ),
              )
            ],
          ),
        ),
        SizedBox(
          width: 71.w,
        ),
        InkResponse(
          onTap: () {
            Get.find<RewardController>().bindAlipay();
          },
          child: Column(
            children: [
              Image.asset(
                "assets/home/share_sales/alipay_icon.png",
                width: 44.w,
                height: 44.w,
              ),
              SizedBox(
                height: 8.w,
              ),
              Text(
                "支付宝支付",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontWeight: FontWeight.w400,
                  fontSize: 14.sp,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.sw,
      height: 202.w,
      padding: EdgeInsets.only(
        left: 12.w,
        right: 12.w,
        top: 16.w,
      ),
      decoration: BoxDecoration(
          color: const Color(0XFF1E1E1E),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12.w),
            topRight: Radius.circular(12.w),
          ),
          border: Border.all(
            color: Colors.transparent,
          )),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "选择提现方式",
                style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const Spacer(),
              InkResponse(
                onTap: () {
                  Get.back();
                },
                child: Container(
                  width: 30.w,
                  height: 30.w,
                  alignment: Alignment.center,
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
            height: 32.w,
          ),
         _buildPay(),
        ],
      ),
    );
  }
}
