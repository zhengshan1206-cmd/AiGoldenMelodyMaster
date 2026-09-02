class VipModel {
  int status;
  String message;
  Data data;

  VipModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory VipModel.fromJson(Map<String, dynamic> json) => VipModel(
        status: json["status"] ?? 0,
        message: json["message"] ?? "",
        data: Data.fromJson(json["data"] ?? {}),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data.toJson(),
      };
}

class Data {
  List<String> buyVip;
  Equity equity;
  List<FeedbackModel> feedback;
  String uservip;
  String buyNotice;

  Data({
    required this.buyVip,
    required this.equity,
    required this.feedback,
    required this.uservip,
    required this.buyNotice,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
      buyVip: List<String>.from(json["buyVip"]?.map((x) => x) ?? []),
      equity: Equity.fromJson(json["equity"] ?? {}),
      feedback: List<FeedbackModel>.from(
          json["feedback"]?.map((x) => FeedbackModel.fromJson(x)) ?? []),
      uservip: json["uservip"] ?? "",
      buyNotice: json["buyNotice"] ?? "");

  Map<String, dynamic> toJson() => {
        "buyVip": List<dynamic>.from(buyVip.map((x) => x)),
        "equity": equity.toJson(),
        "feedback": List<dynamic>.from(feedback.map((x) => x.toJson())),
        "uservip": uservip,
        "buyNotice": buyNotice,
      };
}

class Equity {
  List<Creation> creation;
  List<Creation> advanced;
  List<Creation> exclusive;
  int creationMusicNum;
  int advancedMusicNum;
  int exclusiveMusicNum;

  Equity({
    required this.creation,
    required this.advanced,
    required this.exclusive,
    required this.creationMusicNum,
    required this.advancedMusicNum,
    required this.exclusiveMusicNum,
  });

  factory Equity.fromJson(Map<String, dynamic> json) => Equity(
        creation: List<Creation>.from(
            json["creation"]?.map((x) => Creation.fromJson(x)) ?? []),
        advanced: List<Creation>.from(
            json["advanced"]?.map((x) => Creation.fromJson(x)) ?? []),
        exclusive: List<Creation>.from(
            json["exclusive"]?.map((x) => Creation.fromJson(x)) ?? []),
        creationMusicNum: json["creationMusicNum"] ?? 0,
        advancedMusicNum: json["advancedMusicNum"] ?? 0,
        exclusiveMusicNum: json["exclusiveMusicNum"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "creation": List<dynamic>.from(creation.map((x) => x.toJson())),
        "advanced": List<dynamic>.from(advanced.map((x) => x.toJson())),
        "exclusive": List<dynamic>.from(exclusive.map((x) => x.toJson())),
        "creationMusicNum": creationMusicNum,
        "advancedMusicNum": advancedMusicNum,
        "exclusiveMusicNum": exclusiveMusicNum,
      };
}

class Creation {
  int id;
  String name;
  String desc;
  String icon;
  int selected;

  Creation({
    required this.id,
    required this.name,
    required this.desc,
    required this.icon,
    required this.selected,
  });

  factory Creation.fromJson(Map<String, dynamic> json) => Creation(
        id: json["id"] ?? 0,
        name: json["name"] ?? "",
        desc: json["desc"] ?? "",
        icon: json["icon"] ?? "",
        selected: json["selected"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "desc": desc,
        "icon": icon,
        "selected": selected,
      };
}

class FeedbackModel {
  String name;
  String avatar;
  String content;

  FeedbackModel({
    required this.name,
    required this.avatar,
    required this.content,
  });

  factory FeedbackModel.fromJson(Map<String, dynamic> json) => FeedbackModel(
        name: json["name"] ?? "",
        avatar: json["avatar"] ?? "",
        content: json["content"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "avatar": avatar,
        "content": content,
      };
}
