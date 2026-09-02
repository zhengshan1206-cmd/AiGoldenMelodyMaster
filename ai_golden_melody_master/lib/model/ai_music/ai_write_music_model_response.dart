
class AiMusicResponseModel {
  final int status;
  final String message;
  final Data data;

  AiMusicResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory AiMusicResponseModel.fromJson(Map<String, dynamic> json) {
    return AiMusicResponseModel(
      status: json['status'] as int,
      message: json['message'] as String,
      data: Data.fromJson(json['data'] as Map<String, dynamic>),
    );
  }
}

class Data {
  final String taskId;
  final int taskType;

  Data({
    required this.taskId,
    required this.taskType,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      taskId: json['taskId'] as String,
      taskType: json['taskType'] as int,
    );
  }
}