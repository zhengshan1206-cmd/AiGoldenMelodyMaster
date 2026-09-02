import 'dart:async';

import 'package:ai_golden_melody_master/common/lib/app_time/byhy_time_utils.dart';
import 'package:ai_golden_melody_master/utils/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../common/lib/app_http/apis.dart';
import '../../../common/lib/app_http/http_utils.dart';
import '../../../model/ai_music/ai_music_detail_model.dart';
import '../../../model/ai_music/my_works_data_model.dart';
import '../../../navigator/app_pages.dart';
import '../../../utils/by_color_utils.dart';
import '../../../utils/file_download.dart';
import '../../lanuch_page/launch_controller.dart';

class DownloadMusicDialogEx extends StatefulWidget {
  final MusicData musicItem;

  const DownloadMusicDialogEx({
    super.key,
    required this.musicItem,
  });

  @override
  State<DownloadMusicDialogEx> createState() => _DownloadMusicDialogExState();
}

class _DownloadMusicDialogExState extends State<DownloadMusicDialogEx> {
  ///定时器
  Timer? timer;

  ///是否正在查询
  bool isQuerying = false;
  String mp3Url = "";

  LaunchController launchController = Get.find<LaunchController>();

  int count = 0;

  int maxCount = 10;

  ///开始查询
  startQuery() {
    Get.back();
    EasyLoading.show(status: "正在下载中~",dismissOnTap:false,maskType:EasyLoadingMaskType.black );
    stopQuery();
    performQuery();

    /// 启动周期性定时器
    timer = Timer.periodic(const Duration(seconds: 8), (timer) {
      count+=1;
      if(count>maxCount){
        stopQuery();
        EasyLoading.dismiss();
        EasyLoading.showToast("下载失败,请稍后重试");
        return;
      }
      performQuery();
    });
  }

  ///停止查询
  stopQuery() {
    count = 0;
    if (timer != null) {
      timer!.cancel();
      timer = null;
    }
  }

  ///立即查询
  performQuery() {
    if (isQuerying) {
      return;
    }

    isQuerying = true;
    try {
      downloadMp3();
    } catch (e) {
      stopQuery();
    } finally {
      isQuerying = false;
    }
    if (mounted) {
      setState(() {});
    }
  }

  downloadMp3() {
    HttpUtils.post(APIs.downloadMp3, {
      "type": 1,
      "id": widget.musicItem.id,
    }, success: (data) {
      Get.log("===data111===  $data");
      if (data["data"]["downUrl"] != null) {
        mp3Url = data["data"]["downUrl"];
      }

      if (mp3Url.isNotEmpty) {
        Get.log("轮循获取到的音频地址  $data");
        String date = "${ByHyTimeUtils.timeFromDateTime(DateTime.now())}";
        String musicName = widget.musicItem.name ?? "";
        stopQuery();

        if (mp3Url.isNotEmpty) {
          FileDownloader.downloadWordFile(
              url: mp3Url,
              fileName: "$musicName-$date" + ".mp3",
              onProgress: (progress) {
                Get.log("==当前进度=== $progress");
              },
              done: (path) {
                Get.log("==完成后的地址=== $path");
                EasyLoading.dismiss();
                ShareService.shareFile(
                  path,
                );
              },
              failed: () {
                EasyLoading.dismiss();
              });
        }
      }
    }, fail: (code, msg) {
      stopQuery();
      EasyLoading.dismiss();
      EasyLoading.showToast("下载失败,请稍后重试");
    });
  }

