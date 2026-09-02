import 'package:ai_golden_melody_master/utils/assets.dart';
import 'package:ai_golden_melody_master/utils/by_color_utils.dart';
import 'package:ai_golden_melody_master/view/me_center/user_profile/user_profile_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

///用户信息页面
class UserProfilePage extends StatelessWidget {
  const UserProfilePage({super.key});

  Widget userProfileArea({
    required UserProfileController controller,
  }) {
    return Container(
      margin: EdgeInsets.only(
        top: 4.w,
        left: 12.w,
        right: 12.w,
      ),
      decoration: BoxDecoration(
        color: ByColorUtil.color252525,
        borderRadius: BorderRadius.circular(12.w),
      ),
      padding: EdgeInsets.only(
        top: 18.w,
        left: 15.w,
        right: 15.w,
        bottom: 18.w,
      ),
      child: Column(
        children: [
          InkResponse(
            onTap: () {
              controller.copyId();
            },
            child: Row(
              children: [
                Text(
                  "用户ID",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const Spacer(),
                Text(
                  "${controller.userInfoBean?.userId}",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(
                  width: 4.w,
                ),
                Image.asset(
                  Assets.copyIcon,
                  width: 12.w,
                  height: 12.w,
                )
              ],
            ),
          ),
          SizedBox(
            height: 36.w,
          ),
          Row(
            children: [
              Text(
                "用户名",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const Spacer(),
              Text(
                "${controller.userInfoBean?.nickName}",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 36.w,
          ),
          Row(
            children: [
              Text(
                "手机号",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const Spacer(),
              Text(
                "${controller.userInfoBean?.phone}",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ByColorUtil.color121212,
      appBar: AppBar(
        backgroundColor: ByColorUtil.color121212,
        title: Text(
          "用户信息",
          style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.normal),
        ),
      ),
      body: GetBuilder<UserProfileController>(
        builder: (controller) {
          Get.log("用户的数据==> ${controller.userInfoBean!.toJson()}");

          return Column(
            children: [
              ///用户信息区域
              userProfileArea(
                controller: controller,
              ),
              const Spacer(),
              InkResponse(
                onTap: (){
                  controller.logout();
                },
                child: Container(
                  width: 1.sw,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05,),
                    borderRadius: BorderRadius.circular(12.w),
                  ),
                  margin: EdgeInsets.only(
                    left: 12.w,
                    right: 12.w,
                  ),
                  padding: EdgeInsets.only(top: 17.w,bottom: 17.w,),
                  alignment: Alignment.center,
                  child: Text('退出登录',style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: 14.sp,
                  ),
                  ),
                ),
              ),

              InkResponse(
                onTap: (){
                  controller.deleteAccount();
                },
                child: Container(
                  width: 1.sw,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(12.w),
                  ),
                  margin: EdgeInsets.only(
                    left: 12.w,
                    right: 12.w,
                  ),
                  padding: EdgeInsets.only(top: 17.w,bottom: 17.w,),
                  alignment: Alignment.center,
                  child: Text('注销账号',style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontWeight: FontWeight.w400,
                    fontSize: 14.sp,
                  ),
                  ),
                ),
              ),
              SizedBox(height: 26.w,),

            ],
          );
        },
      ),
    );
  }
}
