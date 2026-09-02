import 'dart:async';
import 'dart:io';
import 'package:ai_golden_melody_master/navigator/app_pages.dart';
import 'package:ai_golden_melody_master/view/lanuch_page/launch_controller.dart';
import 'package:alipay_kit/alipay_kit.dart';
import 'package:flustars_flutter3/flustars_flutter3.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wechat_kit/wechat_kit.dart';
import 'package:ai_golden_melody_master/common/lib/app_common/by_common_utils.dart';
import 'package:ai_golden_melody_master/common/lib/app_common/event/common_event.dart';
import 'package:ai_golden_melody_master/common/lib/app_http/apis.dart';
import 'package:ai_golden_melody_master/common/lib/app_http/http_utils.dart';
import 'package:ai_golden_melody_master/common/lib/app_purchase/ios_purchase/ios_buy_engine.dart';
import 'package:ai_golden_melody_master/common/lib/app_purchase/wechat_buy_engine/ali_pay_order_bean.dart';
import 'package:ai_golden_melody_master/common/lib/app_purchase/wechat_buy_engine/bug_engine.dart';
import '../../../common/lib/app_ui/by_widgets_util.dart';
import '../../../model/launch/app_config.dart';
import '../../../model/purchase/integral_pay_list_bean.dart';
import '../../../model/purchase/wx_pay_order_bean.dart';
import '../../../model/purchase/wx_yeepay_order_bean.dart';
import '../../../model/user/user_model.dart';
import '../../../utils/by_color_utils.dart';
import '../../../utils/data_service.dart';

class MeMusicNoteValueController extends GetxController {
  @override
  void onInit() {
    integralInit();
    super.onInit();
  }

  ///初始化数据
  integralInit() {
    /// 初始化支付方式
    if (Platform.isAndroid) {
      currentPayMethod = "wxpay";
    } else {
      currentPayMethod = "applepay";
    }

    ///加载积分套餐列表
    loadScoreHappyList();
    getMemberData();

    appConfig = Get.find<LaunchController>().appConfig;
    if (appConfig == null) {
      getConfig();
    }

    PaymentUtil().subscribeWXPayResp(Get.context!, onSuccess: () {
      integralQueryOrder();
    });
    PaymentUtil().subscribeAliPayResp(Get.context!, onSuccess: () {
      integralQueryOrder();
    });
  }

  ///积分套餐列表
  List<IntegralPayListBean> integralRecords = [
    IntegralPayListBean(
        id: 100,
        appleVipId: "100",
        money: "298",
        mark: "",
        isDefault: 1,
        isAgreement: 1,
        unitIntegralMoney: "100",
        integral: 3680,
        crossedMoney: "598",
        desc: "",
        buttonTitle: ""),
    IntegralPayListBean(
        id: 101,
        appleVipId: "100",
        money: "168",
        mark: "",
        isDefault: 0,
        isAgreement: 1,
        unitIntegralMoney: "100",
        integral: 1888,
        crossedMoney: "338",
        desc: "",
        buttonTitle: ""),
    IntegralPayListBean(
        id: 102,
        appleVipId: "100",
        money: "99",
        mark: "",
        isDefault: 0,
        isAgreement: 1,
        unitIntegralMoney: "100",
        integral: 1000,
        crossedMoney: "198",
        desc: "",
        buttonTitle: "")
  ];

  ///选中的索引
  int selectedIndex = 0;

  ///支付支持
  String paySupport = Platform.isAndroid ? "wxpay,alipay,yeepay" : "applepay";

  ///接口下发支持支付
  Map<String, dynamic>? _integralPays;

  ///当前选中的支付方式
  String currentPayMethod = "wxpay";

  ///可用的支付方式列表
  List<String> availablePayMethods = [];

  /// 用户协议默认
  bool userAgreementChecked = false;

  ///是否默认同意协议 is_Agreement1是2否
  bool isAgreementChecked = true;

  ///当前下发vip协议是否选中
  bool agreementNum = true;

  ///接口下发按钮文案
  String memberBtnTxt = "立即购买";

  ///积分协议
  String? integralIllustrate;

  ///当前订单Id
  String orderId = "";

  ///是否需要弹窗提示支付状态
  bool needShowDialog = false;

  ///Ios支付工具
  IosBuyEngin iosBuyEngin = IosBuyEngin();

