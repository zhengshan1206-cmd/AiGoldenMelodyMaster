import 'dart:async';
import 'package:ai_golden_melody_master/common/lib/app_common/event/common_event.dart';
import 'package:ai_golden_melody_master/utils/by_color_utils.dart';
import 'package:ai_golden_melody_master/utils/common_event.dart';
import 'package:ai_golden_melody_master/view/ai/ai_write_music/ai_write_music_controller.dart';
import 'package:ai_golden_melody_master/view/lanuch_page/launch_controller.dart';
import 'package:ai_golden_melody_master/view/login/message_dialog.dart';
import 'package:easy_debounce/easy_throttle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ai_golden_melody_master/common/lib/app_http/apis.dart';
import 'package:ai_golden_melody_master/common/lib/app_http/http_utils.dart';
import 'package:ai_golden_melody_master/common/lib/by_device_info_utils.dart';

import 'package:ai_golden_melody_master/common/lib/app_common/by_common_utils.dart';
import 'package:ai_golden_melody_master/common/lib/app_http/intercept.dart';
import 'package:ai_golden_melody_master/common/lib/app_common/by_nav_router_utils.dart';
import '../../model/launch/app_config.dart';
import '../../model/launch/launch_info_bean.dart';
import '../../model/launch/login_info_bean.dart';
import '../../utils/data_service.dart';
import '../main/main_controller.dart';

///登录-业务逻辑
class LoginController extends GetxController {
  ///手机号码输入控制器
  TextEditingController phoneController = TextEditingController();

  ///验证码输入控制器
  TextEditingController phoneCodeController = TextEditingController();

  ///手机号码焦点
  final FocusNode phoneNode = FocusNode();

  ///验证码焦点
  final FocusNode codeNode = FocusNode();

  ///当前容器高度
  double height = 0.58.sh;

  ///手机号码输入框高亮
  bool phoneNodeHighlight = false;

  ///手机号码有值
  bool phoneHasValue = false;

  ///可以获取验证码
  bool getPhoneCode = false;

  ///获取验证码成功
  bool sendPhoneCode = false;

  ///初始获取验证码时间为60秒
  int timeLeft = 60;

  ///验证码的倒计时
  Timer? _timer;

  ///第一次获取验证码
  bool isFirstGetPhoneCode = true;

  ///验证码输入框高亮
  bool phoneCodeNodeHighlight = false;

  ///立即登录按钮可以点击
  bool couldLogin = false;

  ///隐私协议是否默认同意 从服务器获取
  bool confirmPrivacy = false;

  ///给外部调用一个登录成功的接口方法调用
  Function? loginSuccess;

  ///基础配置信息
  AppConfig? appConfig;

  ///是否正在请求服务器登录
  bool isLogin = false;

  ///是否登录失败
  bool isLoginFailure = false;

  @override
  void onInit() {
    initData();
    super.onInit();
  }

  @override
  void dispose() {
    cancel();
    super.dispose();
  }

  ///关闭登录弹窗
  void closeDialog() {
    cancel();
    Get.back();
  }

  ///初始化数据
  initData() {
    phoneController.addListener(() {
      if (phoneController.text.length > 11) {
        phoneController.value = TextEditingValue(
          text: phoneController.text.substring(0, 11),
          selection: const TextSelection.collapsed(offset: 11),
        );
      }

      if (phoneController.text.isNotEmpty) {
        phoneHasValue = true;
      } else {
        phoneHasValue = false;
      }

      if (phoneController.text.length == 11) {
        getPhoneCode = true;
      } else {
        getPhoneCode = false;
      }

      updateLoginBtn();
    });
    phoneCodeController.addListener(() {
      if (phoneCodeController.text.length > 4) {
        phoneCodeController.value = TextEditingValue(
          text: phoneCodeController.text.substring(0, 4),
          selection: const TextSelection.collapsed(offset: 4),
        );
      }

      ///验证码为4位   拉起登录
      if (phoneCodeController.text.length == 4 &&
          phoneController.text.length == 11) {
        if (!isLoginFailure) {
          loginWithVCode(Get.context!);
          if (phoneNode.hasFocus) {
            phoneNode.unfocus();
          }

          if (codeNode.hasFocus) {
            codeNode.unfocus();
          }
        }
      }
      updateLoginBtn();
    });
    phoneNode.addListener(() {
      if (phoneNode.hasFocus) {
        height = 0.8.sh;
        phoneNodeHighlight = true;
      } else {
        height = 0.58.sh;
        phoneNodeHighlight = false;
      }
      update();
    });
    codeNode.addListener(() {
      if (codeNode.hasFocus) {
        height = 0.8.sh;
        phoneCodeNodeHighlight = true;
      } else {
        height = 0.58.sh;
        phoneCodeNodeHighlight = false;
      }
      update();
    });

    appConfig = Get.find<LaunchController>().appConfig;
    if (appConfig == null) {
      getConfig();
    }
  }

