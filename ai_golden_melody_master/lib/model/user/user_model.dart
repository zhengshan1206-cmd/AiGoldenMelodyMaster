
class UserProfileResponse {
  final int status;
  final String message;
  final UserData data;

  const UserProfileResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory UserProfileResponse.fromJson(Map<String, dynamic> json) {
    return UserProfileResponse(
      status: json['status'] as int,
      message: json['message'] as String,
      data: UserData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data.toJson(),
    };
  }
}

class UserData {
  final int userId;
  final String userName;
  final String? userAvatar; // 允许为空（原JSON中为空字符串）
  final int isVip;
  final int vipLevel;
  final String? vipEndTime; // 允许为空（原JSON中为空字符串）
  final int unreadNumber;
  final int worksNumber;
  final int notesNumber;
  final int giftNotesNumber;
  final int purcNotesNumber;

  const UserData({
    required this.userId,
    required this.userName,
    this.userAvatar,
    required this.isVip,
    required this.vipLevel,
    this.vipEndTime,
    required this.unreadNumber,
    required this.worksNumber,
    required this.notesNumber,
    required this.giftNotesNumber,
    required this.purcNotesNumber,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      userId: json['userId'] as int,
      userName: json['userName'] as String,
      // 处理空字符串或null，转为null（根据业务需求可改为空字符串）
      userAvatar: (json['userAvatar'] as String?)?.isEmpty ?? true ? null : json['userAvatar'] as String?,
      isVip: json['isVip'] as int,
      vipLevel: json['vipLevel'] as int,
      // 处理空字符串或null，转为null
      vipEndTime: (json['vipEndTime'] as String?)?.isEmpty ?? true ? null : json['vipEndTime'] as String?,
      unreadNumber: json['unreadNumber'] as int,
      worksNumber: json['worksNumber'] as int,
      notesNumber: json['notesNumber'] as int,
      giftNotesNumber: json['giftNotesNumber'] as int,
      purcNotesNumber: json['purcNotesNumber'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'userName': userName,
      'userAvatar': userAvatar,
      'isVip': isVip,
      'vipLevel': vipLevel,
      'vipEndTime': vipEndTime,
      'unreadNumber': unreadNumber,
      'worksNumber': worksNumber,
      'notesNumber': notesNumber,
      'giftNotesNumber': giftNotesNumber,
      'purcNotesNumber': purcNotesNumber,
    };
  }
}