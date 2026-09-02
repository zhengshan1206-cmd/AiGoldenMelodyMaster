
import 'dart:async';
import 'dart:convert';

class PeriodicQueryManager {
  /// 定时器实例
  Timer? _timer;

  /// 标记是否正在执行查询
  bool _isQuerying = false;

  /// 回调函数 - 用于通知外部查询结果
  final Function(Map<String, dynamic> data) onDataReceived;
  final Function(String error) onError;

  PeriodicQueryManager({
    required this.onDataReceived,
    required this.onError,
  });

  /// 开始定时查询 (5秒间隔)
  void startQuerying() {
    /// 先取消已有的定时器，避免重复
    stopQuerying();

    /// 立即执行一次查询，再开始定时
    _performQuery();

    // 启动周期性定时器
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _performQuery();
    });
  }

  // 停止定时查询
  void stopQuerying() {
    if (_timer != null) {
      _timer?.cancel();
      _timer = null;
    }
  }

  // 执行实际的查询任务
  Future<void> _performQuery() async {
    // 防止并发请求
    if (_isQuerying) return;

    _isQuerying = true;
    try {

    } catch (e) {
      // 捕获所有可能的错误 (网络错误、解析错误等)
      onError('查询出错: ${e.toString()}');
    } finally {
      _isQuerying = false;
    }
  }

  // 释放资源
  void dispose() {
    stopQuerying();
  }
}
