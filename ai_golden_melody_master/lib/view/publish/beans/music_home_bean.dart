// To parse this JSON data, do
//
//     final musicHomeBean = musicHomeBeanFromJson(jsonString);

import 'dart:convert';

MusicHomeBean musicHomeBeanFromJson(String str) =>
    MusicHomeBean.fromJson(json.decode(str));

String musicHomeBeanToJson(MusicHomeBean data) => json.encode(data.toJson());

class MusicHomeBean {
  int totalIssue;
  int totalResidence;
  int totalIncome;

  MusicHomeBean({
    required this.totalIssue,
    required this.totalResidence,
    required this.totalIncome,
  });

  factory MusicHomeBean.fromJson(Map<String, dynamic> json) => MusicHomeBean(
        totalIssue: json["total_issue"] ?? 0,
        totalResidence: json["total_residence"] ?? 0,
        totalIncome: json["total_income"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "total_issue": totalIssue,
        "total_residence": totalResidence,
        "total_income": totalIncome,
      };
}
