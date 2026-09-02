// To parse this JSON data, do
//
//     final musicSelectedBean = musicSelectedBeanFromJson(jsonString);

import 'dart:convert';

MusicSelectedBean musicSelectedBeanFromJson(String str) =>
    MusicSelectedBean.fromJson(json.decode(str));

String musicSelectedBeanToJson(MusicSelectedBean data) =>
    json.encode(data.toJson());

class MusicSelectedBean {
  int id;
  String name;
  String musicAuthor;
  String coverUrl;
  String musicUrl;
  List<SharePlatform> sharePlatform;

  MusicSelectedBean({
    required this.id,
    required this.name,
    required this.musicAuthor,
    required this.coverUrl,
    required this.musicUrl,
    required this.sharePlatform,
  });

  factory MusicSelectedBean.fromJson(Map<String, dynamic> json) =>
      MusicSelectedBean(
        id: json["id"] ?? 0,
        name: json["name"] ?? "",
        musicAuthor: json["music_author"] ?? "",
        coverUrl: json["cover_url"] ?? "",
        musicUrl: json["music_url"] ?? "",
        sharePlatform: json["share_platform"] != null
            ? List<SharePlatform>.from(
                json["share_platform"].map((x) => SharePlatform.fromJson(x)))
            : <SharePlatform>[],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "music_author": musicAuthor,
        "cover_url": coverUrl,
        "music_url": musicUrl,
        "share_platform":
            List<dynamic>.from(sharePlatform.map((x) => x.toJson())),
      };
}

class SharePlatform {
  int id;
  String title;
  String icon;

  SharePlatform({
    required this.id,
    required this.title,
    required this.icon,
  });

  factory SharePlatform.fromJson(Map<String, dynamic> json) => SharePlatform(
        id: json["id"] ?? 0,
        title: json["title"] ?? "",
        icon: json["icon"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "icon": icon,
      };
}
