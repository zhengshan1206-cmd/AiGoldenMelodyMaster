import 'package:ai_golden_melody_master/common/lib/app_common/byhy_download_util.dart';
import 'package:ai_golden_melody_master/common/lib/app_common/event/common_event.dart';
import 'package:ai_golden_melody_master/common/lib/app_http/apis.dart';
import 'package:ai_golden_melody_master/common/lib/app_http/http_utils.dart';
import 'package:ai_golden_melody_master/view/me_center/my_work/edit_music_cover/conver_select_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:ai_golden_melody_master/common/lib/app_permisson/byhy_permission_utils.dart';
import '../../../../model/ai_music/ai_music_cover.dart';
import '../../../../model/ai_music/my_works_data_model.dart';
import '../../../../navigator/app_pages.dart';
import '../../../publish/illegal_words/controller/illegal_words_controller.dart';

///音乐编辑控制器
class EditMusicCoverController extends GetxController {
  List<EditMusicCoverTabModel> tabModeList = const [
    EditMusicCoverTabModel(type: 0, name: "AI重绘歌曲封面"),
    EditMusicCoverTabModel(type: 1, name: "本地上传歌曲封面"),
  ];

  int selectedTabIndex = 0;

  List<DataDetailModel> coverModelList = [];

  int selectedCoverIndex = 0;

  late MyWorksMusicItem musicItem;

  AssetEntity? localAssetEntity;

  RefreshController allMusicCoverController =
      RefreshController(initialRefresh: true);

  RefreshController allMusicCoverController2 =
      RefreshController(initialRefresh: true);

  List<DataDetailModel> coverModelList2 = [];

  int page = 1;

  int page2 = 1;

  bool isAiCreate = false;

  bool isUseCover = false;

  @override
  void onInit() {
    getDataList();
    super.onInit();
  }

  ///加载更多封面记录
  Future<void> onLoading() async {
    page+=1;
    try {
      HttpUtils.post(APIs.getCoverList, {
        "page": page,
        "pageSize": 20,
      }, success: (data) {
        List<DataDetailModel> dataFromServer = [];
        AiMusicCoverResponseModel aiMusicCoverResponseModel =
            AiMusicCoverResponseModel.fromJson(
          data,
        );
        if (aiMusicCoverResponseModel.data.data.isNotEmpty) {
          dataFromServer = aiMusicCoverResponseModel.data.data;
          coverModelList.addAll(dataFromServer);
          allMusicCoverController.loadComplete();
          page += 1;
        } else {
          allMusicCoverController.loadNoData();
        }

        update();
        Get.log(
            "===加载更多获取列表记录=== ${aiMusicCoverResponseModel.data.data.length}");
        eventBus.fire(const RefreshDataEvent());
      }, fail: (code, msg) {
        onLoadFailure();
      });
    } catch (e) {
      onLoadFailure();
    }
  }

  ///刷新封面记录
  Future<void> onRefresh() async {
    page = 1;
    try {
      HttpUtils.post(APIs.getCoverList, {
        "page": page,
        "pageSize": 20,
      }, success: (data) {
        List<DataDetailModel> dataFromServer = [];
        coverModelList = [];
        AiMusicCoverResponseModel aiMusicCoverResponseModel =
            AiMusicCoverResponseModel.fromJson(
          data,
        );
        if (aiMusicCoverResponseModel.data.data.isNotEmpty) {
          dataFromServer = aiMusicCoverResponseModel.data.data;
          coverModelList.addAll(dataFromServer);
          allMusicCoverController.refreshCompleted(resetFooterState: true);
        } else {
          allMusicCoverController.refreshToIdle();
        }

        update();
        Get.log("===刷新获取列表记录=== ${aiMusicCoverResponseModel.data.data.length}");
        eventBus.fire(const RefreshDataEvent());
      }, fail: (code, msg) {
        refreshFailure();
      });
    } catch (e) {
      refreshFailure();
    }
  }

  ///加载更多封面记录
  Future<void> onLoading2() async {
    page2+=1;
    try {
      HttpUtils.post(APIs.getCoverList, {
        "page": page2,
        "pageSize": 20,
      }, success: (data) {
        List<DataDetailModel> dataFromServer = [];
        AiMusicCoverResponseModel aiMusicCoverResponseModel =
            AiMusicCoverResponseModel.fromJson(
          data,
        );
        if (aiMusicCoverResponseModel.data.data.isNotEmpty) {
          dataFromServer = aiMusicCoverResponseModel.data.data;
          coverModelList2.addAll(dataFromServer);
          allMusicCoverController2.loadComplete();
          page2 += 1;
        } else {
          allMusicCoverController2.loadNoData();
        }

        update();
        Get.log(
            "===加载更多获取列表记录=== ${aiMusicCoverResponseModel.data.data.length}");
        eventBus.fire(const RefreshDataEvent(type: 2));
      }, fail: (code, msg) {
        onLoadFailure2();
      });
    } catch (e) {
      onLoadFailure2();
    }
  }

