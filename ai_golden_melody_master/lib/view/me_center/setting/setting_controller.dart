import 'package:ai_golden_melody_master/model/launch/app_config.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:ai_golden_melody_master/common/lib/app_http/apis.dart';
import 'package:ai_golden_melody_master/common/lib/app_http/http_utils.dart';
import 'package:ai_golden_melody_master/common/lib/app_common/by_nav_router_utils.dart';
import '../../../model/setting/setting_item_bean.dart';
import '../../lanuch_page/launch_controller.dart';

class SettingController extends GetxController {
  String version = '';
  List<SettingItemBean> settingConfigs = <SettingItemBean>[];
  AppConfig? appConfig;

  @override
  void onInit() {
    super.onInit();
    initData();
  }

  ///初始化数据
  initData() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    loadSettingConfig();
    version = "V" + info.version;
    appConfig = Get.find<LaunchController>().appConfig;
    if (appConfig == null) {
      getConfig();
    }
    update();
  }

  ///返回上一页面
  goBack() {
    Get.back();
  }

  ///拨打客服电话事件
  callPhone() async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: "4008698538",
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }

  ///获取设置的相关配置
  loadSettingConfig() {
    HttpUtils.get(
      APIs.loadSettingIems,
      {},
      success: (data) {
        final settingItems = data["data"];
        Get.log("请求下来的设置数据===>$data");
        if (settingItems is List) {
          settingConfigs.assignAll(
              settingItems.map((e) => SettingItemBean.fromJson(e)).toList());
        }
        update();
      },
      fail: (code, msg) {},
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

  ///打开隐私政策
  openVip() {
    if (appConfig != null) {
      ByNavRouterUtils.jumpWebViewPage(
          Get.context!, "会员服务协议", appConfig?.data!.agreement!.userVip ?? "");
    }
  }

  ///打开关于我们
  openAboutUs() {
    if (appConfig != null) {
      ByNavRouterUtils.jumpWebViewPage(
          Get.context!, "关于我们", appConfig?.data!.agreement!.aboutUs ?? "");
    }
  }

  ///打开联系客服
  openCustomerService() async {
    // if (appConfig != null) {
    //   Get.log("联系客服==== ${appConfig?.data!.customerService ?? ""}");
    //   ByNavRouterUtils.jumpWebViewPage(
    //       Get.context!, "联系客服", appConfig?.data!.customerService ?? "");
    // }
    const wechatUrl = 'weixin://';
    if (await canLaunchUrl(Uri.parse(wechatUrl))) {
      if (appConfig != null) {
        Get.log("联系客服==== ${appConfig?.data!.customerService ?? ""}");
        ByNavRouterUtils.jumpWebViewPage(
            Get.context!, "联系客服", appConfig?.data!.customerService ?? "");
      }
    } else {
      EasyLoading.showToast("由于您未安装微信，无法直接跳转客服。");
    }
  }

  ///打开算法备案公示
  openAlgorithm() {
    if (appConfig != null) {
      ByNavRouterUtils.jumpWebViewPage(
          Get.context!, "算法备案公示", appConfig?.data!.agreement!.algorithm ?? "");
    }
  }

  ///打开算法备案公示
  openComplaints() {
    if (appConfig != null) {
      ByNavRouterUtils.jumpWebViewPage(
          Get.context!, "投诉与建议", appConfig?.data!.complaints ?? "");
    }
  }
}
