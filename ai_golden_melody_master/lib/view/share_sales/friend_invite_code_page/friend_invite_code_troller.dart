
import 'package:ai_golden_melody_master/common/lib/app_http/apis.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ai_golden_melody_master/common/lib/app_http/http_utils.dart';
import '../../lanuch_page/launch_controller.dart';


class FriendInviteCodeController extends GetxController {
  FocusNode focusNode = FocusNode();
  TextEditingController textEditingController = TextEditingController();

  ///当前容器高度
  double height = 96.w;

  bool isPostData = false;

  ///邀请背景图
  String inviteBgUrl = "";

  ///键盘拉起 刷新布局高度
  updateContainerHeight({
    bool keyboard = false,
  }) {
    if (keyboard) {
      height = 245.w;
    } else {
      height = 96.w;
    }
    update();
  }

  ///取消相关输入框的焦点
  unFocusRealNameFocusNode() {
    if (focusNode.hasFocus) {
      focusNode.unfocus();
    }
  }

  String inviteCode = "";

  ///已经绑定的邀请码
  String boundInviteCode = "";

  @override
  void onInit() {
    super.onInit();
    textEditingController.addListener(() {
      inviteCode = textEditingController.text.replaceAll(' ', "");
      update();
    });
    initData();
  }

  ///确认邀请码
  confirmInviteCode() {
    if (isPostData) {
      EasyLoading.showToast("正在核对邀请码，请勿重复点击～");
      return;
    }
    isPostData = true;
    if (inviteCode.isEmpty) {
      EasyLoading.showToast("请填写邀请码");
      isPostData = false;
      return;
    }
    HttpUtils.post(
      APIs.confirmInviteCode,
      {
        "inviteCode": inviteCode,
      },
      success: (data) {
        Get.log("===确认的邀请码信息===$data");
        isPostData = false;
        Get.find<LaunchController>().reloadUserInfo(
        );
        boundInviteCode = inviteCode;
        textEditingController.text = "";
        Get.log("===绑定的邀请码===$boundInviteCode");
        EasyLoading.showToast("绑定成功~");
        update();
      },
      fail: (code, msg) {
        isPostData = false;
        EasyLoading.showToast( msg);
      },
    );
  }

  initData(){
    inviteBgUrl = Get.find<LaunchController>().inviteBgUrl;
    final argument = Get.arguments;
    if(argument!=null){
      if(argument["boundInviteCode"]!=null){
        boundInviteCode = argument["boundInviteCode"];
      }
    }

    if(boundInviteCode.isNotEmpty){
      height=172.w;
    }
    update();
  }
}
