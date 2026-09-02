
class AudioSeparationResult {
  final int? status;
  final String? message;
  final AudioSeparationResultData? data;

  AudioSeparationResult({
    this.status = 0,
    this.message = '',
    this.data,
  });

  factory AudioSeparationResult.fromJson(Map<String, dynamic>? json) {
    if (json == null) return AudioSeparationResult();

    return AudioSeparationResult(
      status: json['status'] as int?,
      message: json['message'] as String?,
      data: json['data'] != null
          ? AudioSeparationResultData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }
}

class AudioSeparationResultData {
  final int? id;
  final int? status;
  final String? taskId;
  final String? aiTaskId;
  final String? aiTaskKey;
  final int? aiTaskType;
  final String? aiTaskName;
  final AudioSeparationResultInnerData? data;
  final dynamic parse;

  AudioSeparationResultData({
    this.id = 0,
    this.status = 0,
    this.taskId = '',
    this.aiTaskId = '',
    this.aiTaskKey = '',
    this.aiTaskType = 0,
    this.aiTaskName = '',
    this.data,
    this.parse,
  });

  factory AudioSeparationResultData.fromJson(Map<String, dynamic>? json) {
    if (json == null) return AudioSeparationResultData();

    return AudioSeparationResultData(
      id: json['id'] as int?,
      status: json['status'] as int?,
      taskId: json['task_id'] as String?,
      aiTaskId: json['ai_task_id'] as String?,
      aiTaskKey: json['ai_task_key'] as String?,
      aiTaskType: json['ai_task_type'] as int?,
      aiTaskName: json['ai_task_name'] as String?,
      data: json['data'] != null
          ? AudioSeparationResultInnerData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
      parse: json['parse'],
    );
  }
}

class AudioSeparationResultInnerData {
  final String? vocalsFileUrl;
  final String? noVocalsFileUrl;

  AudioSeparationResultInnerData({
    this.vocalsFileUrl = '',
    this.noVocalsFileUrl = '',
  });

  factory AudioSeparationResultInnerData.fromJson(Map<String, dynamic>? json) {
    if (json == null) return AudioSeparationResultInnerData();

    return AudioSeparationResultInnerData(
      vocalsFileUrl: json['vocals_file_url'] as String?,
      noVocalsFileUrl: json['no_vocals_file_url'] as String?,
    );
  }
}