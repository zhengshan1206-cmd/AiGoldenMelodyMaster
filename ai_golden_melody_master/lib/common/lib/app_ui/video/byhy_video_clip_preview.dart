import 'package:ai_golden_melody_master/common/lib/app_ui/byhy_screen_utils.dart';
import 'package:ai_golden_melody_master/common/lib/app_ui/video/byhy_video_player_view_copy.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../app_common/byhy_assets_util.dart';

class VideoClipPreview extends StatefulWidget {
  final String videoFilePath;
  final String? title;
  final bool backToHme;
  final Duration? maxDuration;
  final Duration? initialPosition; // 添加初始播放进度参数
  final Function(Duration)? onProgressChanged; // 添加进度变化回调

  const VideoClipPreview(
    this.videoFilePath, {
    super.key,
    this.title,
    this.backToHme = false,
    this.maxDuration,
    this.initialPosition, // 添加初始播放进度参数
    this.onProgressChanged, // 添加进度变化回调参数
  });

  @override
  State<VideoClipPreview> createState() => _VideoClipPreviewState();
}

class _VideoClipPreviewState extends State<VideoClipPreview> {
  _VideoClipPreviewState();
  bool exists = false;
  final GlobalKey<VideoPlayerWidgetCopyState> _videoPlayerKey =
      GlobalKey<VideoPlayerWidgetCopyState>(); // 添加视频播放器引用

  @override
  void initState() {
    // _checkExists();

    super.initState();
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //       appBar: AppBar(
  //         backgroundColor: Colors.transparent,
  //         elevation: 0,
  //         leading: GestureDetector(
  //           onTap: () {
  //             Navigator.pop(context);
  //           },
  //           child: Container(
  //             width: 32,
  //             height: 32,
  //             alignment: Alignment.center,
  //             child: Icon(
  //               Icons.arrow_back_ios_new,
  //               size: 18.sp,
  //               color: const Color(0XFFFFFFFF),
  //             ),
  //           ),
  //         ),
  //       ),
  //       backgroundColor: const Color(0XFF121212),
  //       body: Column(
  //         children: [
  //           Expanded(
  //             key: UniqueKey(),
  //             child: Center(
  //               child: VideoPlayerWidgetCopy(
  //                 url: widget.videoFilePath,
  //                 showFullScreenButton: false,
  //                 autoPlay: true,
  //                 maxDuration: widget.maxDuration,
  //               ),
  //             ),
  //           ),
  //         ],
  //       ));
  // }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light, // 状态栏白色字体
      child: Scaffold(
        backgroundColor: const Color(0XFF121212),
        body: Stack(
          children: [
            SafeArea(
              top: true,
              bottom: false,
              child: Center(
                child: VideoPlayerWidgetCopy(
                  key: _videoPlayerKey, // 添加key
                  url: widget.videoFilePath,
                  showFullScreenButton: false,
                  autoPlay: true,
                  maxDuration: widget.maxDuration,
                  initialPosition: widget.initialPosition, // 传递初始播放进度
                  onProgressChanged: widget.onProgressChanged, // 传递进度变化回调
                ),
              ),
            ),
            // 返回按钮可选保留
            Positioned(
              top: ByScreenUtils.topSafeHeight + 10,
              left: 15.w,
              child: GestureDetector(
                onTap: () {
                  // 获取当前播放进度并传递回原播放器
                  if (widget.onProgressChanged != null &&
                      _videoPlayerKey.currentState != null) {
                    Duration currentPosition =
                        _videoPlayerKey.currentState!.getCurrentPosition();
                    widget.onProgressChanged!(currentPosition);
                  }
                  Navigator.pop(context);
                },
                child: Container(
                  width: 32,
                  height: 32,
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.arrow_back_ios_new,
                    size: 18.sp,
                    color: const Color(0XFFFFFFFF),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _checkExists() async {
    final assetSearch =
        await ByAssetsUtil.getAssetEntityByPath(widget.videoFilePath);
    if (assetSearch != null) {
      exists = true;
      return null;
    }
  }
}
