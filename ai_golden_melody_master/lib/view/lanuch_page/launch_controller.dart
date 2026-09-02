import 'dart:async';
import 'dart:io';

import 'package:ai_golden_melody_master/common/lib/app_common/event/common_event.dart';
import 'package:ai_golden_melody_master/model/purchase/pre_login_config_bean.dart';
import 'package:ai_golden_melody_master/utils/by_init_utils.dart';
import 'package:ai_golden_melody_master/utils/common_event.dart';
import 'package:ai_golden_melody_master/view/lanuch_page/permission_confirm_page.dart';
import 'package:ai_golden_melody_master/view/purchase/diaglog/close_guide_dialog.dart';
import 'package:ai_golden_melody_master/view/purchase/diaglog/come_back_pay_dialog.dart';
import 'package:ai_golden_melody_master/view/purchase/diaglog/member_pay_upgrade_dialog.dart';
import 'package:ai_golden_melody_master/view/purchase/diaglog/no_free_time_pay_dialog.dart';
import 'package:ai_golden_melody_master/view/purchase/diaglog/pay_confirmation.dart';
import 'package:ai_golden_melody_master/view/purchase/vip/vip_rights/member_pay_upgrade_controller.dart';
import 'package:flustars_flutter3/flustars_flutter3.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bugly/flutter_bugly.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:ai_golden_melody_master/common/lib/app_common/aes/byhy_aes_storage_utils.dart';
import 'package:ai_golden_melody_master/common/lib/app_common/consts/const.dart';
import 'package:ai_golden_melody_master/common/lib/app_common/consts/const_keys.dart';
import 'package:ai_golden_melody_master/common/lib/app_common/package/byhy_package_utils.dart';
import 'package:ai_golden_melody_master/common/lib/app_http/apis.dart';
import 'package:ai_golden_melody_master/common/lib/app_http/dio_utils.dart';
import 'package:ai_golden_melody_master/common/lib/app_http/http_utils.dart';
import 'package:ai_golden_melody_master/common/lib/by_device_info_utils.dart';
import 'package:ai_golden_melody_master/common/lib/app_common/attribution/by_ascribe_util.dart';
import 'package:ai_golden_melody_master/common/lib/app_common/by_common_utils.dart';
import 'package:ai_golden_melody_master/common/lib/app_http/intercept.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ai_golden_melody_master/common/lib/app_common/by_nav_router_utils.dart';
import 'package:wechat_kit/wechat_kit.dart';
import '../../model/ai_music/my_work_response_model.dart';
import '../../model/launch/app_config.dart';
import '../../model/launch/launch_info_bean.dart';
import '../../model/user/user_info_bean.dart';
import '../../navigator/app_pages.dart';
import '../../utils/data_service.dart';
import '../login/login_dialog.dart';
import '../purchase/diaglog/buy_bottom_dialog.dart';
import '../purchase/diaglog/no_music_note_open_vip_dialog.dart';
import '../purchase/diaglog/no_music_note_vip_dialog.dart';

typedef LaunchSuccessCallback = void Function(LaunchInfoBean);
typedef LaunchFailCallback = void Function();

///启动 用户信息 的业务逻辑
class LaunchController extends GetxController {
  ///启动数据
  LaunchInfoBean? launchInfo;

  ///用户信息
  final user = Rx<UserInfoBean?>(null);

  ///用户是否登录
  bool isLogin = false;

  ///基础配置信息
  AppConfig? appConfig;

  ///我的作品数量
  int myWorksNumber = 0;

  ///是否vip
  bool isVip = false;

  ///是否可以升级套餐 2不可以 1可以
  int canUpgrade = 2;

  ///升级套餐错误提示
  String errorMessage = "";

  ///首页背景图
  RxString homeBgUrl = "".obs;

  ///榜单背景图
  RxString rankingBgUrl = "".obs;

  ///是否开启登录前置
  bool isLoginPre = false;