  ///取消
  cancel() {
    phoneController.text = "";
    phoneCodeController.text = "";

    sendPhoneCode = false;
    timeLeft = 60;

    ///清理计时器资源
    _timer?.cancel();
    isLoginFailure = false;
    // phoneController.dispose();
    // phoneCodeController.dispose();
  }

  ///清除手机号码
  clearPhoneNumber() {
    phoneController.text = "";
  }

  ///开始获取验证码倒计时
  void _startGetPhoneCodeTimer() {
    if (!codeNode.hasFocus) {
      codeNode.requestFocus();
    }
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeLeft < 1) {
        ///倒计时结束，取消计时器
        _timer?.cancel();
        sendPhoneCode = false;
        timeLeft = 60;
        isFirstGetPhoneCode = false;
      } else {
        ///减少时间
        timeLeft--;
      }
      update();
    });
  }

  ///更新登录按钮
  updateLoginBtn() {
    if (phoneController.text.length == 11 &&
        phoneCodeController.text.length == 4) {
      // if (confirmPrivacy) {
      //   couldLogin = true;
      // } else {
      //   couldLogin = false;
      // }

      couldLogin = true;
    } else {
      couldLogin = false;
    }
    update();
  }

  ///从服务器获取验证码
  getPhoneCodeFromServer() async {
    if (!getPhoneCode) {
      EasyLoading.showToast("请输入正确的手机号码～");
      return;
    }

    if (!confirmPrivacy) {
      String privacy = "";
      String protocol = "";
      if (appConfig != null) {
        privacy = appConfig?.data?.agreement!.privacy ?? "";
        protocol = appConfig?.data?.agreement!.protocol ?? "";
      }

      await showDialog(
              context: Get.context!,
              builder: (context) {
                return MessageDialog(
                  privacy: privacy,
                  protocol: protocol,
                );
              },
              barrierColor: ByColorUtil.color000000.withOpacity(0.7),
              barrierDismissible: false)
          .then((value) {
        if (value != null) {
          confirmPrivacy = value["confirm"];
        }
        Get.log("获取的值===> $value");
      });
    }
    if (confirmPrivacy) {
      EasyThrottle.throttle("获取验证码接口", const Duration(seconds: 3), () {
        String phoneNumber = phoneController.text;
        getVCode(
            phone: phoneNumber,
            onSuccess: (value) {
              sendPhoneCode = true;
              _startGetPhoneCodeTimer();
              Get.log("获取验证码成功:${DateTime.now()}");
            });
      });
    }
  }

  ///登录事件
  loginEvent() async {
    ///todo 调用服务器接口
  }

  ///更新协议状态
  updateConfirmPrivacy() {
    confirmPrivacy = !confirmPrivacy;
    updateLoginBtn();
    update();
  }

  /// 获取手机验证码
  void getVCode({
    required String phone,
    void Function(dynamic)? onSuccess,
    void Function(int, String)? onFailed,
  }) async {
    final imei = await ByDeviceInfoUtils.deviceInfo();
    HttpUtils.post(
      APIs.sendVCode,
      {
        "phone": phone,
        "uuid": imei.item2,
      },
      success: (data) {
        EasyLoading.showToast(data["message"]);
        onSuccess?.call(data);
      },
      fail: (code, msg) {
        onFailed?.call(code, msg);
        EasyLoading.showToast(msg);
      },
    );
  }

  ///手机号码登录
  void loginWithVCode(
    BuildContext context,
  ) async {
    if (isLogin) {
      return;
    }
    isLogin = true;
    if (phoneController.text.isEmpty) {
      EasyLoading.showToast("请输入完整的手机号码～");
      isLogin = false;
      return;
    } else {
      if (phoneController.text.length < 11) {
        isLogin = false;
        EasyLoading.showToast("请输入完整的手机号码～");
        return;
      }
    }

    if (phoneCodeController.text.isEmpty) {
      isLogin = false;
      EasyLoading.showToast("请输入完整的验证码～");
      return;
    }

    if (!confirmPrivacy) {
      String privacy = "";
      String protocol = "";
      if (appConfig != null) {
        privacy = appConfig?.data?.agreement!.privacy ?? "";
        protocol = appConfig?.data?.agreement!.protocol ?? "";
      }

      await showDialog(
              context: Get.context!,
              builder: (context) {
                return MessageDialog(
                  privacy: privacy,
                  protocol: protocol,
                );
              },
              barrierColor: ByColorUtil.color000000.withOpacity(0.7),
              barrierDismissible: false)
          .then((value) {
        if (value != null) {
          confirmPrivacy = value["confirm"];
        }
        Get.log("获取的值===> $value");
      });
    }

    if (!confirmPrivacy) {
      isLogin = false;
      return;
    }

    EasyLoading.show();
    final imei = await ByDeviceInfoUtils.deviceInfo();
    HttpUtils.post(
      APIs.loginByPhone,
      {
        "phone": phoneController.text,
        "code": phoneCodeController.text,
        "uuid": imei.item2,
      },
      success: (data) async {
        DataService.onEvent(
            DataServiceEventName.loginSuc, {"method": "number"});
        isLogin = false;
        isLoginFailure = false;
        await _handleLoginResponse(data, context);
      },
      fail: (code, msg) {
        isLogin = false;
        isLoginFailure = true;
        DataService.onEvent(DataServiceEventName.loginFail, {"msg": msg});
        EasyLoading.dismiss();
        EasyLoading.showToast(msg);
      },
    );
  }

  ///登录成功
  Future<void> _handleLoginResponse(data, BuildContext context) async {
    ByCommonUtils.debugPrintObj("$data", tag: "sendMsg:----");
    EasyLoading.showToast('登录成功');
    eventBus.fire(const LoginEvent());
    EasyLoading.dismiss();
    if (data["status"] != 200) return;

    final LoginInfoBean userInfo = LoginInfoBean.fromJson(data["data"]);
    userInfo.isFormal = 1;

    LaunchInfoBean? launchInfo = Get.find<LaunchController>().launchInfo;
    launchInfo?.userId = userInfo.userId;
    launchInfo?.isVip = userInfo.isVip;
    launchInfo?.token = userInfo.token;
    launchInfo?.isFormal = userInfo.isFormal ?? 1;
    launchInfo?.canBoundCode = userInfo.canBoundCode;

    setToken(userInfo.token)?.then((onValue) {
      if (onValue) {
        Get.find<LaunchController>().reloadUserInfo(goBack: () {
          Get.back();
          phoneController.text = "";
          phoneCodeController.text = "";
          if (_timer != null) {
            ///倒计时结束，取消计时器
            _timer?.cancel();
            sendPhoneCode = false;
            timeLeft = 60;
            update();
          }
        });
        if (loginSuccess != null) {
          loginSuccess!();
          loginSuccess = null;
        } else {
          bool isMainController = Get.isRegistered<MainController>();
          bool isAiWriteMusicController =
              Get.isRegistered<AiWriteMusicController>();
          if (!isMainController) {
            Get.put(MainController(), permanent: true);
          }
          if (!isAiWriteMusicController) {
            Get.put(AiWriteMusicController(), permanent: true);
            Get.find<AiWriteMusicController>().initData();
          } else {
            Get.find<AiWriteMusicController>().initData();
          }
        }
      }
    });
  }

  ///获取基础配置
  void getConfig() async {
    await HttpUtils.get(
      APIs.config,
      {},
      success: (data) {
        appConfig = AppConfig.fromJson(data);
        Get.log("获取基础配置信息=======>${data}");
        update();
      },
      fail: (code, msg) {
        EasyLoading.showToast(msg);
      },
    );
  }

  ///打开隐私政策
  openPrivacy() {
    if (appConfig != null) {
      ByNavRouterUtils.jumpWebViewPage(
          Get.context!, "隐私政策", appConfig?.data!.agreement!.privacy ?? "");
    }
  }

  ///打开隐私政策
  openProtocol() {
    if (appConfig != null) {
      ByNavRouterUtils.jumpWebViewPage(
          Get.context!, "用户协议", appConfig?.data!.agreement!.protocol ?? "");
    }
  }
}

///刷新手机号码输入焦点事件
class RefreshPhoneNodeEvent {
  const RefreshPhoneNodeEvent();
}
