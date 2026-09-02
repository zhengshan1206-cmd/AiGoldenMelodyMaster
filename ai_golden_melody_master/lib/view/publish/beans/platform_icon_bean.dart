// To parse this JSON data, do
//
//     final platformIcon = platformIconFromJson(jsonString);

import 'dart:convert';

List<PlatformIcon> platformIconFromJson(String str) => List<PlatformIcon>.from(
    json.decode(str).map((x) => PlatformIcon.fromJson(x)));

String platformIconToJson(List<PlatformIcon> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PlatformIcon {
  int id;
  String title;
  String icon;

  PlatformIcon({
    required this.id,
    required this.title,
    required this.icon,
  });

  factory PlatformIcon.fromJson(Map<String, dynamic> json) => PlatformIcon(
        id: json["id"],
        title: json["title"],
        icon: json["icon"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "icon": icon,
      };
}
