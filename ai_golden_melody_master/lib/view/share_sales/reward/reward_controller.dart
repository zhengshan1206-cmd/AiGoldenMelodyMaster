import 'dart:async';

import 'package:ai_golden_melody_master/common/lib/app_http/apis.dart';
import 'package:ai_golden_melody_master/view/share_sales/reward/widgets/real_name_authentication_dialog.dart';
import 'package:ai_golden_melody_master/view/share_sales/reward/widgets/selected_pay_dialog.dart';
import 'package:ai_golden_melody_master/view/share_sales/reward/widgets/withdraw_notice_dialog.dart';
import 'package:ai_golden_melody_master/view/share_sales/reward/widgets/withdraw_page_dialog.dart';
import 'package:alipay_kit/alipay_kit.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wechat_kit/wechat_kit.dart';
import 'package:ai_golden_melody_master/common/lib/app_common/by_nav_router_utils.dart';
import 'package:ai_golden_melody_master/common/lib/app_common/event/common_event.dart';
import 'package:ai_golden_melody_master/common/lib/app_http/http_utils.dart';
import '../bean/withdraw_details_model.dart';
import '../bean/withdraw_model.dart';
import '../share_sales_controller.dart';

class RewardController extends GetxController {

  FocusNode focusNode = FocusNode();
  TextEditingController moneyTextEditingController = TextEditingController();

  ///用户姓名
  TextEditingController userNameController = TextEditingController();

  ///用户身份证
  TextEditingController idController = TextEditingController();

  ///用户手机号码
  TextEditingController phoneController = TextEditingController();

  ///用户姓名焦点
  FocusNode userNameFocusNode = FocusNode();

  ///用户身份证焦点
  FocusNode userIdFocusNode = FocusNode();

  ///用户手机号码焦点
  FocusNode phoneFocusNode = FocusNode();

  ///当前容器高度
  double height = 454.w;

  ///可提现
  String canWithdrawCash = "0.00";

  ///待提现
  String pending = "0.00";

  ///已提现
  String withdrawBalance = "0.00";

  ///累计奖励
  String cumulativeIncome = "0.00";

  ///提现须知
  String cashNotes = "";

  List<WithdrawUserData> payDataList = [];

  ///提现方式类型 0-无绑定好的提现方式  1-支付宝 2-微信  3-支付宝、微信都可以选择
  int withdrawType = 0;

  ///订阅支付宝授权
  StreamSubscription<AlipayResp>? _alipaySubs;

  ///订阅微信授权
  StreamSubscription<WechatResp>? _wechatSubs;

  ///微信返回结果
  WechatAuthResp? wechatAuthResp;

  ///支付宝返回结果
  AlipayResp? alipayResp;

  ///提交给服务器的支付类型
  int postPayMethodToServer = 0;

  ///提现金额
  double withdrawMoney = 0.00;

  String userName = "";
  String idCard = "";
  String phoneNumber = "";

  bool idCardError = false;
  bool phoneNumberError = false;

  bool notMatch = false;
  String notMatchMessage = "";



