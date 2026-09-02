import 'dart:async';
import 'package:ai_golden_melody_master/common/lib/app_common/event/common_event.dart';
import 'package:ai_golden_melody_master/common/lib/app_http/apis.dart';
import 'package:ai_golden_melody_master/common/lib/app_http/http_utils.dart';
import 'package:ai_golden_melody_master/view/lanuch_page/launch_controller.dart';
import 'package:ai_golden_melody_master/view/me_center/my_work/delete_confirm_dialog.dart';
import 'package:ai_golden_melody_master/view/me_center/my_work/download_music_dialog.dart';
import 'package:ai_golden_melody_master/view/me_center/my_work/edit_music_cover/edit_music_cover_controller.dart';
import 'package:ai_golden_melody_master/view/me_center/my_work/rename_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import '../../../model/ai_music/my_works_data_model.dart';
import '../../../model/user/user_info_bean.dart';
import '../../ai/ai_play_music/share_dialog.dart';
import '../../ai/ai_write_music/exclusive_rename_audio_dialog.dart';
import '../../publish/controller/strategy_zone_controller.dart';
import 'edit_music_cover/edit_music_conver_page.dart';

class MyWorkController extends GetxController {
  List<TabModel> modelList = const [
    TabModel(type: 0, text: "全部"),
    TabModel(type: 1, text: "已完成"),
    TabModel(type: 2, text: "生成中"),
    TabModel(type: 3, text: "已失败"),
  ];

  ///选中的类型
  int selectedType = 0;

  ///分页条数 这里默认给20
  int pageSize = 10;

  ///全部作品请求页码
  int allMusicDataPageSize = 1;

  ///已完成作品请求页码
  int completedMusicDataPageSize = 1;

  ///生成中作品请求页码
  int completingMusicDataPageSize = 1;

  ///已失败作品请求页码
  int failureMusicDataPageSize = 1;

  ///全部作品集合
  List<MyWorksMusicItem> allMusicDataList = [];

  ///已完成作品集合
  List<MyWorksMusicItem> completedMusicDataList = [];

  ///生成中作品集合
  List<MyWorksMusicItem> completingMusicDataList = [];

  ///已失败作品集合
  List<MyWorksMusicItem> failureMusicDataList = [];

  ///全部作品请求controller
  RefreshController allMusicDataController =
      RefreshController(initialRefresh: true);

  ///已完成作品请求controller
  RefreshController completedMusicDataController =
      RefreshController(initialRefresh: true);

  ///生成中作品请求controller
  RefreshController completingMusicDataController =
      RefreshController(initialRefresh: true);

  ///已失败作品请求controller
  RefreshController failureMusicDataController =
      RefreshController(initialRefresh: true);

  late StreamSubscription<CoverSuccessEvent> streamSubscription;

  bool isFirstLoad = true;

  ///是否正在加载数据
  bool isLoadingData = false;

  ///状态变量：标记当前是否正在刷新/加载
  bool isRefreshing = false;
  bool isLoading = false;

  @override
  void onInit() {
    streamSubscription = eventBus.on<CoverSuccessEvent>().listen((e) {
      if (selectedType == 0) {
        allMusicDataController.requestRefresh();
      } else if (selectedType == 1) {
        completedMusicDataController.requestRefresh();
      }
    });
    super.onInit();
  }

  ///切换选中类型事件
  selectedTypeEvent({required int type}) {
    selectedType = type;
    update();
  }

  ///刷新作品记录
  Future<void> onRefresh() async {
    int page = 1;
    String status = "";
    isLoadingData = true;
    isRefreshing = true;
    if (selectedType == 0) {
      status = "";
      allMusicDataPageSize = 1;
    } else if (selectedType == 1) {
      status = "1";
      completedMusicDataPageSize = 1;
    } else if (selectedType == 2) {
      status = "0";
      completingMusicDataPageSize = 1;
    } else if (selectedType == 3) {
      status = "2";
      failureMusicDataPageSize = 1;
    }
    try {
      HttpUtils.get(
        APIs.getMyWorkList,
        {
          "status": status,
          "page": page,
          "pageSize": pageSize,
        },
        success: (data) {
          Get.log("刷新请求下来的音乐作品数据===>$data");
          MyWorksDataModel myWorksDataModel = MyWorksDataModel.fromJson(data);
          List<MyWorksMusicItem> musicDataList = [];
          if (myWorksDataModel.status == 200) {
            if (myWorksDataModel.data.data.isNotEmpty) {
              int totalPage = myWorksDataModel.data.lastPage;
              musicDataList.addAll(myWorksDataModel.data.data);
              if (selectedType == 0) {
                allMusicDataList.clear();
                allMusicDataList.addAll(musicDataList);
                allMusicDataController.refreshCompleted(resetFooterState: true);
              } else if (selectedType == 1) {
                completedMusicDataList.clear();
                completedMusicDataList.addAll(musicDataList);
                completedMusicDataController.refreshCompleted(
                    resetFooterState: true);
              } else if (selectedType == 2) {
                completingMusicDataList.clear();
                completingMusicDataList.addAll(musicDataList);
                completingMusicDataController.refreshCompleted(
                    resetFooterState: true);
              } else if (selectedType == 3) {
                failureMusicDataList.clear();
                failureMusicDataList.addAll(musicDataList);
                failureMusicDataController.refreshCompleted(
                    resetFooterState: true);
              }

              if (selectedType == 0) {
                allMusicDataPageSize += 1;
              } else if (selectedType == 1) {
                completedMusicDataPageSize += 1;
              } else if (selectedType == 2) {
                completingMusicDataPageSize += 1;
              } else if (selectedType == 3) {
                failureMusicDataPageSize += 1;
              }
            } else {
              if (selectedType == 0) {
                allMusicDataController.refreshToIdle();
              } else if (selectedType == 1) {
                completedMusicDataController.refreshToIdle();
              } else if (selectedType == 2) {
                completingMusicDataController.refreshToIdle();
              } else if (selectedType == 3) {
                failureMusicDataController.refreshToIdle();
              }
            }
          } else {
            refreshFailure();
          }

          isLoadingData = false;
          isRefreshing = false;

          update();
        },
      );
    } catch (e) {
      isLoadingData = false;
      isRefreshing = false;
      refreshFailure();
      update();
    }
  }

