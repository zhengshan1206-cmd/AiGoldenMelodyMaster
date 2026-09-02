import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MemberCountdown extends StatefulWidget {
  final double fontSize;
  final Color textColor;
  final Color bgColor;
  final Color separatorColor;
  final double timeItemWidth;
  final double borderRadius;
  final Color borderColor;
  final bool showMilliseconds;
  final double padding;

  const MemberCountdown({
    super.key,
    this.fontSize = 12,
    this.textColor = const Color(0XFFFFFFFF),
    this.bgColor = Colors.transparent,
    this.separatorColor = const Color(0XFFFFFFFF),
    this.borderColor = const Color(0x1A00CB64), // 使用十六进制透明度值替代 withOpacity(0.1)
    this.timeItemWidth = 21,
    this.borderRadius = 6,
    this.showMilliseconds = false,
    this.padding = 2,
  });

  @override
  State<MemberCountdown> createState() => _MemberCountdownState();
}

// 添加一个GlobalKey类型
typedef MemberCountdownKey = GlobalKey<_MemberCountdownState>;

class _MemberCountdownState extends State<MemberCountdown> {
  late Duration _duration;
  Timer? _timer;
  int _milliseconds = 0;
  bool _showMilliseconds = true;

  @override
  void initState() {
    super.initState();
    _duration = _getTodayRemain();
    _showMilliseconds = widget.showMilliseconds;
    _startTimer();
  }

  Duration _getTodayRemain() {
    final now = DateTime.now();
    final end = DateTime(now.year, now.month, now.day, 23, 59, 59);
    return end.difference(now).isNegative ? Duration.zero : end.difference(now);
  }

  void _startTimer() {
    _timer?.cancel();
    // 如果显示毫秒，则每50毫秒更新一次，否则每秒更新一次
    final interval = _showMilliseconds
        ? const Duration(milliseconds: 50)
        : const Duration(seconds: 1);

    _timer = Timer.periodic(interval, (timer) {
      setState(() {
        _duration = _getTodayRemain();
        if (_showMilliseconds) {
          _milliseconds = (1000 - DateTime.now().millisecond) % 1000;
        }
      });
    });
  }

  // 切换毫秒显示状态
  void toggleMilliseconds() {
    setState(() {
      _showMilliseconds = !_showMilliseconds;
    });
    _startTimer(); // 重新启动计时器以调整更新频率
  }

  // 设置毫秒显示状态
  void setMillisecondsVisible(bool visible) {
    if (_showMilliseconds != visible) {
      setState(() {
        _showMilliseconds = visible;
      });
      _startTimer(); // 重新启动计时器以调整更新频率
    }
  }

  // 获取当前毫秒显示状态
  bool get isMillisecondsVisible => _showMilliseconds;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hours = _duration.inHours.toString().padLeft(2, '0');
    final minutes = (_duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (_duration.inSeconds % 60).toString().padLeft(2, '0');
    final milliseconds =
        (_milliseconds / 10).floor().toString().padLeft(2, '0');

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildTimeBox(hours),
        _buildSeparator(),
        _buildTimeBox(minutes),
        _buildSeparator(),
        _buildTimeBox(seconds),
        if (_showMilliseconds) ...[
          _buildSeparator(),
          _buildTimeBox(milliseconds),
        ],
      ],
    );
  }

  Widget _buildTimeBox(String time) {
    return Container(
      width: widget.timeItemWidth,
      height: widget.timeItemWidth,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: widget.bgColor,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        border: Border.all(
          width: 1.w,
          color: widget.borderColor,
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        time,
        style: TextStyle(
          color: widget.textColor,
          fontSize: widget.fontSize,
        ),
      ),
    );
  }

  Widget _buildSeparator() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widget.padding),
      child: Text(
        ':',
        style: TextStyle(
          color: widget.separatorColor,
          fontSize: widget.fontSize,
        ),
      ),
    );
  }
}
