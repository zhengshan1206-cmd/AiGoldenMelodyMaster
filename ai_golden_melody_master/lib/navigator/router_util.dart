part of 'app_pages.dart';

class RouterUtil {
  static String initialRoute() => nextRoute();

  static String nextRoute() {
    return Routes.LAUNCH;
  }
}

abstract class Routes {
  Routes._();

  static const LAUNCH = _Paths.launch;

  static const main = _Paths.main;
  static const userProfile = _Paths.userProfile;

  static const createFolkStoryPage = _Paths.createFolkStoryPage;

  /// 民间故事分步页面
  static const folkStorystepsPage = _Paths.stepsPage;
  static const folkStorystepTwoPage = _Paths.stepTwoPage;
  static const folkStorystepThreePage = _Paths.stepThreePage;
  static const aiCreateCaptionsSetting = _Paths.aiCreateCaptionsSetting;

  static const aiCreatePreviewTextFieldPage =
      _Paths.aiCreatePreviewTextFieldPage;
  static const launchFailed = _Paths.launchFaildPage;
  static const stepsPage = _Paths.stepsPage;
  static const storyManagementPage = _Paths.storyManagementPage;
  static const sliceGeneratePage = _Paths.slicingGeneratePage;

  ///新的短剧创作页面
  static const newShortPlayListPage = _Paths.newShortPlayListPage;

  ///积分页面
  static const integralPage = _Paths.integralPage;

  ///民间故事支付成功
  static const folkStorySuccessPayback = _Paths.folkStorySuccessPayback;

  ///ai动态视频页面
  static const String aiDynamicVideoPage = _Paths.aiDynamicVideoPage;

  ///图片裁剪页面
  static const String imageEditPageForVideo = _Paths.imageEditPageForVideo;

  ///新创作者福利页
  static const String benefitsForCreatorPage = _Paths.benefitsForCreatorPage;

  ///关于我们
  static const String aboutUsPage = _Paths.aboutUsPage;

  ///
  static const String singleShortPlayListPage = _Paths.singleShortPlayListPage;

  ///设置页面
  static const String settingPage = _Paths.settingPage;

  ///我的音符值页面
  static const String meMusicNoteValuePage = _Paths.meMusicNoteValuePage;

  ///我的音符值详细页面
  static const String meMusicNoteValueListPage =
      _Paths.meMusicNoteValueListPage;

  ///vip购买页面
  static const String vipPurchasePage = _Paths.vipPurchasePage;

  ///发行页面-排行榜
  static const String purchaseRankingPage = _Paths.purchaseRankingPage;

  ///发行页面-教程主页
  static const String strategyPage = _Paths.strategyPage;

  ///发行页面-教程详情
  static const String strategyDetailsPage = _Paths.strategyDetailsPage;

  ///发行页面-攻略专区
  static const String strategyZonePage = _Paths.strategyZonePage;
  static const String vipRightsPage = _Paths.vipRightsPage;

  ///我的作品
  static const String myWorkPage = _Paths.myWorkPage;

  static const String aiPlayMusicPage = _Paths.aiPlayMusicPage;

  ///引导页
  static const String guidePage = _Paths.guidePage;

  ///分享赚钱
  static const shareSales = _Paths.shareSales;

  ///收益明细页面
  static const profitPage = _Paths.profitPage;

  ///奖励体现页面
  static const rewardPage = _Paths.rewardPage;

  ///好友邀请页面
  static const inviteFriendCodePage = _Paths.inviteFriendCodePage;
}

abstract class _Paths {
  _Paths._();

  static const launch = '/launch';

  static const main = '/main';

  ///用户个人信息页面
  static const userProfile = '/user_profile';

  static const createFolkStoryPage = '/create_fold_story';

  static const launchFaildPage = '/launch_faild';

  static const stepsPage = "/folk_story_steps_page";

  static const stepTwoPage = "/folk_story_step_two_page";

  static const stepThreePage = "/folk_story_step_three_page";

  static const aiCreateCaptionsSetting = '/ai_create_captions_setting';

  static const aiCreatePreviewTextFieldPage =
      '/ai_create_preview_text_field_page';

  static const storyManagementPage = '/folk_story_management_page';

  static const slicingGeneratePage = '/slicing_Generating_page';

  static const newShortPlayListPage = "/short_play_create";

  ///积分页面
  static const integralPage = '/integral';

  static const folkStorySuccessPayback = '/folk_story_success_payback_page';

  ///ai动态视频页面
  static const String aiDynamicVideoPage = "/ai_dynamic_video_page";

  ///图片裁剪页面
  static const String imageEditPageForVideo = "/image_edit_page";

  ///新创作者专属福利页
  static const String benefitsForCreatorPage = "/benefits_for_creator_page";

  ///关于我们
  static const String aboutUsPage = "/about_us_page";

  static const String singleShortPlayListPage = "/single_short_play_list_page";

  ///设置页面
  static const String settingPage = "/setting_page";

  ///我的音符值页面
  static const String meMusicNoteValuePage = "/me_music_note_value_page";

  ///我的音符值详细页面
  static const String meMusicNoteValueListPage =
      "/me_music_note_value_list_page";

  ///vip购买页面
  static const String vipPurchasePage = "/vip_purchase";

  ///vip权益页面
  static const String vipRightsPage = "/vip_rights";

  ///发行页面
  static const String publishPage = "/publish_page";

  ///发行页面-排行榜
  static const String purchaseRankingPage = "/purchase_ranking_page";

  ///发行页面-教程主页
  static const String strategyPage = "/strategy_page";

  ///发行页面-教程详情
  static const String strategyDetailsPage = "/strategy_details_page";

  ///发行页面-攻略专区
  static const String strategyZonePage = "/strategy_zone_page";

  ///我的作品
  static const String myWorkPage = "/my_work_page";

  ///播放音乐
  static const String aiPlayMusicPage = "/ai_play_music_page";

  ///引导页
  static const String guidePage = "/guide_page";

  ///封面选择弹窗


  ///分享赚钱
  static const shareSales = '/share_sales_page';

  ///收益明细页面
  static const profitPage = "/profit_page";

  ///奖励体现页面
  static const rewardPage = "/reward_page";

  ///好友邀请页面
  static const inviteFriendCodePage = "/invite_friend_code_page";
}
