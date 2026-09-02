
import 'dart:async';

import 'package:ai_golden_melody_master/common/lib/app_http/apis.dart';
import 'package:ai_golden_melody_master/view/share_sales/reward/reward_controller.dart';
import 'package:ai_golden_melody_master/view/share_sales/reward/reward_share_dialog.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:ai_golden_melody_master/common/lib/app_common/event/common_event.dart';
import 'package:ai_golden_melody_master/common/lib/app_http/http_utils.dart';
import 'package:ai_golden_melody_master/common/lib/app_permisson/byhy_permission_utils.dart';
import 'package:wechat_kit/wechat_kit.dart';
import '../../utils/common_event.dart';
import 'activity_notice_dialog.dart';
import 'bean/income_list_model.dart';
import 'bean/invite_info.dart';
import 'bean/invite_people_list.dart';

class ShareSalesController extends GetxController {
  ///邀请信息
  InviteInfoApiResponse? infoApiResponse;

  ///当前的分享海报初始化页面
  int initialPage = 0;

  ///分享海报的子组件
  List<Widget> itemsList = [];

  ///分享二维码地址
  String inviteUrl = "";

  ///选中的海报的坐标
  int selectedPosterIndex = 0;

  ///海报数据
  List<Poster> poster = [];

  String inviteCode = "";

  ///可提现
  String canWithdrawCash = "0.00";

  ///待提现
  String pending = "0.00";

  ///已提现
  String withdrawBalance = "0.00";

  ///累计奖励
  String cumulativeIncome = "0.00";

  ///奖励比例
  String rewardNumber = "";

  ///收益明细数据
  List<RewardItem> incomeList = [];
  int incomeListPage = 1;
  int incomeListPageSize = 10;
  bool incomeListCouldLoadMore = true;
  bool incomeListShowShimmer = true;

