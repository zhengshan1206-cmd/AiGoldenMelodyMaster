

class MasterMusicAnalysisResponse {
  final int status;
  final String message;
  final MusicAnalysisData? data;

  MasterMusicAnalysisResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory MasterMusicAnalysisResponse.fromJson(Map<String, dynamic> json) {
    return MasterMusicAnalysisResponse(
      status: json['status'] as int,
      message: json['message'] as String,
      data: json['data'] != null
          ? MusicAnalysisData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }
}

class MusicAnalysisData {
  final int? id;
  final int? status;
  final String? taskId;
  final String? aiTaskId;
  final String? aiTaskKey;
  final int? aiTaskType;
  final String? aiTaskName;
  final MusicContentData? data;
  final List<MusicSection>? parse;

  MusicAnalysisData({
    this.id,
    this.status,
    this.taskId,
    this.aiTaskId,
    this.aiTaskKey,
    this.aiTaskType,
    this.aiTaskName,
    this.data,
    this.parse,
  });

  factory MusicAnalysisData.fromJson(Map<String, dynamic> json) {
    return MusicAnalysisData(
      id: json['id'] as int?,
      status: json['status'] as int?,
      taskId: json['task_id'] as String?,
      aiTaskId: json['ai_task_id'] as String?,
      aiTaskKey: json['ai_task_key'] as String?,
      aiTaskType: json['ai_task_type'] as int?,
      aiTaskName: json['ai_task_name'] as String?,
      data: json['data'] != null
          ? MusicContentData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
      parse: json['parse'] != null
          ? (json['parse'] as List<dynamic>?)
          ?.map((e) => MusicSection.fromJson(e as Map<String, dynamic>))
          .toList()
          : null,
    );
  }
}

class MusicContentData {
  final String? title;
  final String? prompt;
   String? lyrics;
  // final LanguageAnalysis? langAnalysis;

  MusicContentData({
    this.title,
    this.prompt,
    this.lyrics,
    // this.langAnalysis,
  });

  factory MusicContentData.fromJson(Map<String, dynamic> json) {
    return MusicContentData(
      title: json['title'] as String?,
      prompt: json['prompt'] as String?,
      lyrics: json['lyrics'] as String?,
      // langAnalysis: json['lang_analysis'] != null
      //     ? LanguageAnalysis.fromJson(json['lang_analysis'] as Map<String, dynamic>)
      //     : null,
    );
  }
}

class LanguageAnalysis {
  final String? language;
  final String? content;

  LanguageAnalysis({
    this.language,
    this.content,
  });

  factory LanguageAnalysis.fromJson(Map<String, dynamic> json) {
    return LanguageAnalysis(
      language: json['language'] as String?,
      content: json['content'] as String?,
    );
  }
}

class MusicSection {
  final String? type;
  final String? title;
  final String? content;

  MusicSection({
    this.type,
    this.title,
    this.content,
  });

  factory MusicSection.fromJson(Map<String, dynamic> json) {
    return MusicSection(
      type: json['type'] as String?,
      title: json['title'] as String?,
      content: json['content'] as String?,
    );
  }
}

/// 歌词解析工具类
class LyricsParser {
  static List<MusicSection> parse(String rawLyrics) {
    final sections = <MusicSection>[];
    final lines = rawLyrics.split('\n');

    String? currentType;
    StringBuffer contentBuffer = StringBuffer();

    for (var line in lines) {
      line = line.trim();

      /// 检测新的段落标记
      if (line.startsWith('[') && line.endsWith(']')) {
        /// 如果已有内容，先添加当前段落
        if (contentBuffer.isNotEmpty && currentType != null) {
          sections.add(MusicSection(
            type: currentType,
            content: contentBuffer.toString().trim(),
              title: getTitle(type: currentType),
          ));
          contentBuffer.clear();
        }

        /// 提取新的段落类型
        currentType = line.substring(1, line.length - 1);
      }
      /// 处理段落内容
      else if (currentType != null && line.isNotEmpty) {
        contentBuffer.write('$line\n');
      }
    }

    /// 添加最后一个段落
    if (contentBuffer.isNotEmpty && currentType != null) {
      sections.add(MusicSection(
        type: currentType,
        content: contentBuffer.toString().trim(),
        title: getTitle(type: currentType)
      ));
    }

    return sections;
  }


 static String? getTitle({required String type}){
    if(type=="intro"){
      return "前奏";
    }else if(type=="verse"){
      return "主歌";
    }else if(type=="chorus"){
      return "副歌";
    }else if(type=="bridge"){
      return "桥段";
    }else if(type=="outro"){
      return "尾奏";
    }
    return "";
  }
}

