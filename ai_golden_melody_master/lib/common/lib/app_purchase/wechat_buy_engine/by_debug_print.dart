import 'dart:convert';

import 'package:flutter/foundation.dart';

byDebugPrint(Object? obj, {String? tag}) {
  if (kDebugMode) {
    debugPrint("${tag ?? ''}${const JsonEncoder.withIndent(" ").convert(obj)}");
  }
}
