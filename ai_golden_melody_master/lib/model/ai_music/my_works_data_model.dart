///我的作品数据model
class MyWorksDataModel {
  final int status;
  final String message;
  final PageData data;

  MyWorksDataModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory MyWorksDataModel.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return MyWorksDataModel(
      status: json['status'] as int? ?? 0,
      message: json['message'] as String? ?? '',
      data: PageData.fromJson(json['data'] as Map<String, dynamic>?),
    );
  }
}

class PageData {
  final int total;
  final int perPage;
  final int currentPage;
  final int lastPage;
  final List<MyWorksMusicItem> data;

  PageData({
    required this.total,
    required this.perPage,
    required this.currentPage,
    required this.lastPage,
    required this.data,
  });

  factory PageData.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return PageData(
      total: json['total'] as int? ?? 0,
      perPage: json['per_page'] as int? ?? 0,
      currentPage: json['current_page'] as int? ?? 0,
      lastPage: json['last_page'] as int? ?? 0,
      data: (json['data'] as List<dynamic>?)
              ?.map((item) =>
                  MyWorksMusicItem.fromJson(item as Map<String, dynamic>?))
              .toList() ??
          [],
    );
  }
}

class MyWorksMusicItem {
  final int id;
  final int mode;
  final String name;
  final String coverUrl;
  final String musicUrl;
  final String createdAt;
  final int status;
  final String shareUrl;
  final String musicAuthor;

  final String musicWavUrl;
  final String musicBackUrl;
  final String musicMidiUrl;

  final String lyrics;

  final int type;

  MyWorksMusicItem({
    required this.id,
    required this.mode,
    required this.name,
    required this.coverUrl,
    required this.musicUrl,
    required this.createdAt,
    required this.status,
    required this.shareUrl,
    required this.musicAuthor,
    required this.musicWavUrl,
    required this.musicBackUrl,
    required this.musicMidiUrl,
    required this.lyrics,
    required this.type,
  });

  factory MyWorksMusicItem.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return MyWorksMusicItem(
      id: json['id'] as int? ?? 0,
      mode: json['mode'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      coverUrl: json['cover_url'] as String? ?? '',
      musicUrl: json['music_url'] as String? ?? '',
      createdAt: json['created_at'] as String? ?? '',
      status: json['status'] as int? ?? 00,
      shareUrl: json["share_url"] as String? ?? '',
      musicAuthor: json["music_author"] as String? ?? '',
      musicWavUrl: json["music_wav_url"] as String? ?? '',
      musicBackUrl: json["music_back_url"] as String? ?? '',
      musicMidiUrl: json["music_midi_url"] as String? ?? '',
      lyrics: json["lyrics"] as String? ?? '',
      type: json["type"] as int? ?? 0,
    );
  }
}
