class MyWorkResponseModel {
  final int status;
  final String message;
  final Data data;

  MyWorkResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory MyWorkResponseModel.fromJson(Map<String, dynamic> json) {
    return MyWorkResponseModel(
      status: json['status'] as int,
      message: json['message'] as String,
      data: Data.fromJson(json['data'] as Map<String, dynamic>),
    );
  }
}

class Data {
  final int workNumber;

  Data({
    required this.workNumber,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      workNumber: json['workNumber']??0,
    );
  }
}