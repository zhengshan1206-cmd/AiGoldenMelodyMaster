import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:ai_golden_melody_master/common/lib/app_http/apis.dart';
import 'package:ai_golden_melody_master/common/lib/app_http/http_utils.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import '../../../../model/purchase/integral_record_bean.dart';

///音符值明细页面业务逻辑
class MeMusicNoteValueListController extends GetxController {
  List<TabModel> modelList = const [
    TabModel(type: 0, text: "全部"),
    TabModel(type: 1, text: "获取"),
    TabModel(type: 2, text: "消耗"),
  ];

  ///选中的类型
  int selectedType = 0;

  ///全部音符值消耗
  List<IntegralRecordBean> allRecordBeanList = [];

  ///获取音符值消耗
  List<IntegralRecordBean> getRecordBeanList = [];

  ///消耗音符值消耗
  List<IntegralRecordBean> costRecordBeanList = [];

  ///全部音符值请求页码
  int allRecordPageSize = 1;

  ///获取音符值请求页码
  int getRecordPageSize = 1;

  ///消耗音符值请求页码
  int costRecordPageSize = 1;

  ///分页条数 这里默认给20
  int pageSize = 20;

  ///全部音符值请求controller
  RefreshController allRecordBeanController =
      RefreshController(initialRefresh: true);

  ///获取音符值请求controller
  RefreshController getRecordBeanController =
      RefreshController(initialRefresh: true);

  ///消耗音符值请求controller
  RefreshController costRecordBeanController =
      RefreshController(initialRefresh: true);
  @override
  void onInit() {
    super.onInit();
  }

  ///切换选中类型事件
  selectedTypeEvent({required int type}) {
    selectedType = type;
    update();
  }

  ///加载音符值记录
  Future<void> onLoading() async {
    late int page;
    if (selectedType == 0) {
      page = allRecordPageSize;
    } else if (selectedType == 1) {
      page = getRecordPageSize;
    } else if (selectedType == 2) {
      page = costRecordPageSize;
    }
    try {
      HttpUtils.get(
        APIs.musicScore,
        {
          "page": page,
          "pageSize": pageSize,
          "type": selectedType,
        },
        success: (data) {
          Get.log("获取的音符值记录data====> $data");
          if (data == null || data["data"] == null) {
            EasyLoading.showToast("获取音符值明细记录失败");
            return;
          }
          final List items = data["data"]["data"] ?? [];
          final List<IntegralRecordBean> records =
              items.map((ele) => IntegralRecordBean.fromJson(ele)).toList();
          Get.log("获取的音符值记录==>${data["data"]["data"]}");
          ///音符值记录不为空
          if (records.isNotEmpty) {
            Get.log("获取的音符值列表值集合长度==>${records.length}");
            if (selectedType == 0) {
              allRecordPageSize += 1;
              allRecordBeanList.addAll(records);
              allRecordBeanController.loadComplete();
            } else if (selectedType == 1) {
              getRecordPageSize += 1;
              getRecordBeanList.addAll(records);
              getRecordBeanController.loadComplete();
            } else if (selectedType == 2) {
              costRecordPageSize += 1;
              costRecordBeanList.addAll(records);
              costRecordBeanController.loadComplete();
            }
          } else {
            ///音符值记录为空
            if (selectedType == 0) {
              allRecordBeanController.loadNoData();
            } else if (selectedType == 1) {
              getRecordBeanController.loadNoData();
            } else if (selectedType == 2) {
              costRecordBeanController.loadNoData();
            }
          }
          update();
        },
        fail: (code, msg) {
          EasyLoading.showToast(msg);
        },
      );
    } catch (e) {
      EasyLoading.showToast("获取积分记录失败");
    }
  }

  ///刷新音符值记录
  Future<void> onRefresh() async {
    late int page;
    if (selectedType == 0) {
      page = 1;
      allRecordPageSize = 1;
    } else if (selectedType == 1) {
      page = 1;
      getRecordPageSize = 1;
    } else if (selectedType == 2) {
      page = 1;
      costRecordPageSize = 1;
    }
    try {
      HttpUtils.get(
        APIs.musicScore,
        {
          "page": page,
          "pageSize": pageSize,
          "type": selectedType,
        },
        success: (data) {
          Get.log("data====> $data");
          if (data == null || data["data"] == null) {
            EasyLoading.showToast("获取音符值明细记录失败");
            return;
          }
          final List items = data["data"]["data"] ?? [];
          final List<IntegralRecordBean> records =
              items.map((ele) => IntegralRecordBean.fromJson(ele)).toList();
          Get.log("获取的音符值记录==>${data["data"]["data"]}");
          ///音符值记录不为空
          if (records.isNotEmpty) {
            Get.log("获取的音符值列表值集合长度==>${records.length}");
            if (selectedType == 0) {
              allRecordPageSize = (page + 1);
              allRecordBeanList.clear();
              allRecordBeanList.addAll(records);
              allRecordBeanController.refreshCompleted(
                resetFooterState: true,
              );
            } else if (selectedType == 1) {
              getRecordPageSize = (page + 1);
              getRecordBeanList.clear();
              getRecordBeanList.addAll(records);
              getRecordBeanController.refreshCompleted(
                resetFooterState: true,
              );
            } else if (selectedType == 2) {
              costRecordPageSize = (page + 1);
              costRecordBeanList.clear();
              costRecordBeanList.addAll(records);
              costRecordBeanController.refreshCompleted(
                resetFooterState: true,
              );
            }
          } else {
            ///音符值记录为空
            if (selectedType == 0) {
              allRecordBeanController.refreshToIdle();
            } else if (selectedType == 1) {
              getRecordBeanController.refreshToIdle();
            } else if (selectedType == 2) {
              costRecordBeanController.refreshToIdle();
            }
          }
          update();
        },
        fail: (code, msg) {
          refreshFailure();
          EasyLoading.showToast(msg);
        },
      );
    } catch (e) {
      EasyLoading.showToast("获取积音符值明细失败，请尝试刷新");
    }
  }

  ///刷新失败
  void refreshFailure() {
    if (selectedType == 0) {
      allRecordBeanController.refreshFailed();
    } else if (selectedType == 1) {
      getRecordBeanController.refreshFailed();
    } else if (selectedType == 2) {
      costRecordBeanController.refreshFailed();
    }
    EasyLoading.showToast("获取音符值明细失败,您可再次下拉刷新请求");
  }

  ///刷新失败
  void onLoadFailure() {
    if (selectedType == 0) {
      allRecordBeanController.loadFailed();
    } else if (selectedType == 1) {
      getRecordBeanController.loadFailed();
    } else if (selectedType == 2) {
      costRecordBeanController.loadFailed();
    }
    EasyLoading.showToast("加载更多音符值明细失败,您可再次上滑刷新请求");
  }
}

class TabModel {
  final int type;
  final String text;
  const TabModel({
    required this.type,
    required this.text,
  });
}
