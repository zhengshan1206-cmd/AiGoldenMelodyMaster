import 'dart:async';
import 'dart:io';
import 'package:ai_golden_melody_master/common/lib/app_common/event/common_event.dart';
import 'package:ai_golden_melody_master/view/purchase/diaglog/new_pay_retention_dialog.dart';
import 'package:ai_golden_melody_master/view/purchase/diaglog/pay_retention_dialog.dart';
import 'package:alipay_kit/alipay_kit.dart';
import 'package:flustars_flutter3/flustars_flutter3.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ai_golden_melody_master/common/lib/app_common/by_common_utils.dart';
import 'package:ai_golden_melody_master/common/lib/app_http/apis.dart';
import 'package:ai_golden_melody_master/common/lib/app_http/http_utils.dart';
import 'package:ai_golden_melody_master/common/lib/app_purchase/ios_purchase/ios_buy_engine.dart';
import 'package:ai_golden_melody_master/common/lib/app_ui/by_widgets_util.dart';
import 'package:wechat_kit/wechat_kit.dart';
import 'package:ai_golden_melody_master/common/lib/app_purchase/wechat_buy_engine/ali_pay_order_bean.dart';
import 'package:ai_golden_melody_master/common/lib/app_purchase/wechat_buy_engine/bug_engine.dart';
import '../../../model/launch/launch_info_bean.dart';
import '../../../model/purchase/pay_method_bean.dart';
import '../../../model/purchase/vip_model.dart';
import '../../../model/purchase/vip_type_bean.dart';
import '../../../model/purchase/wx_pay_order_bean.dart';
import '../../../model/purchase/wx_yeepay_order_bean.dart';
import '../../../model/user/user_info_bean.dart';
import '../../../utils/assets.dart';
import '../../../utils/by_color_utils.dart';
import '../../../utils/data_service.dart';
import '../../lanuch_page/launch_controller.dart';

///会员的业务逻辑
class VipPurchaseController extends GetxController with WidgetsBindingObserver {
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

  ///商品ios列表
  List<VipTypeBean> vipTypeBeans = [];

  ///Ios支付工具
  IosBuyEngin iosBuyEngin = IosBuyEngin();

  ///选中的vip购买类型产品iosId
  String appleVipId = "";

  ///选中的vip购买类型产品Id -这里服务器有一个id与安卓适配
  int? appleVipIdFromSever;

  ///苹果支付成功后查询订单状态的监听
  late StreamSubscription iosPaySuccessSubscription;

  ///当前订单Id
  // String orderId = "";

  ///产品购买提示语
  String showHintText = "";

  ///是否拦截返回
  bool isPreBack = false;

  /// 挽留弹窗默认选中的套餐的id
  String retentionDefaultVIPTypeID = '';

  /// 挽留弹窗默认选中的appleVipId
  String retentionDefaultAppleVipId = '';

  ///会员解锁按钮文案
  String memberBtnTxt = "立即解锁";

  ///是否是挽留弹出拉起支付
  bool isRetention = false;

  ///是否展示音符值服务协议
  bool isShowIntegralAgreement = false;

  ///选中的购买产品的套餐数据
  VipTypeBean? selectedVipTypeBean;

  ///本地配套的vipTypeModel
  VipTypeModel selectedVipTypeModel = vipTypeModelList.first;

  ///支付支持
  String paySupport = Platform.isAndroid ? "wxpay,alipay,yeepay" : "applepay";

  ///跑马灯 提示文本
  List<String> marqueeList = [];

  ///1
  List<Creation> creation = [];

  ///2
  List<Creation> advanced = [];

  ///3
  List<Creation> exclusive = [];

  ///用户反馈
  List<FeedbackModel> feedback = [];

  ///公告
  String notice = "";

  ///是否同意协议
  bool isAgreePrivacy = false;

  ///用户选中的支付方式
  int selectedPayMethodIndex = 0;

  ///改变用户的支付方式
  changeSelectedPayMethodIndex(int index) {
    selectedPayMethodIndex = index;
    update();
  }

  ///支付方式
  List<PayMethodBean> payMethodBeans = [];

  ///是否需要弹窗提示支付状态
  var needShowDialog = false;

  ///订单id
  String orderID = "";

  ///新用户弹窗套餐信息
  VipTypeBean? newUserVipTypeBean;

  ///挽留弹窗套餐信息
  VipTypeBean? retentionVipTypeBean;

  ///是否挽留
  bool isContinueRetention = true;

  ///是否是挽留弹窗支付
  RxBool isRetentionPay = false.obs;

  ///创作音乐人数量
  int creationMusicNum = 0;

  ///高级音乐人数量
  int advancedMusicNum = 0;

  ///专属音乐人数量
  int exclusiveMusicNum = 0;

  ///订单正在查询中
  RxBool isQueryingOrder = false.obs;

