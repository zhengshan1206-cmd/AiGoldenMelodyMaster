

class AiExclusiveModeTaskModel {
  final int? status;
  final String? message;
  final AiExclusiveModeTaskData? data;

  AiExclusiveModeTaskModel({
    this.status,
    this.message,
    this.data,
  });

  factory AiExclusiveModeTaskModel.fromJson(Map<String, dynamic> json) {
    return AiExclusiveModeTaskModel(
      status: json['status'] as int?,
      message: json['message'] as String?,
      data: json['data'] == null ? null : AiExclusiveModeTaskData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class AiExclusiveModeTaskData {
  final int? id;
  final String? taskId;
  final int? audit;
  final int? status;
  final String? sourceAudioUrl;

  AiExclusiveModeTaskData({
    this.id,
    this.taskId,
    this.audit,
    this.status,
    this.sourceAudioUrl,
  });

  factory AiExclusiveModeTaskData.fromJson(Map<String, dynamic> json) {
    return AiExclusiveModeTaskData(
      id: json['id'] as int?,
      taskId: json['task_id'] as String?,
      audit: json['audit'] as int?,
      status: json['status'] as int?,
      sourceAudioUrl: json['source_audio_url'] ??"",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'task_id': taskId,
      'audit': audit,
      'status': status,
      'source_audio_url': sourceAudioUrl,
    };
  }
}