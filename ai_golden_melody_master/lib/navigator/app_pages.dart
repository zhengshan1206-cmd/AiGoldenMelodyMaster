import 'package:ai_golden_melody_master/binding/app_binding.dart';
import 'package:ai_golden_melody_master/binding/guide_page_binding.dart';
import 'package:ai_golden_melody_master/view/ai/ai_play_music/ai_play_music_page.dart';
import 'package:ai_golden_melody_master/view/lanuch_page/guide_page.dart';
import 'package:ai_golden_melody_master/view/main/main_binding.dart';
import 'package:ai_golden_melody_master/view/main/main_page.dart';
import 'package:ai_golden_melody_master/view/me_center/my_work/my_work_binding.dart';
import 'package:ai_golden_melody_master/view/me_center/my_work/my_work_page.dart';
import 'package:ai_golden_melody_master/view/me_center/setting/setting_binding.dart';
import 'package:ai_golden_melody_master/view/me_center/setting/setting_page.dart';
import 'package:ai_golden_melody_master/view/me_center/user_profile/user_profile_binding.dart';
import 'package:ai_golden_melody_master/view/me_center/user_profile/user_profile_page.dart';
import 'package:ai_golden_melody_master/view/publish/binding/publish_binding.dart';
import 'package:ai_golden_melody_master/view/publish/binding/purchase_ranking_binding.dart';
import 'package:ai_golden_melody_master/view/publish/binding/strategy_binding.dart';
import 'package:ai_golden_melody_master/view/publish/binding/strategy_details_binding.dart';
import 'package:ai_golden_melody_master/view/publish/binding/strategy_zone_binding.dart';
import 'package:ai_golden_melody_master/view/publish/publish_page.dart';
import 'package:ai_golden_melody_master/view/publish/purchase_ranking_page.dart';
import 'package:ai_golden_melody_master/view/publish/strategy/strategy_details_page.dart';
import 'package:ai_golden_melody_master/view/publish/strategy/strategy_page.dart';
import 'package:ai_golden_melody_master/view/publish/strategy/strategy_zone_page.dart';
import 'package:ai_golden_melody_master/view/purchase/music_note_value/me_music_note_value_binding.dart';
import 'package:ai_golden_melody_master/view/purchase/music_note_value/me_music_note_value_page.dart';
import 'package:ai_golden_melody_master/view/purchase/music_note_value/value_list/me_music_note_value_list_binding.dart';
import 'package:ai_golden_melody_master/view/purchase/music_note_value/value_list/me_music_note_value_list_page.dart';
import 'package:ai_golden_melody_master/view/purchase/vip/vip_purchase_binding.dart';
import 'package:ai_golden_melody_master/view/purchase/vip/vip_purchase_page.dart';
import 'package:ai_golden_melody_master/view/purchase/vip/vip_rights/vip_rights_binding.dart';
import 'package:ai_golden_melody_master/view/purchase/vip/vip_rights/vip_rights_page.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

import '../view/ai/ai_play_music/ai_play_music_binding.dart';
import '../view/lanuch_page/launch_page.dart';
import '../view/network_error/launch_error_binding.dart';
import '../view/network_error/launch_error_page.dart';
import '../view/share_sales/friend_invite_code_page/friend_invite_code_binding.dart';
import '../view/share_sales/friend_invite_code_page/friend_invite_code_page.dart';
import '../view/share_sales/profit_list_view/profit_list_binding.dart';
import '../view/share_sales/profit_list_view/profit_list_view.dart';
import '../view/share_sales/reward/reward_binding.dart';
import '../view/share_sales/reward/reward_page.dart';
import '../view/share_sales/share_sales_binding.dart';
import '../view/share_sales/share_sales_page.dart';
part 'router_util.dart';

class AppPages {
  AppPages._();
  static final List<GetPage> routes = [
    ///首页 主导航页面
    GetPage(
      name: _Paths.main,
      page: () => const MainPage(),
      binding: MainBinding(),
    ),

    ///设置页面
    GetPage(
      name: _Paths.settingPage,
      page: () => const SettingPage(),
      binding: SettingBinding(),
    ),

    ///我的音符值页面
    GetPage(
      name: _Paths.meMusicNoteValuePage,
      page: () => const MeMusicNoteValuePage(),
      binding: MeMusicNoteValueBinding(),
    ),

    ///我的音符值详细页面
    GetPage(
      name: _Paths.meMusicNoteValueListPage,
      page: () => const MeMusicNoteValueListPage(),
      binding: MeMusicNoteValueListBinding(),
    ),

    ///vip购买页面
    GetPage(
      name: _Paths.vipPurchasePage,
      page: () => const VipPurchasePage(),
      binding: VipPurchaseBinding(),
    ),

    ///发行页面
    GetPage(
      name: _Paths.publishPage,
      page: () => PublishPage(),
      binding: PublishBinding(),
    ),

    ///发行页面-排行榜
    GetPage(
      name: _Paths.purchaseRankingPage,
      page: () => PurchaseRankingPage(),
      binding: PurchaseRankingBinding(),
    ),

    ///发行页面-教程主页
    GetPage(
      name: _Paths.strategyPage,
      page: () => StrategyPage(),
      binding: StrategyBinding(),
    ),

    ///发行页面-教程详情
    GetPage(
      name: _Paths.strategyDetailsPage,
      page: () => StrategyDetailsPage(),
      binding: StrategyDetailsBinding(),
    ),

    ///发行页面-攻略专区
    GetPage(
      name: _Paths.strategyZonePage,
      page: () => StrategyZonePage(),
      binding: StrategyZoneBinding(),
    ),

    ///vip权益页面
    GetPage(
      name: _Paths.vipRightsPage,
      page: () => const VipRightsPage(),
      binding: VipRightsBinding(),
    ),

    ///启动页面
    GetPage(
      name: _Paths.launch,
      page: () => const LaunchPage(),
      binding: AppBinding(),
    ),

    ///用户个人信息页面
    GetPage(
      name: _Paths.userProfile,
      page: () => const UserProfilePage(),
      binding: UserProfileBinding(),
    ),

    ///我的作品
    GetPage(
      name: _Paths.myWorkPage,
      page: () => const MyWorkPage(),
      binding: MyWorkBinding(),
    ),

    ///音乐播放
    GetPage(
      name: _Paths.aiPlayMusicPage,
      page: () =>  AiPlayMusicPage(),
      binding: AiPlayMusicBinding(),
    ),

    ///引导页
    GetPage(
      name: _Paths.guidePage,
      page: () => GuidePage(),
      binding: GuidePageBinding(),
    ),

    ///引导页
    GetPage(
      name: _Paths.launchFaildPage,
      page: () => LaunchErrorPage(),
      binding: LaunchErrorBinding(),
    ),

    ///邀请码填写页面
    GetPage(
        name: Routes.inviteFriendCodePage,
        page: () => const FriendInviteCodePage(),
        binding: FriendInviteCodeBinding()),

    ///分享赚钱
    GetPage(
        name: Routes.shareSales,
        page: () => const ShareSalesPage(),
        binding: ShareSalesBinding()),

    ///收益明细
    GetPage(
        name: Routes.profitPage,
        page: () => const ProfitListView(),
        binding: ProfitListBinding()),

    ///奖励页面
    GetPage(
        name: Routes.rewardPage,
        page: () => const RewardPage(),
        binding: RewardBinding()),
  ];
}