  ///刷新失败
  void refreshFailure() {
    if (selectedType == 0) {
      allMusicDataController.refreshFailed();
    } else if (selectedType == 1) {
      completedMusicDataController.refreshFailed();
    } else if (selectedType == 2) {
      completingMusicDataController.refreshFailed();
    } else if (selectedType == 3) {
      failureMusicDataController.refreshFailed();
    }
    EasyLoading.showToast("获取作品记录失败,您可再次下拉刷新请求");
  }

  ///加载更多作品记录
  Future<void> onLoading() async {
    int page = 1;
    String status = "";
    isLoadingData = true;
    isLoading = true;
    if (selectedType == 0) {
      status = "";
      page = allMusicDataPageSize;
    } else if (selectedType == 1) {
      status = "1";
      page = completedMusicDataPageSize;
    } else if (selectedType == 2) {
      status = "0";
      page = completingMusicDataPageSize;
    } else if (selectedType == 3) {
      status = "2";
      page = failureMusicDataPageSize;
    }
    try {
      HttpUtils.get(
        APIs.getMyWorkList,
        {
          "status": status,
          "page": page,
          "pageSize": pageSize,
        },
        success: (data) {
          Get.log("请求下来的音乐作品数据===>$data");
          MyWorksDataModel myWorksDataModel = MyWorksDataModel.fromJson(data);
          List<MyWorksMusicItem> musicDataList = [];
          if (myWorksDataModel.status == 200) {
            if (myWorksDataModel.data.data.isNotEmpty) {
              int totalPage = myWorksDataModel.data.lastPage;
              musicDataList.addAll(myWorksDataModel.data.data);
              if (selectedType == 0) {
                allMusicDataList.addAll(musicDataList);
                allMusicDataController.loadComplete();
              } else if (selectedType == 1) {
                completedMusicDataList.addAll(musicDataList);
                completedMusicDataController.loadComplete();
              } else if (selectedType == 2) {
                completingMusicDataList.addAll(musicDataList);
                completingMusicDataController.loadComplete();
              } else if (selectedType == 3) {
                failureMusicDataList.addAll(musicDataList);
                failureMusicDataController.loadComplete();
              }

              ///还可以继续加载
              if (selectedType == 0) {
                allMusicDataPageSize += 1;
              } else if (selectedType == 1) {
                completedMusicDataPageSize += 1;
              } else if (selectedType == 2) {
                completingMusicDataPageSize += 1;
              } else if (selectedType == 3) {
                failureMusicDataPageSize += 1;
              }
            } else {
              if (selectedType == 0) {
                allMusicDataController.loadNoData();
              } else if (selectedType == 1) {
                completedMusicDataController.loadNoData();
              } else if (selectedType == 2) {
                completingMusicDataController.loadNoData();
              } else if (selectedType == 3) {
                failureMusicDataController.loadNoData();
              }
            }
          } else {
            onLoadFailure();
          }
          isLoadingData = false;
          isLoading = false;
          update();
        },
      );
    } catch (e) {
      isLoadingData = false;
      isLoading = false;
      onLoadFailure();
      update();
    }
  }

  ///刷新失败
  void onLoadFailure() {
    if (selectedType == 0) {
      allMusicDataController.loadFailed();
    } else if (selectedType == 1) {
      completedMusicDataController.loadFailed();
    } else if (selectedType == 2) {
      completingMusicDataController.loadFailed();
    } else if (selectedType == 3) {
      failureMusicDataController.loadFailed();
    }
    EasyLoading.showToast("加载更多作品记录失败,您可再次上滑刷新请求");
  }

