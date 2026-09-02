import 'package:ai_golden_melody_master/navigator/app_pages.dart';
import 'package:ai_golden_melody_master/view/ai/ai_play_music/ai_play_music_controller.dart';
import 'package:ai_golden_melody_master/view/me_center/my_work/my_work_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../../../common/lib/app_common/event/common_event.dart';
import '../../../model/ai_music/my_works_data_model.dart';
import '../../../utils/assets.dart';
import '../../../utils/by_color_utils.dart';
import '../../../utils/common_event.dart';

class MyWorkItemView extends StatelessWidget {
  final MyWorksMusicItem musicItem;
  final int type;
  const MyWorkItemView({
    super.key,
    required this.musicItem,
    required this.type,
  });
  Widget _myWorkItemView({
    required MyWorksMusicItem model,
  }) {
    return InkResponse(
        onTap: () {
          int status = model.status;
          if (status == 0) {
            EasyLoading.showToast("正在生成中~", maskType: EasyLoadingMaskType.none);
          } else if (status == 1) {
            Get.toNamed(
              Routes.aiPlayMusicPage,
              arguments: {
                "model": model,
                "type": 0,
                "id": model.id,
              },
            );
            // eventBus.fire(PlayMusicDataEvent());
          } else if (status == 2) {
            EasyLoading.showToast("生成失败，您可以重新生成",
                maskType: EasyLoadingMaskType.none);
          }

          Get.log("====点击了当前音频的id=====${model.id}");
        },
        child: Stack(
          children: [
            Container(
                width: 1.sw,
                decoration: BoxDecoration(
                    color: ByColorUtil.color1E1E1E,
                    borderRadius: BorderRadius.circular(
                      12.w,
                    )),
                margin: EdgeInsets.only(left: 12.w, right: 12.w, bottom: 10.w),
                padding: EdgeInsets.only(
                  left: 12.w,
                  top: 12.w,
                  bottom: 24.w,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 36.w,
                    ),

                    ///头像区域
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 11.w),
                          child: Image.asset(
                            Assets.aiMusicBg1,
                            width: 62.w,
                            height: 62.w,
                          ),
                        ),
                        if (model.status == 0)
                          Positioned(
                              top: 0.w,
                              right: 17.w,
                              child: Container(
                                width: 80.w,
                                height: 80.w,
                                decoration: BoxDecoration(
                                  color: ByColorUtil.color2e2e2e,
                                  borderRadius: BorderRadius.circular(7.w),
                                ),
                              )),
                        Positioned(
                            top: 0.w,
                            right: 17.w,
                            child: Stack(
                              children: [
                                musicItem.coverUrl.isNotEmpty
                                    ? ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(7.w),
                                        child: CachedNetworkImage(
                                          imageUrl: musicItem.coverUrl,
                                          width: 80.w,
                                          height: 80.w,
                                          fit: BoxFit.fill,
                                        ))
                                    : _modeHeaderIcon(model: model),
                                if (musicItem.status == 1)
                                  Positioned(
                                    left: 24.w,
                                    top: 24.w,
                                    child: Container(
                                      width: 32.w,
                                      height: 32.w,
                                      decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.2),
                                          borderRadius:
                                              BorderRadius.circular(32.w)),
                                      alignment: Alignment.center,
                                      child: Image.asset(
                                        Assets.playIcon,
                                        width: 16.w,
                                        height: 16.w,
                                      ),
                                    ),
                                  )
                              ],
                            )),
                        Positioned(
                            top: 4.w,
                            left: -28.w,
                            child: Text(
                              "AI生成",
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.6),
                                fontWeight: FontWeight.w500,
                                fontSize: 8.sp,
                              ),
                            ))
                      ],
                    ),
                    SizedBox(
                      width: 16.w,
                    ),

                    ///信息区域
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 8.w,
                        ),
                        SizedBox(
                          width: 190.w,
                          child: Text(
                            model.status == 0 ? "作品生成中..." : model.name,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14.sp,
                              color: Colors.white,
                              overflow: TextOverflow.ellipsis,
                            ),
                            maxLines: 1,
                          ),
                        ),
                        SizedBox(
                          height: 6.w,
                        ),
                        _modeIcon(model: model),
                        SizedBox(
                          height: 14.w,
                        ),
                        Text(
                          model.createdAt,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14.sp,
                            color: Colors.white.withOpacity(0.3),
                          ),
                        ),
                      ],
                    )
                  ],
                )),
            if (model.status != 0)
              Positioned(
                  top: 12.w,
                  right: 0.w,
                  child: InkResponse(
                    onTap: () {
                      Get.log("===点击了===");
                      showModalBottomSheet(
                          context: Get.context!,
                          builder: (c) {
                            return _openMoreDialog(
                              item: model,
                            );
                          },
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                          ));
                    },
                    child: Container(
                      // color: Colors.red,
                      width: 46.w,
                      height: 46.w,
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.only(right: 22.w,bottom: 20.w),
                      child: Image.asset(
                        Assets.moreIcon,
                        width: 14.w,
                        height: 14.w,
                      ),
                    ),
                  ))
          ],
        ));
  }

  ///作品模式和状态
  Widget _modeIcon({
    required MyWorksMusicItem model,
  }) {
    if (model.status == 0) {
      return Text(
        "请耐心等待3~5分钟",
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 12.sp,
          color: Colors.white.withOpacity(0.5),
        ),
      );
    } else {
      if (model.mode == 1) {
        return Text(
          "灵感写歌",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 9.sp,
            color: Colors.white.withOpacity(0.7),
          ),
        );
      }
      if (model.mode == 2) {
        return Image.asset(Assets.masterIcon, width: 40.w, height: 14.w);
      }
      if (model.mode == 3) {
        return Image.asset(Assets.onlyIcon, width: 40.w, height: 14.w);
      }
    }
    return const SizedBox();
  }

  ///作品模式和状态
  Widget _modeHeaderIcon({
    required MyWorksMusicItem model,
  }) {
    if (model.status == 0) {
      return Container(
        width: 80.w,
        height: 80.w,
        alignment: Alignment.center,
        // child: Image.asset(
        //   Assets.musicIcon1,
        //   width: 60.w,
        //   height: 60.w,
        // ),
        child: Lottie.asset(
          width: 80.w,
          height: 80.w,
          "assets/custom_animation/data.json",
          animate: true,
        ),
      );
    } else if (model.status == 1) {
      return Image.asset(
        Assets.aiMusicBg2,
        width: 80.w,
        height: 80.w,
      );
    } else if (model.status == 2) {
      return Image.asset(
        Assets.aiMusicBg4,
        width: 80.w,
        height: 80.w,
      );
    }
    return Image.asset(
      Assets.aiMusicBg1,
      width: 80.w,
      height: 80.w,
    );
  }

  Widget _openMoreDialog({
    required MyWorksMusicItem item,
  }) {
    return Container(
      width: 1.sw,
      height: 349.w,
      decoration: BoxDecoration(
        color: ByColorUtil.color2e2e2e,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12.w),
          topRight: Radius.circular(12.w),
        ),
        border: Border.all(
          color: ByColorUtil.color2e2e2e,
        )
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
                "更多操作",
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
          _couldSelectOption(item: item),
        ],
      ),
    );
  }

  Widget _couldSelectOption({
    required MyWorksMusicItem item,
  }) {
    if (type == 3) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _itemView(
              iconPath: Assets.deleteIcon3,
              title: "删除歌曲",
              onTap: () {
                Get.find<MyWorkController>().deleteMusic(
                  name: item.name,
                  id: item.id,
                  type: 0,
                );
              })
        ],
      );
    }

    return Column(
      children: [
        Row(
          children: [
            _itemView(
                iconPath: Assets.icon5,
                title: "分享歌曲",
                onTap: () {
                  Get.find<MyWorkController>()
                      .shareMusic(shareUrl: item.shareUrl,myWorksMusicItem: item,);
                }),
            SizedBox(
              width: 36.w,
            ),
            _itemView(
                iconPath: Assets.icon23,
                title: "下载歌曲",
                onTap: () {
                  Get.find<MyWorkController>()
                      .showDownLoadMusicDialog(musicItem: musicItem);
                }),
            SizedBox(
              width: 36.w,
            ),
            _itemView(
                iconPath: Assets.icon21,
                title: "修改歌名",
                onTap: () {
                  Get.find<MyWorkController>()
                      .renameMusicName(name: item.name, id: item.id);
                }),
            SizedBox(
              width: 36.w,
            ),
            _itemView(
                iconPath: Assets.editIcon,
                title: "修改作者",
                onTap: () {
                  Get.find<MyWorkController>().renameMusicName(
                    name: item.musicAuthor,
                    id: item.id,
                    type: 1,
                  );
                }),
          ],
        ),
        SizedBox(
          height: 15.w,
        ),
        Row(
          children: [
            _itemView(
              iconPath: Assets.photoIcon,
              title: "修改封面",
              onTap: () {
                Get.find<MyWorkController>().showEditMusicCoverDialog(
                  musicItem: musicItem,
                );
              },
            ),
            if(item.type!=2)
              SizedBox(
              width: 36.w,
            ),
            if(item.type!=2)
            _itemView(
                iconPath: Assets.icon22,
                title: "复制歌词",
                onTap: () {
                  Get.find<MyWorkController>().copLyrics(lyrics: item.lyrics);
                }),
            SizedBox(
              width: 36.w,
            ),
            _itemView(
                iconPath: Assets.deleteIcon3,
                title: "删除歌曲",
                onTap: () {
                  Get.find<MyWorkController>().deleteMusic(
                    name: item.name,
                    id: item.id,
                    type: 0,
                  );
                }),
          ],
        )
      ],
    );
  }

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
          Container(
            width: 52.w,
            height: 52.w,
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(
                  13.w,
                )),
            alignment: Alignment.center,
            child: Image.asset(
              iconPath,
              width: 20.w,
              height: 20.w,
            ),
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
    return _myWorkItemView(model: musicItem);
  }
}
