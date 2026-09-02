
class RewardResponse {
  final int status;
  final String message;
  final RewardDataWrapper data;

  const RewardResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory RewardResponse.fromJson(Map<String, dynamic> json) {
    return RewardResponse(
      status: json['status'] as int,
      message: json['message'] as String,
      data: RewardDataWrapper.fromJson(json['data'] as Map<String, dynamic>),
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

class RewardDataWrapper {
  final int total;
  final int perPage;
  final int currentPage;
  final int lastPage;
  final List<RewardItem> data;

  const RewardDataWrapper({
    required this.total,
    required this.perPage,
    required this.currentPage,
    required this.lastPage,
    required this.data,
  });

  factory RewardDataWrapper.fromJson(Map<String, dynamic> json) {
    final List<dynamic> dataList = json['data'] as List<dynamic>;
    final List<RewardItem> items = dataList
        .map((dynamic item) => RewardItem.fromJson(item as Map<String, dynamic>))
        .toList();

    return RewardDataWrapper(
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

class RewardItem {
  final int id;
  final int dataType;
  final String rewardNumber;
  final int rewardStatus;
  final int inviteeUserVipLevel;
  final String createdAt;
  final String phone;
  final String vipLevelText;

  const RewardItem({
    required this.id,
    required this.dataType,
    required this.rewardNumber,
    required this.rewardStatus,
    required this.inviteeUserVipLevel,
    required this.createdAt,
    required this.phone,
    required this.vipLevelText,
  });

  factory RewardItem.fromJson(Map<String, dynamic> json) {
    return RewardItem(
      id: json['id'] as int,
      dataType: json['data_type'] as int,
      rewardNumber: json['reward_number'],
      rewardStatus: json['reward_status'] as int,
      inviteeUserVipLevel: json['invitee_user_vip_level'] as int,
      createdAt: json['created_at'] as String,
      phone: json['phone'] as String,
      // 处理可能为空的字符串字段
      vipLevelText: json['vip_level_text'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'data_type': dataType,
      'reward_number': rewardNumber,
      'reward_status': rewardStatus,
      'invitee_user_vip_level': inviteeUserVipLevel,
      'created_at': createdAt,
      'phone': phone,
      'vip_level_text': vipLevelText,
    };
  }
}
