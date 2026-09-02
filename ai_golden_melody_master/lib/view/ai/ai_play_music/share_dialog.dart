import 'dart:ui';

import 'package:ai_golden_melody_master/utils/assets.dart';
import 'package:ai_golden_melody_master/utils/by_color_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wechat_kit/wechat_kit_platform_interface.dart';

import '../../../model/ai_music/ai_music_detail_model.dart';
import '../../../model/ai_music/my_works_data_model.dart';

class ShareDialog extends StatelessWidget {
  final String sharePath;
  final MyWorksMusicItem? myWorksMusicItem;
  final MusicData? musicData;

  const ShareDialog({
    super.key,
    required this.sharePath,
    this.myWorksMusicItem,
    this.musicData,
  });

  Widget _itemView({
    required String iconPath,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkResponse(
      onTap: () {
        onTap();
      },
      child: Column(
        children: [
          Image.asset(
            iconPath,
            width: 52.w,
            height: 52.w,
          ),
          SizedBox(
            height: 8.w,
          ),
          Text(
            title,
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
    String title = "";
    String description = "来听听我用Ai创作的歌曲吧！";
    return Container(
      width: 1.sw,
      height: 218.w,
      decoration: BoxDecoration(
          color: ByColorUtil.color2e2e2e,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(12.w),
            topLeft: Radius.circular(12.w),
          )),
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
                "分享歌曲",
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
            height: 36.w,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 20.w,
              ),
              _itemView(
                  iconPath: Assets.icon13,
                  title: "微信好友",
                  onTap: () async {

                    bool canWechat = await WechatKitPlatform.instance.isInstalled();

                    Get.log("===canWechat=======$canWechat");
                    if (!canWechat) {
                      EasyLoading.showToast("请您先安装微信，才可以分享给微信好友。");
                      return;
                    }

                    Uint8List? thumbData;

                    /// 加载资源图片
                    final ByteData data = await DefaultAssetBundle.of(context)
                        .load(Assets.appLogo);

                    /// 从ByteData中获取Uint8List
                    thumbData = data.buffer.asUint8List();
                    if (myWorksMusicItem != null) {
                      title = myWorksMusicItem!.name;
                    }

                    if(musicData!=null){
                      title = musicData!.name??"";
                    }

                    Get.log("点击分享");
                    Get.back();
                    try {
                      WechatKitPlatform.instance.shareWebpage(
                        title: title,
                        scene: WechatScene.kSession,
                        webpageUrl: sharePath,
                        description: description,
                        thumbData: thumbData,
                      );
                    } catch (e) {
                      Get.log("错误信息==== ${e.toString()}");
                    }
                  }),
              _itemView(
                  iconPath: Assets.icon15,
                  title: "朋友圈",
                  onTap: () async {
                    bool canWechat = await WechatKitPlatform.instance.isInstalled();

                    Get.log("===canWechat=======$canWechat");
                    if (!canWechat) {
                      EasyLoading.showToast("请您先安装微信，才可以分享到微信朋友圈。");
                      return;
                    }
                    Uint8List? thumbData;
                    /// 加载资源图片
                    final ByteData data = await DefaultAssetBundle.of(context)
                        .load(Assets.appLogo);

                    /// 从ByteData中获取Uint8List
                    thumbData = data.buffer.asUint8List();
                    if (myWorksMusicItem != null) {
                      title = myWorksMusicItem!.name;
                    }
                    if(musicData!=null){
                      title = musicData!.name??"";
                    }
                    Get.back();
                    WechatKitPlatform.instance.shareWebpage(
                        title: title,
                        thumbData: thumbData,
                        description: description,
                        scene: WechatScene.kTimeline,
                        webpageUrl: sharePath);
                  }),
              _itemView(
                  iconPath: Assets.icon16,
                  title: "复制链接",
                  onTap: () async {
                    ClipboardData data = ClipboardData(text: sharePath);
                    await Clipboard.setData(data);
                    EasyLoading.showToast(
                      "复制链接地址成功～",
                      maskType: EasyLoadingMaskType.none,
                    );
                    Get.back();
                  }),
              SizedBox(
                width: 20.w,
              ),
            ],
          )
        ],
      ),
    );
  }
}
