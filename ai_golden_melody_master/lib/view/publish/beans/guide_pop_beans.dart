/*
  guide_pop_bean.dart
  攻略弹窗数据模型
  Created by duncy on 25/4/16.
*/

import 'dart:convert';

GuidePopBean userInfoBeanFromJson(String str) =>
    GuidePopBean.fromJson(json.decode(str));

String userInfoBeanToJson(GuidePopBean data) => json.encode(data.toJson());

class GuidePopBean {
  int? jumpType;
  String? url;
  int? isread;
  int? id;
  String? header;
  List<dynamic>? questions;
  int? promotionType;

  GuidePopBean({
    this.jumpType,
    this.url,
    this.isread,
    this.id,
    this.header,
    this.questions,
    this.promotionType,
  });
  factory GuidePopBean.fromJson(Map<String, dynamic> json) => GuidePopBean(
        //优先寻找jump_to_position,再查看com_pr里的类型
        jumpType: _getJumpType(json),
        url: _getUrl(json),
        isread: _getIsRead(json),
        id: _getId(json),
        // header: json["com_pr"][0]["header"] ?? "",
        // questions: json["com_pr"][0]["questions"] ?? [],
        // promotionType: json["com_pr"][0]["promotion_type"],
      );

  // 安全获取jumpType
  static int? _getJumpType(Map<String, dynamic> json) {
    try {
      // 优先从items中获取jump_to_position
      final items = json["items"];
      if (items != null && items is Map<String, dynamic>) {
        final jumpToPosition = items["jump_to_position"];
        if (jumpToPosition != null) {
          return jumpToPosition is int
              ? jumpToPosition
              : int.tryParse(jumpToPosition.toString());
        }
      }

      // 如果items中没有，尝试从com_pr中获取
      final comPr = json["com_pr"];
      if (comPr != null && comPr is List && comPr.isNotEmpty) {
        final firstItem = comPr[0];
        if (firstItem is Map<String, dynamic>) {
          final type = firstItem["type"];
          if (type != null) {
            return type is int ? type : int.tryParse(type.toString());
          }
        }
      }
    } catch (e) {
      print("获取jumpType异常: $e");
    }
    return null;
  }

  // 安全获取url
  static String? _getUrl(Map<String, dynamic> json) {
    try {
      final items = json["items"];
      if (items != null && items is Map<String, dynamic>) {
        final jumpTo = items["jump_to"];
        if (jumpTo != null && jumpTo is List && jumpTo.isNotEmpty) {
          final firstUrl = jumpTo[0];
          return firstUrl?.toString();
        }
      }
    } catch (e) {
      print("获取url异常: $e");
    }
    return null;
  }

  // 安全获取isread
  static int? _getIsRead(Map<String, dynamic> json) {
    try {
      final items = json["items"];
      if (items != null && items is Map<String, dynamic>) {
        final isRead = items["is_read"];
        if (isRead != null) {
          return isRead is int ? isRead : int.tryParse(isRead.toString());
        }
      }
    } catch (e) {
      print("获取isread异常: $e");
    }
    return null;
  }

  // 安全获取id
  static int? _getId(Map<String, dynamic> json) {
    try {
      final items = json["items"];
      if (items != null && items is Map<String, dynamic>) {
        final id = items["id"];
        if (id != null) {
          return id is int ? id : int.tryParse(id.toString());
        }
      }
    } catch (e) {
      print("获取id异常: $e");
    }
    return null;
  }

  Map<String, dynamic> toJson() => {
        "jump_type": jumpType,
        "url": url,
        "isread": isread,
        "id": id,
        // "header": header,
        // "questions": questions,
        // "promotion_type": promotionType,
      };

  // int _handleJumpType() {
  //   return 1;
  // }

  @override
  String toString() {
    return 'GuidePopBean{jumpType: $jumpType, url: $url, isread: $isread, id: $id}';
  }
}
