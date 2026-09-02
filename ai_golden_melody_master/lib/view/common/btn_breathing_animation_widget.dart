
import 'package:flutter/cupertino.dart';

/// 按钮呼吸动画
class BtnBreathingAnimationWidget extends StatefulWidget {
  final Widget child;

  const BtnBreathingAnimationWidget({super.key, required this.child});

  @override
  State<StatefulWidget> createState() => _BtnWidgetState();
}

class _BtnWidgetState extends State<BtnBreathingAnimationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController btnController;
  late Animation<double> btnAnimation;

  @override
  void initState() {
    ///开按钮缩放动画
    btnController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this)
      ..repeat(reverse: true);
    btnAnimation = Tween(begin: 1.0, end: 0.8).animate(btnController);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: btnAnimation,
      builder: (BuildContext context, Widget? child) {
        return Transform.scale(
          scale: btnAnimation.value,
          child: widget.child,
        );
      },
    );
  }

  @override
  void dispose() {
    btnController.dispose();
    super.dispose();
  }
}