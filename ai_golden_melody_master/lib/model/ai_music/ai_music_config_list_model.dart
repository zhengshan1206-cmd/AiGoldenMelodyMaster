
///服务器配置的音频数据集
class AIMusicConfigListModel {
  int status;
  String message;
  List<AiMusicConfigListItem> data;

  AIMusicConfigListModel({
    this.status = 0,
    this.message = '',
    this.data = const [],
  });

  factory AIMusicConfigListModel.fromJson(Map<String, dynamic> json) {
    return AIMusicConfigListModel(
      status: json['status'] as int? ?? 0,
      message: json['message'] as String? ?? '',
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => AiMusicConfigListItem.fromJson(e as Map<String, dynamic>))
          .toList() ??
          const [],
    );
  }
}

class AiMusicConfigListItem {
  int id;
  String musicUrl;
  int duration;
  String content;

  AiMusicConfigListItem({
    this.id = 0,
    this.musicUrl = '',
    this.duration = 0,
    this.content = '',
  });

  factory AiMusicConfigListItem.fromJson(Map<String, dynamic> json) {
    return AiMusicConfigListItem(
      id: json['id'] as int? ?? 0,
      musicUrl: json['music_url'] as String? ?? '',
      duration: json['duration'] as int? ?? 0,
      content: json['content'] as String? ?? '',
    );
  }
}