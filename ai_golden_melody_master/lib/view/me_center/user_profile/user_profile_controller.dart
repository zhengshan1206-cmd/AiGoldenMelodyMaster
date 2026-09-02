import 'package:ai_golden_melody_master/navigator/app_pages.dart';
import 'package:ai_golden_melody_master/view/ai/ai_write_music/ai_write_music_controller.dart';
import 'package:ai_golden_melody_master/view/main/main_controller.dart';
import 'package:flustars_flutter3/flustars_flutter3.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:ai_golden_melody_master/common/lib/app_http/apis.dart';
import 'package:ai_golden_melody_master/common/lib/app_http/http_utils.dart';
import 'package:ai_golden_melody_master/common/lib/app_ui/by_widgets_util.dart';
import '../../../common/lib/app_common/event/common_event.dart';
import '../../../model/launch/launch_info_bean.dart';
import '../../../model/user/user_info_bean.dart';
import '../../../utils/by_color_utils.dart';
import '../../lanuch_page/launch_controller.dart';
import '../../purchase/vip/vip_purchase_controller.dart';

///用户信息的controller
class UserProfileController extends GetxController {
  ///用户数据 从启动controller里获取
  UserInfoBean? userInfoBean;

  ///launchController
  late LaunchController launchController;

  @override
  void onInit() {
    super.onInit();
    initData();
  }

  ///初始化数据
  void initData() {
    userInfoBean = Get.find<LaunchController>().user.value;
    launchController = Get.find<LaunchController>();
    update();
  }

  ///复制id
  ///复制id
  copyId() {
    if (userInfoBean == null) {
      EasyLoading.showToast(
        "请登录您的账号～",
        maskType: EasyLoadingMaskType.none,
      );
    } else {
      ClipboardData data = ClipboardData(text: "${userInfoBean?.userId}");
      Clipboard.setData(data);
      EasyLoading.showToast(
        "复制ID成功～",
        maskType: EasyLoadingMaskType.none,
      );
    }
  }

  ///退出登录
  ///退出登陆
  void logout() {
    Get.dialog(
      confirmDialog(),
    );
  }

  ///
  void deleteAccount() {
    Get.dialog(
      deleteAccountDialog(),
    );
  }

