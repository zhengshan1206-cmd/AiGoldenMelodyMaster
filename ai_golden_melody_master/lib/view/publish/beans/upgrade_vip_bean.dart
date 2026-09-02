// To parse this JSON data, do
//
//     final upgradeVipBean = upgradeVipBeanFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/cupertino.dart';

UpgradeVipBean upgradeVipBeanFromJson(String str) =>
    UpgradeVipBean.fromJson(json.decode(str));

String upgradeVipBeanToJson(UpgradeVipBean data) => json.encode(data.toJson());

class UpgradeVipBean {
  int id;
  String appleVipId;
  String money;
  String originalPackageMoney;
  String crossedMoney;
  String des;
  String illustrate;
  int isDefault;
  int isOpenWeb;
  String webDes;
  String dayMoney;
  DateTime vipEndTime;
  int day;
  int integral;
  int originalPackageIntegral;
  String subscribePeriodDes;
  int isSubscribe;
  String pagePath;
  String subscribeMoney;
  String subscribeVipEndTime;
  int vipLevel;
  String title;
  String buttonTitle;
  String mark;

  String musicMoney;

  UpgradeVipBean({
    required this.id,
    required this.appleVipId,
    required this.money,
    required this.originalPackageMoney,
    required this.crossedMoney,
    required this.des,
    required this.illustrate,
    required this.isDefault,
    required this.isOpenWeb,
    required this.webDes,
    required this.dayMoney,
    required this.vipEndTime,
    required this.day,
    required this.integral,
    required this.originalPackageIntegral,
    required this.subscribePeriodDes,
    required this.isSubscribe,
    required this.pagePath,
    required this.subscribeMoney,
    required this.subscribeVipEndTime,
    required this.vipLevel,
    required this.title,
    required this.buttonTitle,
    required this.mark,

    required this.musicMoney,

  });

  factory UpgradeVipBean.fromJson(Map<String, dynamic> json) => UpgradeVipBean(
        id: json["id"] ?? 0,
        appleVipId: json["apple_vip_id"] ?? "",
        money: json["money"] ?? "",
        originalPackageMoney: json["original_package_money"] ?? "",
        crossedMoney: json["crossed_money"] ?? "",
        des: json["des"] ?? "",
        illustrate: json["illustrate"] ?? "",
        isDefault: json["is_default"] ?? 0,
        isOpenWeb: json["is_open_web"] ?? 0,
        webDes: json["web_des"] ?? "",
        dayMoney: json["day_money"] ?? "",
        vipEndTime: json["vip_end_time"] != null
            ? DateTime.tryParse(json["vip_end_time"]) ?? DateTime.now()
            : DateTime.now(),
        day: json["day"] ?? 0,
        integral: json["integral"] ?? 0,
        originalPackageIntegral: json["original_package_integral"] ?? 0,
        subscribePeriodDes: json["subscribe_period_des"] ?? "",
        isSubscribe: json["is_subscribe"] ?? 0,
        pagePath: json["page_path"] ?? "",
        subscribeMoney: json["subscribe_money"] ?? "",
        subscribeVipEndTime: json["subscribe_vip_end_time"] ?? "",
        vipLevel: json["vip_level"] ?? 0,
        title: json["title"] ?? "",
        buttonTitle: json["button_title"] ?? "",
        mark: json["mark"] ?? "",
        musicMoney: json["music_money"]
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "apple_vip_id": appleVipId,
        "money": money,
        "original_package_money": originalPackageMoney,
        "crossed_money": crossedMoney,
        "des": des,
        "illustrate": illustrate,
        "is_default": isDefault,
        "is_open_web": isOpenWeb,
        "web_des": webDes,
        "day_money": dayMoney,
        "vip_end_time": vipEndTime.toIso8601String(),
        "day": day,
        "integral": integral,
        "original_package_integral": originalPackageIntegral,
        "subscribe_period_des": subscribePeriodDes,
        "is_subscribe": isSubscribe,
        "page_path": pagePath,
        "subscribe_money": subscribeMoney,
        "subscribe_vip_end_time": subscribeVipEndTime,
        "vip_level": vipLevel,
        "title": title,
        "button_title": buttonTitle,
        "mark": mark,
         "music_money":musicMoney,
      };
}
