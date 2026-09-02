import 'dart:io';

import 'package:ai_golden_melody_master/common/lib/app_common/by_common_utils.dart';
import 'package:ai_golden_melody_master/common/lib/app_common/event/common_event.dart';
import 'package:ai_golden_melody_master/common/lib/app_http/apis.dart';
import 'package:ai_golden_melody_master/common/lib/app_http/http_utils.dart';
import 'package:ai_golden_melody_master/common/lib/app_purchase/wechat_buy_engine/ali_pay_order_bean.dart';
import 'package:ai_golden_melody_master/common/lib/app_purchase/wechat_buy_engine/bug_engine.dart';
import 'package:ai_golden_melody_master/model/launch/launch_info_bean.dart';
import 'package:ai_golden_melody_master/model/purchase/pay_method_bean.dart';
import 'package:ai_golden_melody_master/model/purchase/vip_model.dart';
import 'package:ai_golden_melody_master/model/purchase/wx_pay_order_bean.dart';
import 'package:ai_golden_melody_master/model/purchase/wx_yeepay_order_bean.dart';
import 'package:ai_golden_melody_master/view/publish/beans/upgrade_vip_bean.dart';
import 'package:ai_golden_melody_master/view/purchase/diaglog/pay_agreement_dialog.dart';
import 'package:ai_golden_melody_master/view/purchase/diaglog/pay_confirmation.dart';
import 'package:ai_golden_melody_master/view/purchase/diaglog/pay_success_dialog.dart';
import 'package:alipay_kit/alipay_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:wechat_kit/wechat_kit.dart';
import '../../../../model/user/user_info_bean.dart';
import '../../../../utils/assets.dart';
import '../../../../utils/by_color_utils.dart';
import '../../../lanuch_page/launch_controller.dart';
import '../vip_purchase_controller.dart';
import '../../../../navigator/app_pages.dart';

