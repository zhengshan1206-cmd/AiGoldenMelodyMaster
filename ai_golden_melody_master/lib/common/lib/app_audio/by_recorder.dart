import 'dart:io';
import 'dart:async';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:path_provider/path_provider.dart';
import 'package:another_audio_recorder/another_audio_recorder.dart';

import '../app_common/by_common_utils.dart';

class ByRecorder {
  // final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  AnotherAudioRecorder? _recorder;
  bool _isInitialized = false;
  String? _recordingPath;
  Recording? _current;
  RecordingStatus _currentStatus = RecordingStatus.Unset;

  // 初始化
  Future<void> initialize() async {
    if (_isInitialized) return;
    if (await AnotherAudioRecorder.hasPermissions == false) {
      EasyLoading.showToast( "麦克风权限被拒绝",maskType: EasyLoadingMaskType.none);
      return;
    }
    try {
      final directory = await getApplicationSupportDirectory();
      _recordingPath =
          "${directory.path}/audio_${DateTime.now().millisecondsSinceEpoch}.wav";
      // await File(_recordingPath!).create(recursive: true);
      _recorder =
          AnotherAudioRecorder(_recordingPath!, audioFormat: AudioFormat.WAV);
      await _recorder?.initialized;
      var current = await _recorder?.current(channel: 0);

      _current = current;
      _currentStatus = current!.status!;
      _isInitialized = true;
    } catch (e) {
      byDebugPrint(e.toString());
    }
  }

  // 开始录音
  Future<void> startRecording() async {
    if (!_isInitialized) {
      EasyLoading.showToast("录音功能启动失败",maskType: EasyLoadingMaskType.none);
      throw Exception('录音器未初始化');
    }
    try {
      await _recorder?.start();
      var recording = await _recorder?.current(channel: 0);

      _current = recording;

      const tick = Duration(milliseconds: 50);
      Timer.periodic(tick, (Timer t) async {
        if (_currentStatus == RecordingStatus.Stopped) {
          t.cancel();
        }

        var current = await _recorder?.current(channel: 0);
        _current = current;
        _currentStatus = _current!.status!;
      });
    } catch (e) {
      byDebugPrint(e);
    }
  }

  // 停止录音并返回文件路径
  Future<String?> stopRecording() async {
    if (!_isInitialized) {
      throw Exception('录音器未初始化');
    }

    // await _recorder.stopRecorder();
    var result = await _recorder?.stop();
    byDebugPrint("Stop recording: ${result?.path}");
    byDebugPrint("Stop recording: ${result?.duration}");
    File file = File(result?.path ?? "");
    byDebugPrint("File length: ${await file.length()}");
    _current = result;
    _currentStatus = _current!.status!;
    return _recordingPath;
  }

  // 释放资源
  Future<void> dispose() async {
    if (_isInitialized) {
      // await _recorder.closeRecorder();
      _isInitialized = false;
    }
  }

  // 检查是否正在录音
  bool get isRecording => _currentStatus == RecordingStatus.Recording;
}
