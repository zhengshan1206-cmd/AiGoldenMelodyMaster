import 'dart:async';
import 'dart:convert';
import 'package:ai_golden_melody_master/common/lib/extension.dart';
import 'package:ai_golden_melody_master/common/lib/result.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;

import 'package:ai_golden_melody_master/common/lib/app_common/aes/byhy_aes_storage_utils.dart';
import 'package:ai_golden_melody_master/common/lib/app_common/aes/byhy_encrypt_utils.dart';
import 'package:ai_golden_melody_master/common/lib/app_common/consts/const_keys.dart';
import 'package:ai_golden_melody_master/common/lib/app_http/intercept.dart';


mixin StreamDataMixin {
  Future<Stream<String>> getStream({
    required String url,
    Map<String, dynamic>? body,
  }) async {
    final controller = StreamController<String>();
    final uri = Uri.parse(url);

    final request = http.Request('POST', uri);
    _updateHeaders(request);

    if (body != null && body.isNotEmpty) {
      request.bodyFields = body.convertMap();
    }
    request.send().then((http.StreamedResponse response) async {
      Get.log("responseData=========> ${response.statusCode}");
      // 处理响应
      if (response.statusCode == 200) {
        await for (String chunk in response.stream.transform(utf8.decoder)) {
          controller.add(chunk);
        }
        controller.close();
      } else {
        controller.addError(
            APIError(response.reasonPhrase ?? '', response.statusCode));
      }
    });

    return controller.stream;
  }

  void _updateHeaders(http.Request request) {
    final timestamp = (DateTime.now().millisecondsSinceEpoch / 1000).floor();
    request.headers[ConstKeys.kToken] = getToken();
    request.headers[ConstKeys.kClientType] = "strong";
    request.headers[ConstKeys.kTimeStamp] = timestamp.toString();
    request.headers[ConstKeys.kAppFramework] = 'flutter';
    request.headers[ConstKeys.kAppVersion] =
        ByStorageUtils.getString(ConstKeys.kAppVersion) ?? "5.0.0";
    request.headers[ConstKeys.kSign] = _getSign(timestamp);
  }

  String _getSign(int timestamp) {
    final token = ByAESStorageUtils.getString(ConstKeys.kToken) ?? "";
    final sign = ByEncryptUtils.md5String("$timestamp$token");
    return sign;
  }
}