  ///苹果支付成功后查询订单状态的监听
  late StreamSubscription _iosPaySuccessSubscription;

  late StreamSubscription _iosBuyStreamSubscription;

  ///使用的支付方式
  String usePayMethod = "";

  @override
  void onInit() {
    // 注册应用生命周期观察者
    WidgetsBinding.instance.addObserver(this);
    initData();
    // iniIosPaySuccessSubscription();
    super.onInit();
  }

  @override
  void onClose() {
    // 移除应用生命周期观察者
    WidgetsBinding.instance.removeObserver(this);
    // 清理动画定时器
    _moneyAnimationTimer?.cancel();
    super.onClose();
  }

  ///导航返回事件
  goBack({String musicMoney = "",}) {
    if (Get.find<LaunchController>().user.value?.isVip == 1) {
      Get.back();
      return;
    }
    // if (!isContinueRetention) {
    //   Get.back();
    //   return;
    // }

    Get.dialog(
        barrierColor: Colors.black.withOpacity(0.8),
        barrierDismissible: false,
        NewPayRetentionDialog(
          onButtonTap: (){
            buyEvent();
          },
          musicMoney: musicMoney,
        )
    );

    // Get.dialog(
    //   barrierColor: Colors.black.withOpacity(0.8),
    //   barrierDismissible: false,
    //   PayRetentionDialog(
    //     onButtonTap: () {
    //       // isContinueRetention = false;
    //       print("isRetentionPay====>1 ${isRetentionPay.value}");
    //
    //       ///如果领取将vipTypeBeans套餐第一个替换为retentionVipTypeBean 并且给retentionVipTypeBean中的money添加数字滚动效果（注意：是将retentionVipTypeBean中的money添加到vipTypeBeans套餐第一个中money变为vipTypeBeans第一个套餐中money的数字滚动）
    //       if (retentionVipTypeBean != null && vipTypeBeans.isNotEmpty) {
    //         // // 保存原始价格用于动画
    //         // final originalMoney = vipTypeBeans.first.money;
    //         // final targetMoney = retentionVipTypeBean!.money;
    //
    //         // 替换第一个套餐为挽留套餐
    //         // vipTypeBeans[0] = retentionVipTypeBean!;
    //
    //         // 启动数字滚动动画
    //         // _startMoneyAnimation(originalMoney, targetMoney);
    //
    //         ///不滚动直接拉起支付（
    //         isRetentionPay.value = true;
    //         Future.delayed(const Duration(milliseconds: 100), () {
    //           buyEvent();
    //         });
    //         // buyEvent();
    //       }
    //       update();
    //     },
    //     onClose: () {
    //       // isContinueRetention = false;
    //       // update();
    //       Get.back();
    //     },
    //   ),
    // );
  }

  /// 设置页面已进入标志
  void setPageEntered() {
    // isContinueRetention = true;
    loadData();
    Future.delayed(const Duration(milliseconds: 100), () {
      getFirstHappy(3);
    });
  }

  loadData() {
    loadVIPItems();
    loadDataFromServer();
    getFirstHappy(2);
  }

  initData() {
    loadData();

    final isAudit = Get.find<LaunchController>().launchInfo!.isAudit;
    userInfoBean = Get.find<LaunchController>().user.value;
    Get.log("isAudit====> $isAudit");
    if (isAudit == 1) {
      agreementCheckedStatusChanged(false);
    }
    PaymentUtil().subscribeWXPayResp(Get.context!, onSuccess: () {
      _queryOrderStatus(isWechat: true);
    });

    PaymentUtil().subscribeAliPayResp(Get.context!, onSuccess: () {
      _queryOrderStatus();
    });
  }