  ///是否是新用户运营位进入付费页
  bool isShowNewUserDialog = false;

  /// 存储被前置登录限制的操作回调
  VoidCallback? _pendingActionCallback;

  ///30天会员
  bool is30Vip = false;

  ///90天会员
  bool is90Vip = false;

  ///365天会员
  bool is365Vip = false;

  ///首页底部运营小条图片
  String homeBottomImage = "";

  ///写歌页面悬浮图片
  String writeSongFloatingImage = "";

  ///付费页新用户运营位图片
  String vipPurchaseNewUserImage = "";

  ///付费页挽留运营位图片
  String vipPurchaseRetentionImage = "";

  ///首次用户试用挽留引导文案
  String btnText = "";

  ///首次用户进入的时间配置(单位:秒)
  int playTime = 10;

  ///邀请名称
  String inviteName = "邀请码";

  ///邀请背景图
  String inviteBgUrl = "";

  ///回归用户背景弹窗
  String comeBackUserBgUrl = "";

  ///抄底支付弹窗背景
  String comeBackPayBgUrl = "";

  ///关闭引导背景弹窗
  String closeGuideBg = "";

  ///免费次数不足弹窗
  String noFreeTimeBg = "";

  ///音符值不足且无vip弹窗
  String noMusicNoteAndNoVipBg = "";

  ///音符值不足且有vip弹窗
  String noMusicNoteAndVipBg = "";

  ///订单未支付展示下方倒计时弹窗
  String orderShowBg = "";

  ///订单未支付右边小红包
  String orderShowRedEnvelop = "";

  ///付费页面挽留
  String vipPurchaseKeepDialog = "";

  @override
  void onInit() {
    checkAgreement();
    super.onInit();
  }

  ///启动接口调用
  launch({
    LaunchSuccessCallback? onSuccess,
    LaunchFailCallback? onFail,
  }) async {
    final imei = await ByDeviceInfoUtils.deviceInfo();
    final String system =
        ByPackageUtils.isAndroid ? Consts.kSystemAndroid : Consts.kSystemIOS;
    Map params = {};
    params = {
      "uuid": imei.item2,
      "app_version": ByStorageUtils.getString(ConstKeys.kAppVersion) ?? "5.0.0",
      "sys": system,
    };
    HttpUtils.request(
      Method.post,
      APIs.launch,
      forceData: false,
      showMsgWhenFailed: true,
      params,
      success: (data) async {
        final responseData = data["data"];
        final LaunchInfoBean launchInfoBean =
            LaunchInfoBean.fromJson(responseData);
        launchInfo = launchInfoBean;
        final token = launchInfoBean.token;

        /// 保存token
        setToken(token)?.then((onValue) {
          if (onValue) {
            /// 上报设别信息
            DeviceInfoUpload.uploadUserDeviceInfo();
            // ByInitUtils.initUmeng();

            /// 回调
            onSuccess?.call(launchInfoBean);
            reloadUserInfo();
            preLoginConfig();
            update();
          }
        });
      },
      fail: (code, msg) {
        ByCommonUtils.debugPrintObj("onError: code: $code");
        ByCommonUtils.debugPrintObj("onError: msg: $msg");
        FlutterBugly.uploadException(message: "启动接口失败", detail: msg);
        onFail?.call();
      },
    );
  }

  ///更新用户信息
  Future reloadUserInfo(
      {void Function(UserInfoBean? userInfo)? successAction,
      VoidCallback? goBack}) async {
    await getUserInfo(onSuccess: (userInfo) {
      saveUser(userInfo);
      Get.log("保存用户数据===>${userInfo?.toJson()}");
      if (userInfo != null) {
        if (userInfo.isFormal == 1) {
          isLogin = true;
        } else {
          isLogin = false;
        }

        if (userInfo.isVip == 1) {
          isVip = true;
        } else {
          isVip = false;
        }
      }

      if (goBack != null) {
        goBack();
      }
      if (successAction != null) {
        successAction(userInfo);
      }
      getConfig();
      getMyWorkNumber();
      checkUpgrade();
      eventBus.fire(const RefreshMusicNoteEvent());

      // bool isAiWriteMusicController = Get.isRegistered<AiWriteMusicController>();
      // ///初始化写歌业务逻辑
      // if(isAiWriteMusicController){
      //   Get.find<AiWriteMusicController>().initData();
      // }else{
      //   Get.put(AiWriteMusicController());
      //   Get.find<AiWriteMusicController>().initData();
      // }
    });
  }

