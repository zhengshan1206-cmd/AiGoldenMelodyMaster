import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:wechat_kit/wechat_kit.dart';
import 'package:alipay_kit/alipay_kit.dart';
import '../../../../model/purchase/wx_pay_order_bean.dart';
import '../../../../model/purchase/wx_yeepay_order_bean.dart';
import '../../../../view/share_sales/reward/reward_controller.dart';
import '../../app_common/event/common_event.dart';
import 'ali_pay_order_bean.dart';
import 'by_debug_print.dart';

/// 微信 支付宝支付工具类 - 单例模式
class PaymentUtil {
  /// 私有静态实例
  static final PaymentUtil _instance = PaymentUtil._internal();

  /// 工厂方法获取单例
  factory PaymentUtil() => _instance;

  /// 私有构造函数
  PaymentUtil._internal();

  /// 初始化支付 SDK
  void initPayments({
    String kWechatAppID = "",
    String? kWechatUniversalLink,
  }) {
    try {
      /// 初始化微信 SDK
      WechatKitPlatform.instance.registerApp(
        appId: kWechatAppID,
        universalLink: kWechatUniversalLink,
      );
    } catch (e) {
      debugPrint("微信支付初始化失败: $e");
    }
  }

  /// 微信支付
  wxPay(WxPayOrderBean payOrderBean) {
    Get.log("===== wechat_pay2===");
    eventBus.fire(ShareDataEvent());
    WechatKitPlatform.instance.pay(
      appId: payOrderBean.info.appid,
      partnerId: payOrderBean.info.partnerid,
      prepayId: payOrderBean.info.prepayid,
      package: payOrderBean.info.package,
      nonceStr: payOrderBean.info.noncestr,
      timeStamp: payOrderBean.info.timestamp,
      sign: payOrderBean.info.sign,
    );
  }

  /// 易宝微信小程序支付
  wxMiniProgramPay(YeepayPayOrderBean payOrderBean) {
    eventBus.fire(ShareDataEvent());
    WechatKitPlatform.instance.launchMiniProgram(
      userName: payOrderBean.info.miniProgramOrgId,
      type: WechatMiniProgram.kRelease,
      path: payOrderBean.info.prePayTn,
    );
  }

  /// 支付宝支付
  aliPay(AliPayOrderBean payOrderBean) {
    AlipayKitPlatform.instance.pay(
      orderInfo: payOrderBean.info.orderInfo,
      isShowLoading: payOrderBean.info.isShowPayLoading,
    );
  }

  /// 订阅微信支付
  StreamSubscription<WechatResp>? _respSubs;

  ///订阅支付宝支付
  StreamSubscription<AlipayResp>? _alipaySubs;

  ///微信返回结果
  WechatPayResp? payResp;

  ///支付宝返回结果
  AlipayResp? alipayResp;

  void subscribeWXPayResp(
    BuildContext context, {
    void Function()? onSuccess,
    void Function()? onFailure,
    void Function()? onError,
    void Function()? onDone,
  }) {
    byDebugPrint("----subscribeWXPayResp", tag: "注册订阅:");
    _respSubs?.cancel();
    _respSubs = WechatKitPlatform.instance.respStream().listen(
      (resp) {
        if (resp is WechatPayResp) {
          payResp = resp;
          byDebugPrint("response: ${resp.toJson()}");
          if (resp.isSuccessful) {
            onSuccess?.call();
          } else {
            onFailure?.call();
          }
        } else if (resp is WechatLaunchMiniProgramResp) {
          /**
           * 由于易宝微信小程序取消支付后，返回的数据如下，
           * 【"isCancelled": false,"isSuccessful": true,】
              WechatLaunchMiniProgramResp ({
              "errorCode": 0,
              "errorMsg": null,
              "extMsg": "status=cancel",
              "isCancelled": false,
              "isSuccessful": true,
              })
           * 支付成功后的数据为：
           * 【"isCancelled": false,"isSuccessful": true,】
              WechatLaunchMiniProgramResp ({
              "errorCode": 0,
              "errorMsg": null,
              "extMsg": "status=success",
              "isCancelled": false,
              "isSuccessful": true,
              })
           * 无法通过 isSuccessful/isCancelled 的值来判断是否支付成功，
           * 暂时使用extMsg消息中包含 cancel 来判断是否取消支付
           * 暂时使用extMsg消息中包含 success 来判断是否取消支付
           */
          byDebugPrint("response: ${resp.toJson()}");
          if ((resp.extMsg ?? "").toLowerCase().contains("cancel")) {
            onFailure?.call();
          } else if (resp.isSuccessful &&
              (resp.extMsg ?? "").toLowerCase().contains("success")) {
            onSuccess?.call();
          } else {
            onFailure?.call();
          }
        }
      },
      onError: (e) {
        byDebugPrint("登陆失败：$e");
        onError?.call();
      },
      onDone: () {
        onDone?.call();
      },
      cancelOnError: true,
    );
  }

  void subscribeAliPayResp(
    BuildContext context, {
    void Function()? onSuccess,
    void Function()? onFailure,
    void Function()? onError,
    void Function()? onDone,
  }) {
    byDebugPrint("----subscribeAliPayResp", tag: "注册订阅:");
    _alipaySubs?.cancel();
    _alipaySubs = AlipayKitPlatform.instance.payResp().listen(
      (resp) {
        alipayResp = resp;
        byDebugPrint("response: ${resp.toJson()}");

        if (resp.isSuccessful) {
          onSuccess?.call();
        } else {
          onFailure?.call();
        }
      },
      onError: (e) {
        byDebugPrint("登陆失败：$e");
        onError?.call();
      },
      onDone: () {
        onDone?.call();
      },
    );
  }

  /// 取消订阅微信支付
  void cancelSubscribeWXPayResp() {
    byDebugPrint("----cancelSubscribeWXPayResp", tag: "取消订阅:");
    _respSubs?.cancel();
    _respSubs = null;
  }

  /// 取消订阅支付宝支付
  void cancelSubscribeAliPayResp() {
    byDebugPrint("----cancelSubscribeAliPayResp", tag: "取消订阅:");
    _alipaySubs?.cancel();
    _alipaySubs = null;
  }
}
