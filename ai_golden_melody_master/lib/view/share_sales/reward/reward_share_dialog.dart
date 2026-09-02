import 'dart:async';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:wechat_kit/wechat_kit.dart';
import 'package:widgets_to_image/widgets_to_image.dart';
import 'package:ai_golden_melody_master/common/lib/app_common/event/common_event.dart';
import '../../../utils/image_compressor.dart';
import '../bean/invite_info.dart';
import '../share_sales_controller.dart';

///赚钱分享弹窗
class RewardShareDialog extends StatelessWidget {
  final InviteInfoApiResponse infoApiResponse;
  final List<Widget> itemsList;
  const RewardShareDialog({
    super.key,
    required this.infoApiResponse,
    required this.itemsList,
  });

  ///分享底部弹窗
  Widget _shareDialog() {
    return Container(
      width: 1.sw,
      height: 202.w,
      decoration: BoxDecoration(
          color: Color(0XFF2E2E2E),
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(12.w),
            topLeft: Radius.circular(12.w),
          )),
      padding: EdgeInsets.only(left: 12.w, right: 12.w, top: 14.w),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "分享至",
                style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const Spacer(),
              InkResponse(
                onTap: () {
                  Get.back();
                },
                child: Container(
                  width: 30.w,
                  height: 30.w,
                  alignment: Alignment.centerRight,
                  child: Image.asset(
                    "assets/home/share_sales/close_icon.png",
                    width: 16.w,
                    height: 16.w,
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 30.w,
          ),
          Row(
            children: [
              SizedBox(
                width: 40.w,
              ),
              _shareItemView(
                  iconPath: "assets/home/share_sales/wechat_1.png",
                  text: "微信好友",
                  click: () {
                    Get.find<ShareSalesController>().shareWechatFriends();
                  }),
              const Spacer(),
              _shareItemView(
                  iconPath: "assets/home/share_sales/wechat_share_friend.png",
                  text: "朋友圈",
                  click: () {
                    Get.find<ShareSalesController>().shareWechatFriendsCircle();
                  }),
              const Spacer(),
              _shareItemView(
                iconPath: "assets/home/share_sales/local_photo.png",
                text: "保存到相册",
                click: () {
                  Get.find<ShareSalesController>().saveLocal();
                },
              ),
              SizedBox(
                width: 39.w,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _shareItemView({
    required String iconPath,
    required String text,
    required VoidCallback click,
  }) {
    return InkResponse(
      onTap: () {
        click();
      },
      child: Column(
        children: [
          Image.asset(
            iconPath,
            width: 44.w,
            height: 44.w,
          ),
          SizedBox(
            height: 8.w,
          ),
          Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              color: Colors.white,
              fontSize: 14.sp,
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ShareSalesController controller = Get.find<ShareSalesController>();
    return Material(
      color: Colors.transparent,
      child: SizedBox(
        width: 1.sw,
        height: 1.sh,
        child: Column(
          children: [
            SizedBox(
              height: 100.w,
            ),
            if (itemsList.isNotEmpty)
              CarouselSlider(
                  items: itemsList,
                  options: CarouselOptions(
                    height: 380.h,
                    // aspectRatio: 1.0,
                    enlargeCenterPage: false,
                    enlargeStrategy: CenterPageEnlargeStrategy.zoom,
                    enlargeFactor: 0.3,
                    initialPage: controller.initialPage,
                    viewportFraction: 0.70,
                    enableInfiniteScroll: true,
                    reverse: false,
                    autoPlay: false,
                    autoPlayInterval: const Duration(seconds: 3),
                    autoPlayAnimationDuration:
                        const Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    onPageChanged: (index, reason) {
                      Get.log("移动===$index reason==> $reason ");
                      controller.updateSelectedPosterIndex(
                        index: index,
                      );
                    },
                    scrollDirection: Axis.horizontal,
                  )),
            const Spacer(),
            _shareDialog(),
          ],
        ),
      ),
    );
  }
}

///海报组件
class PosterItemView extends StatefulWidget {
  final Poster poster;
  final String inviteUrl;
  final String inviteCode;
  const PosterItemView({
    super.key,
    required this.poster,
    required this.inviteUrl,
    required this.inviteCode,
  });

  @override
  State<PosterItemView> createState() => _PosterItemViewState();
}

class _PosterItemViewState extends State<PosterItemView> {
  WidgetsToImageController controller = WidgetsToImageController();

  ///监听分享事件
  late StreamSubscription<SharePosterDataEvent> shareSubscription;

  @override
  void initState() {
    shareSubscription = eventBus.on<SharePosterDataEvent>().listen((e) async {
      if (e.type == 2) {
        EasyLoading.show(status: "保存到相册");
      } else if (e.type == 1) {
        EasyLoading.show(status: "分享朋友圈");
      } else if (e.type == 0) {
        EasyLoading.show(status: "分享微信好友");
      }

      Uri? shareUri;
      Uint8List? bytes = await controller.capture(
        options: const CaptureOptions(
          format: ImageFormat.png,
          pixelRatio: 8,
          quality: 100,
          waitForAnimations: true,
          delayMs: 100,
        ),
      );
      Get.log("当前的bytes===> ${bytes?.length}");
      try {
        if (bytes != null) {
          if (bytes.length > 9.8 * 1024 * 1024) {
            final compressedBytes = await FlutterImageCompress.compressWithList(
              bytes,
              quality: 90,
              format: CompressFormat.jpeg,
              // 保持图片方向（避免压缩后旋转）
              keepExif: false, // 不需要Exif信息可关闭，减少体积
            );
            bytes = compressedBytes;
          }
          String? shareUriString =
              await ImageUriConverter.convertToLocalUri(bytes);
          Get.log("最后的的bytes===> ${bytes.length}");
          Get.log("===shareUriString=== $shareUriString");
          if (shareUriString != null && shareUriString.isNotEmpty) {
            shareUriString = shareUriString.substring(5);
            Get.log("===shareUriString=== $shareUriString");
            shareUri = Uri(path: shareUriString, scheme: "file");
          }
        }
      } catch (error) {
        EasyLoading.dismiss();
        if (e.type == 2) {
          EasyLoading.showToast("保存到相册失败~");
        } else {
          EasyLoading.showToast("分享失败~");
        }
        return;
      }

      if (shareUri == null) {
        EasyLoading.dismiss();
        if (e.type == 2) {
          EasyLoading.showToast("保存到相册失败~");
        } else {
          EasyLoading.showToast("分享失败~");
        }
        return;
      }
      if (e.id == widget.poster.id) {
        Get.log("当前分享的图片===> ${bytes?.length}");

        ///分享到微信好友
        if (e.type == 0) {
          Get.log("点击分享到微信好友");

          try {
            await WechatKitPlatform.instance.shareImage(
              title: "Ai小说创作精灵",
              scene: WechatScene.kSession,
              // imageData: bytes,
              imageUri: shareUri,
            );
            EasyLoading.dismiss();
            Get.back();
          } catch (error) {
            EasyLoading.dismiss();
            if (e.type == 2) {
              EasyLoading.showToast("保存到相册失败~");
            } else {
              EasyLoading.showToast("分享失败~");
            }
            Get.log("分享到微信好友错误信息==== ${e.toString()}");
          }
        }

        ///分享到朋友圈
        if (e.type == 1) {
          Get.log("点击分享到朋友圈");
          try {
            await WechatKitPlatform.instance.shareImage(
              title: "Ai小说创作精灵",
              scene: WechatScene.kTimeline,
              // imageData: bytes,
              imageUri: shareUri,
            );
            EasyLoading.dismiss();
            Get.back();
          } catch (error) {
            EasyLoading.dismiss();
            if (e.type == 2) {
              EasyLoading.showToast("保存到相册失败~");
            } else {
              EasyLoading.showToast("分享失败~");
            }
            Get.log("错误信息==== ${e.toString()}");
          }
        }

        ///分享到本地相册
        if (e.type == 2) {
          Get.back();
          await saveImage(
            imageBytes: bytes!,
          );
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    shareSubscription.cancel();
    super.dispose();
  }

  static Future<void> saveImage({
    bool showLoading = true,
    required Uint8List imageBytes,
  }) async {
    // if (showLoading) {
    //   LoadingDialog().show(message: "正在保存中...");
    // }
    // 保存到相册
    final result = await ImageGallerySaver.saveImage(
      imageBytes,
      quality: 100, // 图片质量
    );

    if (showLoading) {
      EasyLoading.dismiss();
    }
    if (result['isSuccess']) {
      EasyLoading.showToast("保存成功,请在相册中查看~");
    } else {
      EasyLoading.showToast("保存失败，请重试~");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.w),
          color: Colors.white,
        ),
        // margin: EdgeInsets.only(left: 12.w, right: 12.w),
        child: WidgetsToImage(
          controller: controller,
          child: Container(
            width: 240.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.w),
              color: Colors.white,
            ),
            // margin: EdgeInsets.only(left: 12.w, right: 12.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12.w),
                        topRight: Radius.circular(12.w),
                      ),
                      child:  CachedNetworkImage(
                              imageUrl: widget.poster.url ?? "",
                              width: 240.w,
                              height: 316.w,
                              fit: BoxFit.fill,
                              placeholder: (context, url) {
                                return Image.asset(
                                  "assets/home/share_sales/defalut_share_bg.png",
                                  width: 240.w,
                                  height: 316.w,
                                  fit: BoxFit.fill,
                                );
                              },
                              errorWidget: (context, url, error) => Image.asset(
                                    "assets/home/share_sales/defalut_share_bg.png",
                                    width: 240.w,
                                    height: 316.w,
                                    fit: BoxFit.fill,
                                  )),
                    ),
                    Positioned(
                      top: 141.w,
                      child: Container(
                        width: 240.w,
                        height: 28.w,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              Colors.white
                                  .withOpacity(0), // rgba(255,255,255,0)
                              Colors.white, // #FFFFFF
                              Colors.white
                                  .withOpacity(0), // rgba(255,255,255,0)
                            ],
                            stops: const [0.0, 0.5, 1.0],
                          ),
                          borderRadius: BorderRadius.zero,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "{邀请码${widget.inviteCode}}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 10.w,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 12.w,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              "assets/home/share_sales/app_logo.png",
                              width: 20.w,
                              height: 20.w,
                            ),
                            SizedBox(
                              width: 4.w,
                            ),
                            Text(
                              "Ai金曲大师",
                              style: TextStyle(
                                color: Color(0XFF121212),
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10.w,
                        ),
                        Text(
                          "0基础创作爆款歌曲, 卖歌赚钱",
                          style: TextStyle(
                            color: Color(0XFF121212).withOpacity(0.5),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        )
                      ],
                    ),
                    const Spacer(),
                    QrImageView(
                      data: widget.inviteUrl,
                      version: QrVersions.auto,
                      size: 48.w,
                      gapless: false,
                      padding: EdgeInsets.zero,
                      dataModuleStyle: const QrDataModuleStyle(
                        dataModuleShape: QrDataModuleShape.square,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      width: 10.w,
                    )
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