  ///刷新封面记录
  Future<void> onRefresh2() async {
    page2 = 1;
    try {
      HttpUtils.post(APIs.getCoverList, {
        "page": page2,
        "pageSize": 20,
      }, success: (data) {
        List<DataDetailModel> dataFromServer = [];
        coverModelList2 = [];
        AiMusicCoverResponseModel aiMusicCoverResponseModel =
            AiMusicCoverResponseModel.fromJson(
          data,
        );
        if (aiMusicCoverResponseModel.data.data.isNotEmpty) {
          dataFromServer = aiMusicCoverResponseModel.data.data;
          coverModelList2.addAll(dataFromServer);
          allMusicCoverController2.refreshCompleted(resetFooterState: true);
        } else {
          allMusicCoverController2.refreshToIdle();
        }

        update();
        Get.log("===刷新获取列表记录=== ${aiMusicCoverResponseModel.data.data.length}");
        eventBus.fire(const RefreshDataEvent(type: 2));
      }, fail: (code, msg) {
        refreshFailure2();
      });
    } catch (e) {
      refreshFailure2();
    }
  }

  ///加载失败
  void refreshFailure() {
    allMusicCoverController.loadFailed();
    EasyLoading.showToast("刷新封面记录失败,您可再次上滑刷新请求");
    update();
  }

  ///刷新失败
  void onLoadFailure() {
    allMusicCoverController.loadFailed();
    EasyLoading.showToast("加载更多封面记录失败,您可再次上滑刷新请求");
    update();

  }

  ///加载失败
  void refreshFailure2() {
    allMusicCoverController2.loadFailed();
    EasyLoading.showToast("刷新封面记录失败,您可再次上滑刷新请求");
    update();

  }

  ///刷新失败
  void onLoadFailure2() {
    allMusicCoverController2.loadFailed();
    EasyLoading.showToast("加载更多封面记录失败,您可再次上滑刷新请求");
    update();

  }

  ///选择
  updateSelectedTabIndex({
    required int tabIndex,
  }) {
    if (tabIndex != selectedTabIndex) {
      selectedTabIndex = tabIndex;
      update();
    }
  }

  updateMusicItem({required MyWorksMusicItem musicItemData}) {
    musicItem = musicItemData;
    update();
  }

  ///检查文本
  checkText({
    required String textData,
  }) async {
    IllegalWordsController illegalWordsController =
        Get.put<IllegalWordsController>(IllegalWordsController());
    if (textData.isNotEmpty) {
      await illegalWordsController.detectIllegalWords(textData,
          onFail: () {}, onSuccess: () {}, onSuccessValue: (value) {
        Get.log("不希望呈现的内容===>$value");
      });
    }
  }

  ///一键生成
  aiCreateMusic({
    required TextEditingController controller,
  }) async {
    if(isAiCreate){
      return;
    }
    isAiCreate = true;
    String textData = controller.text;
    if (textData.isEmpty) {
      EasyLoading.showToast("Ai提示词不能为空~", maskType: EasyLoadingMaskType.none);
      isAiCreate = false;
      return;
    }
    IllegalWordsController illegalWordsController =
        Get.put<IllegalWordsController>(IllegalWordsController());
    if (textData.isNotEmpty) {
      await illegalWordsController.detectIllegalWords(
        textData,
        onFail: () {
          isAiCreate = false;
        },
        onSuccess: () {},
        onSuccessValue: (value) {
          controller.text = value;
          HttpUtils.post(APIs.aiCreateCover, {
            "width": "1328",
            "height": "1328",
            "prompt": value,
          }, success: (json) {
            AiMusicCoverTaskModel data = AiMusicCoverTaskModel.fromJson(
              taskId: json["data"]["taskId"],
              dataId: json["data"]["dataId"],
            );
            Get.back();
            Get.to(() => CoverSelectPage(musicCoverTaskModel: data));
            isAiCreate = false;
            Get.log("===一键Ai生成的结果=== $data");
          }, fail: (code, msg) {
            isAiCreate = false;
            EasyLoading.showToast(msg);
            if (code == 1000001) {
              Get.toNamed(Routes.meMusicNoteValuePage);
            }
          });
          Get.log("不希望呈现的内容===>$value");
        },
      );
    }
  }

