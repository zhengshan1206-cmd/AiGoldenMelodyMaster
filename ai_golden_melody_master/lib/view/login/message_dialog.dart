import 'package:ai_golden_melody_master/utils/assets.dart';
import 'package:ai_golden_melody_master/utils/by_color_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:ai_golden_melody_master/common/lib/app_common/by_nav_router_utils.dart';

///信息确认弹窗
class MessageDialog extends StatelessWidget {
  final String privacy;
  final String protocol;
  const MessageDialog({
    super.key,
    required this.privacy,
    required this.protocol,
  });
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          width: 351.w,
          height: 180.w,
          decoration: BoxDecoration(
            color:Colors.white,
            image: const DecorationImage(
                image: AssetImage(Assets.login_bg2), fit: BoxFit.fill),
            borderRadius: BorderRadius.circular(24.w),
          ),
          padding: EdgeInsets.only(bottom: 24.w, top: 2.w),
          child: Column(
            children: [
              Row(
                children: [
                  const Spacer(),
                  InkResponse(
                    onTap: () {
                      Get.back(result: {"confirm": false});
                    },
                    child: Container(
                      width: 30.w,
                      height: 30.w,
                      color: Colors.transparent,
                      alignment: Alignment.center,
                      child:Image.asset(Assets.iconClose,color: ByColorUtil.color6c6c6c,
                      width: 16.w,
                        height: 16.w,
                      )
                    ),
                  ),
                  SizedBox(
                    width: 5.w,
                  )
                ],
              ),
              Text(
                "隐私保护及用户协议",
                style: TextStyle(
                  color: ByColorUtil.color121212,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 10.w,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("我已阅读并同意 ",
                      style: TextStyle(
                        color:ByColorUtil.color121212.withOpacity(0.5),
                        fontSize: 15.sp,
                        fontWeight: FontWeight.normal
                      )),
                  GestureDetector(
                    onTap: () {
                      if(privacy.isNotEmpty){
                        ByNavRouterUtils.jumpWebViewPage(
                            context, "隐私政策", privacy);
                      }
                      Get.log("隐私政策===$privacy");
                    },
                    child: Text("隐私政策、",
                        style: TextStyle(
                          color:ByColorUtil.color121212.withOpacity(1),
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w400
                        )),
                  ),
                  GestureDetector(
                    onTap: () {
                      if(protocol.isNotEmpty){
                        ByNavRouterUtils.jumpWebViewPage(
                            context, "用户协议", protocol);
                      }
                      Get.log("用户协议===$protocol");
                    },
                    child: Text("用户协议",
                        style: TextStyle(
                            color:ByColorUtil.color121212.withOpacity(1),
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w400
                        )),
                  ),
                ],
              ),
              const Spacer(),
              InkResponse(
                onTap: () {
                  Get.back(result: {"confirm": true});
                },
                child: Container(
                  width: 1.sw,
                  height: 48.w,
                  margin: EdgeInsets.only(left: 24.w, right: 24.w),
                  decoration: BoxDecoration(
                      color: ByColorUtil.color00CB64,
                      borderRadius: BorderRadius.circular(12.w)),
                  alignment: Alignment.center,
                  child: Text(
                    '同意并登录',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                    ),
                  ),
                ),
              )
            ],
          )),
    );
  }
}
