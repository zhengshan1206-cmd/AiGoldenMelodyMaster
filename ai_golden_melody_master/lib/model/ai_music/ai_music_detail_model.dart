import 'package:ai_golden_melody_master/model/ai_music/ai_music_config_model.dart';

class AiMusicDetailModel {
  final int? status;
  final String? message;
  final MusicData? data;

  AiMusicDetailModel({
    this.status,
    this.message,
    this.data,
  });

  factory AiMusicDetailModel.fromJson(Map<String, dynamic> json) {
    return AiMusicDetailModel(
      status: json['status'] as int?,
      message: json['message'] as String?,
      data: json['data'] == null
          ? null
          : MusicData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }
}

class MusicData {
  final int? id;
  final int? type;
  final int? mode;
  final int? userId;
  final String? taskId;
  String? name;
  final String? lyrics;
  final String? prompt;
  final ReqData? reqData;
  final String? describe;
  final int? timbreId;
  final String? coverUrl;
  String? musicAuthor;
  final String? wordAuthor;
  final String? songAuthor;
  final int? isShare;
  final int? status;
  final String? audioUrl;
  final String? musicUrl;
  final String? musicWavUrl;
  final String? musicVoiceUrl;
  final String? musicBackUrl;
  final String? musicMidiUrl;
  final String? musicScoreUrl;
  final List<dynamic>? sharePlatform;
  final int? integral;
  final int? manualEnd;
  final dynamic deletedAt;
  final String? createdAt;
  final String? updatedAt;
  final MusicInfo? musicInfo;
  final String? shareUrl;
  final SameData? sameData;

  MusicData({
    this.id,
    this.type,
    this.mode,
    this.userId,
    this.taskId,
    this.name,
    this.lyrics,
    this.prompt,
    this.reqData,
    this.describe,
    this.timbreId,
    this.coverUrl,
    this.musicAuthor,
    this.wordAuthor,
    this.songAuthor,
    this.isShare,
    this.status,
    this.audioUrl,
    this.musicUrl,
    this.musicWavUrl,
    this.musicVoiceUrl,
    this.musicBackUrl,
    this.musicMidiUrl,
    this.musicScoreUrl,
    this.sharePlatform,
    this.integral,
    this.manualEnd,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.musicInfo,
    this.shareUrl,
    this.sameData,
  });

  factory MusicData.fromJson(Map<String, dynamic> json) {
    return MusicData(
      id: json['id'] as int?,
      type: json['type'] as int?,
      mode: json['mode'] as int?,
      userId: json['user_id'] as int?,
      taskId: json['task_id'] as String?,
      name: json['name'] as String?,
      lyrics: json['lyrics'] as String?,
      prompt: json['prompt'] as String?,
      describe: json['describe'] as String?,
      timbreId: json['timbre_id'] as int?,
      coverUrl: json['cover_url'] ?? "",
      musicAuthor: json['music_author'] ?? "",
      wordAuthor: json['word_author'] as String?,
      songAuthor: json['song_author'] as String?,
      isShare: json['is_share'] as int?,
      status: json['status'] as int?,
      audioUrl: json['audio_url'] as String?,
      musicUrl: json['music_url'] as String?,
      musicWavUrl: json['music_wav_url'] as String?,
      musicVoiceUrl: json['music_voice_url'] as String?,
      musicBackUrl: json['music_back_url'] as String?,
      musicMidiUrl: json['music_midi_url'] as String?,
      musicScoreUrl: json['music_score_url'] as String?,
      sharePlatform: json['share_platform'] as List<dynamic>?,
      integral: json['integral'] as int?,
      manualEnd: json['manual_end'] as int?,
      deletedAt: json['deleted_at'],
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      musicInfo: json['music_info'] == null
          ? null
          : MusicInfo.fromJson(json['music_info'] as Map<String, dynamic>),
      shareUrl: json["share_url"],
      sameData: SameData.fromJson(
        json: json["same_data"],
      ),
    );
  }
}

class ReqData {
  final bool? isPure;
  final String? prompt;

  ReqData({
    this.isPure,
    this.prompt,
  });

  factory ReqData.fromJson(Map<String, dynamic> json) {
    return ReqData(
      isPure: json['isPure'] as bool?,
      prompt: json['prompt'] as String?,
    );
  }
}

class MusicInfo {
  final List<Stream>? streams;
  final Format? format;

  MusicInfo({
    this.streams,
    this.format,
  });

  factory MusicInfo.fromJson(Map<String, dynamic> json) {
    return MusicInfo(
      streams: (json['Streams'] as List<dynamic>?)
          ?.map((e) => Stream.fromJson(e as Map<String, dynamic>))
          .toList(),
      format: json['Format'] == null
          ? null
          : Format.fromJson(json['Format'] as Map<String, dynamic>),
    );
  }
}

class Format {
  final String? duration;
  final String? size;
  final String? bitRate;

  Format({
    this.duration,
    this.size,
    this.bitRate,
  });

  factory Format.fromJson(Map<String, dynamic> json) {
    return Format(
      duration: json['duration'] as String?,
      size: json['size'] as String?,
      bitRate: json['bit_rate'] as String?,
    );
  }
}

class Stream {
  final String? codecName;
  final String? codecType;
  final int? width;
  final int? height;
  final String? pixFmt;
  final String? duration;

  Stream({
    this.codecName,
    this.codecType,
    this.width,
    this.height,
    this.pixFmt,
    this.duration,
  });

  factory Stream.fromJson(Map<String, dynamic> json) {
    return Stream(
      codecName: json['codec_name'] as String?,
      codecType: json['codec_type'] as String?,
      width: json['width'] as int?,
      height: json['height'] as int?,
      pixFmt: json['pix_fmt'] as String?,
      duration: json['duration'] as String?,
    );
  }
}

class SameData {
  final String? prompt;
  final Map<String, dynamic>? options;
  final bool? instrumentalMode;
  final String? reversePrompt;

  const SameData({
    required this.prompt,
    this.options,
    required this.instrumentalMode,
    required this.reversePrompt,
  });

  factory SameData.fromJson({required dynamic json}) {
    return SameData(
      prompt: json["prompt"],
      instrumentalMode: json["instrumental_mode"],
      reversePrompt: json["reverse_prompt"],
      options: json["options"],
    );
  }
}