  /// 是否正在查询订单
  bool _isQueryingOrder = false;

  UserProfileResponse? userProfileResponse;

  ///用户选中的支付方式
  int selectedPayMethodIndex = 0;

  AppConfig? appConfig;

  bool agreementChecked = false;

  LaunchController launchController = Get.find<LaunchController>();

  ///苹果支付成功后查询订单状态的监听
  late StreamSubscription _iosPaySuccessSubscription;
  late StreamSubscription _iosBuyStreamSubscription;

  ///获取音符值套餐列表
  void loadScoreHappyList() {
    HttpUtils.get(
      APIs.scoreHappys,
      {
        "ver": 2,
        "support_pays": paySupport,
      },
      success: (data) {
        byDebugPrint(data, tag: "----音符值套餐列表");
        final List items = data["data"]["items"] ?? [];
        if (items.isEmpty) {
          EasyLoading.showToast("暂无可用的积分套餐");
          return;
        }
        final List<IntegralPayListBean> records =
            items.map((ele) => IntegralPayListBean.fromJson(ele)).toList();
        integralIllustrate = data["data"]["integral_illustrate"] ?? "";
        if (integralIllustrate!.isEmpty) {}
        integralRecords = records;

        // 处理支付方式
        if (Platform.isAndroid) {
          Get.log("pay data===> ${data["data"]["pays"]}");
          _integralPays = data["data"]["pays"];
          availablePayMethods.clear();
          _integralPays!.forEach((key, value) {
            if (value == 1) {
              if (key == "wxpay" || key == "yeepay") {
                /// 如果已经有微信支付了，就不再添加
                if (!availablePayMethods.contains("wxpay")) {
                  availablePayMethods.add("wxpay");
                }
              } else if (key == "alipay") {
                availablePayMethods.add("alipay");
              }
            }
          });

          /// 设置默认支付方式
          if (availablePayMethods.isNotEmpty) {
            currentPayMethod = availablePayMethods.first;
          }
        }

        if (integralRecords.isNotEmpty) {
          getAgreement(selectedIndex);
          validateMemberBtnTxt(integralRecords[selectedIndex].buttonTitle);
        }
        update();
      },
      fail: (code, msg) {
        // BotToast.showText(text: msg);
        EasyLoading.showToast(msg);
      },
    );
  }

  //套餐点击
  void integralItemClick(IntegralPayListBean item) {
    if (integralRecords.isEmpty) return;
    selectedIndex = integralRecords.indexOf(item);
    getAgreement(selectedIndex);
    validateMemberBtnTxt(integralRecords[selectedIndex].buttonTitle);
    update();
  }

  //按钮文案
  validateMemberBtnTxt(String? input) {
    if (integralRecords.isEmpty) return;
    if (input?.isNotEmpty ?? false) {
      memberBtnTxt = integralRecords[selectedIndex].buttonTitle;
    } else {
      memberBtnTxt = "立即购买";
    }
    update();
  }

  agreementCheckedStatusChanged(bool status) {
    userAgreementChecked = status;
    isAgreementChecked = status;
    update();
  }

  ///判断当前选中套餐是否展示同意协议
  void getAgreement(int index) {
    if (integralRecords.isEmpty) return;
    if (integralRecords[index].isAgreement == 1 || userAgreementChecked) {
      isAgreementChecked = true;
    } else {
      isAgreementChecked = false;
    }
    agreementNum = integralRecords[index].isAgreement == 1 ? true : false;
    update();
  }

  //切换支付方式
  void switchPayMethod() {
    if (availablePayMethods.length <= 1) {
      return;
    }
    // 获取当前支付方式在列表中的索引
    int currentIndex = availablePayMethods.indexOf(currentPayMethod);
    // 计算下一个索引，如果是最后一个则回到第一个
    int nextIndex = (currentIndex + 1) % availablePayMethods.length;
    // 更新当前支付方式
    currentPayMethod = availablePayMethods[nextIndex];
    update();
  }