  Widget _itemView({
    required String iconPath,
    required String name,
    required VoidCallback onTap,
  }) {
    return InkResponse(
      onTap: () {
        onTap();
      },
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 52.w,
                height: 52.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(13.w),
                  color: Colors.white.withOpacity(0.05),
                ),
                alignment: Alignment.center,
                child: Image.asset(
                  iconPath,
                  width: 24.w,
                  height: 24.w,
                ),
              ),
              Positioned(
                  right: 7.w,
                  bottom: -5.w,
                  child: Image.asset(
                    Assets.icon10,
                    width: 36.w,
                    height: 16.w,
                  )),
            ],
          ),
          SizedBox(
            height: 8.w,
          ),
          Text(
            name,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.sw,
      height: 196.w,
      decoration: BoxDecoration(
        color: ByColorUtil.color2e2e2e,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12.w),
          topRight: Radius.circular(12.w),
        ),
      ),
      padding: EdgeInsets.only(
        left: 12.w,
        top: 20.w,
        right: 12.w,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "下载歌曲",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Icon(
                  Icons.close,
                  size: 24.w,
                  color: Colors.grey.withOpacity(0.3),
                ),
              )
            ],
          ),
          SizedBox(
            height: 24.w,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 5.w,
              ),
              _itemView(
                iconPath: Assets.icon6,
                name: "MP3文件",
                onTap: () async {
                  if (launchController.is90Vip ||
                      launchController.is30Vip ||
                      launchController.is365Vip) {
                    startQuery();
                  } else {
                    Get.back();
                    Get.toNamed(Routes.vipPurchasePage);
                  }
                },
              ),
              _itemView(
                iconPath: Assets.icon7,
                name: "WAV文件",
                onTap: () {
                  if (launchController.is90Vip || launchController.is365Vip) {
                    _downloadUrl(type: 1);
                  } else {
                    if (launchController.is30Vip) {
                      Get.back();
                      launchController.showVipUpgradeDialog();
                    }else{
                      Get.back();
                      Get.toNamed(Routes.vipPurchasePage);
                    }
                  }
                },
              ),
              _itemView(
                iconPath: Assets.icon8,
                name: "伴奏文件",
                onTap: () {
                  if (launchController.is90Vip || launchController.is365Vip) {
                    _downloadUrl(type: 2);
                  } else {
                    if (launchController.is30Vip) {
                      Get.back();
                      launchController.showVipUpgradeDialog();
                    }else{
                      Get.back();
                      Get.toNamed(Routes.vipPurchasePage);
                    }
                  }
                },
              ),
              _itemView(
                iconPath: Assets.icon9,
                name: "分轨文件",
                onTap: () {
                  if (launchController.is90Vip || launchController.is365Vip) {
                    _downloadUrl(type: 3);
                  } else {
                    if (launchController.is30Vip) {
                      Get.back();
                      launchController.showVipUpgradeDialog();
                    }else{
                      Get.back();
                      Get.toNamed(Routes.vipPurchasePage);
                    }
                  }
                },
              ),
              SizedBox(
                width: 5.w,
              ),
            ],
          )
        ],
      ),
    );
  }

  /// type 0-mp3 1-wav 2-伴奏文件 3-分轨文件
  void _downloadUrl({
    required int type,
  }) {
    Get.log("${widget.musicItem.musicUrl} ");
    Get.log("${ByHyTimeUtils.timeFromDateTime(DateTime.now())}");
    String url = widget.musicItem.musicUrl ?? "";
    String suffix = ".mp3";
    if (type == 0) {
      url = widget.musicItem.musicUrl ?? "";
      suffix = ".mp3";
    } else if (type == 1) {
      url = widget.musicItem.musicWavUrl ?? "";
      suffix = ".wav";
    } else if (type == 2) {
      url = widget.musicItem.musicBackUrl ?? "";
      suffix = ".mp3";
    } else if (type == 3) {
      url = widget.musicItem.musicMidiUrl ?? "";
      suffix = ".mid";
    }

    String date = "${ByHyTimeUtils.timeFromDateTime(DateTime.now())}";
    String musicName = widget.musicItem.name ?? "";
    if (url.isNotEmpty) {
      Get.back();
      EasyLoading.show();
      FileDownloader.downloadWordFile(
          url: url,
          fileName: "$musicName-$date$suffix",
          onProgress: (progress) {
            Get.log("==当前进度=== $progress");
          },
          done: (path) {
            Get.log("==完成后的地址=== $path");
            EasyLoading.dismiss();
            ShareService.shareFile(
              path,
            );
          },
          failed: () {
            EasyLoading.dismiss();
          });
    } else {
      String fileText = "MP3文件";
      if (type == 0) {
        fileText = "MP3文件";
      } else if (type == 1) {
        fileText = "WAV文件";
      } else if (type == 2) {
        fileText = "伴奏文件";
      } else if (type == 3) {
        fileText = "分轨文件";
      }
      EasyLoading.showToast("当前$fileText地址为空");
    }
  }

  // @override
  // void dispose() {
  //   timer?.cancel();
  //   super.dispose();
  // }
}