  ///获取用户的信息
  getUserInfo({
    void Function(UserInfoBean? userInfo)? onSuccess,
  }) async {
    await HttpUtils.get(
      APIs.loadUserInfo,
      {},
      success: (data) {
        final userInfoData = data["data"];
        UserInfoBean bean = UserInfoBean.fromJson(userInfoData);
        onSuccess?.call(bean);
      },
      fail: (code, msg) {
        EasyLoading.showToast(msg);
      },
    );
  }

  ///保存用户信息
  void saveUser(UserInfoBean? userInfo) {
    user.value = userInfo;
    if (userInfo != null) {
      if (userInfo.vipLevel == 30) {
        is30Vip = true;
      }
      if (userInfo.vipLevel == 90) {
        is90Vip = true;
      }
      if (userInfo.vipLevel == 365) {
        is365Vip = true;
      }
    }

    update();
  }

  ///跳转设置页面
  goSettingPage() {
    if (isLogin) {
      Get.toNamed(Routes.settingPage);
    } else {
      login(source: "setting_btn");
    }
  }

  ///跳转我的音符值页面
  goMeMusicNodeValuePage() {
    if (isLogin) {
      if (isVip) {
        Get.toNamed(Routes.meMusicNoteValuePage);
      } else {
        Get.toNamed(Routes.meMusicNoteValueListPage);
      }
    } else {
      login(source: "go_music_node_page");
    }
  }

  ///复制id
  copyId() {
    if (user.value == null) {
      EasyLoading.showToast("请登录您的账号～");
    } else {
      ClipboardData data = ClipboardData(text: "${user.value!.userId}");
      Clipboard.setData(data);
      EasyLoading.showToast("复制ID成功～");
    }
  }

  ///登录
  void login({
    VoidCallback? loginSuccess,
    VoidCallback? loginCancel,
    String? source,
    bool? showPayDialog,
  }) async {
    if (isLogin) {
      loginCancel?.call();
      return;
    }
    DataService.onEvent(DataServiceEventName.loginShow, {
      "source": source,
    });
    await showDialog(
      context: Get.context!,
      builder: (context) {
        return const LoginDialog();
      },
      useSafeArea: false,
      barrierDismissible: false,
      barrierColor: Colors.black54.withOpacity(0.8),
    ).then((value) {
      ///检查是否登录成功
      Get.log("===登录弹窗拉起后是否登录=== $isLogin");
      if (isLogin) {
        if (loginSuccess != null) {
          loginSuccess();
        }

        if(showPayDialog==true){
          openCloseGuideBg();
        }
      }
      loginCancel?.call();
    });
  }

  ///购买vip页面
  void goToVipPage() {
    if (isLogin) {
      Get.toNamed(Routes.vipPurchasePage);
    } else {
      login(source: "go_buy_vip_page");
    }
  }

  void goToVipRightPage() {
    Get.toNamed(Routes.vipRightsPage);
  }

