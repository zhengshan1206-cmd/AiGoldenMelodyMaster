// music_model.dart
class HotTopicMusicModel {
  final int status;
  final String message;
  final List<MusicItem> data;

  HotTopicMusicModel({
    required this.status,
    required this.message,
    required this.data,
  });

  // 从 JSON 解析
  factory HotTopicMusicModel.fromJson(Map<String, dynamic> json) {
    List<dynamic> data = [];
    if(json['data']!=null){
      data = json['data'];
    }


    return HotTopicMusicModel(
      status: json['status'] as int,
      message: json['message'] as String,
      data: data.map((item) => MusicItem.fromJson(item),).toList(),
    );
  }

  // 转换为 JSON
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data.map((item) => item.toJson()).toList(),
    };
  }
}

class MusicItem {
  final int id;
  final String title;
  final String detail;

  MusicItem({
    required this.id,
    required this.title,
    required this.detail,
  });

  // 从 JSON 解析
  factory MusicItem.fromJson(Map<String, dynamic> json) {
    return MusicItem(
      id: json['id'] as int,
      title: json['title'] as String,
      detail: json['detail'] as String,
    );
  }

  // 转换为 JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'detail': detail,
    };
  }
}