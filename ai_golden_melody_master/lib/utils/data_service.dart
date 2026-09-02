import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:umeng_common_sdk/umeng_common_sdk.dart';
import 'package:ai_golden_melody_master/common/lib/app_common/aes/byhy_aes_storage_utils.dart';
import 'package:ai_golden_melody_master/common/lib/app_common/consts/const.dart';

///数据统计，埋点上传服务
///

class DataService {
  ///上报事件
  static void onEvent(String eventName, Map<String, dynamic> params) async {
    // 检查用户是否已同意隐私政策
    final bool agreementChecked =
        ByStorageUtils.getBool(Consts.kAgreementChecked) ?? false;

    String device = 'unknown';
    if (agreementChecked) {
      // 只有在用户同意隐私政策后才收集设备信息
      if (Platform.isAndroid) {
        final androidInfo = await DeviceInfoPlugin().androidInfo;
        device = androidInfo.model;
      } else if (Platform.isIOS) {
        final iosInfo = await DeviceInfoPlugin().iosInfo;
        device = iosInfo.utsname.machine;
      }
      params['device'] = device;
      UmengCommonSdk.onEvent(eventName, params);
    }

    ///正式环境才上报
    // if(Environment.PRODUCTION.domain == APIs.apiPrefix) {
    // }
  }
}

class DataServiceEventName {
  ///APP启动
  static const String appFirstOpen = "app_first_open";

  ///隐私协议展示
  static const String privacyShow = "privacy_show";

  ///隐私协议点击确认
  static const String privacyContinue = "privacy_continue";

  ///隐私协议点击取消
  static const String privacyCancel = "privacy_cancel";

  ///进入OB流程
  static const String obShow = "ob_show";

  ///OB流程点击跳过
  static const String obClickSkip = "ob_click_skip";

  ///OB流程点击第一步
  static const String obNextClick1 = "ob_next1_click";

  ///OB流程点击第二步
  static const String obNextClick2 = "ob_next2_click";

  ///OB展示试听页面
  static const String obListenShow = "ob_listen_show";

  ///OB点击试听
  static const String obListenClick = "ob_listen_click";

  ///OB试听页面展示继续使用
  static const String obListenContinueShow = "ob_listen_continue_show";

  ///OB试用结束按钮点击继续
  static const String obListenContinueClick = "ob_listen_continue_click";

  ///OB试用结束按钮点击关闭
  static const String obListenCloseClick = "ob_listen_close_click";

  ///OB展示试听点击播放
  static const String obListenPlayClick = "ob_listen_play_click";

  ///OB展示试听点击返回
  static const String obListenBackClick = "ob_listen_back_click";

  ///OB展示试听点击学习发行教程
  static const String obListenStudyClick = "ob_listen_study_click";

  // ///OB试用结束按钮点击关闭
  // static const String obListenCloseClick = "ob_listen_close_click";

  ///进入首页
  static const String homeShow = "home_show";

  ///进入登录页
  static const String loginShow = "login_show";

  ///登陆页一键登获取状态
  static const String loginOneClickLoadingResult =
      "login_one_click_loading_result";

  ///登陆页展示一键登录
  static const String loginOneClick = "login_one_click";

  ///登陆页展示手机号登陆
  static const String loginNumber = "login_number";

  ///进入登录页
  static const String loginOtherClick = "login_other_click";

  ///登陆成功
  static const String loginSuc = "login_suc";

  ///进入登录页
  static const String loginFail = "login_fail";

  ///进入付费页
  static const String paywallShow = "paywall_show";

  ///创建订单
  static const String createOrder = "create_order";

  ///支付成功
  static const String paySuc = "pay_suc";

  ///支付失败
  static const String payFail = "pay_fail";
}
