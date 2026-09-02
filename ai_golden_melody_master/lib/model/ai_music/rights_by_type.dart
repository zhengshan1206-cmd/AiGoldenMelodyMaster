// To parse this JSON data, do
//
//     final rightsByType = rightsByTypeFromJson(jsonString);

import 'dart:convert';

import 'package:get/get_core/src/get_main.dart';

RightsByType rightsByTypeFromJson(String str) =>
    RightsByType.fromJson(json.decode(str));

String rightsByTypeToJson(RightsByType data) => json.encode(data.toJson());

class RightsByType {
  int? isTest;
  int? testCount;
  int freeCount;
  int maxFreeCount;
  int freeIntegral;
  int textLength;
  int voiceLength;
  int currentIntegral;
  int configIntegral;
  String show;
  int userIntegral;
  int vipLevel;
  String vipLevelText;

  RightsByType({
     this.isTest,
    required this.testCount,
    required this.freeCount,
    required this.maxFreeCount,
    required this.freeIntegral,
    required this.textLength,
    required this.voiceLength,
    required this.currentIntegral,
    required this.configIntegral,
    required this.show,
    required this.userIntegral,
    required this.vipLevel,
    required this.vipLevelText,
  });

  factory RightsByType.fromJson(Map<String, dynamic> json){
    Get.log("===rights_by_type=== ${json}");
    return RightsByType(
      isTest: json["is_test"],
      testCount: json["test_count"],
      freeCount: json["free_count"],
      maxFreeCount: json["maxFreeCount"],
      freeIntegral: json["freeIntegral"],
      textLength: json["textLength"],
      voiceLength: json["voiceLength"],
      currentIntegral: json["currentIntegral"],
      configIntegral: json["configIntegral"],
      show: json["show"],
      userIntegral: json["user_integral"],
      vipLevel: json["vip_level"],
      vipLevelText: json["vip_level_text"],
    );
  }

  Map<String, dynamic> toJson() => {
        "is_test": isTest,
        "test_count": testCount,
        "free_count": freeCount,
        "maxFreeCount": maxFreeCount,
        "freeIntegral": freeIntegral,
        "textLength": textLength,
        "voiceLength": voiceLength,
        "currentIntegral": currentIntegral,
        "configIntegral": configIntegral,
        "show": show,
        "user_integral": userIntegral,
        "vip_level": vipLevel,
        "vip_level_text": vipLevelText,
      };
}
