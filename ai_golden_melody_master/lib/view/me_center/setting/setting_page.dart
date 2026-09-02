import 'dart:io';
import 'dart:ui';
import 'package:ai_golden_melody_master/navigator/app_pages.dart';
import 'package:ai_golden_melody_master/utils/assets.dart';
import 'package:ai_golden_melody_master/view/me_center/setting/setting_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:ai_golden_melody_master/common/lib/app_common/by_nav_router_utils.dart';

import '../../../common/lib/app_common/consts/build_config.dart';
import '../../../common/lib/app_http/channel.dart';
import '../../../model/user/user_info_bean.dart';
import '../../../utils/by_color_utils.dart';
import '../../lanuch_page/launch_controller.dart';

///设置页面
class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  Widget _itemView({
    required String text,
    String text2 = "",
    required VoidCallback click,
    int type = 0,
  }) {
    return InkResponse(
        onTap: () {
          Get.log("===点击了条目===");
          click();
        },
        child: Row(
          children: [
            Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
              ),
            ),
            const Spacer(),
            type == 0
                ? Icon(
              Icons.arrow_forward_ios,
              color: const Color.fromRGBO(255, 255, 255, 0.5),
              size: 15.w,
            )
                : Text(
              text2,
              style: TextStyle(
                color: const Color.fromRGBO(255, 255, 255, 0.5),
                fontSize: 12.sp,
              ),
            ),
          ],
        ),);
  }


  ///邀请码
  Widget _inviteCode() {
    ChannelType channelType = BuildConfig.instance.channelType;
    bool isPassChannelType = false;

    if (channelType == ChannelType.aiAndroidTest ||
        channelType == ChannelType.huawei ||
        channelType == ChannelType.huaweiHonor ||
        channelType == ChannelType.vivo ||
        channelType == ChannelType.xiaomi ||
        channelType == ChannelType.oppo ||
        channelType == ChannelType.baidu||
        channelType == ChannelType.tencent) {
      isPassChannelType = true;
    }

    bool isVip = Get.find<LaunchController>().isVip;

    if (Platform.isAndroid && isPassChannelType&&!isVip) {
      String inviteName = Get.find<LaunchController>().inviteName;

      return GestureDetector(
        onTap: () {
          UserInfoBean? userInfoBean = Get.find<LaunchController>().user.value;
          String boundInviteCode = "";
          Get.log("===userInfoBean=== ${userInfoBean?.toJson()}");

          if(userInfoBean!=null){

            Get.log("===userInfoBean=== ${userInfoBean.toJson()}");
            boundInviteCode = userInfoBean.boundInviteCode??"";
          }
          Get.toNamed(Routes.inviteFriendCodePage,arguments: {
            "boundInviteCode":boundInviteCode,
          });
        },
        child: Container(
          width: 1.sw,
          height: 54.w,
          margin: EdgeInsets.only(
            left: 12.w,
            right: 12.w,
            top: 31.w,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0xFF242926).withOpacity(0.5),
                const Color(0xFF1E1E1E).withOpacity(0.5),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          padding: EdgeInsets.only(left: 15.w,right: 15.w,),
          child:Row(
            children: [
              Text(
                inviteName,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: ByColorUtil.colorF1,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.arrow_forward_ios,
                color: const Color.fromRGBO(255, 255, 255, 0.5),
                size: 15.w,
              )
            ],
          )
        ),
      );
    }
    return const SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingController>(builder: (controller) {
      return Material(
        child: Container(
          color: const Color(0XFF121212),
          // color: Colors.white,
          child: ListView(
            padding: EdgeInsets.only(bottom: 180.w),
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
                            width: 136.w,
                          ),
                          Text(
                            "设置",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      )),
                ],
              ),
              SizedBox(
                height: 19.w,
              ),
              Image.asset(
                Assets.userLoginHeader,
                width: 76.w,
                height: 76.w,
              ),
              SizedBox(
                height: 20.w,
              ),
              Center(
                child: Text(
                  "成为音乐人，让AI音乐为您赚钱",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 10.w,
              ),
              GestureDetector(
                onTap: () async {
                  await controller.callPhone();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      Assets.callPhone,
                      width: 14.w,
                      height: 14.w,
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                    Text(
                      "客服电话：400-869-8538",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              ///邀请码
              _inviteCode(),

              ///
              Container(
                width: 1.sw,
                height: 100.w,
                margin: EdgeInsets.only(
                  left: 12.w,
                  right: 12.w,
                  top: 10.w,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color(0xFF242926).withOpacity(0.5),
                      const Color(0xFF1E1E1E).withOpacity(0.5),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                padding: EdgeInsets.only(left: 15.w,right: 15.w,top:20.w,bottom: 20.w ),
                child: Column(
                  children: [
                          _itemView(
                              text: "联系客服",
                              click: () {
                                controller.openCustomerService();
                              }),
                          const Spacer(),
                          _itemView(
                              text: "投诉与建议",
                              click: () {
                                controller.openComplaints();
                              }),
                  ],
                ),
              ),


              Container(
                width: 1.sw,
                height: 146.w,
                margin: EdgeInsets.only(
                  left: 12.w,
                  right: 12.w,
                  top: 10.w,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color(0xFF242926).withOpacity(0.5),
                      const Color(0xFF1E1E1E).withOpacity(0.5),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                padding: EdgeInsets.only(left: 15.w,right: 15.w,top:20.w,bottom: 20.w ),
                child: Column(
                  children: [
                          _itemView(
                              text: "用户协议",
                              click: () {
                                controller.openProtocol();
                              }),
                          const Spacer(),
                          _itemView(
                              text: "隐私政策",
                              click: () {
                                controller.openPrivacy();
                              }),
                    const Spacer(),
                          _itemView(
                              text: "会员服务协议",
                              click: () {
                                controller.openVip();
                              }),
                  ],
                ),
              ),


              Container(
                width: 1.sw,
                height: 192.w,
                margin: EdgeInsets.only(
                  left: 12.w,
                  right: 12.w,
                  top: 10.w,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color(0xFF242926).withOpacity(0.5),
                      const Color(0xFF1E1E1E).withOpacity(0.5),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                padding: EdgeInsets.only(left: 15.w,right: 15.w,top:20.w,bottom: 20.w ),
                child: Column(
                  children: [
                          _itemView(
                              text: "算法备案公示",
                              click: () {
                                controller.openAlgorithm();
                              }),
                          const Spacer(),
                          _itemView(
                              text: "关于我们",
                              click: () {
                                controller.openAboutUs();
                              }),
                    const Spacer(),

                          _itemView(
                              text: "用户信息",
                              click: () {
                                Get.toNamed(Routes.userProfile);
                              }),
                    const Spacer(),

                    _itemView(
                              text: "版本信息",
                              click: () {},
                              type: 1,
                              text2: controller.version),
                  ],
                ),
              ),

              ///备案号相关信息
              Column(
                children: [
                  SizedBox(
                    height: 10.w,
                  ),
                  Text(
                    controller.appConfig?.data?.icpFiling ?? "",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(
                    height: 2.w,
                  ),
                  Text(
                    controller.appConfig?.data?.algorithmFiling ?? "",
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
        ),
      );
    });
  }
}
