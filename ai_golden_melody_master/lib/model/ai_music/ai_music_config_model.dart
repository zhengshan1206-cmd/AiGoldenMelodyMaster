

///音乐配置数据
class MusicOptionsModel {
  final int? status;
  final String? message;
  final Data? data;

  MusicOptionsModel({
    this.status,
    this.message,
    this.data,
  });

  factory MusicOptionsModel.fromJson(Map<String, dynamic> json) =>
      MusicOptionsModel(
        status: json['status'] as int?,
        message: json['message'] as String?,
        data: json['data'] == null
            ? null
            : Data.fromJson(json['data'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
    'status': status,
    'message': message,
    'data': data?.toJson(),
  };
}

class Data {
  final List<Option>? options;
  final List<Preset>? preset;

  Data({
    this.options,
    this.preset,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    options: (json['options'] as List<dynamic>?)
        ?.map((e) => Option.fromJson(e as Map<String, dynamic>))
        .toList(),
    preset: (json['preset'] as List<dynamic>?)
        ?.map((e) => Preset.fromJson(e as Map<String, dynamic>))
        .toList(),
  );

  Map<String, dynamic> toJson() => {
    'options': options?.map((e) => e.toJson()).toList(),
    'preset': preset?.map((e) => e.toJson()).toList(),
  };
}

class Option {
  final String? en;
  final String? zh;
  final String? type;
  final String? category;
  final bool? instrumentalMode;
  final int? min;
  final int? max;
  final int? defaultVal;
  final List<Item>? items;

  Option({
    this.en,
    this.zh,
    this.type,
    this.category,
    this.instrumentalMode,
    this.min,
    this.max,
    this.defaultVal,
    this.items,
  });

  factory Option.fromJson(Map<String, dynamic> json) => Option(
    en: json['en'] as String?,
    zh: json['zh'] as String?,
    type: json['type'] as String?,
    category: json['category'] as String?,
    instrumentalMode: json['instrumental_mode'] as bool?,
    min: json['min'] as int?,
    max: json['max'] as int?,
    defaultVal: json['default'] as int?,
    items: (json['items'] as List<dynamic>?)
        ?.map((e) => Item.fromJson(e as Map<String, dynamic>))
        .toList(),
  );

  Map<String, dynamic> toJson() => {
    'en': en,
    'zh': zh,
    'type': type,
    'category': category,
    'instrumental_mode': instrumentalMode,
    'min': min,
    'max': max,
    'default': defaultVal,
    'items': items?.map((e) => e.toJson()).toList(),
  };
}

class Item {
  final String? en;
  final String? zh;

  Item({
    this.en,
    this.zh,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    en: json['en'] as String?,
    zh: json['zh'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'en': en,
    'zh': zh,
  };
}

class Preset {
  final String? en;
  final String? zh;
  final String? items;

  Preset({
    this.en,
    this.zh,
    this.items,
  });

  factory Preset.fromJson(Map<String, dynamic> json) => Preset(
    en: json['en'] as String?,
    zh: json['zh'] as String?,
    items: json['items'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'en': en,
    'zh': zh,
    'items': items,
  };
}


///生成一个可以
class OptionModelEx{
  final Option? option;
  final String selectContent;
  final String selectContent2;
  OptionModelEx({this.option,this.selectContent = "",this.selectContent2 = "",});
}