  ///提现已到账数据
  List<WithdrawDetailsItem> completedList = [];
  int completedWithdrawPage = 1;
  int completedWithdrawPageSize = 10;
  bool completedCouldLoadMore = true;
  bool completedShowShimmer = true;
  ///提现已到账的数据controller
  EasyRefreshController _completedController = EasyRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true,
  );


  ///提现待到账数据
  List<WithdrawDetailsItem> uncompletedList = [];
  int uncompletedWithdrawPage = 1;
  int uncompletedWithdrawPageSize = 10;
  bool uncompletedCouldLoadMore = true;
  bool unCompletedShowShimmer = true;
  ///提现已到账的数据controller
  EasyRefreshController _uncompletedController = EasyRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true,
  );


  ShareSalesController shareSalesController = Get.find<ShareSalesController>();

  bool pushWechatAuth = false;

  ///订阅支付宝网页端授权
  StreamSubscription<ByHyBaseWebViewCloseEvent>? alipayWebViewSubs;

  StreamSubscription<ShareDataEvent>? shareSubs;



  @override
  void onInit() {
    initData();

    shareSubs = eventBus.on<ShareDataEvent>().listen((e){
      pushWechatAuth = false;
      update();
    });

    _alipaySubs = AlipayKitPlatform.instance.authResp().listen(
      (resp) {
        alipayResp = resp;
        Get.log("支付宝授权response: ${resp.toJson()}");
        if (resp.isSuccessful) {
          Map json = resp.toJson();
          json["type"] = 1;
          Get.log("支付宝json: $json");
          authCallback(json: json);
        } else {

        }
      },
      onError: (e) {
        Get.log("支付宝授权失败：$e");
      },
      onDone: () {},
    );

    _wechatSubs = WechatKitPlatform.instance.respStream().listen(
        (resp) {
          Get.log("微信授权response: ${resp.toJson()}");
          if(resp.isSuccessful){
            Map json = resp.toJson();
            json["type"] = 2;
            Get.log("微信json: $json");
            if(pushWechatAuth){
              authCallback(json: json);
            }
          }
        },
        onDone: () {},
        onError: (e) {
          if(pushWechatAuth){
            EasyLoading.showToast("微信授权失败,请您重新操作");
          }
          Get.log("微信授权失败：$e");
        });

    alipayWebViewSubs = eventBus.on<ByHyBaseWebViewCloseEvent>().listen((e){
      if(e.title=="支付宝授权"){
        Get.log("===支付宝网页授权===");
        getAccount();
      }
    });

    moneyTextEditingController.addListener(() {
      if (moneyTextEditingController.text.trim().isNotEmpty) {
        withdrawMoney = double.parse(moneyTextEditingController.text.trim());
        update();
      }else{
        withdrawMoney = 0.00;
        update();
      }
    });

    userNameController.addListener(() {
      if (userNameController.text.trim().isNotEmpty) {
        userName = userNameController.text.trim();
        notMatch = false;
        notMatchMessage = "";
        update();
      }
    });

    idController.addListener(() {
      if (idController.text.trim().isNotEmpty) {
        idCardError = false;
        idCard = idController.text.trim();
        notMatch = false;
        notMatchMessage = "";
        Get.log("更新身份证===> $idCard");
        update();
      }
    });

    phoneController.addListener(() {
      if (phoneController.text.trim().isNotEmpty) {
        phoneNumberError = false;
        phoneNumber = phoneController.text.trim();
        notMatch = false;
        notMatchMessage = "";
        update();
      }
    });

    super.onInit();
  }


  initData() {
    final dynamic arguments = Get.arguments;
    if (arguments != null) {
      canWithdrawCash = arguments["canWithdrawCash"] ?? "0.00";
      pending = arguments["pending"] ?? "0.00";
      withdrawBalance = arguments["withdrawBalance"] ?? "0.00";
      cumulativeIncome = arguments["cumulativeIncome"] ?? "0.00";
      cashNotes = arguments["cashNotes"] ?? "";
    }
    getAccount();
    refreshCompletedWithdraw();
    refreshUnCompletedWithdraw();
    getInviteInfo();
    update();
  }

  ///打开选择支付方式弹窗
  showPayDialog() {
    showModalBottomSheet(
        context: Get.context!,
        shape:  RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(12.w),
          ),
        ),
        backgroundColor:Color(0XFF1E1E1E) ,
        builder: (context) {
          return SelectedPayDialog();
        });
  }

  ///取消焦点
  unFocusNode() {
    if (focusNode.hasFocus) {
      focusNode.unfocus();
    }
  }

  ///打开明细页面
  showWithdrawPageDialog() {
    showModalBottomSheet(
        context: Get.context!,
        shape:  RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(12.w),
          ),
        ),
        backgroundColor:Color(0XFF2E2E2E) ,
        builder: (context) {
          return WithdrawPageDialog();
        });
  }

  ///打开说明弹窗
  showNoticeDialog() {
    Get.dialog(WithdrawNoticeDialog());
  }

  ///提现成功弹窗
  showSuccessNoticeDialog() {
    Get.dialog(WithdrawSuccessNoticeDialog());
  }

  ///提现失败弹窗
  showFailureNoticeDialog({required String errorMsg,}) {
    Get.dialog(WithdrawFailureNoticeDialog(errorMsg: errorMsg,));
  }

  ///实名认证弹窗
  showRealNameAuthDialog() {
    showDialog(
        useSafeArea: false,
        barrierDismissible: false,
        context: Get.context!,
        // shape:  RoundedRectangleBorder(
        //   borderRadius: BorderRadius.vertical(
        //     top: Radius.circular(20.w)
        //   )
        // ),
        builder: (context) {
          return RealNameAuthenticationDialog();
        });
  }

  ///键盘拉起 刷新布局高度
  updateContainerHeight({
    bool keyboard = false,
  }) {
    if (keyboard) {
      height = 0.9.sh;
    } else {
      height = 454.w;
    }
    update();
  }

  ///取消实名认证相关输入框的焦点
  unFocusRealNameFocusNode() {
    if (userNameFocusNode.hasFocus) {
      userNameFocusNode.unfocus();
    }
    if (userIdFocusNode.hasFocus) {
      userIdFocusNode.unfocus();
    }
    if (phoneFocusNode.hasFocus) {
      phoneFocusNode.unfocus();
    }
  }

  ///提现
  withdrawPay() {
    if (payDataList.isEmpty) {
      EasyLoading.showToast( "请绑定支付方式~");
      return;
    }

    if(withdrawMoney<=0){
      EasyLoading.showToast( "请您输入有效金额~");
      return;
    }
    if(withdrawMoney>500){
      EasyLoading.showToast("单笔最大提现金额，不可超过500元");
      return;
    }


    for (var e in payDataList) {
      if (e.type == postPayMethodToServer) {
        ///暂未实名认证
        if (e.isAuth == 0) {
          showRealNameAuthDialog();
          return;
        }

        ///已经实名认证
        if (e.isAuth == 1) {
          withDrawMoney();
          return;
        }
      }
    }

    Get.log("===提交给服务器的提现方式=== $postPayMethodToServer");
  }

  ///绑定支付宝
  bindAlipay() {
    pushWechatAuth = false;
    HttpUtils.post(
      APIs.bindPay,
      {
        "type": 1,
      },
      success: (data) async {
        Get.back();
        dynamic serverData = data["data"];
        String app = "";
        String web = "";
        if (serverData != null) {
          if (serverData["app"] != null) {
            app = serverData["app"];
          }
          if (serverData["web"] != null) {
            web = serverData["web"];
          }
        }

        bool canAliPay = await AlipayKitPlatform.instance.isInstalled();
        if (!canAliPay) {
          /// 支付宝网页端绑定
          if(web.isNotEmpty){
            ByNavRouterUtils.jumpWebViewPage(Get.context!, "支付宝授权", web);
            return;
          }
        }


        if (app.isNotEmpty) {
          await AlipayKitPlatform.instance.auth(
              authInfo:
              app);
        }

        Get.log("===绑定支付宝方式信息===$data");
        update();
      },
      fail: (code, msg) {
        EasyLoading.showToast( msg);
      },
    );
  }

  ///更换绑定方式
  changePayMethod(){
    if(payDataList.length==2){
      if(withdrawType==1){
        withdrawType =2;
        postPayMethodToServer = 2;
        update();
        return;
      }

      if(withdrawType==2){
        withdrawType =1;
        postPayMethodToServer = 1;
        update();
        return;
      }

    }
  }

  ///绑定微信
  bindWechatPay()async {
    bool canWechatPay = await WechatKitPlatform.instance.isInstalled();

    Get.log("===canWechatPay=======$canWechatPay");
    if (!canWechatPay) {
      EasyLoading.showToast("请安装微信，或者绑定其他支付方式。");
      return;
    }
    HttpUtils.post(
      APIs.bindPay,
      {
        "type": 2,
      },
      success: (data) async {
        Get.back();
        dynamic serverData = data["data"];
        String ghId = "";
        String path = "";
        String query = "";
        if (serverData != null) {
          if (serverData["gh_id"] != null && serverData["path"] != null) {
            ghId = serverData["gh_id"];
            path = serverData["path"];
            query = serverData["query"];
            Get.log("拉起授权===>$path?$query");

            pushWechatAuth = true;
            WechatKitPlatform.instance.launchMiniProgram(
              userName: ghId,
              path: "$path?$query",
            );
          }
        }

        Get.log("===绑定微信支付方式信息===$data");
        update();
      },
      fail: (code, msg) {
        EasyLoading.showToast( msg);
      },
    );
  }

  ///提现账号信息
  getAccount() {
    HttpUtils.get(
      APIs.withdrawAccount,
      {},
      success: (data) {
        WithdrawApiResponse withdrawApiResponse =
            WithdrawApiResponse.fromJson(data);
        payDataList = [];
        if (withdrawApiResponse.data.isNotEmpty) {
          payDataList = withdrawApiResponse.data;
        }

        ///todo 这里校验微信 支付宝 绑定情况
        if (payDataList.isEmpty) {
          withdrawType = 0;
        } else {
          if (payDataList.length >= 2) {
             withdrawType = 3;
            for (var e in payDataList) {
              if(e.type==1){
                withdrawType = 1;
                postPayMethodToServer = 1;
                update();
                return;
              }

              if(e.type==2){
                withdrawType = 2;
                postPayMethodToServer = 2;
                update();
                return;
              }
            }

            update();
          }

          if (payDataList.length == 1) {
            int type = payDataList.first.type;

            ///已绑定支付宝
            if (type == 1) {
              withdrawType = 1;
              postPayMethodToServer = 1;
            }

            ///已绑定微信
            if (type == 2) {
              withdrawType = 2;
              postPayMethodToServer = 2;
            }
          }
        }

        Get.log("===提现账号信息===$data");
        update();
      },
      fail: (code, msg) {
        EasyLoading.showToast(msg);
      },
    );
  }

  ///实名认证
  authentication() {
    pushWechatAuth = false;
    if (userName.isEmpty) {
      EasyLoading.showToast("请输入您的姓名");
      return;
    }

    if (idCard.isEmpty||idCard.length<18) {
      idCardError = true;
      EasyLoading.showToast("请输入您的有效18位身份证");
      update();
      return;
    }

    if (phoneNumber.isEmpty||phoneNumber.length<11) {
      phoneNumberError = true;
      EasyLoading.showToast("请输入您的有效手机号码");
      update();
      return;
    }

    HttpUtils.post(
      APIs.authentication,
      {
        "type": postPayMethodToServer, // 1.支付宝 2.微信
        "phone": phoneNumber, // 手机号
        "idCard": idCard, // 身份证
        "realName": userName // 姓名
      },
      success: (data) {
        getAccount();
        dynamic serverData = data["data"];
        Get.log("===实名认证信息===$data");
        notMatch = false;
        notMatchMessage = "";
        Get.back();
        EasyLoading.showToast( "实名认证成功~");
        update();
      },
      fail: (code, msg) {
        notMatch = true;
        notMatchMessage = msg;
        EasyLoading.showToast(msg);
      },
    );
  }

  ///微信、支付宝 实名认证回调
  authCallback({required Map json,}) {
    HttpUtils.post(
      APIs.authCallback,
      json,
      success: (data) {
        dynamic serverData = data["data"];
        Get.log("===微信、支付宝 实名认证回调===$data");
        getAccount();
        update();
        pushWechatAuth = false;
      },
      fail: (code, msg) {
        EasyLoading.showToast(msg);
      },
    );
  }

  clearData(){
    idCardError = false;
    phoneNumberError = false;
    phoneController.text = "";
    idController.text="";
    userNameController.text = "";
    userName = "";
    idCard = "";
    phoneNumber = "";
    notMatch = false;
    notMatchMessage = "";

    pushWechatAuth = false;
  }

  ///微信、支付宝提现
  withDrawMoney(){
    pushWechatAuth = false;
    HttpUtils.post(
      APIs.withdraw,
      {
        "type": postPayMethodToServer,
        "amount": withdrawMoney.toString(),
      },
      success: (data) {
        Get.log("===微信、支付宝 提现回调===$data");
        getAccount();
        showSuccessNoticeDialog();
        refreshCompletedWithdraw();
        refreshUnCompletedWithdraw();
        getInviteInfo();

        ///todo 刷新外面的数据
        shareSalesController.getInviteInfo();
        shareSalesController.getInviteList();
        shareSalesController.getIncomeList();

        update();
      },
      fail: (code, msg) {
        showFailureNoticeDialog(errorMsg: msg);
        // BotToast.showText(text: msg);
      },
    );
  }

  @override
  void dispose() {
    _alipaySubs?.cancel();
    _wechatSubs?.cancel();
    super.dispose();
  }

  ///刷新已经提现数据
  Future<void> refreshCompletedWithdraw() async {
    completedWithdrawPage =1;
    HttpUtils.get(
      APIs.getWithdrawList,
      {
        "page": completedWithdrawPage,
        "pageSize": completedWithdrawPageSize,
        "type": 1,
      },
      success: (data) {
        if (completedShowShimmer == true) {
          completedShowShimmer = false;
        }
        WithdrawDetailsApiResponse withdrawDetailsApiResponse = WithdrawDetailsApiResponse.fromJson(data);
        List<WithdrawDetailsItem> dataList = [];
        if(withdrawDetailsApiResponse.data.data.isNotEmpty){
          dataList = withdrawDetailsApiResponse.data.data;
        }
        int lastPage = withdrawDetailsApiResponse.data.lastPage;
        Get.log("====list====> ${data["data"]}");
        completedList.clear();
        completedList.addAll(dataList);
        if(completedWithdrawPage<lastPage){
          completedCouldLoadMore = true;
        }else{
          completedCouldLoadMore = false;
        }
        Get.log("====page====> ${completedWithdrawPage}  beans==> ${dataList.length}");
        _completedController.finishRefresh();
        _completedController.resetFooter();
        update();
      },
      fail: (code, msg) {
        EasyLoading.showToast(msg);
        _completedController.finishRefresh(IndicatorResult.fail);
        _completedController.resetFooter();
        update();
      },
    );
  }

  ///加载更多已经提现数据
  Future<void> loadMoreCompletedWithdraw()async{
    if(!completedCouldLoadMore){
      _completedController.finishLoad(IndicatorResult.noMore);
      _completedController.resetFooter();
      update();
      return;
    }
    completedWithdrawPage++;
    HttpUtils.get(
      APIs.getWithdrawList,
      {
        "page": completedWithdrawPage,
        "pageSize": completedWithdrawPageSize,
        "type": 1,
      },
      success: (data) {
        if (completedShowShimmer == true) {
          completedShowShimmer = false;
        }
        WithdrawDetailsApiResponse withdrawDetailsApiResponse = WithdrawDetailsApiResponse.fromJson(data);
        List<WithdrawDetailsItem> dataList = [];
        if(withdrawDetailsApiResponse.data.data.isNotEmpty){
          dataList = withdrawDetailsApiResponse.data.data;
        }
        int lastPage = withdrawDetailsApiResponse.data.lastPage;
        Get.log("====list====> ${data["data"]}");
        completedList.addAll(dataList);
        if(completedWithdrawPage<lastPage){
          completedCouldLoadMore = true;
        }else{
          completedCouldLoadMore = false;
        }
        Get.log("====page====> ${completedWithdrawPage}  beans==> ${dataList.length}");
        _completedController.finishLoad();
        _completedController.resetFooter();
        update();
      },
      fail: (code, msg) {
        EasyLoading.showToast(msg);
        _completedController.finishLoad(IndicatorResult.fail);
        _completedController.resetFooter();
        update();
      },
    );

  }


  ///刷新未提现数据
  Future<void> refreshUnCompletedWithdraw() async {
    uncompletedWithdrawPage =1;
    HttpUtils.get(
      APIs.getWithdrawList,
      {
        "page": uncompletedWithdrawPage,
        "pageSize": uncompletedWithdrawPageSize,
        "type": 2,
      },
      success: (data) {
        if (unCompletedShowShimmer == true) {
          unCompletedShowShimmer = false;
        }
        WithdrawDetailsApiResponse withdrawDetailsApiResponse = WithdrawDetailsApiResponse.fromJson(data);
        List<WithdrawDetailsItem> dataList = [];
        if(withdrawDetailsApiResponse.data.data.isNotEmpty){
          dataList = withdrawDetailsApiResponse.data.data;
        }
        int lastPage = withdrawDetailsApiResponse.data.lastPage;
        Get.log("====list====> ${data["data"]}");
        uncompletedList.clear();
        uncompletedList.addAll(dataList);
        if(uncompletedWithdrawPage<lastPage){
          uncompletedCouldLoadMore = true;
        }else{
          uncompletedCouldLoadMore = false;
        }
        Get.log("====page====> ${uncompletedWithdrawPage}  beans==> ${dataList.length}");
        _uncompletedController.finishRefresh();
        _uncompletedController.resetFooter();
        update();
      },
      fail: (code, msg) {
        EasyLoading.showToast(msg);
        _uncompletedController.finishRefresh(IndicatorResult.fail);
        _uncompletedController.resetFooter();
        update();
      },
    );
  }

  ///加载更多已经提现数据
  Future<void> loadMoreUnCompletedWithdraw()async{
    if(!uncompletedCouldLoadMore){
      _uncompletedController.finishLoad(IndicatorResult.noMore);
      _uncompletedController.resetFooter();
      update();
      return;
    }
    uncompletedWithdrawPage++;
    HttpUtils.get(
      APIs.getWithdrawList,
      {
        "page": uncompletedWithdrawPage,
        "pageSize": uncompletedWithdrawPageSize,
        "type": 2,
      },
      success: (data) {
        if (unCompletedShowShimmer == true) {
          unCompletedShowShimmer = false;
        }
        WithdrawDetailsApiResponse withdrawDetailsApiResponse = WithdrawDetailsApiResponse.fromJson(data);
        List<WithdrawDetailsItem> dataList = [];
        if(withdrawDetailsApiResponse.data.data.isNotEmpty){
          dataList = withdrawDetailsApiResponse.data.data;
        }
        int lastPage = withdrawDetailsApiResponse.data.lastPage;
        Get.log("====list====> ${data["data"]}");
        uncompletedList.addAll(dataList);
        if(uncompletedWithdrawPage<lastPage){
          uncompletedCouldLoadMore = true;
        }else{
          uncompletedCouldLoadMore = false;
        }
        Get.log("====page====> ${uncompletedWithdrawPage}  beans==> ${dataList.length}");
        _uncompletedController.finishLoad();
        _uncompletedController.resetFooter();
        update();
      },
      fail: (code, msg) {
        EasyLoading.showToast(msg);
        _uncompletedController.finishLoad(IndicatorResult.fail);
        _uncompletedController.resetFooter();
        update();
      },
    );

  }


  ///获取提现信息
  Future<void> getInviteInfo()async{
    HttpUtils.get(
      APIs.getInviteMoney,
      {
      },
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
}


class ByHyBaseWebViewCloseEvent {
  final String title;
  const ByHyBaseWebViewCloseEvent({
    required this.title,
  });
}

class ShareDataEvent{

}