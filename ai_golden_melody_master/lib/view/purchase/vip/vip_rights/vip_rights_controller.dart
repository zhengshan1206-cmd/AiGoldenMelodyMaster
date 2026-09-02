import 'package:ai_golden_melody_master/common/lib/app_http/apis.dart';
import 'package:ai_golden_melody_master/common/lib/app_http/http_utils.dart';
import 'package:ai_golden_melody_master/model/purchase/vip_model.dart';
import 'package:ai_golden_melody_master/view/common/tutorial/tutorial_mixin.dart';
import 'package:ai_golden_melody_master/view/purchase/vip/vip_purchase_controller.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '../../../../model/user/user_info_bean.dart';
import '../../../../utils/assets.dart';
import '../../../../utils/by_color_utils.dart';
import '../../../lanuch_page/launch_controller.dart';
import '../../../../navigator/app_pages.dart';
import 'package:ai_golden_melody_master/common/lib/app_common/event/common_event.dart';

class VipRightsController extends GetxController with TutorialMixin {
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

  ///是否可以升级套餐 2不可以 1可以
  int canUpgrade = 2;

  @override
  void onInit() {
    super.onInit();
    initData();
    // 监听购买成功事件
    eventBus.on<BuySuccessEvent>().listen((event) {
      // 购买成功后刷新用户信息
      initData();
    });
  }

  @override
  void onClose() {
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
    canUpgrade = Get.find<LaunchController>().canUpgrade;

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

  /// 升级会员
  void upgradeMember() {
    Get.find<LaunchController>().showVipUpgradeDialog(
      onClose: () {
        /// 升级成功后，刷新用户信息
        print("升级成功后，刷新用户信息");
        initData();
      },
    );
  }
}