  Widget confirmDialog() {
    return Center(
      child: SizedBox(
          width: double.infinity,
          height: 350.w,
          child: Stack(
            children: [
              Container(
                height: 350.w,
                margin: EdgeInsets.only(
                  left: 12.w,
                  right: 12.w,
                  bottom: 90.w,
                  top: 60.w,
                ),
                decoration: BoxDecoration(
                  color: ByColorUtil.color2e2e2e,
                  borderRadius: BorderRadius.circular(16.w),
                ),
              ),
              Positioned(
                top: 60.w,
                child: Image.asset(
                  "assets/common/hint_bg.png",
                  width: 1.sw,
                  height: 120.w,
                ),
              ),
              Positioned(
                left: 36.w,
                right: 36.w,
                top: 60.w,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 30.w,
                    ),
                    ByWidgetsUtil.commonText(
                        text: "温馨提示",
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                        textColor: Colors.white),
                    SizedBox(
                      height: 30.w,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 6.w,
                      ),
                      child: ByWidgetsUtil.commonText(
                          text: "您确定要退出吗？",
                          fontWeight: FontWeight.w400,
                          fontSize: 16.sp,
                          textColor: Colors.white),
                    ),
                    SizedBox(
                      height: 30.w,
                    ),
                    SizedBox(
                      height: 44.h,
                      child: Row(
                        children: [
                          Expanded(
                            child: ByWidgetsUtil.commonBtn(
                              borderRadius: 12.w,
                              title: "不退出",
                              bgColor: ByColorUtil.WhiteColor.withOpacity(0.1),
                              fontWeight: FontWeight.w500,
                              textColor: ByColorUtil.WhiteColor,
                              fontSize: 16.sp,
                              onClick: () async {
                                Get.back();
                              },
                            ),
                          ),
                          SizedBox(width: 20.w),
                          Expanded(
                            child: ByWidgetsUtil.commonBtn(
                              bgColor: ByColorUtil.color00CB64,
                              borderRadius: 12.w,
                              title: "退出",
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              textColor: Colors.white,
                              onClick: () async {
                                HttpUtils.post(
                                  APIs.logout,
                                  {},
                                  success: (data) async {
                                    if (data["status"] == 200) {
                                      Get.find<AiWriteMusicController>()
                                          .clearHistoryState();
                                      launchController.clearHistoryData();
                                      /// 此处不能直接跳转到 launch 页面（该页面会根据配置跳转到主页或者付费页）
                                      /// 改为直接调用 游客登陆 接口后，回到个人中心
                                      launchController.launch(
                                        onSuccess: (LaunchInfoBean bean) {
                                          /// 更新个人信息

                                          SpUtil.putBool("show_history_order", false);
                                          SpUtil.putBool("show_history_order2", false);
                                          eventBus.fire(const ShowHistoryOrderEvent());

                                          launchController.reloadUserInfo(
                                              successAction: (_) {});
                                          Get.back();
                                          Get.offAllNamed(Routes.main);
                                        },
                                      );
                                    }
                                  },
                                  fail: (code, msg) {
                                    EasyLoading.showToast(
                                      msg,
                                      maskType: EasyLoadingMaskType.none,
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Positioned(
                  top: 74.w,
                  right: 28.w,
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
          )),
    );
  }

  Widget deleteAccountDialog() {
    return Center(
      child: SizedBox(
          width: double.infinity,
          height: 550.w,
          child: Stack(
            children: [
              Container(
                height: 550.w,
                margin: EdgeInsets.only(
                  left: 12.w,
                  right: 12.w,
                  bottom: 90.w,
                  top: 60.w,
                ),
                decoration: BoxDecoration(
                  color: ByColorUtil.color2e2e2e,
                  borderRadius: BorderRadius.circular(16.w),
                ),
              ),
              Positioned(
                top: 60.w,
                child: Image.asset(
                  "assets/common/hint_bg.png",
                  width: 1.sw,
                  height: 120.w,
                ),
              ),
              Positioned(
                left: 36.w,
                right: 36.w,
                top: 60.w,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 30.w,
                    ),
                    ByWidgetsUtil.commonText(
                        text: "注销须知",
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                        textColor: Colors.white),
                    SizedBox(
                      height: 30.w,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 6.w,
                      ),
                      child: Column(
                        children: [
                          Text(
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 16.sp,
                                color: Colors.white),
                            "1、账户一旦注销，该账户下的信息、数据、记录将全部删除，且无法恢复。\n2、注销后，账户下的全部权益均被清除:且无法恢复。\n3、注销后，该账户绑定的第三方账户将被解除绑定，您可重新使用并注册成为新用户。\n4、提交注销后将在三个工作日内完成数据清除",
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30.w,
                    ),
                    SizedBox(
                      height: 44.h,
                      child: Row(
                        children: [
                          Expanded(
                            child: ByWidgetsUtil.commonBtn(
                              borderRadius: 12.w,
                              title: "继续注销",
                              bgColor: ByColorUtil.WhiteColor.withOpacity(0.1),
                              fontWeight: FontWeight.w500,
                              textColor: ByColorUtil.WhiteColor,
                              fontSize: 16.sp,
                              onClick: () async {
                                HttpUtils.post(
                                  APIs.accountCancellations,
                                  {},
                                  showLoading: true,
                                  success: (data) {
                                    EasyLoading.showToast(
                                      "注销成功",
                                      maskType: EasyLoadingMaskType.none,
                                    );
                                    launchController.launch(
                                      onSuccess: (p0) {
                                        Get.back();
                                        Get.offAllNamed(Routes.main);
                                      },
                                    );
                                  },
                                  fail: (code, msg) {
                                    EasyLoading.showToast(
                                      msg,
                                      maskType: EasyLoadingMaskType.none,
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                          SizedBox(width: 20.w),
                          Expanded(
                            child: ByWidgetsUtil.commonBtn(
                              bgColor: ByColorUtil.color00CB64,
                              borderRadius: 12.w,
                              title: "继续使用",
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              textColor: Colors.white,
                              onClick: () async {
                                Get.back();
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Positioned(
                  top: 74.w,
                  right: 28.w,
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
          )),
    );
  }
}
