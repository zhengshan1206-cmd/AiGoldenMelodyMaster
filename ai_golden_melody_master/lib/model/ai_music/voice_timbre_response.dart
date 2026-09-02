

class VoiceTimbreResponse {
  final int? status;
  final String? message;
  final VoiceTimbreData? data;

  VoiceTimbreResponse({
    this.status = 0,
    this.message = '',
    this.data,
  });

  factory VoiceTimbreResponse.fromJson(Map<String, dynamic>? json) {
    if (json == null) return VoiceTimbreResponse();
    
    return VoiceTimbreResponse(
      status: json['status'] as int?,
      message: json['message'] as String?,
      data: json['data'] != null 
        ? VoiceTimbreData.fromJson(json['data'] as Map<String, dynamic>) 
        : null,
    );
  }
}

class VoiceTimbreData {
  final int? total;
  final int? perPage;
  final int? currentPage;
  final int? lastPage;
  final List<VoiceTimbreItem>? data;

  VoiceTimbreData({
    this.total = 0,
    this.perPage = 0,
    this.currentPage = 0,
    this.lastPage = 0,
    this.data,
  });

  factory VoiceTimbreData.fromJson(Map<String, dynamic>? json) {
    if (json == null) return VoiceTimbreData();
    
    final dataList = json['data'] as List<dynamic>?;
    return VoiceTimbreData(
      total: json['total'] as int?,
      perPage: json['per_page'] as int?,
      currentPage: json['current_page'] as int?,
      lastPage: json['last_page'] as int?,
      data: dataList?.map((item) => VoiceTimbreItem.fromJson(item as Map<String, dynamic>)).toList(),
    );
  }
}

class VoiceTimbreItem {
  final int? id;
  final String? name;
  final String? trainAudioUrl;
  final String? voiceTimbreUrl;
  final int? status;
  final int? audit;

  VoiceTimbreItem({
    this.id = 0,
    this.name = '',
    this.trainAudioUrl = '',
    this.voiceTimbreUrl = '',
    this.status,
    this.audit,
  });

  factory VoiceTimbreItem.fromJson(Map<String, dynamic>? json) {
    if (json == null) return VoiceTimbreItem();
    
    return VoiceTimbreItem(
      id: json['id'] as int?,
      name: json['name'] as String?,
      trainAudioUrl: json['train_audio_url'] as String?,
      voiceTimbreUrl: json['voice_timbre_url'] as String?,
      status: json['status'] as int?,
      audit:  json['audit'] as int?,
    );
  }
}    