  ///加载vip列表数据
  loadVIPItems({
    void Function()? onSuccess,
  }) {
    String supportPays = paySupport;
    if (Platform.isIOS) {
      supportPays = "apple";
    }
    HttpUtils.get(
      APIs.vipHappys,
      {
        "ver": 2,
        "support_pays": supportPays,
      },
      success: (data) {
        final respData = data["data"];
        byDebugPrint(respData, tag: "获取VIP权益：");
        final List items = respData["items"] ?? [];
        Get.log("商品列表的数据====>$data ");
        List<VipTypeBean> typeBeans =
            items.map((e) => VipTypeBean.fromJson(e)).toList();
        vipTypeBeans = typeBeans;
        if (vipTypeBeans.isNotEmpty) {
          selectedVipTypeBean = vipTypeBeans.first;
        } else {
          return;
        }
        if (selectedVipTypeBean == null) {
          return;
        }
        checkSelectedVipTypeModel(selectedVipTypeBean: selectedVipTypeBean!);
        if (Platform.isIOS) {
          appleVipId = selectedVipTypeBean!.appleVipId;
          appleVipIdFromSever = selectedVipTypeBean!.id;
        }
        _setRetentionDefaultVipType();
        showHintText = selectedVipTypeBean!.des;
        isShowIntegralAgreement =
            vipTypeBeans.first.integral > 0 ? true : false;
        Get.log("第一个分配到的苹果产品id====>$appleVipId ");

        ///判断选中会员列表按钮文案
        if (validateMemberBtnTxt(selectedVipTypeBean!.buttonTitle)) {
          memberBtnTxt = selectedVipTypeBean!.buttonTitle;
        } else {
          memberBtnTxt = "立即解锁";
        }

        ///支付方式的更新
        if (Platform.isAndroid) {
          final Map<String, dynamic> pays = respData["pays"] ?? {};

          /// 支付列表
          /// 原生的微信支付
          final wxpayEnable = (pays["wxpay"] ?? 0) == 1;

          /// 易宝的微信小程序支付
          final yeepayEnable = (pays["yeepay"] ?? 0) == 1;
          payMethodBeans.clear();

          Get.log("支付顺序===> ${pays}");

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

        /// 更新UI
        update();
      },
      fail: (code, msg) {
        EasyLoading.showToast(msg, maskType: EasyLoadingMaskType.none);
      },
    );
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

      /// 重置挽留支付状态
      isRetentionPay.value = false;

      /// 充值成功
      Get.find<LaunchController>().launch(
        onSuccess: (LaunchInfoBean bean) {
          /// 更新个人信息
          Get.dialog(openVipSuccessDialog(isWechat: false));
        },
      );
      Get.log("===ios补单返回来的数据===  $json");
      onSuccess?.call();
    }, fail: (code, msg) {
      EasyLoading.dismiss();
      EasyLoading.showToast(msg, maskType: EasyLoadingMaskType.none);
    });
  }

  /// 设置挽留弹窗默认选中的VIP套餐
  void _setRetentionDefaultVipType() {
    if (vipTypeBeans.isEmpty) return;

    // 查找默认套餐
    int defaultIndex = -1;
    for (int i = 0; i < vipTypeBeans.length; i++) {
      if (vipTypeBeans[i].isDefault == 1) {
        defaultIndex = i;
        break;
      }
    }

    // 如果找到默认套餐，则设置为挽留弹窗的默认套餐id
    if (defaultIndex != -1) {
      retentionDefaultVIPTypeID = vipTypeBeans[defaultIndex].id.toString();
      retentionDefaultAppleVipId = vipTypeBeans[defaultIndex].appleVipId;
    }
  }

  bool validateMemberBtnTxt(String? input) {
    return input?.isNotEmpty ?? false;
  }

  void selectedVipType({
    required VipTypeBean vipTypeBean,
  }) {
    selectedVipTypeBean = vipTypeBean;
    Get.log("选中的vip购买类型产品Id====>${selectedVipTypeBean?.toJson()}");

    ///判断选中会员列表按钮文案
    if (validateMemberBtnTxt(vipTypeBean.buttonTitle)) {
      memberBtnTxt = vipTypeBean.buttonTitle;
    } else {
      memberBtnTxt = "立即解锁";
    }
    showHintText = vipTypeBean.des;

    ///更新苹果套餐相关id
    if (Platform.isIOS) {
      appleVipId = vipTypeBean.appleVipId;
      appleVipIdFromSever = vipTypeBean.id;
    }
    checkSelectedVipTypeModel(selectedVipTypeBean: vipTypeBean);
    update();
  }

  ///核对选中的会员类型
  void checkSelectedVipTypeModel({
    required VipTypeBean selectedVipTypeBean,
  }) {
    if (selectedVipTypeBean.vipLevel >= 365) {
      selectedVipTypeModel = vipTypeModelList.first;
    } else if (selectedVipTypeBean.vipLevel == 90) {
      selectedVipTypeModel = vipTypeModelList[1];
    } else if (selectedVipTypeBean.vipLevel <= 30) {
      selectedVipTypeModel = vipTypeModelList[2];
    }
  }

  ///加载数据
  loadDataFromServer() async {
    await HttpUtils.get(APIs.unlockMember, {}, success: (data) {
      VipModel vipModel = VipModel.fromJson(data);
      Get.log("请求下来的数据===> ${data} ");

      creation = [];
      advanced = [];
      exclusive = [];
      marqueeList = [];
      feedback = [];

      creation = vipModel.data.equity.creation;
      advanced = vipModel.data.equity.advanced;
      exclusive = vipModel.data.equity.exclusive;
      marqueeList = vipModel.data.buyVip;
      feedback = vipModel.data.feedback;
      notice = vipModel.data.buyNotice;

      creationMusicNum = vipModel.data.equity.creationMusicNum;
      advancedMusicNum = vipModel.data.equity.advancedMusicNum;
      exclusiveMusicNum = vipModel.data.equity.exclusiveMusicNum;

      eventBus.fire(const RefreshMarqueeEvent());
      update();
    });
  }

  agreementCheckedStatusChanged(bool status) {
    isAgreePrivacy = status;
    update();
  }

  ///打开vip政策
  openVip() {
    Get.find<LaunchController>().openVip();
  }

  ///购买事件
  buyEvent({VoidCallback? clickEvent,}) {
    if (isAgreePrivacy) {
      postBuyEvent();
    } else {
      Get.dialog(privacyDialog()).then((value) {
        if (isAgreePrivacy) {
          Get.log("===用户已经同意===");
          if(clickEvent!=null){
            clickEvent();
          }
          postBuyEvent();
        } else {
          isRetentionPay.value = false;
        }
      });
    }
  }

  postBuyEvent() {
    Get.log("当前选中的产品===>${selectedVipTypeBean?.toJson()}");

    ///安卓平台的支付
    if (Platform.isAndroid) {
      createAndroidPayOrder();
    }

    if (Platform.isIOS) {
      createIosPayOrder();
    }
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
                        text: "服务协议及隐私保护",
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
                              openVip();
                            },
                            child: Text(
                              "会员服务协议",
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

  ///安卓-创建支付订单版本
  void createAndroidPayOrder() async {
    final PayMethodBean bean = payMethodBeans[selectedPayMethodIndex];
    final String originalType = bean.payNameKey;
    PayType type = PayTypeExt.typeFromPayTypeNameValue(originalType);

    ///检查微信支付是否正常
    if (type == PayType.wxpay || type == PayType.yeepay) {
      bool canWechatPay = await WechatKitPlatform.instance.isInstalled();
      if (!canWechatPay) {
        EasyLoading.showToast("由于您未安装微信，无法完成支付。请切换其他方式支付");
        return;
      }
    }
    EasyLoading.show();
    HttpUtils.post(
      APIs.createVipOrder,
      {
        "pay": Platform.isAndroid ? type.payTypeName : "apple",
        "config_id": isRetentionPay.value
            ? retentionVipTypeBean?.id
            : selectedVipTypeBean?.id,
        "support_pays": Platform.isAndroid ? "wxpay,alipay,yeepay" : "apple",
      },
      success: (data) {
        EasyLoading.dismiss();
        byDebugPrint(data["data"], tag: "创建支付订单:");
        orderID = data["data"]["id"];

        ///拉起支付
        Get.log("===== 拉起支付 wechat_pay===");
        isRetentionPay.value = false;
        pullUpPayment(data["data"]);
      },
      fail: (code, msg) {
        EasyLoading.dismiss();
        // 重置挽留支付状态
        isRetentionPay.value = false;
        EasyLoading.showToast(msg);
      },
    );
  }

  ///ios-创建支付订单版本
  void createIosPayOrder() {
    EasyLoading.show();
    HttpUtils.post(
      APIs.createVipOrder,
      {
        "pay": "apple",
        "config_id": isRetentionPay.value
            ? retentionVipTypeBean?.id
            : selectedVipTypeBean?.id,
        "support_pays": Platform.isAndroid ? "wxpay,alipay,yeepay" : "apple",
      },
      success: (data) {
        EasyLoading.dismiss();
        byDebugPrint(data["data"], tag: "创建支付订单:");
        orderID = data["data"]["id"];

        ///拉起支付
        Get.log("===== 拉起支付===");
        // isRetentionPay.value = false;
        pullUpPayment(data["data"]);
      },
      fail: (code, msg) {
        EasyLoading.dismiss();
        // 重置挽留支付状态
        isRetentionPay.value = false;
        EasyLoading.showToast(msg);
      },
    );
  }

  ///分平台拉起支付
  pullUpPayment(data) async {
    Get.log("data==== $data");

    if (Platform.isAndroid) {
      if (data["call_method"] == "wxpay") {
        ///微信支付
        bool canWechatPay = await WechatKitPlatform.instance.isInstalled();
        if (!canWechatPay) {
          EasyLoading.showToast("由于您未安装微信，无法完成支付。请切换其他方式支付");
          return;
        }
        WxPayOrderBean payOrderBean = WxPayOrderBean.fromJson(data);
        Get.log("===== wechat_pay1===");
        orderID = payOrderBean.id;
        usePayMethod = "wx";
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
        orderID = payOrderBean.id;
        usePayMethod = "yb";
        PaymentUtil().wxMiniProgramPay(payOrderBean);
      } else if (data["call_method"] == "alipay") {
        ///支付宝支付
        bool canAliPay = await AlipayKitPlatform.instance.isInstalled();
        if (!canAliPay) {
          EasyLoading.showToast("由于您未安装支付宝，无法完成支付。请切换其他方式支付");
          return;
        }
        AliPayOrderBean aliPayOrderBean = AliPayOrderBean.fromJson(data);
        orderID = aliPayOrderBean.id;
        usePayMethod = "zfb";
        PaymentUtil().aliPay(aliPayOrderBean);
      }
    } else if (Platform.isIOS) {
      /// 苹果支付
      Get.log("===开始苹果支付===${data}");
      usePayMethod = "apple";
      buyIosProductData(data["id"]);
    }
  }

  ///购买ios产品
  buyIosProductData(String orderId) async {
    // if (isRetention &&
    //     retentionDefaultAppleVipId.isNotEmpty &&
    //     retentionDefaultVIPTypeID.isNotEmpty) {
    //   appleVipId = retentionDefaultAppleVipId;
    // }
    if (isRetentionPay.value && retentionVipTypeBean != null) {
      appleVipId = retentionVipTypeBean?.appleVipId ?? "";
    }
    print("appleVipId==== $appleVipId");
    if (appleVipId.isEmpty) {
      EasyLoading.showToast("未查找到商品，请重试");
      return;
    }
    await iosBuyEngin.loadProductDataAndBuy(appleVipId, orderId, changeType: 1);
    isRetentionPay.value = false;
  }

  ///监听苹果支付成功状态
  iniIosPaySuccessSubscription() {
    if (Platform.isIOS) {
      iosBuyEngin.initializeInAppPurchase();
      _iosPaySuccessSubscription =
          eventBus.on<QueryIosOrderEvent>().listen((event) {
        _queryOrderStatus(receiptData: event.serverVerificationData);
      });
      _iosBuyStreamSubscription =
          eventBus.on<IosProductBuySuccessEvent>().listen((e) {});
    }
  }

  ///取消监听状态
  cancelIosPaySuccessSubscription() {
    if (Platform.isIOS) {
      _iosPaySuccessSubscription.cancel();
      _iosBuyStreamSubscription.cancel();
    }
  }

  /// 查询订单状态
  void _queryOrderStatus({
    String? loaddingText,
    bool isWechat = false,
    String? receiptData,
  }) {
    if (Platform.isIOS && receiptData != null && orderID.isEmpty) {
      return;
    }

    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 2000)
      ..maskType = EasyLoadingMaskType.custom
      ..indicatorType = EasyLoadingIndicatorType.cubeGrid
      ..indicatorColor = ByColorUtil.PurchasePriceTextColor
      ..loadingStyle = EasyLoadingStyle.light;
    EasyLoading.show(status: loaddingText, dismissOnTap: false);

    ///安卓平台
    if (Platform.isAndroid) {
      queryOrderStatus(
        onSuccess: () async {
          EasyLoading.dismiss();

          // 重置挽留支付状态
          isRetentionPay.value = false;

          /// 充值成功
          Get.find<LaunchController>().launch(
            onSuccess: (LaunchInfoBean bean) {
              /// 更新个人信息
              Get.dialog(openVipSuccessDialog(isWechat: isWechat));
            },
          );
        },
        onFailed: () {
          EasyLoading.dismiss();

          // 重置挽留支付状态
          isRetentionPay.value = false;

          Get.dialog(normalDialog());
        },
      );
    }

    ///ios平台
    if (Platform.isIOS) {
      queryIosOrderStatus(
        onSuccess: () async {
          EasyLoading.dismiss();

          /// 重置挽留支付状态
          isRetentionPay.value = false;

          /// 充值成功
          Get.find<LaunchController>().launch(
            onSuccess: (LaunchInfoBean bean) {
              /// 更新个人信息
              Get.dialog(openVipSuccessDialog(isWechat: isWechat));
            },
          );
        },
        onFailed: () {
          EasyLoading.dismiss();

          // 重置挽留支付状态
          isRetentionPay.value = false;

          Get.dialog(normalDialog());
        },
        receiptData: receiptData!,
      );
    }
  }

  normalDialog() {
    return Center(
      child: SizedBox(
          width: double.infinity,
          height: 370.w,
          child: Stack(
            children: [
              Container(
                height: 370.w,
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
                        text: "确认失败",
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "获取订单失败",
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 16.sp,
                                color: Colors.white.withOpacity(0.5)),
                          ),
                          Text(
                            "如果已支付请点击联系客服解决问题",
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 16.sp,
                                color: Colors.white.withOpacity(0.5)),
                          ),
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
                              title: "取消",
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
                              title: "联系客服",
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              textColor: Colors.white,
                              onClick: () async {
                                Get.find<LaunchController>().goChatOnlinePage();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20.w,
                    ),
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

  queryOrderStatus({
    void Function()? onSuccess,
    void Function()? onFailed,
    int retryCount = 0,
  }) {
    isQueryingOrder.value = true;
    if (retryCount > 2) {
      isQueryingOrder.value = false;
      onFailed?.call();
      return;
    }
    HttpUtils.post(
      APIs.queryOrderStatus,
      {"id": orderID},
      success: (data) {
        byDebugPrint(data["data"], tag: "订单状态:");
        final status = data["data"]["order_status"] ?? "";
        if (status == 'SUCCESS') {
          DataService.onEvent(DataServiceEventName.paySuc, {
            "pay_method":usePayMethod
          });
          eventBus.fire(const BuySuccessEvent());
          isQueryingOrder.value = false;
          onSuccess?.call();
        } else if (status == 'FAIL') {
          DataService.onEvent(DataServiceEventName.payFail, {
            "pay_method":usePayMethod,
            "message":data["data"]
          });
          isQueryingOrder.value = false;
          onFailed?.call();
        } else {
          Future.delayed(const Duration(seconds: 3), () {
            queryOrderStatus(
                onSuccess: onSuccess,
                onFailed: onFailed,
                retryCount: retryCount + 1);
          });
        }
      },
      fail: (code, msg) {
        DataService.onEvent(DataServiceEventName.payFail, {
          "pay_method":usePayMethod,
          "message":"code-$code msg-$msg"
        });
        isQueryingOrder.value = false;
        EasyLoading.dismiss();
      },
    );
  }

  queryIosOrderStatus({
    void Function()? onSuccess,
    void Function()? onFailed,
    int retryCount = 0,
    required String receiptData,
  }) {
    isQueryingOrder.value = true;
    if (retryCount > 2) {
      isQueryingOrder.value = false;
      onFailed?.call();
      return;
    }

    if (receiptData.isEmpty || orderID.isEmpty) {
      return;
    }
    HttpUtils.post(
      APIs.queryOrderStatus,
      {
        "id": orderID,
        "receipt_data": receiptData,
      },
      success: (data) {
        byDebugPrint(data["data"], tag: "订单状态:");
        final status = data["data"]["order_status"] ?? "";
        if (status == 'SUCCESS') {
          DataService.onEvent(DataServiceEventName.paySuc, {
            "pay_method":"apple"
          });
          EasyLoading.dismiss();
          onSuccess?.call();
          eventBus.fire(const IosProductBuySuccessEvent());
          eventBus.fire(const BuySuccessEvent());
          isQueryingOrder.value = false;
          onSuccess?.call();
        } else if (status == 'FAIL') {
          DataService.onEvent(DataServiceEventName.payFail, {
            "pay_method":"apple",
            "message":data["data"]
          });
          isQueryingOrder.value = false;
          onFailed?.call();
        } else {
          Future.delayed(const Duration(seconds: 3))
              .then((value) => queryIosOrderStatus(
                    onSuccess: onSuccess,
                    onFailed: onFailed,
                    retryCount: retryCount + 1,
                    receiptData: receiptData,
                  ));
        }
      },
      fail: (code, msg) {
        DataService.onEvent(DataServiceEventName.payFail, {
          "pay_method":"apple",
          "message":"code-$code msg-$msg"
        });
        isQueryingOrder.value = false;
        EasyLoading.dismiss();
      },
    );
  }

  Widget openVipSuccessDialog({
    bool isWechat = false,
  }) {
    return Center(
      child: SizedBox(
          width: double.infinity,
          height: 450.w,
          child: Stack(
            children: [
              Container(
                height: 450.w,
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
                top: 84.w,
                left: 124.w,
                child: Image.asset(
                  Assets.openVipSuccess,
                  width: 140.w,
                  height: 74.w,
                ),
              ),
              Positioned(
                left: 56.w,
                right: 36.w,
                top: 134.w,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 30.w,
                    ),
                    ByWidgetsUtil.commonText(
                        text: "解锁会员成功",
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "恭喜您，解锁会员成功，开启Ai音乐创作之旅吧！",
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 16.sp,
                              color: Colors.white.withOpacity(0.5),
                            ),
                            textAlign: TextAlign.center,
                          ),
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
                              title: "取消",
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
                              title: "开始创作",
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              textColor: Colors.white,
                              onClick: () async {
                                if (isWechat) {
                                  Get.log("==== wechat开始创作====");
                                  Get.back();
                                  Get.back();
                                  Get.back();
                                  return;
                                }

                                if (Platform.isIOS) {
                                  Get.log("==== ios开始创作====");
                                  Get.back();
                                  Get.back();
                                  Get.back();
                                  return;
                                }

                                Get.log("==== 开始创作====");
                                Get.back();
                                Get.back();
                                // Get.offAllNamed(Routes.main);
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

  ///获取第一个套餐
  ///1普通套餐 2挽留弹窗套餐 3新用户弹窗套餐
  void getFirstHappy(int vipType) {
    HttpUtils.get(
      APIs.getFirstHappy,
      {"vip_type": vipType},
      success: (data) {
        byDebugPrint(data, tag: "获取第一个套餐:-$vipType");
        if (data["status"] == 200 &&
            (data["data"] != null &&
                data["data"] != [] &&
                data["data"] != {})) {
          Map<String, dynamic> vipTypeData = data["data"];

          if (vipTypeData.isEmpty) {
            return;
          }

          VipTypeBean vipTypeBean = VipTypeBean.fromJson(vipTypeData);
          if (vipType == 2) {
            retentionVipTypeBean = vipTypeBean;
          } else if (vipType == 3) {
            newUserVipTypeBean = vipTypeBean;
          }
        } else {
          if (vipType == 2) {
            retentionVipTypeBean = vipTypeBeans.first;
          } else if (vipType == 3) {
            newUserVipTypeBean = vipTypeBeans.first;
          }
        }
        if (vipType == 3) {
          getNewUserVipTypeBean();
        }
        update();
      },
      fail: (code, msg) {},
    );
  }

  void getNewUserVipTypeBean() {
    final launchController = Get.find<LaunchController>();
    Future.delayed(
      const Duration(milliseconds: 50),
      () {
        if (launchController.user.value?.isVip == 0 &&
            launchController.user.value?.activeDay != null &&
            launchController.user.value!.activeDay! <= 1) {
          if (!launchController.isShowNewUserDialog) {

            // Get.dialog(
            //   barrierColor: Colors.black.withOpacity(0.8),
            //   barrierDismissible: false,
            //     NewPayRetentionDialog(
            //       onButtonTap: (){
            //         buyEvent();
            //       },
            //     )
            // );

            // Get.dialog(
            //   barrierColor: Colors.black.withOpacity(0.8),
            //   barrierDismissible: false,
            //   PayRetentionDialog(
            //     isNewUser: true,
            //     onButtonTap: () {
            //       newUserRedPacket();
            //     },
            //     onClose: () {},
            //   ),
            // );
          } else {
            launchController.checkIsNewUser(false);
            newUserRedPacket();
          }
        }
      },
    );
  }

  ///新用户红包逻辑
  void newUserRedPacket() {
    // isContinueRetention = false;

    ///如果领取将vipTypeBeans套餐第一个替换为newUserVipTypeBean 并且给第一个套餐中money添加数字滚动效果（注意：是将newUserVipTypeBean中的money添加到vipTypeBeans套餐第一个中money变为vipTypeBeans第一个套餐中money的数字滚动）
    if (newUserVipTypeBean != null && vipTypeBeans.isNotEmpty) {
      // 判断第一个套餐是否是当前选中的套餐
      bool isFirstPackageSelected =
          selectedVipTypeBean?.id == vipTypeBeans.first.id;

      // 保存原始价格用于动画
      final originalMoney = vipTypeBeans.first.money;
      final targetMoney = newUserVipTypeBean!.money;

      // 替换第一个套餐为新用户套餐
      vipTypeBeans[0] = newUserVipTypeBean!;

      // 如果第一个套餐是当前选中的套餐，则更新选中信息
      if (isFirstPackageSelected) {
        selectedVipTypeBean = newUserVipTypeBean;

        ///判断选中会员列表按钮文案
        if (validateMemberBtnTxt(newUserVipTypeBean!.buttonTitle)) {
          memberBtnTxt = newUserVipTypeBean!.buttonTitle;
        } else {
          memberBtnTxt = "立即解锁";
        }
        showHintText = newUserVipTypeBean!.des;

        ///更新苹果套餐相关id
        if (Platform.isIOS) {
          appleVipId = newUserVipTypeBean!.appleVipId;
          appleVipIdFromSever = newUserVipTypeBean!.id;
        }
        checkSelectedVipTypeModel(selectedVipTypeBean: newUserVipTypeBean!);
      }

      // 启动数字滚动动画
      _startMoneyAnimation(originalMoney, targetMoney);
    }
    update();
  }

  /// 数字滚动动画相关变量
  Timer? _moneyAnimationTimer;
  double _currentMoneyValue = 0;
  double _targetMoneyValue = 0;
  bool isAnimating = false;
  bool _isTargetInteger = false; // 新增：记录目标值是否为整数

  /// 启动价格数字滚动动画
  void _startMoneyAnimation(String originalMoney, String targetMoney) {
    // 解析价格字符串，提取数字部分
    final originalValue = _extractMoneyValue(originalMoney);
    final targetValue = _extractMoneyValue(targetMoney);

    if (originalValue == targetValue) return;

    _currentMoneyValue = originalValue.toDouble();
    _targetMoneyValue = targetValue.toDouble();
    isAnimating = true;

    // 检查目标字符串是否包含小数（直接检查原始字符串）
    _isTargetInteger = !targetMoney.contains('.');

    // 取消之前的动画
    _moneyAnimationTimer?.cancel();

    // 计算动画步长和间隔
    final difference = (_targetMoneyValue - _currentMoneyValue).abs();
    final steps = 30; // 动画步数
    final stepValue = difference / steps;
    final interval = Duration(milliseconds: 50); // 每步间隔

    _moneyAnimationTimer = Timer.periodic(interval, (timer) {
      if (_currentMoneyValue < _targetMoneyValue) {
        _currentMoneyValue += stepValue;
        if (_currentMoneyValue >= _targetMoneyValue) {
          _currentMoneyValue = _targetMoneyValue;
          isAnimating = false;
          timer.cancel();
        }
      } else if (_currentMoneyValue > _targetMoneyValue) {
        _currentMoneyValue -= stepValue;
        if (_currentMoneyValue <= _targetMoneyValue) {
          _currentMoneyValue = _targetMoneyValue;
          isAnimating = false;
          timer.cancel();
        }
      }

      // 更新第一个套餐的价格显示
      if (vipTypeBeans.isNotEmpty) {
        // 根据目标值类型决定显示格式
        if (_isTargetInteger) {
          // 目标是整数，动画过程中显示整数
          vipTypeBeans[0].money = _currentMoneyValue.toInt().toString();
        } else {
          // 目标有小数，动画过程中显示两位小数
          vipTypeBeans[0].money = _currentMoneyValue.toStringAsFixed(2);
        }
      }

      update();
    });
  }

  /// 从价格字符串中提取数字值
  double _extractMoneyValue(String moneyString) {
    // 移除所有非数字字符（保留小数点）
    final numericString = moneyString.replaceAll(RegExp(r'[^\d.]'), '');
    return double.tryParse(numericString) ?? 0;
  }

  /// 获取当前动画中的价格值（用于UI显示）
  String getCurrentAnimatedMoney() {
    if (isAnimating && vipTypeBeans.isNotEmpty) {
      // 根据目标值类型决定显示格式
      if (_isTargetInteger) {
        return _currentMoneyValue.toInt().toString();
      } else {
        return _currentMoneyValue.toStringAsFixed(2);
      }
    }
    return vipTypeBeans.isNotEmpty ? vipTypeBeans.first.money : '';
  }

  /// 监听异常返回
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (state == AppLifecycleState.resumed) {
        if (needShowDialog &&
            !(Get.isDialogOpen ?? false) &&
            !isQueryingOrder.value) {
          needShowDialog = false;
          isQueryingOrder.value = false;
          // EasyLoading.dismiss();

          // Get.dialog(normalDialog());
          ///订单查询
          if (Platform.isAndroid) {
            _queryOrderStatus(loaddingText: '订单查询中，请稍后...', isWechat: true);
          }
        }
      }
    });
  }

  ///发送展示抄底事件弹窗
  postShowBottomPayDialogEvent({required bool showBottomPayDialog }){
    Get.log("showBottomPayDialog==== $showBottomPayDialog orderID===$orderID ");

    if(showBottomPayDialog){
      if(orderID.isEmpty){
        eventBus.fire(ShowBottomPayDialogEvent());
      }else{
        SpUtil.putBool("show_history_order", true);
        SpUtil.putBool("show_history_order2", true);
        eventBus.fire(const ShowHistoryOrderEvent());
      }
    }
  }
}


class ShowBottomPayDialogEvent{
  ShowBottomPayDialogEvent();
}

///展示有历史订单事件
class ShowHistoryOrderEvent{
  final bool show;
  const ShowHistoryOrderEvent({this.show = true,});
}



class BuySuccessEvent {
  const BuySuccessEvent();
}

class VipTypeModel {
  final String image;
  final int type;
  final String vipHeaderImage;
  final String userMessageIconPath;
  final Color userMessageColor;
  final String userMessageText;
  final String userMessageBgIconPath;
  VipTypeModel({
    required this.image,
    required this.type,
    required this.vipHeaderImage,
    required this.userMessageIconPath,
    required this.userMessageColor,
    required this.userMessageText,
    required this.userMessageBgIconPath,
  });
}

class VipRightIconModel {
  final String iconPath;
  final String title1;
  final String title2;

  const VipRightIconModel({
    required this.iconPath,
    required this.title1,
    required this.title2,
  });
}

///刷新跑马灯事件
class RefreshMarqueeEvent {
  const RefreshMarqueeEvent();
}

enum PurchaseType { type1, type2 }

enum PayType { wxpay, yeepay, alipay }

extension PayTypeExt on PayType {
  String get payTypeName {
    switch (this) {
      case PayType.alipay:
        return "alipay";
      case PayType.yeepay:
        return "yeepay";
      default:
        return "wxpay";
    }
  }

  int get rawValue {
    switch (this) {
      case PayType.yeepay:
        return 2;
      case PayType.alipay:
        return 1;
      default:
        return 0;
    }
  }

  static PayType typeFromPayTypeNameValue(String val) {
    switch (val) {
      case "wxpay":
        return PayType.wxpay;
      case "yeepay":
        return PayType.yeepay;
      default:
        return PayType.alipay;
    }
  }
}