  //创建支付订单v2版本  createOrderv2
  void createPayOrderV2() {
    EasyLoading.show();
    Get.log("===currentPayMethod=== $currentPayMethod");
    DataService.onEvent(DataServiceEventName.createOrder, {});
    HttpUtils.post(
      APIs.createOrderv2,
      {
        "pay": Platform.isAndroid ? currentPayMethod : "apple",
        "config_id": integralRecords[selectedIndex].id,
        "support_pays": Platform.isAndroid ? "wxpay,alipay,yeepay" : "apple",
      },
      success: (data) {
        EasyLoading.dismiss();
        byDebugPrint(data["data"], tag: "创建支付订单:");
        orderId = data["data"]["id"];
        //拉起支付
        pullUpPayment(data["data"]);
      },
      fail: (code, msg) {
        EasyLoading.dismiss();
        EasyLoading.showToast(msg);
        Get.log("===支付失败");
      },
    );
  }

  ///分平台拉起支付
  pullUpPayment(data) async {
    if (Platform.isAndroid) {
      Get.log(
          "payData===> ${data["call_method"]} currentPayMethod====> $currentPayMethod");
      if (data["call_method"] == "wxpay") {
        ///微信支付
        bool canWechatPay = await WechatKitPlatform.instance.isInstalled();
        if (!canWechatPay) {
          EasyLoading.showToast("由于您未安装微信，无法完成支付。请切换其他方式支付");
          return;
        }
        WxPayOrderBean payOrderBean = WxPayOrderBean.fromJson(data);
        // orderId = payOrderBean.id;
        PaymentUtil().wxPay(payOrderBean);
      } else if (data["call_method"] == "wxpay_mini") {
        ///易宝微信支付
        bool canWechatPay = await WechatKitPlatform.instance.isInstalled();
        if (!canWechatPay) {
          EasyLoading.showToast("由于您未安装微信，无法完成支付。请切换其他方式支付");
          return;
        }
        YeepayPayOrderBean payOrderBean = YeepayPayOrderBean.fromJson(data);
        needShowDialog = true;
        // orderId = payOrderBean.id;
        PaymentUtil().wxMiniProgramPay(payOrderBean);
      } else if (data["call_method"] == "alipay") {
        ///支付宝支付
        bool canAliPay = await AlipayKitPlatform.instance.isInstalled();
        if (!canAliPay) {
          EasyLoading.showToast("由于您未安装支付宝，无法完成支付。请切换其他方式支付");
          return;
        }
        AliPayOrderBean aliPayOrderBean = AliPayOrderBean.fromJson(data);
        // orderId = aliPayOrderBean.id;
        PaymentUtil().aliPay(aliPayOrderBean);
      }
    } else if (Platform.isIOS) {
      /// 苹果支付
      buyIosProductData(orderId);
      Get.log(
          "orderId===> $orderId   ${integralRecords[selectedIndex].appleVipId}");
    }
  }

  ///购买ios产品
  buyIosProductData(String orderId) async {
    if (integralRecords[selectedIndex].appleVipId.isEmpty) {
      EasyLoading.showToast("未查找到商品，请重试");
      return;
    }


    await iosBuyEngin.loadProductDataAndBuy(
        integralRecords[selectedIndex].appleVipId, orderId,changeType: 2);
  }

  ///监听苹果支付成功状态
  iniIosPaySuccessSubscription() {
    if (Platform.isIOS) {
      iosBuyEngin.initializeInAppPurchase();
      _iosPaySuccessSubscription =
          eventBus.on<QueryIosOrderEvent>().listen((event) {
            // _queryOrderStatus(receiptData: event.serverVerificationData);
            if (event.type == 2) {
              integralQueryOrder(
                receiptData: event.serverVerificationData,
              );
            }
          });
      _iosBuyStreamSubscription =
          eventBus.on<IosProductBuySuccessEvent>().listen((e) {});
    }

  }

  ///ios补单
  void iosRepair({
    void Function()? onSuccess,
  }) {
    EasyLoading.show();
    Get.log("===点击恢复购买");
    String receiptData = SpUtil.getString("ios_last_server_verification") ?? "";
    if (receiptData.isEmpty) {
      EasyLoading.showToast(
        "当前没有正在处于交易的订单,您可选择套餐进行购买~",
      );
      return;
    }
    HttpUtils.post(APIs.iosRepair, {
      "receipt_data": receiptData,
    }, success: (json) {
      EasyLoading.dismiss();
      Get.log("===ios补单返回来的数据===  $json");
      onSuccess?.call();
    }, fail: (code, msg) {
      EasyLoading.dismiss();
      EasyLoading.showToast(msg);
    });
  }

