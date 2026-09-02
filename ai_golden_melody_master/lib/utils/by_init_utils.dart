import 'dart:io';
import 'package:ai_golden_melody_master/utils/wx_login_config.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:fk_user_agent/fk_user_agent.dart';
import 'package:flustars_flutter3/flustars_flutter3.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:umeng_common_sdk/umeng_common_sdk.dart';
import 'package:wechat_kit/wechat_kit.dart';
import 'package:ai_golden_melody_master/common/lib/app_common/package/byhy_package_utils.dart';
import 'package:ai_golden_melody_master/common/lib/app_common/aes/byhy_aes_storage_utils.dart';
import 'package:ai_golden_melody_master/common/lib/app_common/consts/const_keys.dart';
import 'by_color_utils.dart';

class ByInitUtils {

  static init() async {
    _initLoading();

    /// 初始化PF
    await _initPF();
    final version = await ByPackageUtils.version();
    await ByStorageUtils.saveString(ConstKeys.kAppVersion, version);
    await FkUserAgent.init();
    await WechatKitPlatform.instance.registerApp(
      appId: WxLoginConfig.kWechatAppID,
      universalLink: WxLoginConfig.kWechatUniversalLink,
    );

    initEasyRefresh();

    initAudioPlayer();

    // initUmeng();
  }

  static void _initLoading() {
    EasyLoading.instance
      ..maskColor = ByColorUtil.BlackColor.withOpacity(0.5)
      ..dismissOnTap = false
      ..indicatorType = EasyLoadingIndicatorType.cubeGrid
      ..maskType = EasyLoadingMaskType.none
      ..progressColor = Colors.yellow
      ..backgroundColor = Colors.green
      ..indicatorColor = ByColorUtil.TabTextColorSelected;
    // ..customAnimation = CustomAnimation();
  }

  static _initPF() async {
    SpUtil.getInstance();
  }

  // static void initEasyRefresh() {
  //   EasyRefresh.defaultHeaderBuilder = () => ClassicHeader(
  //         textStyle: TextStyle(
  //           fontSize: 12,
  //           color: ByColorUtil.CommonTextColor.withOpacity(0.5),
  //         ),
  //         messageStyle: TextStyle(
  //           fontSize: 10,
  //           color: ByColorUtil.CommonTextColor.withOpacity(0.5),
  //         ),
  //         succeededIcon: Icon(
  //           Icons.done,
  //           color: ByColorUtil.TabTextColorSelected.withOpacity(0.5),
  //         ),
  //         triggerOffset: 40,
  //         dragText: "下拉刷新",
  //         armedText: '释放开始刷新',
  //         readyText: '刷新中...',
  //         processingText: '刷新中...',
  //         processedText: '刷新成功',
  //         noMoreText: '没有更多数据了',
  //         failedText: '刷新失败',
  //         messageText: '最后更新 %T',
  //       );
  //   EasyRefresh.defaultFooterBuilder = () => ClassicFooter(
  //         // backgroundColor: Colors.red,
  //         dragText: '上拉加载更多',
  //         armedText: '释放开始加载',
  //         readyText: '加载中...',
  //         processingText: '加载中...',
  //         processedText: '加载成功',
  //         noMoreText: '没有更多数据了',
  //         failedText: '加载失败',
  //         messageText: '最后更新 %T',
  //         textStyle: TextStyle(
  //           fontSize: 12,
  //           color: ByColorUtil.CommonTextColor.withOpacity(0.5),
  //         ),
  //         messageStyle: TextStyle(
  //           fontSize: 10,
  //           color: ByColorUtil.CommonTextColor.withOpacity(0.5),
  //         ),
  //         succeededIcon: Icon(
  //           Icons.done,
  //           color: ByColorUtil.TabTextColorSelected.withOpacity(0.5),
  //         ),
  //       );
  // }

  static void initAudioPlayer() {
    // ByAudioPlayer.sharedInstance;
  }

  ///初始化友盟统计
  static void initUmeng() {
    ///初始化组件化基础库, 所有友盟业务SDK都必须调用此初始化接口。
    UmengCommonSdk.initCommon(
        '685dff5179267e021095fc6c', '68874103bc47b67d83c0ee91', 'Umeng');
    // 自动采集页面信息
    UmengCommonSdk.setPageCollectionModeAuto();
  }

  ///初始化上下拉刷新
  static void initEasyRefresh() {
    EasyRefresh.defaultHeaderBuilder = () => ClassicHeader(
      textStyle: TextStyle(
        fontSize: 12,
        color: Colors.white.withOpacity(0.5),
      ),
      messageStyle: TextStyle(
        fontSize: 10,
        color: Colors.white.withOpacity(0.5),
      ),
      succeededIcon: Icon(
        Icons.done,
        color: ByColorUtil.colorC1.withOpacity(0.5),
      ),
      triggerOffset: 40,
      dragText: "下拉刷新",
      armedText: '释放开始刷新',
      readyText: '刷新中...',
      processingText: '刷新中...',
      processedText: '刷新成功',
      noMoreText: '没有更多数据了',
      failedText: '刷新失败',
      messageText: '最后更新 %T',
    );
    EasyRefresh.defaultFooterBuilder = () => ClassicFooter(
      // backgroundColor: Colors.red,
      dragText: '上拉加载更多',
      armedText: '释放开始加载',
      readyText: '加载中...',
      processingText: '加载中...',
      processedText: '加载成功',
      noMoreText: '没有更多数据了',
      failedText: '加载失败',
      messageText: '最后更新 %T',
      textStyle: TextStyle(
        fontSize: 12,
        color: Colors.white.withOpacity(0.5),
      ),
      messageStyle: TextStyle(
        fontSize: 10,
        color: Colors.white.withOpacity(0.5),
      ),
      succeededIcon: Icon(
        Icons.done,
        color: ByColorUtil.colorC1.withOpacity(0.5),
      ),
    );
  }

}

// class CustomAnimation extends EasyLoadingAnimation {
//   @override
//   Widget buildWidget(
//       Widget child,
//       AnimationController controller,
//       AlignmentGeometry alignment,
//       ) {
//     return Image.asset(
//       "assets/common/loading_large.gif",
//       width: 120.w,
//       height: 124.h,
//     );
//   }
// }
