import 'dart:developer';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flustars_flutter3/flustars_flutter3.dart';
import 'package:flutter/foundation.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../aes/byhy_aes_storage_utils.dart';
import 'const.dart';

///一些静态配置信息
class ConstKeys {
  static const String kToken = "token";
  static const String kClientType = "client_type";
  static const String kSign = "sign";
  static const String kChannel = "channel";
  static const String kTimeStamp = "timestamp";
  static const String kAccept = "Accept";
  static const String kContentType = "Content-Type";
  static const String kAppVersion = "appVersion";
  static const String kAppFramework = "app_framework";
  static const String kUserAgent = "User-Agent";

  static String userAgentData = "";

  static String audioAgree = "audio_agree";

  static String audioAgreePrivacy = "audio_agree_privacy";

  static String isFirstJoinApp = "is_first_join";

  static bool isFirst = false;

  ///App 首次进入同意使用相关协议
  static bool agreementChecked = false;

  initUserAgentData() async {
    userAgentData = await IosUserAgentUtil.getDefaultUserAgent();
    isFirst = SpUtil.getBool(ConstKeys.isFirstJoinApp, defValue: true) ?? true;
    agreementChecked =  SpUtil.getBool(Consts.kAgreementChecked) ?? false;
    log("userAgentData======> $userAgentData isFirst====> $isFirst");
  }

  updateIsFirst() {
    SpUtil.putBool(ConstKeys.isFirstJoinApp, false);
    isFirst = SpUtil.getBool(ConstKeys.isFirstJoinApp, defValue: true) ?? true;
  }
}

///苹果用户的 user-agent
class IosUserAgentUtil {
  static String? _defaultUserAgent;

  static Future<String> getDetailedUserAgent() async {
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.iOS) {
      try {
        /// 获取设备信息
        final deviceInfo = DeviceInfoPlugin();
        final iosInfo = await deviceInfo.iosInfo;

        /// 获取默认User-Agent
        String defaultUserAgent = await getDefaultUserAgent();

        /// 添加设备信息
        return '$defaultUserAgent (${iosInfo.model}; ${iosInfo.systemVersion})';
      } catch (e) {
        return await getDefaultUserAgent();
      }
    }

    return await getDefaultUserAgent();
  }

  static Future<String> getDefaultUserAgent() async {
    if (_defaultUserAgent != null) {
      return _defaultUserAgent!;
    }

    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.iOS) {
      try {
        final controller = WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted);

        _defaultUserAgent = await controller.getUserAgent();
        return _defaultUserAgent ??
            'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1';
      } catch (e) {
        return 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1';
      }
    }

    return 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1';
  }
}
