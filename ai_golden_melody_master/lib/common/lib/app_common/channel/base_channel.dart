
import 'package:flutter/services.dart';

import '../by_common_utils.dart';
import 'by_channel_api.dart';


///插件的通道
class BaseChannel {
  late var channel;

  factory BaseChannel() => _singleton;

  BaseChannel._() {
    channel = const MethodChannel(ChannelApi.channelIdentifier);
  }

  static final BaseChannel _singleton = BaseChannel._();

  static BaseChannel get instance => BaseChannel();

  ///调用原生的方法
  Future<dynamic> callNativeMethod(String method, {dynamic params}) async {
    try {
      final result = await channel.invokeMethod(
        method,
        params,
      );
      byDebugPrint(
        "${result ?? "null"}<>${method}<>${params ?? "null"}",
        tag: "======调用原生的BaseChannel======",
      );

      return result != null
          ? result["code"] == ChannelApi.channelSuccess
          ? result["data"]
          : Future.error(result["msg"] ??= "")
          : result;
    } on Exception catch (e) {
      return Future.error(e);
    }
  }
}