class AppConfig {
  final int status;
  final String message;
  final AppConfigData? data;

  AppConfig({
    required this.status,
    required this.message,
    this.data,
  });

  factory AppConfig.fromJson(Map<String, dynamic> json) {
    return AppConfig(
      status: json['status'] as int,
      message: json['message'] as String,
      data: json['data'] != null
          ? AppConfigData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }
}

class AppConfigData {
  final BgImg? bgImg;
  final Agreement? agreement;
  final String? customerService;
  final String? customerPhone;
  final String? algorithmFiling;
  final String? icpFiling;
  final String? integralBuyNotice;
  final String? complaints;

  ///分享的平台
  final List<SharingPlatform>? sharingPlatform;

  AppConfigData({
    this.bgImg,
    this.agreement,
    this.customerService,
    this.customerPhone,
    this.algorithmFiling,
    this.icpFiling,
    this.integralBuyNotice,
    this.complaints,
    this.sharingPlatform,
  });

  factory AppConfigData.fromJson(Map<String, dynamic> json) {
    return AppConfigData(
        bgImg: json['bgImg'] != null
            ? BgImg.fromJson(json['bgImg'] as Map<String, dynamic>)
            : null,
        agreement: json['agreement'] != null
            ? Agreement.fromJson(json['agreement'] as Map<String, dynamic>)
            : null,
        customerService: json['customerService'] as String?,
        customerPhone: json['customerPhone']?.toString(),
        algorithmFiling: json['algorithmFiling'] as String?,
        icpFiling: json['icpFiling'] as String?,
        integralBuyNotice: json['integralBuyNotice'] as String?,
        complaints: json['complaints'] as String?,
        sharingPlatform: parseSharingPlatforms(json["sharingPlatform"] ?? []));
  }
}

class BgImg {
  final String? home;
  final String? rank;
  final My? my;
  final String? login;
  final String? guide;
  final String? pay;

  BgImg({
    this.home,
    this.rank,
    this.my,
    this.login,
    this.guide,
    this.pay,
  });

  factory BgImg.fromJson(Map<String, dynamic> json) {
    return BgImg(
      home: json['home'] as String?,
      rank: json['rank'] as String?,
      my: json['my'] != null
          ? My.fromJson(json['my'] as Map<String, dynamic>)
          : null,
      login: json['login'] as String?,
      guide: json['guide'] as String?,
      pay: json['pay'] as String?,
    );
  }
}

class My {
  final String? noVip;
  final String? yesVip;

  My({
    this.noVip,
    this.yesVip,
  });

  factory My.fromJson(Map<String, dynamic> json) {
    return My(
      noVip: json['noVip'] as String?,
      yesVip: json['yesVip'] as String?,
    );
  }
}

class Agreement {
  final String? integral;
  final String? userVip;
  final String? subscribeVip;
  final String? privacy;
  final String? protocol;
  final String? aboutUs;
  final String? algorithm;
  final String? soundProtocol;

  Agreement({
    this.integral,
    this.userVip,
    this.subscribeVip,
    this.privacy,
    this.protocol,
    this.aboutUs,
    this.algorithm,
    this.soundProtocol,
  });

  factory Agreement.fromJson(Map<String, dynamic> json) {
    return Agreement(
      integral: json['integral'] as String?,
      userVip: json['userVip'] as String?,
      subscribeVip: json['subscribeVip'] as String?,
      privacy: json['privacy'] as String?,
      protocol: json['protocol'] as String?,
      aboutUs: json['aboutUs'] as String?,
      algorithm: json["algorithm"] as String?,
      soundProtocol: json["soundProtocol"] as String?,
    );
  }
}

class SharingPlatform {
  final int id;
  final String title;
  final String icon;

  const SharingPlatform({
    required this.id,
    required this.title,
    required this.icon,
  });

  /// 工厂方法，用于从JSON数据创建SharingPlatform对象
  factory SharingPlatform.fromJson(Map<String, dynamic> json) {
    return SharingPlatform(
      id: json['id'] as int,
      title: json['title'] as String,
      icon: json['icon'] as String,
    );
  }

  /// 将SharingPlatform对象转换为JSON格式
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'icon': icon,
    };
  }
}

/// 用于解析包含多个SharingPlatform对象的列表

List<SharingPlatform> parseSharingPlatforms(List<dynamic> jsonList) {
  return jsonList.map((json) => SharingPlatform.fromJson(json)).toList();
}
