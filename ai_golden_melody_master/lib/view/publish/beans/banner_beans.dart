// To parse this JSON data, do
//
//     final bannerBean = bannerBeanFromJson(jsonString);

import 'dart:convert';

BannerBean bannerBeanFromJson(String str) =>
    BannerBean.fromJson(json.decode(str));

String bannerBeanToJson(BannerBean data) => json.encode(data.toJson());

class BannerBean {
  int id;
  String title;
  String imgUrl;
  String jumpUrl;
  String jumpParam;
  int type;
  String des;

  BannerBean({
    required this.id,
    required this.title,
    required this.imgUrl,
    required this.jumpUrl,
    required this.jumpParam,
    required this.type,
    required this.des,
  });

  factory BannerBean.fromJson(Map<String, dynamic> json) => BannerBean(
        id: json["id"],
        title: json["title"],
        imgUrl: json["img_url"],
        jumpUrl: json["jump_url"],
        jumpParam: json["jump_param"],
        type: json["type"],
        des: json["des"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "img_url": imgUrl,
        "jump_url": jumpUrl,
        "jump_param": jumpParam,
        "type": type,
        "des": des,
      };
}
