import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:ai_golden_melody_master/common/lib/app_permisson/byhy_permission_utils.dart';
import '../../../../common/lib/app_common/event/common_event.dart';
import '../../../../common/lib/app_http/apis.dart';
import '../../../../common/lib/app_http/http_utils.dart';
import '../../../../common/lib/by_ffmpeg_util.dart';
import '../../../../model/ai_music/ai_music_cover.dart';
import '../../../../model/ai_music/upload_info_bean.dart';
import '../../../../utils/assets.dart';
import '../../../../utils/by_color_utils.dart';
import 'ai_edit_music_cover_page.dart';
import 'conver_select_page.dart';
import 'edit_music_cover_controller.dart';

///本地上传图片
class LocalUploadImage extends StatefulWidget {
  const LocalUploadImage({super.key});

  @override
  State<LocalUploadImage> createState() => _LocalUploadImageState();
}

class _LocalUploadImageState extends State<LocalUploadImage>
    with AutomaticKeepAliveClientMixin {
  EditMusicCoverController controller = Get.find<EditMusicCoverController>();

  AssetEntity? localAssetEntity;

  File? localImageFile;

  String serverImageUrl = "";

  ///是否上传本地图片
  bool uploadImage = false;

  StreamSubscription<RefreshDataEvent>? messageSubscription2;


  @override
  void initState() {
    controller.onRefresh2();
    messageSubscription2 = eventBus.on<RefreshDataEvent>().listen((e) {
      if(e.type==2){
        if (mounted) {
          setState(() {});
        }
      }

    });
    super.initState();
  }

  ///历史区域
  Widget _historyArea() {
    List<DataDetailModel> coverModelList = controller.coverModelList2;
    return SizedBox(
      height: 80.w,
      width: 1.sw,
      child: coverModelList.isEmpty? Text(
        "暂无封面记录，赶快去生成吧～",
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 14.sp,
          color: Colors.white,
        ),
      )
          :SmartRefresher(
          physics: const CustomBouncingPhysics(horizontalDamping: 0.6),
          header: CustomHeader(
            height: 78,
            builder: (BuildContext context, RefreshStatus? mode) {
              Widget body;
              if (mode == RefreshStatus.idle) {
                body = Column(
                  mainAxisSize: MainAxisSize.min,
                  children: '右滑刷新'.split('').map((char) {
                    return Text(
                      char,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 12.sp,
                        color: Colors.white,
                      ),
                    );
                  }).toList(),
                );
              } else if (mode == RefreshStatus.refreshing) {
                body = const CircularProgressIndicator(
                  color: Colors.white,
                );
              } else if (mode == RefreshStatus.canRefresh) {
                ///释放刷新
                body = Column(
                  mainAxisSize: MainAxisSize.min,
                  children: '释放刷新'.split('').map((char) {
                    return Text(
                      char,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 12.sp,
                        color: Colors.white,
                      ),
                    );
                  }).toList(),
                );
              } else if (mode == RefreshStatus.completed) {
                ///刷新完成
                body = Column(
                  mainAxisSize: MainAxisSize.min,
                  children: '刷新完成'.split('').map((char) {
                    return Text(
                      char,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 12.sp,
                        color: Colors.white,
                      ),
                    );
                  }).toList(),
                );
              } else {
                ///刷新失败
                body = Column(
                  mainAxisSize: MainAxisSize.min,
                  children: '刷新失败'.split('').map((char) {
                    return Text(
                      char,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 12.sp,
                        color: Colors.white,
                      ),
                    );
                  }).toList(),
                );
              }
              return Container(
                width: 78.0, // 横向指示器宽度
                height: 78.0,
                alignment: Alignment.center,
                child: body,
              );
            },
          ),
          // 自定义底部指示器（高度减小）
          footer: CustomFooter(
            height: 78.0,
            builder: (context, mode) {
              Widget body;
              if (mode == LoadStatus.idle) {
                body = Column(
                  mainAxisSize: MainAxisSize.min,
                  children: '左滑加载'.split('').map((char) {
                    return Text(
                      char,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 12.sp,
                        color: Colors.white,
                      ),
                    );
                  }).toList(),
                );

              } else if (mode == LoadStatus.loading) {
                body = const CircularProgressIndicator(color: Colors.white,);
              } else if (mode == LoadStatus.canLoading) {
                body = Column(
                  mainAxisSize: MainAxisSize.min,
                  children: '释放加载'.split('').map((char) {
                    return Text(
                      char,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 12.sp,
                        color: Colors.white,
                      ),
                    );
                  }).toList(),
                );
              } else {
                body = Column(
                  mainAxisSize: MainAxisSize.min,
                  children: '加载完成'.split('').map((char) {
                    return Text(
                      char,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 12.sp,
                        color: Colors.white,
                      ),
                    );
                  }).toList(),
                );
              }
              return Container(
                width: 78.0,
                height: 78.0,
                alignment: Alignment.center,
                child: body,
              );
            },
          ),
          scrollDirection: Axis.horizontal,
          enablePullDown: true,
          enablePullUp: true,
          controller: controller.allMusicCoverController2,
          onRefresh: controller.onRefresh2,
          onLoading: controller.onLoading2,
          child: ListView(
            padding: EdgeInsets.zero,
            scrollDirection: Axis.horizontal,
            children: [
              ...coverModelList.map(
                    (e) => _coverItemView(model: e),
              )
            ],
          )),
    );
  }

  Widget _coverItemView({
    required DataDetailModel model,
  }) {
    bool selected = false;
    late Widget dataWidget;
    if (controller.coverModelList.isNotEmpty) {
      DataDetailModel selectedModel =
          controller.coverModelList[controller.selectedCoverIndex];
      if (selectedModel.id == model.id) {
        selected = true;
      }
    }

    if (model.status == 0) {
      dataWidget = Image.asset(
        Assets.icon17,
        width: 40.w,
        height: 40.w,
      );
    } else if (model.status == 1) {
      dataWidget = ClipRRect(
        borderRadius: BorderRadius.circular(8.w),
        child: CachedNetworkImage(
          imageUrl: model.coverUrl,
        ),
      );
    } else if (model.status == 2) {
      dataWidget = Image.asset(
        Assets.icon19,
        width: 40.w,
        height: 40.w,
      );
    }

    return InkResponse(
        onTap: () {
          // Get.back();
          Get.log("===当前封面==== ${model.toJson()}");
          Get.to(() => CoverSelectPage(
                dataDetailModel: model,
              ));
        },
        child: SizedBox(
          width: 72.w,
          height: 72.w,
          child: Container(
              width: 72.w,
              height: 72.w,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.w),
                  border: Border.all(
                      color: selected
                          ? ByColorUtil.color00CB64
                          : Colors.transparent,
                      width: 2)),
              alignment: Alignment.center,
              padding: EdgeInsets.all(2.w),
              child: (model.status == 0 || model.status == 2)
                  ? Container(
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(8.w),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.1),
                          )),
                      alignment: Alignment.center,
                      child: dataWidget,
                    )
                  : dataWidget),
        ));
  }

  ///上传图片
  Widget _uploadPicture() {
    if (localImageFile != null) {
      return Stack(
        children: [
          Container(
            width: 1.sw,
            height: 290.w,
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(10.w),
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                )),
            margin: EdgeInsets.only(
              top: 15.w,
              bottom: 15.w,
            ),
            alignment: Alignment.center,
            padding: EdgeInsets.all(12.w),
            child: Image.file(localImageFile!),
          ),
          Positioned(
            top: 20.w,
            right: 0,
            child: InkResponse(
              onTap: () {
                deleteLocalImage();
              },
              child: Icon(
                Icons.close,
                size: 20.w,
                color: Colors.white,
              ),
            ),
          ),
        ],
      );
    }

    return InkResponse(
      onTap: () {
        uploadLocalImage();
      },
      child: Container(
        width: 1.sw,
        height: 290.w,
        decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(10.w),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
            )),
        margin: EdgeInsets.only(
          top: 15.w,
          bottom: 15.w,
        ),
        alignment: Alignment.center,
        child: Image.asset(
          Assets.icon20,
          width: 52.w,
          height: 52.w,
        ),
      ),
    );
  }

  ///上传本地图片
  Widget _uploadBtn() {
    return InkResponse(
        onTap: () {
          uploadImageToServer();
        },
        child: Opacity(
          opacity: localImageFile != null ? 1 : 0.3,
          child: Container(
            width: 1.sw,
            height: 52.w,
            decoration: BoxDecoration(
              color: ByColorUtil.color00CB64,
              borderRadius: BorderRadius.circular(12.w),
            ),
            alignment: Alignment.center,
            child: Text(
              "上传本地图片",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18.sp,
              ),
            ),
          ),
        ));
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
      localImageFile = await localAssetEntity!.file;
    }
    if (mounted) {
      setState(() {});
    }
    Get.log("===获取的相册===  ${result.length}");
  }

  deleteLocalImage() {
    if (mounted) {
      setState(() {
        localAssetEntity = null;
        localImageFile = null;
      });
    }
  }

  uploadImageToServer() {
    if (uploadImage) {
      // EasyLoading.showToast("正在上传图片，请勿重复点击～", maskType: EasyLoadingMaskType.none);
      return;
    }
    if (localImageFile == null) {
      EasyLoading.showToast("请先选择一张本地图片～", maskType: EasyLoadingMaskType.none);
      return;
    }
    uploadImage = true;
    EasyLoading.show(status: "文件上传中...");
    ByFfmpegUtil.loadUploadInfo(
      showLoading: false,
      type: MediaType.picture,
      onSuccess: (UploadInfoBean infoBean) {
        ByFfmpegUtil.uploadFile(
           dismiss: false,
            infoBean: infoBean,
            filePath: localImageFile!.path,
            onSuccess: (resp) {
              Get.log("上传的封面图片信息===> ${infoBean.toJson()}");

              ///增加鉴黄逻辑
              contentsRisk(
                  url: infoBean.objectUrl,
                  onSuccess: () {
                    serverImageUrl = infoBean.objectUrl;
                    Get.log("服务器返回的图片信息===> $serverImageUrl");
                    controller.useLocalImageCover(
                        coverUrl: serverImageUrl,
                        success: () {
                          uploadImage = false;
                        });
                  });
            },
            onFailed: () {
              uploadImage = false;
              EasyLoading.dismiss();
              EasyLoading.showToast("修改封面失败～", maskType: EasyLoadingMaskType.none);
            },
           showLoading: false,
        );
      },
      onFailed: () {
        uploadImage = false;
        EasyLoading.dismiss();
        EasyLoading.showToast("修改封面失败～", maskType: EasyLoadingMaskType.none);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _uploadPicture(),
        _uploadBtn(),
        Padding(
          padding: EdgeInsets.only(top: 12.w, bottom: 16.w),
          child: Text(
            "历史生成记录",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14.sp,
              color: Colors.white,
            ),
          ),
        ),
        _historyArea(),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;

  /// 鉴黄
  ///[type] 鉴黄类型: 2图片 3音频 4视频
  ///[url]  url地址
  contentsRisk({
    int type = 2,
    required String url,
    void Function()? onSuccess,
  }) {
    Get.log("==创建了鉴黄任务==");
    HttpUtils.post(
      APIs.contentsRisk,
      showLoading: false,
      showMsgWhenFailed: false,
      {"type": type, "url": url},
      success: (data) {
        Get.log("鉴黄任务创建成功===$data");
        // EasyLoading.dismiss();
        onSuccess?.call();
      },
      fail: (code, msg) {
        EasyLoading.dismiss();
        uploadImage = false;
        Get.log("鉴黄任务创建失败结果===$code  msg==$msg");
        if (code == -1) {
          EasyLoading.showToast(msg, maskType: EasyLoadingMaskType.none);
        } else {
          EasyLoading.showToast(msg, maskType: EasyLoadingMaskType.none);
        }
      },
    );
  }
}
