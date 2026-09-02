import 'package:ai_golden_melody_master/common/lib/app_common/by_nav_router_utils.dart';
import 'package:ai_golden_melody_master/common/lib/app_ui/video/byhy_video_clip_preview.dart';
import 'package:ai_golden_melody_master/utils/navigation_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ai_golden_melody_master/common/lib/app_http/apis.dart';
import 'package:ai_golden_melody_master/common/lib/app_http/http_utils.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:ai_golden_melody_master/view/publish/beans/banner_beans.dart';

class BannerWidgetController extends GetxController {
  ///banner数据列表
  RxList<BannerBean> bannerList = <BannerBean>[].obs;

  ///是否显示banner
  RxBool showBanner = true.obs;

  ///banner位置标识，用于区分不同页面的banner
  int bannerPosition = 1;

  ///实例ID，用于区分不同的banner实例
  String? instanceId;

  ///banner高度
  double bannerHeight = 80.0;

  ///是否自动播放
  bool autoPlay = true;

  ///自动播放间隔时间（秒）
  int autoPlayInterval = 3;

  ///是否启用无限滚动
  bool enableInfiniteScroll = true;

  ///banner点击回调
  Function(BannerBean banner)? onBannerTap;

  ///banner关闭回调
  Function()? onBannerClose;

  @override
  void onInit() {
    super.onInit();
    // 移除自动加载，让外部调用 setBannerPosition 时再加载
    // loadBanners();
  }

  ///加载banner数据
  ///首页  1
  /// 个人中心  7
  /// AI写歌 11
  /// ai音乐攻略 200
  /// 201 APP-AI音乐-我的作品
  void loadBanners({
    int? position,
    bool showMsgWhenFailed = false,
  }) {
    if (position != null) {
      bannerPosition = position;
    }

    HttpUtils.get(
      APIs.homeBanner,
      {
        "postion": bannerPosition,
      },
      showMsgWhenFailed: showMsgWhenFailed,
      success: (data) {
        if (bannerPosition == 11) {
          print("bannerPosition: $bannerPosition");
          print("instanceId: $instanceId");
          print("data: $data");
        }
        final List bannerData = data["data"]["item"] ?? [];
        List<BannerBean> beans =
            bannerData.map((e) => BannerBean.fromJson(e)).toList();
        bannerList.value = beans;
        update();
      },
      fail: (code, msg) {
        // 确保在失败时也清空banner列表，触发回调
        bannerList.value = [];
        update();
        if (!showMsgWhenFailed) {
          EasyLoading.showToast(msg);
        }
      },
    );
  }

  ///关闭banner
  void closeBanner() {
    showBanner.value = false;
    onBannerClose?.call();
  }

  ///设置banner高度
  void setBannerHeight(double height) {
    bannerHeight = height;
    update();
  }

  ///设置banner位置
  void setBannerPosition(int position) {
    if (bannerPosition != position) {
      bannerPosition = position;
      // 设置实例ID
      instanceId = 'banner_$position';
      loadBanners();
    }
  }

  ///设置自动播放
  void setAutoPlay(bool autoPlay) {
    this.autoPlay = autoPlay;
    update();
  }

  ///设置自动播放间隔
  void setAutoPlayInterval(int seconds) {
    autoPlayInterval = seconds;
    update();
  }

  ///设置无限滚动
  void setEnableInfiniteScroll(bool enable) {
    enableInfiniteScroll = enable;
    update();
  }

  ///设置banner点击回调
  void setOnBannerTap(Function(BannerBean banner) callback) {
    onBannerTap = callback;
  }

  ///设置banner关闭回调
  void setOnBannerClose(Function() callback) {
    onBannerClose = callback;
  }

  ///处理banner点击
  void handleBannerTap(BannerBean banner) {
    final url = banner.jumpUrl;
    final params = banner.jumpParam;
    if (banner.type == 1) {
      // 检测是否为纯数字，如果是则转换为int，否则使用默认值0
      final isNumeric = RegExp(r'^\d+$').hasMatch(params);
      if (isNumeric) {
        NavigationUtils.navigateToTab(int.parse(params));
      }
    } else if (banner.type == 2) {
      // 跳转
      Get.toNamed("/$url", arguments: params);
    } else if (banner.type == 3) {
      //视频播放
      Navigator.push(
        Get.context!,
        MaterialPageRoute(
          builder: (context) => VideoClipPreview(
            url,
          ),
        ),
      );
    } else if (banner.type == 4) {
      //跳转外链
      ByNavRouterUtils.jumpWebViewPage(Get.context!, banner.des, url);
    }
    onBannerTap?.call(banner);
  }

  ///刷新banner数据
  void refreshBanners() {
    loadBanners();
  }
}
