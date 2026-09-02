import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';
import '../../app_common/by_common_utils.dart';
import '../../app_common/byhy_download_util.dart';
import '../../app_common/consts/assets_data.dart';
import '../../app_common/event/common_event.dart';
import '../by_widgets_util.dart';
import 'package:flutter/rendering.dart';
import 'byhy_video_clip_preview.dart';

///视频播放组件
class VideoPlayerWidget extends StatefulWidget {
  final String url;
  final String? coverUrl;
  final bool autoPlay;
  final int? offset;
  final bool userInteractive;
  final bool mute;
  final double? aspectRatio;
  final Duration? maxDuration;
  final bool showFullScreenButton;
  final Function(Duration)? onProgressChanged; // 添加进度变化回调
  const VideoPlayerWidget({
    super.key,
    required this.url,
    this.autoPlay = false,
    this.offset,
    this.userInteractive = true,
    this.coverUrl,
    this.mute = false,
    this.aspectRatio,
    this.maxDuration,
    this.showFullScreenButton = true,
    this.onProgressChanged, // 添加进度变化回调参数
  });

  @override
  State<VideoPlayerWidget> createState() => VideoPlayerWidgetState();
}

class VideoPlayerWidgetState extends State<VideoPlayerWidget>
    with TickerProviderStateMixin {
  CachedVideoPlayerPlusController? _cachedVideoPlayerPlusController;
  VideoPlayerController? _localController;
  late bool isPlaying = widget.autoPlay;

  changeMuteStatus(bool status) {
    _cachedVideoPlayerPlusController?.setVolume(status ? 0.0 : 1.0);
  }

  stopPlay() {
    _localController?.pause();
    _cachedVideoPlayerPlusController?.pause();
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  resumePlay() {
    _localController?.play();
    _cachedVideoPlayerPlusController?.play();
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  void _checkDuration() {
    if (widget.maxDuration == null) return;

    if (_cachedVideoPlayerPlusController != null) {
      if (_cachedVideoPlayerPlusController!.value.position >=
          widget.maxDuration!) {
        _cachedVideoPlayerPlusController!.seekTo(Duration.zero);
        _cachedVideoPlayerPlusController!.pause();
        setState(() {
          isPlaying = false;
        });
      }
    } else if (_localController != null) {
      if (_localController!.value.position >= widget.maxDuration!) {
        _localController!.seekTo(Duration.zero);
        _localController!.pause();
        setState(() {
          isPlaying = false;
        });
      }
    }
  }

  // 切换播放状态
  void _togglePlayPause() {
    if (widget.url.startsWith("http")) {
      if (isPlaying) {
        _cachedVideoPlayerPlusController?.pause();
      } else {
        _cachedVideoPlayerPlusController?.play();
      }
    } else {
      if (isPlaying) {
        _localController?.pause();
      } else {
        _localController?.play();
      }
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  late StreamSubscription<PauseVideoEvent> streamSubscription;

  @override
  void initState() {
    super.initState();

    byDebugPrint("--------VideoPlayerWidgetState initState", tag: "播放的url:");

    // 初始化远程视频控制器
    if (widget.url.startsWith("http")) {
      _cachedVideoPlayerPlusController =
          CachedVideoPlayerPlusController.networkUrl(
        Uri.parse(widget.url),
      )..initialize().then((_) async {
              _cachedVideoPlayerPlusController
                  ?.setVolume(widget.mute ? 0.0 : 1);
              await _cachedVideoPlayerPlusController!
                  .seekTo(Duration(seconds: widget.offset ?? 0));
              _cachedVideoPlayerPlusController!.setLooping(true).then((_) {
                setState(() {});
                if (mounted) {
                  if (widget.maxDuration != null) {
                    _cachedVideoPlayerPlusController!
                        .addListener(_checkDuration);
                  }
                  // 添加进度监听器
                  if (widget.onProgressChanged != null) {
                    _cachedVideoPlayerPlusController!
                        .addListener(_onProgressChanged);
                  }
                  widget.autoPlay
                      ? _cachedVideoPlayerPlusController?.play()
                      : _cachedVideoPlayerPlusController?.pause();
                }
              });
            });
    } else {
      // 初始化本地视频控制器
      _localController = VideoPlayerController.file(File(widget.url))
        ..initialize().then((_) {
          _localController!.setLooping(true).then((_) async {
            if (mounted) {
              setState(() {});
              await _localController!
                  .seekTo(Duration(seconds: widget.offset ?? 0));
              if (widget.maxDuration != null) {
                _localController!.addListener(_checkDuration);
              }
              // 添加进度监听器
              if (widget.onProgressChanged != null) {
                _localController!.addListener(_onProgressChanged);
              }
              widget.autoPlay
                  ? _localController?.play()
                  : _localController?.pause();
            }
          });
        });
    }

    streamSubscription = eventBus.on<PauseVideoEvent>().listen((event) {
      if (_cachedVideoPlayerPlusController != null) {
        _cachedVideoPlayerPlusController!.pause();
      }
      if (_localController != null) {
        _localController!.pause();
      }
      if (mounted) {
        setState(() {
          isPlaying = false;
        });
      }
    });
  }

  // 进度变化监听器
  void _onProgressChanged() {
    if (widget.onProgressChanged != null) {
      Duration currentPosition;
      if (widget.url.startsWith("http")) {
        currentPosition =
            _cachedVideoPlayerPlusController?.value.position ?? Duration.zero;
      } else {
        currentPosition = _localController?.value.position ?? Duration.zero;
      }
      widget.onProgressChanged!(currentPosition);
    }
  }

  // 获取当前播放进度
  Duration getCurrentPosition() {
    if (widget.url.startsWith("http")) {
      return _cachedVideoPlayerPlusController?.value.position ?? Duration.zero;
    } else {
      return _localController?.value.position ?? Duration.zero;
    }
  }

  @override
  void dispose() {
    byDebugPrint("--------VideoPlayerWidgetState dispose", tag: "播放的url:");
    if (widget.maxDuration != null) {
      _cachedVideoPlayerPlusController?.removeListener(_checkDuration);
      _localController?.removeListener(_checkDuration);
    }
    // 移除进度监听器
    if (widget.onProgressChanged != null) {
      _cachedVideoPlayerPlusController?.removeListener(_onProgressChanged);
      _localController?.removeListener(_onProgressChanged);
    }
    _cachedVideoPlayerPlusController?.dispose();
    _localController?.dispose();
    streamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    byDebugPrint("${_cachedVideoPlayerPlusController?.value.isInitialized}",
        tag: "播放器初始化状态 in build：");

    // 正常播放时的布局
    if (widget.url.startsWith("http")) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          if (widget.userInteractive == false) return;
          _togglePlayPause();
        },
        child: Stack(
          children: [
            (_cachedVideoPlayerPlusController?.value.isInitialized ?? false)
                ? LayoutBuilder(
                    builder: (context, constraints) {
                      final aspectRatio = widget.aspectRatio ??
                          _cachedVideoPlayerPlusController!.value.aspectRatio;
                      final maxHeight = constraints.maxHeight;
                      final maxWidth = constraints.maxWidth;

                      return Stack(
                        children: [
                          LayoutBuilder(
                            builder: (context, constraints) {
                              final videoAspectRatio =
                                  _cachedVideoPlayerPlusController!
                                      .value.aspectRatio;
                              final containerAspectRatio = maxWidth / maxHeight;

                              // 计算自适应高度
                              double adaptiveHeight;
                              if (videoAspectRatio > containerAspectRatio) {
                                // 视频更宽，以宽度为准，高度自适应
                                adaptiveHeight = maxWidth / videoAspectRatio;
                              } else {
                                // 视频更高，以高度为准，但不超过最大高度
                                adaptiveHeight = maxHeight;
                              }

                              return SizedBox(
                                width: maxWidth,
                                height: adaptiveHeight,
                                child: ClipRect(
                                  child: FittedBox(
                                    fit: BoxFit.cover,
                                    alignment: Alignment.center,
                                    child: SizedBox(
                                      width: _cachedVideoPlayerPlusController!
                                          .value.size.width,
                                      height: _cachedVideoPlayerPlusController!
                                          .value.size.height,
                                      child: CachedVideoPlayerPlus(
                                          _cachedVideoPlayerPlusController!),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          _buildControlBar(),
                        ],
                      );
                    },
                  )
                : widget.coverUrl != null
                    ? CachedNetworkImage(imageUrl: widget.coverUrl!)
                    : ByWidgetsUtil.activityIndicator(),
            Positioned.fill(
              child: Offstage(
                offstage: isPlaying,
                child: Center(
                  child: Image.asset(
                    AssetsData.iconVideoPlay,
                    width: 40.w,
                    height: 40.h,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (widget.userInteractive == false) return;
        _togglePlayPause();
      },
      child: Stack(
        children: [
          (_localController?.value.isInitialized ?? false)
              ? LayoutBuilder(
                  builder: (context, constraints) {
                    final aspectRatio = _localController!.value.aspectRatio;
                    final maxHeight = constraints.maxHeight;
                    final maxWidth = constraints.maxWidth;

                    return LayoutBuilder(
                      builder: (context, constraints) {
                        final videoAspectRatio =
                            _localController!.value.aspectRatio;
                        final containerAspectRatio = maxWidth / maxHeight;

                        // 计算自适应高度
                        double adaptiveHeight;
                        if (videoAspectRatio > containerAspectRatio) {
                          // 视频更宽，以宽度为准，高度自适应
                          adaptiveHeight = maxWidth / videoAspectRatio;
                        } else {
                          // 视频更高，以高度为准，但不超过最大高度
                          adaptiveHeight = maxHeight;
                        }

                        return SizedBox(
                          width: maxWidth,
                          height: adaptiveHeight,
                          child: ClipRect(
                            child: FittedBox(
                              fit: BoxFit.cover,
                              alignment: Alignment.center,
                              child: SizedBox(
                                width: _localController!.value.size.width,
                                height: _localController!.value.size.height,
                                child: VideoPlayer(_localController!),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                )
              : ByDownloadUtil.videoCover(widget.url),
          Positioned.fill(
            child: Offstage(
              offstage:
                  isPlaying || (_localController?.value.isInitialized == false),
              child: Center(
                child: Image.asset(
                  AssetsData.iconVideoPlay,
                  width: 40.w,
                  height: 40.h,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  // 构建控制栏
  Widget _buildControlBar() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        height: 50,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromRGBO(18, 18, 18, 0),
              Color.fromRGBO(18, 18, 18, 0.8),
            ],
          ),
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: _togglePlayPause,
              child: Padding(
                padding: EdgeInsets.all(6.w),
                child: Image.asset(
                  isPlaying
                      ? AssetsData.iconVideoPause
                      : AssetsData.iconVideoPlay,
                  width: 21,
                  height: 21,
                ),
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: widget.url.startsWith("http")
                  ? ValueListenableBuilder<CachedVideoPlayerPlusValue>(
                      valueListenable: _cachedVideoPlayerPlusController!,
                      builder: (context, value, child) =>
                          _buildProgressSlider(value),
                    )
                  : ValueListenableBuilder<VideoPlayerValue>(
                      valueListenable: _localController!,
                      builder: (context, value, child) =>
                          _buildProgressSlider(value),
                    ),
            ),
            SizedBox(width: 10.w),
            widget.url.startsWith("http")
                ? ValueListenableBuilder<CachedVideoPlayerPlusValue>(
                    valueListenable: _cachedVideoPlayerPlusController!,
                    builder: (context, value, child) =>
                        _buildTimeDisplay(value),
                  )
                : ValueListenableBuilder<VideoPlayerValue>(
                    valueListenable: _localController!,
                    builder: (context, value, child) =>
                        _buildTimeDisplay(value),
                  ),
            widget.showFullScreenButton
                ? IconButton(
                    icon: Image.asset(
                      AssetsData.iconVideoFullScreen,
                      width: 15,
                      height: 15,
                    ),
                    onPressed: () {
                      // 获取当前播放进度
                      Duration currentPosition;
                      if (widget.url.startsWith("http")) {
                        currentPosition =
                            _cachedVideoPlayerPlusController?.value.position ??
                                Duration.zero;
                      } else {
                        currentPosition =
                            _localController?.value.position ?? Duration.zero;
                      }

                      // 暂停当前播放
                      if (widget.url.startsWith("http")) {
                        _cachedVideoPlayerPlusController?.pause();
                      } else {
                        _localController?.pause();
                      }
                      setState(() {
                        isPlaying = false;
                      });

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VideoClipPreview(
                            widget.url,
                            maxDuration: widget.maxDuration,
                            initialPosition: currentPosition, // 传递初始播放进度
                            onProgressChanged: (Duration newPosition) {
                              // 接收从全屏播放器返回的进度，并更新当前播放器
                              if (widget.url.startsWith("http")) {
                                _cachedVideoPlayerPlusController
                                    ?.seekTo(newPosition);
                                // 恢复播放状态
                                if (isPlaying) {
                                  _cachedVideoPlayerPlusController?.play();
                                }
                              } else {
                                _localController?.seekTo(newPosition);
                                // 恢复播放状态
                                if (isPlaying) {
                                  _localController?.play();
                                }
                              }
                            },
                          ),
                        ),
                      );
                    },
                  )
                : SizedBox(width: 12.w),
          ],
        ),
      ),
    );
  }

  // 构建进度条
  Widget _buildProgressSlider(dynamic value) {
    final position = value.position.inMilliseconds.toDouble();
    final duration = (widget.maxDuration?.inMilliseconds.toDouble() ??
        value.duration.inMilliseconds.toDouble());

    return SliderTheme(
      data: SliderThemeData(
        trackHeight: 2,
        inactiveTrackColor: const Color.fromRGBO(255, 255, 255, 0.3),
        activeTrackColor: Colors.white,
        thumbColor: Colors.white,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
        overlayShape: SliderComponentShape.noOverlay,
        trackShape: const _CustomSliderTrackShape(),
      ),
      child: Slider(
        value: position.clamp(0, duration),
        min: 0,
        max: duration,
        onChanged: (newValue) {
          if (widget.maxDuration != null &&
              newValue > widget.maxDuration!.inMilliseconds) {
            return;
          }
          if (widget.url.startsWith("http")) {
            _cachedVideoPlayerPlusController
                ?.seekTo(Duration(milliseconds: newValue.toInt()));
          } else {
            _localController?.seekTo(Duration(milliseconds: newValue.toInt()));
          }
        },
        onChangeEnd: (newValue) {
          if (isPlaying) {
            if (widget.url.startsWith("http")) {
              _cachedVideoPlayerPlusController?.play();
            } else {
              _localController?.play();
            }
          }
        },
      ),
    );
  }

  // 构建时间显示
  Widget _buildTimeDisplay(dynamic value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          _formatDuration(value.position),
          style: const TextStyle(fontSize: 12, color: Colors.white),
        ),
        const Text(
          "/",
          style: TextStyle(fontSize: 12, color: Colors.white),
        ),
        Text(
          _formatDuration(value.duration),
          style: const TextStyle(fontSize: 12, color: Colors.white),
        ),
      ],
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }
}

class _CustomSliderTrackShape extends SliderTrackShape {
  const _CustomSliderTrackShape();

  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = 2;
    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required Offset thumbCenter,
    Offset? secondaryOffset,
    bool isEnabled = false,
    bool isDiscrete = false,
    required TextDirection textDirection,
  }) {
    final double trackHeight = 2;
    final double trackRadius = 1;
    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width;
    final Rect trackRect =
        Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);

    // 未选中部分
    final Paint inactivePaint = Paint()
      ..color = const Color.fromRGBO(255, 255, 255, 0.3)
      ..style = PaintingStyle.fill;
    context.canvas.drawRRect(
      RRect.fromRectAndRadius(trackRect, Radius.circular(trackRadius)),
      inactivePaint,
    );

    // 已选中部分
    final double progress = (thumbCenter.dx - trackLeft) / trackWidth;
    if (progress > 0) {
      final Rect progressRect = Rect.fromLTWH(
          trackLeft, trackTop, trackWidth * progress, trackHeight);
      final Paint activePaint = Paint()..color = Colors.white;
      context.canvas.drawRRect(
        RRect.fromRectAndRadius(progressRect, Radius.circular(trackRadius)),
        activePaint,
      );
    }
  }
}