  /// 查询积分订单状态
  void integralQueryOrder({
    void Function()? onSuccess,
    void Function()? onFailed,
    int retryCount = 0,
    String receiptData = "",
  }) {
    // if (_isQueryingOrder) {
    //   return;
    // }

    if (retryCount > 2) {
      _isQueryingOrder = false;
      onFailed?.call();
      return;
    }

    if (receiptData.isEmpty && Platform.isIOS || orderId.isEmpty) {
      return;
    }

    _isQueryingOrder = true;
    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 2000)
      ..maskType = EasyLoadingMaskType.custom
      ..indicatorType = EasyLoadingIndicatorType.cubeGrid
      ..indicatorColor = ByColorUtil.PurchasePriceTextColor
      ..loadingStyle = EasyLoadingStyle.light;
    EasyLoading.show(status: "订单查询中，请稍后...", dismissOnTap: false);

    HttpUtils.post(
      APIs.queryOrder,
      {
        "id": orderId,
        "receipt_data": Platform.isAndroid ? "" : receiptData,
      },
      success: (data) {
        byDebugPrint(data["data"], tag: "订单状态:");
        final status = data["data"]["order_status"] ?? "";
        if (status == 'SUCCESS') {
          EasyLoading.dismiss();
          _isQueryingOrder = false;

          /// 更新个人信息
          Get.find<LaunchController>()
              .reloadUserInfo(successAction: (userInfo) {});
          getMemberData();
          eventBus.fire(const IosProductBuySuccessEvent());
          onSuccess?.call();
        } else if (status == 'FAIL') {
          EasyLoading.dismiss();
          _isQueryingOrder = false;
          onFailed?.call();
        } else {
          Future.delayed(const Duration(seconds: 3)).then((value) =>
              integralQueryOrder(
                  onSuccess: onSuccess,
                  onFailed: onFailed,
                  retryCount: retryCount + 1));
        }
      },
      fail: (code, msg) {
        EasyLoading.dismiss();
        _isQueryingOrder = false;
        EasyLoading.showToast(msg);
      },
    );
  }

  ///返回上一页面
  goBack() {
    Get.back();
  }

  getMemberData() {
    HttpUtils.get(APIs.member, {}, success: (data) {
      userProfileResponse = UserProfileResponse.fromJson(data);
      Get.log("获取的会员数据===> ${userProfileResponse?.data.toJson()}");
      update();
    });
  }

  ///改变用户的支付方式
  changeSelectedPayMethodIndex(int index) {
    selectedPayMethodIndex = index;
    currentPayMethod = availablePayMethods[index];
    update();
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

  ///打开积分服务协议
  void openIntegral() {
    Get.find<LaunchController>().openIntegral();
  }

  ///购买事件
  void buyEvent() {
    if (!launchController.isVip) {
      EasyLoading.showToast("购买音符值前，您需要先开通会员～");
      Get.back();
      Get.toNamed(Routes.vipPurchasePage);
      return;
    }
    if (userAgreementChecked) {
      buyEventPostServer();
    } else {
      Get.dialog(privacyDialog()).then((value) {
        if (userAgreementChecked) {
          Get.log("===用户已经同意协议===");
          buyEventPostServer();
        }
      });
    }
  }

  void buyEventPostServer() {
    Get.log("当前选中的产品id===> ${integralRecords[selectedIndex].toJson()} ");
    createPayOrderV2();
  }

  Widget privacyDialog() {
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
                        text: "音符值服务协议",
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                        textColor: Colors.white),
                    SizedBox(
                      height: 30.w,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 0.w,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            " 我已经阅读并同意",
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 16.sp,
                                color: Colors.white.withOpacity(0.5)),
                          ),
                          InkResponse(
                            onTap: () {
                              openIntegral();
                            },
                            child: Text(
                              "《音符值服务协议》",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16.sp,
                                  color: Colors.white),
                            ),
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
                              title: "不同意",
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
                              title: "同意并继续",
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              textColor: Colors.white,
                              onClick: () async {
                                agreementCheckedStatusChanged(true);
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

  ///取消监听状态
  cancelIosPaySuccessSubscription() {
    if (Platform.isIOS) {
      _iosPaySuccessSubscription.cancel();
      _iosBuyStreamSubscription.cancel();
    }
  }
}
