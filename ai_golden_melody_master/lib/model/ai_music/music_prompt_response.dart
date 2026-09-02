


/// 音乐提示词响应模型（所有字段支持空安全）
class MusicPromptResponse {
  final int? status;
  final String? message;
  final List<MusicPromptData>? data;

  MusicPromptResponse({
    this.status,
    this.message,
    this.data,
  });

  /// 从JSON映射创建实例，处理可能的null值
  factory MusicPromptResponse.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return MusicPromptResponse();
    }

    var dataList = json['data'] as List?;
    List<MusicPromptData>? promptItems;
    
    if (dataList != null) {
      promptItems = dataList
          .map((i) => MusicPromptData.fromJson(i as Map<String, dynamic>?))
          .toList();
    }

    return MusicPromptResponse(
      status: json['status'] as int?,
      message: json['message'] as String?,
      data: promptItems,
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data?.map((item) => item.toJson()).toList(),
    };
  }
}

/// 音乐提示词数据项模型（所有字段支持空安全）
class MusicPromptData {
  final int? id;
  final String? prompt;
  final String? musicUrl;

  MusicPromptData({
    this.id,
    this.prompt,
    this.musicUrl,
  });

  // 从JSON映射创建实例，处理可能的null值
  factory MusicPromptData.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return MusicPromptData();
    }

    return MusicPromptData(
      id: json['id'] as int?,
      prompt: json['prompt'] as String?,
      musicUrl: json['musicUrl'] as String?,
    );
  }

  // 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'prompt': prompt,
      'musicUrl': musicUrl,
    };
  }

  /// 复制方法，便于创建修改后的对象副本
  MusicPromptData copyWith({
    int? id,
    String? prompt,
    String? musicUrl,
  }) {
    return MusicPromptData(
      id: id ?? this.id,
      prompt: prompt ?? this.prompt,
      musicUrl: musicUrl ?? this.musicUrl,
    );
  }
}
    