  ///检查权限是否许可
  void checkAgreement() async {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        final checked = ConstKeys.agreementChecked;

        if (checked) {
          launch(onSuccess: (LaunchInfoBean bean) {
            reloadUserInfo(successAction: (userInfo) {
              ///todo 这里可能还需要跳转vip页面
              final guideCheck =
                  ByStorageUtils.getBool(Consts.kLaunchGuideCheck) ?? false;
              if (guideCheck) {
                Get.offNamed(Routes.main);
              } else {
                Get.offNamed(Routes.guidePage);
              }
            });
          }, onFail: () {
            ///todo 添加失败页面
          });
          return;
        } else {
          showDialog(
            context: Get.context!,
            barrierColor: Colors.black,
            builder: (ctx) {
              return PermissionConfirmPage(
                onConfirm: () {
                  launch(onSuccess: (LaunchInfoBean bean) {
                    reloadUserInfo(successAction: (userInfo) {
                      ///todo 这里可能还需要跳转vip页面
                      // 检查引导页状态
                      final guideCheck =
                          ByStorageUtils.getBool(Consts.kLaunchGuideCheck) ??
                              false;

                      if (guideCheck) {
                        Get.offNamed(Routes.main);
                      } else {
                        Get.offNamed(Routes.guidePage);
                      }
                    });
                  }, onFail: () {
                    ///todo 添加失败页面
                  });
                },
              );
            },
            barrierDismissible: false,
          );
        }
      },
    );
  }

  ///获取基础配置
  void getConfig() async {
    await HttpUtils.get(
      APIs.config,
      {},
      success: (data) {
        appConfig = AppConfig.fromJson(data);
        Get.log("获取基础配置信息=======>${data}");
      },
      fail: (code, msg) {
        EasyLoading.showToast(msg);
      },
    );
  }

  ///去客服配置页面
  void goChatOnlinePage() async {
    const wechatUrl = 'weixin://';
    if (await canLaunchUrl(Uri.parse(wechatUrl))) {
      bool canWechat = await WechatKitPlatform.instance.isInstalled();
      if (!canWechat) {
        EasyLoading.showToast("由于您未安装微信，无法跳转微信客服");
        return;
      }
      ByNavRouterUtils.jumpWebViewPage(
        Get.context!,
        "在线客服",
        user.value!.kfUrl ?? "",
      );
    } else {
      // EasyLoading.showToast("由于您未安装微信，无法直接跳转客服。");
      ByNavRouterUtils.jumpWebViewPage(
        Get.context!,
        "在线客服",
        user.value!.kfUrl ?? "",
      );
    }
  }

  ///打开联系客服
  openCustomerService() async {
    const wechatUrl = 'weixin://';
    if (await canLaunchUrl(Uri.parse(wechatUrl))) {
      if (appConfig != null) {
        bool canWechat = await WechatKitPlatform.instance.isInstalled();
        if (!canWechat) {
          EasyLoading.showToast("由于您未安装微信，无法跳转微信客服");
          return;
        }
        Get.log("联系客服==== ${appConfig?.data!.customerService ?? ""}");
        ByNavRouterUtils.jumpWebViewPage(
            Get.context!, "联系客服", appConfig?.data!.customerService ?? "");
      }
    } else {
      // EasyLoading.showToast("由于您未安装微信，无法直接跳转客服。");
      ByNavRouterUtils.jumpWebViewPage(
          Get.context!, "联系客服", appConfig?.data!.customerService ?? "");
    }
  }

  ///打开隐私政策
  openVip() {
    if (appConfig != null) {
      ByNavRouterUtils.jumpWebViewPage(
          Get.context!, "会员服务协议", appConfig?.data!.agreement!.userVip ?? "");
    }
  }

  ///打开积分服务协议
  openIntegral() {
    if (appConfig != null) {
      ByNavRouterUtils.jumpWebViewPage(
          Get.context!, "音符值服务协议", appConfig?.data!.agreement!.integral ?? "");
    }
  }

  ///去往我的作品页面
  goMyWorkPage() {
    if (isLogin) {
      Get.toNamed(Routes.myWorkPage);
    } else {
      login(source: "go_my_work_page");
    }
  }

  ///获取基础配置
  void getMyWorkNumber() async {
    await HttpUtils.get(
      APIs.myWorkNumber,
      {},
      success: (data) {
        MyWorkResponseModel myWorkResponseModel =
            MyWorkResponseModel.fromJson(data);
        if (myWorkResponseModel.status == 200) {
          myWorksNumber = myWorkResponseModel.data.workNumber;
          update();
        }
        Get.log("获取我的作品数量=======>$data");
      },
      fail: (code, msg) {},
    );
  }

  ///打开隐私政策
  openRecordAudio() {
    if (appConfig != null) {
      ByNavRouterUtils.jumpWebViewPage(Get.context!, "会员服务协议",
          appConfig?.data!.agreement!.soundProtocol ?? "");
    }
  }

  /// 在任意页面中显示会员升级对话框
  showVipUpgradeDialog({VoidCallback? onClose}) {
    if (canUpgrade == 2) {
      Get.dialog(
        barrierColor: Colors.black54.withOpacity(0.8),
        PayConfirmationDialog(
          title: "温馨提示",
          content: errorMessage,
          cancelText: "取消",
          confirmText: "确定",
          onCancel: () {},
          onConfirm: () {},
        ),
      );
      return;
    }
    if (Platform.isAndroid) {
      Get.put(MemberPayUpgradeController());
      Get.bottomSheet(
        MemberPayUpgradeDialog(),
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
      ).then((_) {
        // 对话框关闭后清理controller
        if (Get.isRegistered<MemberPayUpgradeController>()) {
          Get.delete<MemberPayUpgradeController>();
        }
        // 执行关闭回调
        onClose?.call();
      });
    } else if (Platform.isIOS) {
      Get.dialog(
        barrierColor: Colors.black54.withOpacity(0.8),
        PayConfirmationDialog(
          title: "温馨提示",
          content:
              "由于App Store无法提供直接升级的能力，需要您进行手动升级，升级教程：打开App Store->点击右上角头像->选择订阅->选择Ai金曲大师->点击“查看所有方案”->选择你想要的套餐",
          cancelText: "取消",
          confirmText: "联系客服",
          onCancel: () {},
          onConfirm: () {
            openCustomerService();
          },
        ),
      );
    }
  }

  ///查询是否可以升级套餐
  void checkUpgrade() async {
    await HttpUtils.post(APIs.canRisehappys, {
      "ver": 2,
      "support_pays": Platform.isAndroid ? "wxpay,alipay,yeepay" : "apple",
    }, success: (data) {
      // Get.log("查询是否可以升级套餐=======>$data");
      if (data["status"] == 200) {
        canUpgrade = data["data"]["can_rise_happy"];
        errorMessage = data["data"]["error_message"];
      }
    });
  }

  /// 获取所有的超级配置
  preLoginConfig({
    void Function()? onSuccess,
  }) {
    HttpUtils.get(
      APIs.getConfig,
      {"group": "jin_qu_da_shi"},
      success: (data) {
        byDebugPrint(data, tag: "超级配置---");

        ///首页背景图
        final config = data["data"]["shou_ye_ding_bu_bei_jing_tu"];
        if (config != null && config is! List) {
          PreLoginConfigBean configBean = PreLoginConfigBean.fromJson(config);
          homeBgUrl.value = configBean.valText;
        }

        ///榜单背景图
        final config2 = data["data"]["pai_hang_bang_bei_jing_tu"];
        if (config2 != null && config2 is! List) {
          PreLoginConfigBean configBean = PreLoginConfigBean.fromJson(config2);
          rankingBgUrl.value = configBean.valText;
        }

        ///是否开启登录前置
        final config3 = data["data"]["deng_lu_qian_zhi"];
        if (config3 != null && config3 is! List) {
          PreLoginConfigBean configBean = PreLoginConfigBean.fromJson(config3);
          if (configBean.valText == "1") {
            isLoginPre = true;
          } else {
            isLoginPre = false;
          }
          update();
        }

        ///付费页挽留运营位图片
        final config4 = data["data"]["zhi_fu_wan_liu_tan_chuang"];
        if (config4 != null && config4 is! List) {
          PreLoginConfigBean configBean = PreLoginConfigBean.fromJson(config4);
          vipPurchaseRetentionImage = configBean.valText;
        }

        ///付费页新用户运营位图片
        final config5 = data["data"]["zhi_fu_ye_shou_ci_tan_chuang"];
        if (config5 != null && config5 is! List) {
          PreLoginConfigBean configBean = PreLoginConfigBean.fromJson(config5);
          vipPurchaseNewUserImage = configBean.valText;
        }

        ///首页底部运营小条图片
        final config6 = data["data"]["shou_ye_di_bu_xiao_tiao"];
        if (config6 != null && config6 is! List) {
          PreLoginConfigBean configBean = PreLoginConfigBean.fromJson(config6);
          homeBottomImage = configBean.valText;
        }

        ///写歌页面悬浮图片
        final config7 = data["data"]["xie_ge_ye_you_fu_dong_tu_biao"];
        if (config7 != null && config7 is! List) {
          PreLoginConfigBean configBean = PreLoginConfigBean.fromJson(config7);
          writeSongFloatingImage = configBean.valText;
        }

        ///首次用户试用挽留引导文案
        final config8 = data["data"]["Ai_yin_yue_yin_dao_an_niu_wen_an"];
        if (config8 != null && config8 is! List) {
          PreLoginConfigBean configBean = PreLoginConfigBean.fromJson(config8);
          btnText = configBean.valText;
        }

        ///首次用户试用音乐播放时间
        final config9 = data["data"]["bo_fang_yu_lan_shi_chang"];
        if (config9 != null && config9 is! List) {
          PreLoginConfigBean configBean = PreLoginConfigBean.fromJson(config9);
          playTime = int.parse(configBean.valText);
          Get.log("===播放时间===$playTime");
        }

        ///邀请名称配置
        final inviteNameConfig = data["data"]["yao_qing_ming_cheng"];
        if (inviteNameConfig != null && inviteNameConfig is! List) {
          PreLoginConfigBean configBean =
              PreLoginConfigBean.fromJson(inviteNameConfig);
          Get.log("===邀请名称===${configBean.toJson()}");
          if (configBean.valText.isNotEmpty) {
            inviteName = configBean.valText;
            update();
          }
        }

        ///邀请背景图相关配置
        final inviteBgUrlConfig = data["data"]["yao_qing_bei_jing_tu"];
        if (inviteBgUrlConfig != null && inviteBgUrlConfig is! List) {
          PreLoginConfigBean configBean =
              PreLoginConfigBean.fromJson(inviteBgUrlConfig);
          Get.log("===邀请背景图===${configBean.toJson()}");
          if (configBean.valText.isNotEmpty) {
            inviteBgUrl = configBean.valText;
            update();
          }
        }

        ///回归用户背景
        final comeBackUserConfig = data["data"]["hui_gui_you_hui"];
        if (comeBackUserConfig != null && comeBackUserConfig is! List) {
          PreLoginConfigBean configBean =
          PreLoginConfigBean.fromJson(comeBackUserConfig);
          Get.log("===回归用户背景===${configBean.toJson()}");
          if (configBean.valText.isNotEmpty) {
            comeBackUserBgUrl = configBean.valText;
            update();
          }
        }

        ///抄底支付用户背景
        final comeBackPayConfig = data["data"]["chang_gui_yong_hu"];
        if (comeBackPayConfig != null && comeBackPayConfig is! List) {
          PreLoginConfigBean configBean =
          PreLoginConfigBean.fromJson(comeBackPayConfig);
          Get.log("===抄底用户背景===${configBean.toJson()}");
          if (configBean.valText.isNotEmpty) {
            comeBackPayBgUrl = configBean.valText;
            update();
          }
        }


        ///关闭引导背景
        final closeGuideConfig = data["data"]["guan_bi_yin_dao"];
        if (closeGuideConfig != null && closeGuideConfig is! List) {
          PreLoginConfigBean configBean =
          PreLoginConfigBean.fromJson(closeGuideConfig);
          Get.log("===关闭引导===${configBean.toJson()}");
          if (configBean.valText.isNotEmpty) {
            closeGuideBg = configBean.valText;
            update();
          }
        }

        ///关闭引导背景
        final noFreeTimeBgConfig = data["data"]["mian_fei_ci_shu"];
        if (noFreeTimeBgConfig != null && noFreeTimeBgConfig is! List) {
          PreLoginConfigBean configBean =
          PreLoginConfigBean.fromJson(noFreeTimeBgConfig);
          Get.log("===免费次数===${configBean.toJson()}");
          if (configBean.valText.isNotEmpty) {
            noFreeTimeBg = configBean.valText;
            update();
          }
        }

        ///音符值不足且没有vip
        final noMusicNoteAndNoVipBgConfig = data["data"]["yin_fu_zhi_bu_zu_wu_vip"];
        if (noMusicNoteAndNoVipBgConfig != null && noMusicNoteAndNoVipBgConfig is! List) {
          PreLoginConfigBean configBean =
          PreLoginConfigBean.fromJson(noMusicNoteAndNoVipBgConfig);
          Get.log("===音符不足无会员===${configBean.toJson()}");
          if (configBean.valText.isNotEmpty) {
            noMusicNoteAndNoVipBg = configBean.valText;
            update();
          }
        }

        ///音符值不足且有vip
        final noMusicNoteAndVipBgConfig = data["data"]["yin_fu_zhi_bu_zu_you_vip"];
        if (noMusicNoteAndVipBgConfig != null && noMusicNoteAndVipBgConfig is! List) {
          PreLoginConfigBean configBean =
          PreLoginConfigBean.fromJson(noMusicNoteAndVipBgConfig);
          Get.log("===音符不足有会员===${configBean.toJson()}");
          if (configBean.valText.isNotEmpty) {
            noMusicNoteAndVipBg = configBean.valText;
            update();
          }
        }


        ///折扣未支付
        final orderShowBgConfig = data["data"]["zhe_kou_wei_zhi_fu"];
        if (orderShowBgConfig != null && orderShowBgConfig is! List) {
          PreLoginConfigBean configBean =
          PreLoginConfigBean.fromJson(orderShowBgConfig);
          Get.log("===折扣未支付===${configBean.toJson()}");
          if (configBean.valText.isNotEmpty) {
            orderShowBg = configBean.valText;
            update();
          }
        }


        ///折扣过期
        final orderShowRedEnvelopBgConfig = data["data"]["zhe_kou_guo_qi"];
        if (orderShowRedEnvelopBgConfig != null && orderShowRedEnvelopBgConfig is! List) {
          PreLoginConfigBean configBean =
          PreLoginConfigBean.fromJson(orderShowRedEnvelopBgConfig);
          Get.log("===折扣过期===${configBean.toJson()}");
          if (configBean.valText.isNotEmpty) {
            orderShowRedEnvelop = configBean.valText;
            update();
          }
        }

        ///付费页面挽留
        final  vipPurchaseKeepBgConfig = data["data"]["fu_fei_ye_wan_liu_tan_chuang"];
        if (vipPurchaseKeepBgConfig != null && vipPurchaseKeepBgConfig is! List) {
          PreLoginConfigBean configBean =
          PreLoginConfigBean.fromJson(vipPurchaseKeepBgConfig);
          Get.log("===付费页面挽留===${configBean.toJson()}");
          if (configBean.valText.isNotEmpty) {
            vipPurchaseKeepDialog = configBean.valText;
            update();
          }
        }


      },
      fail: (code, msg) {},
    );
  }

  ///检查是否前置登录
  /// [actionCallback] 如果需要登录，登录成功后要执行的操作

  void checkPreLogin({VoidCallback? actionCallback, String? source}) {
    // if (isLoginPre && user.value?.isFormal == 0) {
    //   // 保存被限制的操作回调
    //   if (actionCallback != null) {
    //     _pendingActionCallback = actionCallback;
    //   }
    //   if (user.value?.isVip == 0) {
    //     login(loginSuccess: () {
    //       // 登录成功后执行待执行的操作
    //       _executePendingAction();
    //     });
    //   } else {
    //     ///账号绑定
    //   }
    // } else {
    //   ///未开启前置登录，未登录并且是会员，则强制绑定
    //   if (user.value?.isFormal == 0 && user.value?.isVip == 1) {
    //     return;
    //   }
    //   actionCallback?.call();
    // }

    if (user.value?.isFormal == 0) {
      // 保存被限制的操作回调
      if (actionCallback != null) {
        _pendingActionCallback = actionCallback;
      }
      login(
          source: source,
          loginSuccess: () {
            // 登录成功后执行待执行的操作
          },
          loginCancel: () {
            ///延时执行
            Future.delayed(const Duration(milliseconds: 100), () {
              if (user.value?.isFormal == 1) {
                _executePendingAction();
              }
            });
          });
    } else {
      actionCallback?.call();
    }
  }

  /// 执行被前置登录限制的操作
  void _executePendingAction() {
    if (_pendingActionCallback != null) {
      _pendingActionCallback!();
      _pendingActionCallback = null; // 执行后清空回调
    }
  }

  /// 清除待执行的操作（用于正常关闭登录页面时）
  void clearPendingAction() {
    _pendingActionCallback = null;
  }

  /// 更新
  void checkIsNewUser(bool isNewUser) {
    isShowNewUserDialog = isNewUser;
    update();
  }

  ///清除数据
  void clearHistoryData() {
    launchInfo = null;
    is30Vip = false;
    is90Vip = false;
    is365Vip = false;
    SpUtil.putBool(ConstKeys.audioAgree, false);
    SpUtil.putBool(ConstKeys.audioAgreePrivacy, false);
  }

  ///打开回归用户背景弹窗
   openComeBackUserBgDialog(){
    Get.dialog(ComeBackPayDialog(comeBackUserBgUrl: comeBackUserBgUrl,));
  }

  ///打开抄底支付弹窗
  openComeBackPayBgDialog(){
    comeBackPayBgUrl;
    Get.dialog(BuyBottomDialog(comeBackPayBgUrl: comeBackPayBgUrl,));
  }

  ///打开关闭引导背景弹窗
  openCloseGuideBg(){
    Get.dialog( CloseGuideDialog(closeGuideBg: closeGuideBg,));
  }

  ///打开没有试用次数的弹窗
  openNoFreeTimeBg(){
    Get.dialog( NoFreeTimePayDialog(noFreeTimeBg: noFreeTimeBg,));
  }

  ///打开没有音符值弹窗
  openNoMusicNoteAndOpenVipBgDialog(){
    Get.dialog( NoMusicNoteOpenVipDialog(noMusicNoteAndNoVipBg: noMusicNoteAndNoVipBg,));
  }

  ///打开没有音符值弹窗
  openNoMusicNoteVipBgDialog(){
    Get.dialog( NoMusicNoteVipDialog(noMusicNoteAndVipBg: noMusicNoteAndVipBg,));
  }
}

/// 上报用户设备信息
class DeviceInfoUpload {
  /// 有推送token时加入推送token
  static void uploadUserDeviceInfo({String? pushToken}) async {
    await ByAscribeUtil.iniBDConvert();
    final params = await ByDeviceInfoUtils.getUserDiviceInfo();
    if (pushToken != null) {
      params["um_device_tokens"] = pushToken;
    }
    HttpUtils.post(APIs.deviceInfo, params, success: (data) {
      Get.log("~~~~~上报设备信息成功$data,$pushToken");
    }, fail: (code, msg) {
      FlutterBugly.uploadException(message: "上报用户设备信息", detail: msg);
    });
  }
}
