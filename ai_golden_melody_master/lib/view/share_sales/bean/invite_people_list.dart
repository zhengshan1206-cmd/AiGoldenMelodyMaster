
class InviteUserResponse {
  final int status;
  final String message;
  final UserDataWrapper data;

  const InviteUserResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory InviteUserResponse.fromJson(Map<String, dynamic> json) {
    return InviteUserResponse(
      status: json['status'] as int,
      message: json['message'] as String,
      data: UserDataWrapper.fromJson(json['data'] as Map<String, dynamic>),
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

class UserDataWrapper {
  final int total;
  final int perPage;
  final int currentPage;
  final int lastPage;
  final List<UserItem> data;

  const UserDataWrapper({
    required this.total,
    required this.perPage,
    required this.currentPage,
    required this.lastPage,
    required this.data,
  });

  factory UserDataWrapper.fromJson(Map<String, dynamic> json) {
    final List<dynamic> dataList = json['data'] as List<dynamic>;
    final List<UserItem> items = dataList
        .map((dynamic item) => UserItem.fromJson(item as Map<String, dynamic>))
        .toList();

    return UserDataWrapper(
      total: json['total'] as int,
      perPage: json['per_page'] as int,
      currentPage: json['current_page'] as int,
      lastPage: json['last_page'] as int,
      data: items,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'per_page': perPage,
      'current_page': currentPage,
      'last_page': lastPage,
      'data': data.map((item) => item.toJson()).toList(),
    };
  }
}

class UserItem {
  final int id;
  final int vipLevel;
  final String createdAt;
  final String phone;
  final String avatar;
  final String vipLevelText;

  const UserItem({
    required this.id,
    required this.vipLevel,
    required this.createdAt,
    required this.phone,
    required this.avatar,
    required this.vipLevelText,
  });

  factory UserItem.fromJson(Map<String, dynamic> json) {
    return UserItem(
      id: json['id'] as int,
      vipLevel: json['vip_level'] as int,
      createdAt: json['created_at'] as String,
      phone: json['phone'] as String,
      // 处理可能为空的头像字段，默认为空字符串
      avatar: json['avatar'] as String? ?? '',
      // 处理可能为空的VIP等级文本，默认为空字符串
      vipLevelText: json['vip_level_text'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vip_level': vipLevel,
      'created_at': createdAt,
      'phone': phone,
      'avatar': avatar,
      'vip_level_text': vipLevelText,
    };
  }
}