class MemberPayUpgradeController extends GetxController
    with WidgetsBindingObserver {
  ///默认的会员类型数据
  static List<VipTypeModel> vipTypeModelList = [
    VipTypeModel(
      image: Assets.vipBg1,
      type: 0,
      vipHeaderImage: Assets.vipHeaderIcon,
      userMessageBgIconPath: Assets.vipMessageIcon1,
      userMessageColor: ByColorUtil.colorCCA869,
      userMessageText: "尊享音乐达人",
      userMessageIconPath: Assets.vipId1,
    ),
    VipTypeModel(
      image: Assets.vipBg2,
      type: 1,
      vipHeaderImage: Assets.vipHeaderIcon2,
      userMessageBgIconPath: Assets.vipMessageIcon2,
      userMessageColor: ByColorUtil.colorC98465,
      userMessageText: "高级音乐人",
      userMessageIconPath: Assets.vipId2,
    ),
    VipTypeModel(
      image: Assets.vipBg3,
      type: 2,
      vipHeaderImage: Assets.vipHeaderIcon3,
      userMessageBgIconPath: Assets.vipMessageIcon3,
      userMessageColor: ByColorUtil.color00CB64,
      userMessageText: "创作音乐人",
      userMessageIconPath: Assets.vipId3,
    ),
  ];

  ///会员核心权益集合数据
  List<VipRightIconModel> vipRightIconModel = const [
    VipRightIconModel(
      iconPath: Assets.vipRight1,
      title1: "商用版权授权",
      title2: "可支持商用发现变现",
    ),
    VipRightIconModel(
      iconPath: Assets.vipRight2,
      title1: "助力极速发行",
      title2: "伴奏·分轨·简谱·下载",
    ),
    VipRightIconModel(
      iconPath: Assets.vipRight3,
      title1: "全站攻略随心看",
      title2: "发行+著作权申请教程",
    ),
    VipRightIconModel(
      iconPath: Assets.vipRight4,
      title1: "解锁所有功能",
      title2: "全部写歌模式随心用",
    ),
    VipRightIconModel(
      iconPath: Assets.vipRight5,
      title1: "专属客服陪跑",
      title2: "人工客服在线陪跑",
    ),
    VipRightIconModel(
      iconPath: Assets.vipRight6,
      title1: "训练自有声音",
      title2: "支持用自己声音写歌",
    ),
    VipRightIconModel(
      iconPath: Assets.vipRight7,
      title1: "灵感+大师模式",
      title2: "精创精品爆款作品",
    ),
    VipRightIconModel(
      iconPath: Assets.vipRight8,
      title1: "客服在线指导",
      title2: "在线客服贴心服务",
    ),
    VipRightIconModel(
      iconPath: Assets.vipRight9,
      title1: "精选攻略随心看",
      title2: "精选攻略助力创作",
    ),
  ];

  ///用户数据 从启动controller里获取
  UserInfoBean? userInfoBean;

  ///本地配套的vipTypeModel
  VipTypeModel selectedVipTypeModel = vipTypeModelList.first;

  ///当前会员权益
  List<Creation> creation = [];

  ///升级会员权益 <=30
  List<Creation> upgradeCreation = [];

  ///升级会员权益 90
  List<Creation> upgradeAdvanced = [];

  ///升级会员权益 >=365
  List<Creation> upgradeExclusive = [];

  ///支付方式
  String paySupport = Platform.isAndroid ? "wxpay,alipay,yeepay" : "apple";

  ///VIP升级套餐列表
  List<UpgradeVipBean> vipRiseHappys = [];

  ///支付方式
  List<PayMethodBean> payMethodBeans = [];

  ///用户选中的支付方式
  int selectedPayMethodIndex = 0;

  ///当前支持的支付方式
  String supportPayMethods = "";

  ///是否阅读协议
  bool isReadAgreement = false;

  ///购买须知
  String purchaseNotice = "";

  ///当前选中的套餐索引
  int selectedVipRiseHappyIndex = 0;

  ///订单id
  String orderID = "";

  ///是否是易宝支付
  bool isYeepayException = false;

  ///订单是否在查询中
  bool isOrderQuerying = false;

  @override
  void onInit() {
    WidgetsBinding.instance.addObserver(this); // 添加生命周期监听
    initData();
    getVipRiseHappys();

    ///支付监听
    subscribePayResult();
    super.onInit();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    if (Platform.isAndroid) {
      PaymentUtil().cancelSubscribeWXPayResp();
      PaymentUtil().cancelSubscribeAliPayResp();
    }
    super.onClose();
  }

  initData() {
    userInfoBean = Get.find<LaunchController>().user.value;
    if (userInfoBean != null) {
      if (userInfoBean!.vipLevel == 365) {
        selectedVipTypeModel = vipTypeModelList.first;
      } else if (userInfoBean!.vipLevel == 90) {
        selectedVipTypeModel = vipTypeModelList[1];
      } else if (userInfoBean!.vipLevel == 30) {
        selectedVipTypeModel = vipTypeModelList[2];
      }
    }

    loadDataFromServer();

    update();
  }

  ///加载数据
  loadDataFromServer() async {
    await HttpUtils.get(APIs.unlockMember, {}, success: (data) {
      VipModel vipModel = VipModel.fromJson(data);

      creation = vipModel.data.equity.creation;
      if (userInfoBean != null) {
        if (userInfoBean!.vipLevel == 365) {
          creation = vipModel.data.equity.exclusive;
        } else if (userInfoBean!.vipLevel == 90) {
          creation = vipModel.data.equity.advanced;
        }
      }

      upgradeCreation = vipModel.data.equity.creation;
      upgradeAdvanced = vipModel.data.equity.advanced;
      upgradeExclusive = vipModel.data.equity.exclusive;
      purchaseNotice = vipModel.data.buyNotice;

      update();
    });
  }

  ///返回
  goBack() {
    Get.back();
  }

  ///复制id
  copyId() {
    if (userInfoBean == null) {
      EasyLoading.showToast("请登录您的账号～");
    } else {
      ClipboardData data = ClipboardData(text: "${userInfoBean!.userId}");
      Clipboard.setData(data);
      EasyLoading.showToast("复制ID成功～");
    }
  }

  ///去客服配置页面
  void goChatOnlinePage() async {
    Get.find<LaunchController>().goChatOnlinePage();
  }

  /// 更多 - 跳转到教程页面
  void loadMore(int index) {
    Get.toNamed(Routes.strategyPage);
  }

  ///获取VIP升级套餐列表
  void getVipRiseHappys() {
    HttpUtils.post(APIs.vipRiseHappys, {
      "ver": 2,
      "support_pays": paySupport,
    }, success: (data) {
      byDebugPrint(data, tag: "获取VIP升级套餐列表22");
      final List items = data["data"]["items"] ?? [];
      List<UpgradeVipBean> typeBeans =
          items.map((e) => UpgradeVipBean.fromJson(e)).toList();
      vipRiseHappys = typeBeans;
      // byDebugPrint(data, tag: "获取VIP升级套餐列表22");

      ///支付方式的更新
      if (Platform.isAndroid) {
        final Map<String, dynamic> pays = data["data"]["pays"] ?? {};

        /// 支付列表
        /// 原生的微信支付
        final wxpayEnable = (pays["wxpay"] ?? 0) == 1;

        /// 易宝的微信小程序支付
        final yeepayEnable = (pays["yeepay"] ?? 0) == 1;
        payMethodBeans.clear();

        ///替换支付顺序为服务器下发的顺序
        pays.forEach((e1, e2) {
          Get.log("e1===>$e1  e2===>$e2");
          if (e2 == 1) {
            if (e1 == "wxpay") {
              payMethodBeans.add(PayMethodBean.fromJson({
                "payName": "微信支付",
                "icon": "assets/purchase/wechat_icon.png",
                "payNameKey": "wxpay",
              }));
            } else if (e1 == "alipay") {
              payMethodBeans.add(PayMethodBean.fromJson({
                "payName": "支付宝支付",
                "icon": "assets/purchase/alipay_icon.png",
                "payNameKey": "alipay",
              }));
            } else if (e1 == "yeepay") {
              payMethodBeans.add(PayMethodBean.fromJson({
                "payName": "微信支付",
                "icon": "assets/purchase/wechat_icon.png",
                "payNameKey": "yeepay",
              }));
            }
          }
        });
        if (wxpayEnable && yeepayEnable) {
          payMethodBeans.removeWhere((e) {
            return e.payNameKey == "wxpay";
          });
        }
      }
      if (payMethodBeans.isNotEmpty) {
        // 确保支付方式索引在有效范围内
        if (selectedPayMethodIndex >= payMethodBeans.length) {
          selectedPayMethodIndex = 0;
        }
        supportPayMethods = payMethodBeans[selectedPayMethodIndex].payNameKey;
      }
      update();
    });
  }

  ///切换支付方式 - 按顺序切换，到最后一个后从第一个开始
  void switchPayMethod() {
    if (payMethodBeans.isEmpty) return;

    // 确保索引在有效范围内
    if (selectedPayMethodIndex >= payMethodBeans.length) {
      selectedPayMethodIndex = 0;
    }

    // 切换到下一个支付方式
    selectedPayMethodIndex =
        (selectedPayMethodIndex + 1) % payMethodBeans.length;

    // 更新当前支持的支付方式
    supportPayMethods = payMethodBeans[selectedPayMethodIndex].payNameKey;

    update();
  }

  ///获取当前选中的支付方式名称
  String getCurrentPayMethodName() {
    if (payMethodBeans.isEmpty) return "暂无支付方式";
    if (selectedPayMethodIndex >= payMethodBeans.length) {
      selectedPayMethodIndex = 0;
    }
    return payMethodBeans[selectedPayMethodIndex].payName;
  }

  ///获取当前选中的支付方式图标
  String getCurrentPayMethodIcon() {
    if (payMethodBeans.isEmpty) return "assets/purchase/wechat_icon.png";
    if (selectedPayMethodIndex >= payMethodBeans.length) {
      selectedPayMethodIndex = 0;
    }
    return payMethodBeans[selectedPayMethodIndex].icon;
  }

  ///阅读协议
  agreementCheckedStatusChanged(bool status) {
    isReadAgreement = status;
    update();
  }

  ///切换套餐
  void switchVipRiseHappy(int index) {
    selectedVipRiseHappyIndex = index;
    getCurrentVipRights();
    update();
  }

  ///获取当前选中套餐的权益列表
  List<Creation> getCurrentVipRights() {
    if (vipRiseHappys.isEmpty) return [];

    // 确保索引在有效范围内
    if (selectedVipRiseHappyIndex >= vipRiseHappys.length) {
      selectedVipRiseHappyIndex = 0;
    }

    final selectedVip = vipRiseHappys[selectedVipRiseHappyIndex];
    final vipLevel = selectedVip.vipLevel;

    // 根据VIP等级返回对应的权益列表
    if (vipLevel <= 30) {
      return upgradeCreation;
    } else if (vipLevel == 90) {
      return upgradeAdvanced;
    } else if (vipLevel >= 365) {
      return upgradeExclusive;
    }
    return upgradeCreation; // 默认返回基础权益
  }

  ///套餐升级
  void upgradeVipTap() {
    if (isReadAgreement) {
      ///创建订单
      createUpgradePayOrder();
    } else {
      Get.dialog(PayAgreementDialog(
        onAgree: () {
          isReadAgreement = true;
          createUpgradePayOrder();
          update();
        },
      ));
    }
  }

  ///创建升级支付订单版本
  void createUpgradePayOrder() async {
    final String originalType = supportPayMethods;

    ///检查微信支付是否正常
    if (originalType == "wxpay" && Platform.isAndroid ||
        originalType == "yeepay" && Platform.isAndroid) {
      bool canWechatPay = await WechatKitPlatform.instance.isInstalled();
      if (!canWechatPay) {
        EasyLoading.showToast("由于您未安装微信，无法完成支付。请切换其他方式支付");
        return;
      }
    }
    if (originalType == "alipay" && Platform.isAndroid) {
      ///支付宝支付
      bool canAliPay = await AlipayKitPlatform.instance.isInstalled();
      if (!canAliPay) {
        EasyLoading.showToast("由于您未安装支付宝，无法完成支付。请切换其他方式支付");
        return;
      }
    }
    // 检查是否有有效的套餐选择
    if (vipRiseHappys.isEmpty ||
        selectedVipRiseHappyIndex >= vipRiseHappys.length) {
      EasyLoading.showToast("请选择有效的升级套餐");
      return;
    }
    EasyLoading.show();

    HttpUtils.post(
      APIs.createRiseOrderV2,
      {
        "pay": Platform.isAndroid ? originalType : "apple",
        "config_id": vipRiseHappys[selectedVipRiseHappyIndex].id,
        "support_pays": Platform.isAndroid ? "wxpay,alipay,yeepay" : "apple",
      },
      success: (data) {
        EasyLoading.dismiss();
        byDebugPrint(data["data"], tag: "创建支付订单:");
        orderID = data["data"]["id"];
        pullUpPayment(data["data"]);
      },
      fail: (code, msg) {
        EasyLoading.dismiss();
        EasyLoading.showToast(msg);
      },
    );
  }

  ///拉支付
  void pullUpPayment(data) async {
    if (Platform.isAndroid) {
      if (data["call_method"] == "wxpay") {
        ///微信支付
        WxPayOrderBean payOrderBean = WxPayOrderBean.fromJson(data);
        orderID = payOrderBean.id;
        PaymentUtil().wxPay(payOrderBean);
      } else if (data["call_method"] == "wxpay_mini") {
        isYeepayException = true;
        update();

        ///易宝微信支付
        YeepayPayOrderBean payOrderBean = YeepayPayOrderBean.fromJson(data);
        orderID = payOrderBean.id;
        PaymentUtil().wxMiniProgramPay(payOrderBean);
      } else if (data["call_method"] == "alipay") {
        ///支付宝支付
        AliPayOrderBean aliPayOrderBean = AliPayOrderBean.fromJson(data);
        orderID = aliPayOrderBean.id;
        PaymentUtil().aliPay(aliPayOrderBean);
      }
    } else if (Platform.isIOS) {}
  }

  queryOrderStatus({
    void Function()? onSuccess,
    void Function()? onFailed,
    int retryCount = 0,
  }) {
    if (retryCount > 2) {
      onFailed?.call();
      return;
    }
    HttpUtils.get(
      APIs.queryOrderStatus,
      {"id": orderID},
      success: (data) {
        byDebugPrint(data["data"], tag: "订单状态:");
        final status = data["data"]["order_status"] ?? "";
        if (status == 'SUCCESS') {
          eventBus.fire(const BuySuccessEvent());
          onSuccess?.call();
        } else if (status == 'FAIL') {
          onFailed?.call();
        } else {
          Future.delayed(const Duration(seconds: 3)).then((value) =>
              queryOrderStatus(
                  onSuccess: onSuccess,
                  onFailed: onFailed,
                  retryCount: retryCount + 1));
        }
      },
      fail: (code, msg) {
        EasyLoading.dismiss();
        isOrderQuerying = false;
        update();
      },
    );
  }

  /// 查询订单状态
  void _queryOrderStatus({String? loaddingText}) {
    isOrderQuerying = true;
    update();
    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 2000)
      ..maskType = EasyLoadingMaskType.custom
      ..indicatorType = EasyLoadingIndicatorType.cubeGrid
      ..indicatorColor = ByColorUtil.PurchasePriceTextColor
      ..loadingStyle = EasyLoadingStyle.light;
    EasyLoading.show(status: loaddingText, dismissOnTap: false);
    queryOrderStatus(
      onSuccess: () async {
        EasyLoading.dismiss();
        isOrderQuerying = false;
        update();

        /// 充值成功
        Get.find<LaunchController>().launch(
          onSuccess: (LaunchInfoBean bean) {
            showPaySuccessDialog();
          },
        );
      },
      onFailed: () {
        EasyLoading.dismiss();
        isOrderQuerying = false;
        update();
        showConfirmDialog();
      },
    );
  }

  ///支付监听
  void subscribePayResult() {
    if (Platform.isAndroid) {
      // 微信支付结果
      PaymentUtil().subscribeWXPayResp(
        Get.context!,
        onSuccess: () {
          _queryOrderStatus();
        },
        onFailure: () {
          // EasyLoading.showToast("支付失败");
        },
        onError: () {
          Get.log("支付异常");
        },
      );

      // 支付宝支付结果
      PaymentUtil().subscribeAliPayResp(
        Get.context!,
        onSuccess: () {
          // 支付成功,查询订单状态
          _queryOrderStatus();
        },
        onFailure: () {
          // EasyLoading.showToast("支付失败");
        },
        onError: () {
          Get.log("支付异常");
        },
      );
    }
  }

  ///订单查询失败，展示确认弹窗
  void showConfirmDialog() {
    isYeepayException = false;
    update();
    Get.dialog(
      PayConfirmationDialog(
        title: '确认失败',
        content: '获取订单失败，如果【已支付】\n请点击联系客服解决问题',
        confirmText: '联系客服',
        onConfirm: () {
          Get.find<LaunchController>().goChatOnlinePage();
        },
        onCancel: () {},
      ),
    );
  }

  ///支付成功，展示确认弹窗
  void showPaySuccessDialog() {
    Get.dialog(PaySuccessDialog(
      title: "会员升级成功",
      content: "恭喜您，会员升级成功，开启Ai音乐创作之旅吧！",
      confirmText: "开始创作",
      cancelText: "取消",
      onConfirm: () {
        Get.back();
      },
      onCancel: () {},
    ));
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    Future.delayed(const Duration(milliseconds: 800), () {
      if (state == AppLifecycleState.resumed) {
        if (isYeepayException &&
            !(Get.isDialogOpen ?? false) &&
            !isOrderQuerying) {
          isYeepayException = false;

          Get.dialog(PayConfirmationDialog(
            title: '支付确认',
            content: '支付成功，请点击【已支付】\n如未支付成功，请点击【取消】',
            confirmText: '已支付',
            cancelText: '取消',
            onConfirm: () {
              // 用户确认已支付，查询订单状态
              _queryOrderStatus();
            },
            onCancel: () {
              // 用户取消，不进行任何操作
            },
          ));
          update();
        }
      }
    });
  }
}
