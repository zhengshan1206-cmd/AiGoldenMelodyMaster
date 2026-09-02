// To parse this JSON data, do
//
//     final rankingTabListBean = rankingTabListBeanFromJson(jsonString);

import 'dart:convert';

RankingTabListBean rankingTabListBeanFromJson(String str) =>
    RankingTabListBean.fromJson(json.decode(str));

String rankingTabListBeanToJson(RankingTabListBean data) =>
    json.encode(data.toJson());

class RankingTabListBean {
  int id;
  String title;
  String iconUrl;
  String bgUrl;

  RankingTabListBean({
    required this.id,
    required this.title,
    required this.iconUrl,
    required this.bgUrl,
  });

  factory RankingTabListBean.fromJson(Map<String, dynamic> json) =>
      RankingTabListBean(
        id: json["id"],
        title: json["title"],
        iconUrl: json["icon_url"],
        bgUrl: json["bg_url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "icon_url": iconUrl,
        "bg_url": bgUrl,
      };
}
