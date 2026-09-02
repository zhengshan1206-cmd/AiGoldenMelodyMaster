///一些静态配置信息
class Consts {
  static const kSystemAndroid = "android";
  static const kSystemIOS = "ios";

  /// 启动时，用户协议是否已同意
  static const kAgreementChecked = "kAgreementChecked";
  static const kOralMuted = "kOralMuted";
  static const kUpgradeDialogShown = "kUpgradeDialogShown";

  /// 启动时，用户是否已经过引导页
  static const kLaunchGuideCheck = 'kLaunchGuideCheck';

  /// 混剪引导页是否已弹出
  static const kGuidClipVoiceHasShown = "kGuidClipVoiceHasShown";

  /// 二创引导页是否已弹出
  static const kGuidRecreateVoiceHasShown = "kGuidRecreateVoiceHasShown";

  static const kVoiceoverSubtitlePage = "kVoiceoverSubtitlePage";
  static const kAddMaterialPage = "kAddMaterialPage";

  /// 添加作品纪录的type
  /// 1视频混剪 2短剧二创 3普通剪辑
  static const kUserWorkLogTypeClip = 1;
  static const kUserWorkLogTypeRecreate = 2;
  static const kUserWorkLogTypeClipNormal = 3;

  static const kConfigValueTypeText = 50;
  static const kConfigValueTypeAppPage = 51;
  static const kConfigValueTypeAppSecondPage = 52;
  static const kConfigValueTypeLink = 53;
  static const kConfigValueTypePicture = 100;

  static const ratiosMap = {
    "1:1": 1 / 1,
    "3:4": 3 / 4,
    "4:3": 4 / 3,
    "16:9": 16 / 9,
    "9:16": 9 / 16,
  };
}