  ///收益明细数据controller
  EasyRefreshController _incomeListController = EasyRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true,
  );

  ///邀请用户信息
  List<UserItem> inviteUserList = [];
  int inviteUserListPage = 1;
  int inviteUserListPageSize = 10;
  bool inviteUserListCouldLoadMore = true;
  bool inviteUserListShowShimmer = true;

  ///收益明细数据controller
  EasyRefreshController _inviteUserListController = EasyRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true,
  );

  Widget? shareDialog;

  InviteActivityModel? descriptionUrl;

  ///监听登录成功.
  late StreamSubscription<LoginEvent> loginSubscription;

  ///获取邀请信息
  getInviteInfo() {
    HttpUtils.get(
      APIs.invitePeople,
      {},
      success: (data) {
        infoApiResponse = InviteInfoApiResponse.fromJson(data);
        InviteInfoData? inviteInfoData;
        poster = [];
        itemsList = [];
        if (infoApiResponse != null) {
          inviteInfoData = infoApiResponse!.data;
        }

        if (inviteInfoData != null) {
          poster = inviteInfoData.poster ?? [];
          inviteUrl = inviteInfoData.inviteUrl ?? "";
          inviteCode = inviteInfoData.inviteCode ?? '';
          descriptionUrl = inviteInfoData.description;
          if (inviteInfoData.inviteInfo != null) {
            int? rewardNumberData = inviteInfoData.inviteInfo!.rewardNumber;
            if (rewardNumberData == null) {
              rewardNumber = "";
            } else {
              rewardNumber = rewardNumberData.toString();
            }
          }
        }

        if (poster.isNotEmpty) {
          for (var e in poster) {
            itemsList.add(
              PosterItemView(
                poster: e,
                inviteUrl: inviteUrl,
                key: ValueKey(
                  e.id,
                ),
                inviteCode: inviteCode,
              ),
            );
          }

          shareDialog = RewardShareDialog(
            infoApiResponse: infoApiResponse!,
            itemsList: itemsList,
          );
        }

        Get.log("===获取邀请信息===$data");
        update();
      },
      fail: (code, msg) {
        EasyLoading.showToast(msg);
      },
    );

    HttpUtils.get(
     APIs.getInviteMoney,
      {},
      success: (data) {
        Get.log("获取提现信息=====>$data");
        canWithdrawCash = data["data"]["canWithdrawCash"];
        pending = data["data"]["pending"];
        withdrawBalance = data["data"]["withdrawBalance"];
        cumulativeIncome = data["data"]["cumulativeIncome"];
        update();
      },
      fail: (code, msg) {
        EasyLoading.showToast(msg);
      },
    );
  }

  ///复制邀请码
  copyCode({
    required String code,
  }) {
    if (code.isEmpty) {
      // BotToast.showText(text: "复制邀请码成功~");
      return;
    }
    ClipboardData data = ClipboardData(text: code);
    Clipboard.setData(data);
    EasyLoading.showToast( "复制邀请码成功~");
  }

  ///邀请好友弹窗
  inviteFriendDialog() {
    if (infoApiResponse != null && shareDialog != null) {
      // Get.dialog(
      //     RewardShareDialog(
      //       infoApiResponse: infoApiResponse!,
      //       itemsList: itemsList,
      //     ),
      //     barrierDismissible: false);

      eventBus.fire(ShareDataEvent());
      Get.dialog(shareDialog!, barrierDismissible: false);
    }
  }

  ///活动说明弹窗
  Future<void> showActivityNoticeDialog()async{

    Get.log("===descriptionUrl=== ${descriptionUrl?.toJson()}");
    // showModalBottomSheet(
    //
    //     context: Get.context!, builder: (context){
    //   return ActivityNoticeDialog();
    // });

    if(descriptionUrl!=null){
      Get.dialog(ActivityNoticeDialog(descriptionUrl: descriptionUrl!,));
    }
  }


  ///分享选中的海报index
  updateSelectedPosterIndex({
    required int index,
  }) {
    selectedPosterIndex = index;
    update();
  }

  ///分享到微信好友
  shareWechatFriends()async {
    bool canWechat = await WechatKitPlatform.instance.isInstalled();

    Get.log("===canWechat=======$canWechat");
    if (!canWechat) {
      EasyLoading.showToast("请您先安装微信，才能分享给微信好友。");
      return;
    }

    if (poster.isNotEmpty) {
      eventBus.fire(
          SharePosterDataEvent(type: 0, id: poster[selectedPosterIndex].id!));
    }
  }

  ///分享到微信朋友圈
  shareWechatFriendsCircle()async {
    bool canWechat = await WechatKitPlatform.instance.isInstalled();

    Get.log("===canWechat=======$canWechat");
    if (!canWechat) {
      EasyLoading.showToast("请您先安装微信，才能分享到微信朋友圈。");
      return;
    }
    if (poster.isNotEmpty) {
      eventBus.fire(
          SharePosterDataEvent(type: 1, id: poster[selectedPosterIndex].id!));
    }
  }

  ///保存到相册
  saveLocal() async {
    final status = await ByPermissionUtils.photos();
    if (!status) return;
    if (poster.isNotEmpty ) {
      Get.log("===选中的index==$selectedPosterIndex  ${poster.length}");

      eventBus.fire(
          SharePosterDataEvent(type: 2, id: poster[selectedPosterIndex].id!));
    }
  }

  @override
  void onInit() {
    super.onInit();
    loginSubscription = eventBus.on<LoginEvent>().listen((e) {
      if (e.type == 1) {
        Get.log("===重新登录=== 刷新赚钱页面");
        getData();
      }
    });
    getData();
  }


  getData(){
    getInviteInfo();
    getIncomeList();
    getInviteList();
  }


  ///收益明细
  getIncomeList() {
    HttpUtils.get(
      APIs.getIncomeList,
      {
        "page": 1,
        "pageSize": 10,
      },
      success: (data) {
        RewardResponse rewardResponse = RewardResponse.fromJson(data);
        if (rewardResponse.data.data.isNotEmpty) {
          incomeList.clear();
          incomeList.addAll(rewardResponse.data.data);
        }

        Get.log("获取收益信息 api/invite/getIncomeList=====>$data");
        update();
      },
      fail: (code, msg) {
        EasyLoading.showToast( msg);
      },
    );
  }

  ///邀请人明细
  getInviteList() {
    HttpUtils.get(
      APIs.getInviteList,
      {
        "page": 1,
        "pageSize": 10,
      },
      success: (data) {
        InviteUserResponse inviteUserResponse =
            InviteUserResponse.fromJson(data);
        if (inviteUserResponse.data.data.isNotEmpty) {
          inviteUserList.clear();
          inviteUserList.addAll(inviteUserResponse.data.data);
        }

        Get.log("获取邀请人 api/invite/getInviteList=====>$data");
        update();
      },
      fail: (code, msg) {
        EasyLoading.showToast( msg);
      },
    );
  }

  ///刷新收益明细数据
  Future<void> refreshIncomeList() async {
    incomeListPage = 1;
    HttpUtils.get(
      APIs.getIncomeList,
      {
        "page": incomeListPage,
        "pageSize": incomeListPageSize,
        "type": 1,
      },
      success: (data) {
        if (incomeListShowShimmer == true) {
          incomeListShowShimmer = false;
        }
        RewardResponse rewardResponse = RewardResponse.fromJson(data);
        if (rewardResponse.data.data.isNotEmpty) {
          incomeList.clear();
          incomeList.addAll(rewardResponse.data.data);
        }

        Get.log("获取收益信息 api/invite/getIncomeList=====>$data");
        update();
        int lastPage = rewardResponse.data.lastPage;
        if (incomeListPage < lastPage) {
          incomeListCouldLoadMore = true;
        } else {
          incomeListCouldLoadMore = false;
        }
        Get.log(
            "====page====> ${incomeListPage}  beans==> ${incomeList.length}");
        _incomeListController.finishRefresh();
        _incomeListController.resetFooter();
        update();
      },
      fail: (code, msg) {
        EasyLoading.showToast(msg);
        _incomeListController.finishRefresh(IndicatorResult.fail);
        _incomeListController.resetFooter();
        update();
      },
    );
  }

  ///加载更多收益明细数据
  Future<void> loadIncomeList() async {
    if (!incomeListCouldLoadMore) {
      _incomeListController.finishLoad(IndicatorResult.noMore);
      _incomeListController.resetFooter();
      update();
      return;
    }
    incomeListPage++;
    HttpUtils.get(
      APIs.getIncomeList,
      {
        "page": incomeListPage,
        "pageSize": incomeListPageSize,
        "type": 1,
      },
      success: (data) {
        if (incomeListShowShimmer == true) {
          incomeListShowShimmer = false;
        }
        RewardResponse rewardResponse = RewardResponse.fromJson(data);
        if (rewardResponse.data.data.isNotEmpty) {
          incomeList.addAll(rewardResponse.data.data);
        }

        Get.log("获取收益信息 api/invite/getIncomeList=====>$data");
        update();
        int lastPage = rewardResponse.data.lastPage;
        if (incomeListPage < lastPage) {
          incomeListCouldLoadMore = true;
        } else {
          incomeListCouldLoadMore = false;
        }
        Get.log(
            "====page====> ${incomeListPage}  beans==> ${incomeList.length}");
        _incomeListController.finishLoad();
        _incomeListController.resetFooter();
        update();
      },
      fail: (code, msg) {
       EasyLoading.showToast( msg);
        _incomeListController.finishLoad(IndicatorResult.fail);
        _incomeListController.resetFooter();
        update();
      },
    );
  }

  ///刷新邀请人明细数据
  Future<void> refreshInviteUserList() async {
    inviteUserListPage = 1;
    HttpUtils.get(
      APIs.getInviteList,
      {
        "page": inviteUserListPage,
        "pageSize": inviteUserListPageSize,
        "type": 1,
      },
      success: (data) {
        if (inviteUserListShowShimmer == true) {
          inviteUserListShowShimmer = false;
        }
        InviteUserResponse inviteUserResponse =
            InviteUserResponse.fromJson(data);
        if (inviteUserResponse.data.data.isNotEmpty) {
          inviteUserList.clear();
          inviteUserList.addAll(inviteUserResponse.data.data);
        }

        Get.log("获取邀请人明细 api/invite/getInviteList=====>$data");
        update();
        int lastPage = inviteUserResponse.data.lastPage;
        if (inviteUserListPage < lastPage) {
          inviteUserListCouldLoadMore = true;
        } else {
          inviteUserListCouldLoadMore = false;
        }
        Get.log(
            "====page====> ${incomeListPage}  beans==> ${incomeList.length}");
        _inviteUserListController.finishRefresh();
        _inviteUserListController.resetFooter();
        update();
      },
      fail: (code, msg) {
        EasyLoading.showToast(msg);
        _inviteUserListController.finishRefresh(IndicatorResult.fail);
        _inviteUserListController.resetFooter();
        update();
      },
    );
  }

  ///加载更多邀请人明细数据
  Future<void> loadInviteUserList() async {
    if (!inviteUserListCouldLoadMore) {
      _inviteUserListController.finishLoad(IndicatorResult.noMore);
      _inviteUserListController.resetFooter();
      update();
      return;
    }
    inviteUserListPage++;
    HttpUtils.get(
      APIs.getInviteList,
      {
        "page": inviteUserListPage,
        "pageSize": inviteUserListPageSize,
        "type": 1,
      },
      success: (data) {
        if (inviteUserListShowShimmer == true) {
          inviteUserListShowShimmer = false;
        }
        InviteUserResponse inviteUserResponse =
            InviteUserResponse.fromJson(data);
        if (inviteUserResponse.data.data.isNotEmpty) {
          inviteUserList.addAll(inviteUserResponse.data.data);
        }
        Get.log("获取邀请人明细 api/invite/getInviteList=====>$data");

        update();
        int lastPage = inviteUserResponse.data.lastPage;
        if (inviteUserListPage < lastPage) {
          inviteUserListCouldLoadMore = true;
        } else {
          inviteUserListCouldLoadMore = false;
        }
        Get.log(
            "====page====> ${inviteUserListPage}  beans==> ${inviteUserList.length}");
        _inviteUserListController.finishLoad();
        _inviteUserListController.resetFooter();
        update();
      },
      fail: (code, msg) {
        EasyLoading.showToast(msg);
        _inviteUserListController.finishLoad(IndicatorResult.fail);
        _inviteUserListController.resetFooter();
        update();
      },
    );
  }
}

///分享海报数据事件
class SharePosterDataEvent {
  ///0-微信好友  1-朋友圈  2-保存到本地相册
  final int type;
  final int id;
  const SharePosterDataEvent({
    required this.type,
    required this.id,
  });
}
