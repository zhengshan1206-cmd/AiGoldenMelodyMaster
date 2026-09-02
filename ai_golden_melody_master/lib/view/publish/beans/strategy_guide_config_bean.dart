// To parse this JSON data, do
//
//     final strategyGuideConfigBean = strategyGuideConfigBeanFromJson(jsonString);

import 'dart:convert';

StrategyGuideConfigBean strategyGuideConfigBeanFromJson(String str) =>
    StrategyGuideConfigBean.fromJson(json.decode(str));

String strategyGuideConfigBeanToJson(StrategyGuideConfigBean data) =>
    json.encode(data.toJson());

class StrategyGuideConfigBean {
  int learnNumber;
  List<UserAvatar> userAvatar;

  StrategyGuideConfigBean({
    required this.learnNumber,
    required this.userAvatar,
  });

  factory StrategyGuideConfigBean.fromJson(Map<String, dynamic> json) =>
      StrategyGuideConfigBean(
        learnNumber: json["learnNumber"],
        userAvatar: List<UserAvatar>.from(
            json["userAvatar"].map((x) => UserAvatar.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "learnNumber": learnNumber,
        "userAvatar": List<dynamic>.from(userAvatar.map((x) => x.toJson())),
      };
}

class UserAvatar {
  int id;
  String avatar;

  UserAvatar({
    required this.id,
    required this.avatar,
  });

  factory UserAvatar.fromJson(Map<String, dynamic> json) => UserAvatar(
        id: json["id"],
        avatar: json["avatar"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "avatar": avatar,
      };
}