  /// 分享歌曲
  void shareMusic({
    required String shareUrl,
    required MyWorksMusicItem myWorksMusicItem,
  }) {
    Get.back();
    showModalBottomSheet(
        context: Get.context!,
        builder: (c) {
          return ShareDialog(
            sharePath: shareUrl,
            myWorksMusicItem: myWorksMusicItem,
          );
        },
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ));
  }

  ///修改音乐名称
  void renameMusicName({required String name, required int id, int type = 0}) {
    Get.back();
    Get.dialog(
      RenameDialog(
        name: name,
        id: id,
        title: type == 0 ? "修改歌名" : "修改作者名",
      ),
    ).then((value) {
      if (value != null) {
        Get.log("===newName=== ${value["newName"]}");
        if (value["newName"] != null) {
          if (type == 0) {
            renameMusicNameEvent(name: value["newName"], id: id);
          } else if (type == 1) {
            renameAuthorNameEvent(name: value["newName"], id: id);
          }
        }
      }
    });
  }

  ///给服务器提交修改的音乐名称
  renameMusicNameEvent({required String name, required int id}) {
    HttpUtils.post(APIs.reMusicName, {"id": id, "name": name},
        success: (value) {
      Get.log("修改歌名成功===$value");
      if (selectedType == 0) {
        allMusicDataController.requestRefresh();
      } else if (selectedType == 1) {
        completedMusicDataController.requestRefresh();
      }

      EasyLoading.showToast("修改歌名成功~", maskType: EasyLoadingMaskType.none);
    }, fail: (code, msg) {
      EasyLoading.showToast(msg, maskType: EasyLoadingMaskType.none);
    });
  }

  ///给服务器提交修改的作者名称
  renameAuthorNameEvent({required String name, required int id}) {
    HttpUtils.post(APIs.reNameAuthor, {
      "id": id,
      "type": 1, // 1.演唱者 2.词作者 3.曲作者
      "name": name
    }, success: (value) {
      Get.log("修改作者名成功===$value");
      if (selectedType == 0) {
        allMusicDataController.requestRefresh();
      } else if (selectedType == 1) {
        completedMusicDataController.requestRefresh();
      }
      EasyLoading.showToast("修改作者名成功~", maskType: EasyLoadingMaskType.none);
    }, fail: (code, msg) {
      EasyLoading.showToast(msg, maskType: EasyLoadingMaskType.none);
    });
  }

  ///删除歌曲
  deleteMusic({required String name, required int id, int type = 0}) {
    Get.back();
    Get.dialog(
      DeleteConfirmDialog(
        name: name,
        id: id,
        title: "删除确认",
      ),
    ).then((value) {
      if (value != null) {
        if (value["confirmDelete"] == true) {
          HttpUtils.post(APIs.deleteMusic, {
            "id": id,
          }, success: (value) {
            Get.log("删除歌曲成功===$value");
            if (selectedType == 0) {
              allMusicDataController.requestRefresh();
            } else if (selectedType == 1) {
              completedMusicDataController.requestRefresh();
            }
          }, fail: (code, msg) {
            EasyLoading.showToast(msg, maskType: EasyLoadingMaskType.none);
          });
        }
      }
    });
  }

  ///下载歌曲
  showDownLoadMusicDialog({
    required MyWorksMusicItem musicItem,
  }) {
    Get.back();
    showModalBottomSheet(
        context: Get.context!,
        builder: (c) {
          // return ShareDialog(sharePath: shareUrl);
          return DownloadMusicDialog(
            musicItem: musicItem,
          );
        },
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ));
  }

  ///修改封面
  showEditMusicCoverDialog({
    required MyWorksMusicItem musicItem,
  }) {
    Get.back();
    Get.put(EditMusicCoverController());

    Get.find<EditMusicCoverController>()
        .updateMusicItem(musicItemData: musicItem);
    showModalBottomSheet(
      context: Get.context!,
      builder: (c) {
        // return ShareDialog(sharePath: shareUrl);
        return EditMusicCoverPage(
          musicItem: musicItem,
        );
      },
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      isScrollControlled: true,
    );
  }

  refreshAllData() {
    if (selectedType == 0) {
      allMusicDataController.requestRefresh();
    } else if (selectedType == 1) {
      completedMusicDataController.requestRefresh();
    }
  }

  ///复制歌词
  copLyrics({required String lyrics}) {
    /// 提取所有标签
    RegExp tagRegex = RegExp(r'\[.*?\]');

    /// 提取歌词文本（不含标签）
    String pureLyrics = lyrics.replaceAll(tagRegex, '').trim();
    Get.log('纯歌词文本== $pureLyrics');
    ClipboardData data = ClipboardData(text: pureLyrics);
    Clipboard.setData(data);
    EasyLoading.showToast(
      "复制歌词成功～",
      maskType: EasyLoadingMaskType.none,
    );
  }

  ///展示付费挽留弹窗
  showPayDialog(){
    bool isVip = Get.find<LaunchController>().isVip;
    UserInfoBean? userValue =  Get.find<LaunchController>().user.value;
    if(userValue!=null){
      if(userValue.integral<=0){
        if(isVip){
          Get.find<LaunchController>().openNoMusicNoteVipBgDialog();
        }else{
          Get.find<LaunchController>().openNoMusicNoteAndOpenVipBgDialog();
        }
      }else{
        Get.back();
      }
    }
  }
}
