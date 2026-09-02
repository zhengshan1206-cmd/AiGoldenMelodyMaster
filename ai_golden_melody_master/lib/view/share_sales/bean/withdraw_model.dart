import 'package:get/get_core/src/get_main.dart';

class WithdrawApiResponse {
  final int status;
  final String message;
  final List<WithdrawUserData> data;

  WithdrawApiResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory WithdrawApiResponse.fromJson(Map<String, dynamic> json) {
    List data = [];
    if(json["data"] is Map){
      Get.log("dataJson===> ${json["data"]}");
      data = [];
    }else{
      data = json["data"];
    }
    var dataList = data;
    List<WithdrawUserData> userList = dataList.map((i) => WithdrawUserData.fromJson(i)).toList();

    return WithdrawApiResponse(
      status: json['status'] as int,
      message: json['message'] as String,
      data: userList,
    );
  }
}

class WithdrawUserData {
  final int id;
  final int type;
  final String name;
  final String avatar;
  final int isAuth;

  WithdrawUserData({
    required this.id,
    required this.type,
    required this.name,
    required this.avatar,
    required this.isAuth,
  });

  factory WithdrawUserData.fromJson(Map<String, dynamic> json) {
    return WithdrawUserData(
      id: json['id'] as int,
      type: json['type'] as int,
      // 处理可能为空的字符串字段
      name: json['name'] as String? ?? '',
      avatar: json['avatar'] as String? ?? '',
      isAuth: json['is_auth'] as int,
    );
  }
}
