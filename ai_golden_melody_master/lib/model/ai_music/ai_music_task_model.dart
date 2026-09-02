class AiMusicTaskModel {
  int status;
  String message;
  AiMusicTaskData data;

  AiMusicTaskModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory AiMusicTaskModel.fromJson(Map<String, dynamic> json) => AiMusicTaskModel(
    status: json["status"],
    message: json["message"],
    data: AiMusicTaskData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data.toJson(),
  };
}

class AiMusicTaskData {
  String taskId;
  int taskType;

  AiMusicTaskData({
    required this.taskId,
    required this.taskType,
  });

  factory AiMusicTaskData.fromJson(Map<String, dynamic> json) => AiMusicTaskData(
    taskId: json["taskId"],
    taskType: json["taskType"],
  );

  Map<String, dynamic> toJson() => {
    "taskId": taskId,
    "taskType": taskType,
  };
}