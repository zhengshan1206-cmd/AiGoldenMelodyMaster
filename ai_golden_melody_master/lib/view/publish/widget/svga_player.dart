import 'package:flutter/material.dart';
import 'package:svgaplayer_flutter/svgaplayer_flutter.dart';

///svga播放器
class SvgaPlayer extends StatefulWidget {
  const SvgaPlayer(
      {super.key,
      this.url,
      this.completeAnimate,
      this.fit,
      this.isRepeat = false,
      this.isAssets = true});

  final bool? isAssets;

  ///是否是本地动画
  final String? url;

  ///动画链接
  final Function()? completeAnimate;

  ///动画完成
  final BoxFit? fit;
  final bool? isRepeat;

  ///是否循环播放

  @override
  State<SvgaPlayer> createState() => _SvgaPlayerState();
}

class _SvgaPlayerState extends State<SvgaPlayer>
    with SingleTickerProviderStateMixin {
  late SVGAAnimationController animationController;

  @override
  void initState() {
    animationController = SVGAAnimationController(vsync: this);
    loadAnimation();
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  void loadAnimation() async {
    MovieEntity videoItem;
    if (widget.isAssets!) {
      videoItem = await SVGAParser.shared.decodeFromAssets(widget.url!);
    } else {
      videoItem = await SVGAParser.shared.decodeFromURL(widget.url!);
    }

    animationController.videoItem = videoItem;
    if (widget.isRepeat!) {
      animationController.repeat();
    } else {
      animationController
          .forward() // Try to use .forward() .reverse()
          .whenComplete(() {
        animationController.videoItem = null;
        widget.completeAnimate?.call();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SVGAImage(
      animationController,
      fit: widget.fit ?? BoxFit.fitWidth,
    );
  }
}