  ///获取列表记录
  getDataList() {
    HttpUtils.post(
      APIs.getCoverList,
      {
        "page": 1,
        "pageSize": "999",
      },
      success: (data) {
        AiMusicCoverResponseModel aiMusicCoverResponseModel =
            AiMusicCoverResponseModel.fromJson(
          data,
        );
        if (aiMusicCoverResponseModel.data.data.isNotEmpty) {
          coverModelList = aiMusicCoverResponseModel.data.data;
          coverModelList2 = aiMusicCoverResponseModel.data.data;
        }
        update();
        Get.log("===获取列表记录=== ${aiMusicCoverResponseModel.data.data.length}");
        eventBus.fire(const RefreshDataEvent());
      },
    );
  }

  ///删除封面
  deleteCover({
    required int id,
  }) {
    HttpUtils.post(APIs.deleteMusicCover, {"id": id}, success: (data) {
      EasyLoading.showToast("删除封面成功～", maskType: EasyLoadingMaskType.none);
      eventBus.fire(const CoverSuccessEvent());
      Get.back();
      Get.back();
    }, fail: (msg, code) {
      EasyLoading.showToast("删除封面失败～", maskType: EasyLoadingMaskType.none);
    });
  }

  ///使用封面
  useCover({
    required int id,
    required String coverUrl,
  }) {
    if(isUseCover){
      return;
    }
    isUseCover = true;
    HttpUtils.post(APIs.updateMusicCover, {
      "id": musicItem.id,
      "cover_url": coverUrl,
    }, success: (data) {
      EasyLoading.showToast("修改封面成功～", maskType: EasyLoadingMaskType.none);
      eventBus.fire(const CoverSuccessEvent());
      isUseCover = false;
      Get.back();
      Get.back();
    }, fail: (msg, code) {
      isUseCover = false;
      EasyLoading.showToast("修改封面失败～", maskType: EasyLoadingMaskType.none);
    });
  }

  ///下载封面
  downloadCover({
    required String coverUrl,
  }) {
    ByDownloadUtil.saveNetwrokImage(coverUrl).then((value) {
      // Get.back();
    });
  }

  uploadLocalImage() async {
    final status = await ByPermissionUtils.photos();
    if (!status) return;

    /// 你也可以将类似的逻辑应用在其他常见的相册上。
    final List<AssetEntity> result = await AssetPicker.pickAssets(
          Get.context!,
          pickerConfig: AssetPickerConfig(
            maxAssets: 1,
            requestType: RequestType.image,
            pathNameBuilder: (AssetPathEntity entity) {
              // 获取原始路径名，如果为空则使用默认的"未知文件"
              final String originalPath = entity.name ?? '未知文件';
              // 定义一个映射表，将英文相册名映射为中文
              final Map<String, String> pathMapping = {
                'Camera Roll': '相机胶卷',
                'Screenshots': '截图',
                'Downloads': '下载',
                'Recents': '最近项目',
                'Favorites': '收藏',
                'Selfies': '自拍',
                'Live Photos': '实况照片',
                'Portrait': '人像',
                'Panoramas': '全景照片',
                'Bursts': '连拍快照',
                'Animated': '动图',
                'Recently Saved': '最近的日子',
                'Recent': '最近项目',
                'Camera': '相册',
                'Pictures': '图册',
                'Videos': '视频',
              };
              String newPath = originalPath;
              // 遍历映射表，将原始路径中的英文替换为中文
              pathMapping.forEach((key, value) {
                newPath = newPath.replaceAll(key, value);
              });
              return newPath;
            },
          ),
        ) ??
        [];
    if (result.isNotEmpty) {
      localAssetEntity = result.first;
    }
    update();
    Get.log("===获取的相册===  ${result.length}");
  }

  useLocalImageCover({
    required String coverUrl,
    required VoidCallback success,
  }) {
    HttpUtils.post(APIs.updateMusicCover, {
      "id": musicItem.id,
      "cover_url": coverUrl,
    }, success: (data) {
      EasyLoading.dismiss();
      EasyLoading.showToast("修改封面成功～", maskType: EasyLoadingMaskType.none);
      eventBus.fire(const CoverSuccessEvent());
      success();
      Get.back();
    }, fail: (msg, code) {
      EasyLoading.dismiss();
      EasyLoading.showToast("修改封面失败～", maskType: EasyLoadingMaskType.none);
    });
  }
}

class EditMusicCoverTabModel {
  final int type;
  final String name;
  const EditMusicCoverTabModel({
    required this.type,
    required this.name,
  });
}

//刷新数据
class RefreshDataEvent {
  ///1 ai 2-本地
  final int type;
  const RefreshDataEvent({this.type=1,});
}

///删除封面事件
class CoverSuccessEvent {
  const CoverSuccessEvent();
}

///确认使用封面事件
class UseCoverSuccessEvent {
  const UseCoverSuccessEvent();
}
