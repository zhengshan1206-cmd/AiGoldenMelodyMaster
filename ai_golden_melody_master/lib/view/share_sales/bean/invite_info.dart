
class InviteInfoApiResponse {
  final int? status;
  final String? message;
  final InviteInfoData? data;

  InviteInfoApiResponse({
    this.status,
    this.message,
    this.data,
  });

  factory InviteInfoApiResponse.fromJson(Map<String, dynamic> json) {
    return InviteInfoApiResponse(
      status: json['status'] as int?,
      message: json['message'] as String?,
      data: json['data'] != null ? InviteInfoData.fromJson(json['data'] as Map<String, dynamic>) : null,
    );
  }
}

class InviteInfoData {
  final String? canWithdrawCash;
  final String? cumulativeIncome;
  final int? inviteNumber;
  final String? inviteCode;
  final String? inviteUrl;
  final InviteInfo? inviteInfo;
  final List<Poster>? poster;
  final InviteActivityModel? description;

  final String? pending;
  final String? withdrawBalance;
  final String? cashNotes;

  InviteInfoData({
    this.canWithdrawCash,
    this.cumulativeIncome,
    this.inviteNumber,
    this.inviteCode,
    this.inviteUrl,
    this.inviteInfo,
    this.poster,
    this.description,
    this.pending,
    this.withdrawBalance,
    this.cashNotes,
  });

  factory InviteInfoData.fromJson(Map<String, dynamic> json) {
    return InviteInfoData(
      canWithdrawCash: json['canWithdrawCash'] as String?,
      pending:json["pending"] as String?,
      cumulativeIncome: json['cumulativeIncome'] as String?,
      inviteNumber: json['inviteNumber'] as int?,
      inviteCode: json['inviteCode'] as String?,
      inviteUrl: json['inviteUrl'] as String?,
      inviteInfo: json['inviteInfo'] != null ? InviteInfo.fromJson(json['inviteInfo'] as Map<String, dynamic>) : null,
      poster: (json['poster'] as List<dynamic>?)
          ?.map((e) => Poster.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      description: InviteActivityModel.fromJson(json['description']),
      withdrawBalance: json['withdrawBalance'] as String?,
      cashNotes: json["cashNotes"] as String?,
    );
  }
}

class InviteInfo {
  final String? sTime;
  final String? eTime;
  final int? inviteType;
  final int? rewardNumber;
  final int? rewardLimit;
  final int? rewardDelayTime;

  InviteInfo({
    this.sTime,
    this.eTime,
    this.inviteType,
    this.rewardNumber,
    this.rewardLimit,
    this.rewardDelayTime,
  });

  factory InviteInfo.fromJson(Map<String, dynamic> json) {
    return InviteInfo(
      sTime: json['sTime'] as String?,
      eTime: json['eTime'] as String?,
      inviteType: json['inviteType'] as int?,
      rewardNumber: json['rewardNumber'] as int?,
      rewardLimit: json['rewardLimit'] as int?,
      rewardDelayTime: json['rewardDelayTime'] as int?,
    );
  }
}

class Poster {
  final int? id;
  final String? name;
  final String? url;

  Poster({
    this.id,
    this.name,
    this.url,
  });

  factory Poster.fromJson(Map<String, dynamic> json) {
    return Poster(
      id: json['id'] as int?,
      name: json['name'] as String?,
      url: json['url'] as String?,
    );
  }
}

class Description {
  final String? title;
  final String? content;

  Description({
    this.title,
    this.content,
  });

  factory Description.fromJson(Map<String, dynamic> json) {
    return Description(
      title: json['title'] as String?,
      content: json['content'] as String?,
    );
  }
}

class InviteActivityModel {
  final String title;
  final String start;
  final String end;
  final List<ContentItem> content;
  final String? cashNotes;

  InviteActivityModel({
    required this.title,
    required this.start,
    required this.end,
    required this.content,
    required this.cashNotes,
  });

  factory InviteActivityModel.fromJson(Map<String, dynamic> json) {
    var contentList = json['content'] as List;
    List<ContentItem> contentItems = contentList
        .map((i) => ContentItem.fromJson(i as Map<String, dynamic>))
        .toList();

    return InviteActivityModel(
      title: json['title'] as String,
      start: json['start'] as String,
      end: json['end'] as String,
      content: contentItems,
      cashNotes: json['cashNotes'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'start': start,
      'end': end,
      'content': content.map((item) => item.toJson()).toList(),
      'cashNotes': cashNotes,
    };
  }
}

class ContentItem {
  final String title;
  final String content;

  ContentItem({
    required this.title,
    required this.content,
  });

  factory ContentItem.fromJson(Map<String, dynamic> json) {
    return ContentItem(
      title: json['title'] as String,
      content: json['content'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
    };
  }
}