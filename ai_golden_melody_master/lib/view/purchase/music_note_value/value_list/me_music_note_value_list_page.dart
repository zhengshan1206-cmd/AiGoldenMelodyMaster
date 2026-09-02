import 'package:ai_golden_melody_master/common/lib/app_time/byhy_time_utils.dart';
import 'package:ai_golden_melody_master/utils/assets.dart';
import 'package:ai_golden_melody_master/utils/by_color_utils.dart';
import 'package:ai_golden_melody_master/view/purchase/music_note_value/value_list/me_music_note_value_all_list_page.dart';
import 'package:ai_golden_melody_master/view/purchase/music_note_value/value_list/me_music_note_value_get_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import '../../../../model/purchase/integral_record_bean.dart';
import '../../../lanuch_page/launch_controller.dart';
import 'me_music_note_value_cost_list_page.dart';
import 'me_music_note_value_list_controller.dart';

///音符值明细页面
class MeMusicNoteValueListPage extends StatefulWidget {
  const MeMusicNoteValueListPage({super.key});

  @override
  State<MeMusicNoteValueListPage> createState() =>
      _MeMusicNoteValueListPageState();
}

class _MeMusicNoteValueListPageState extends State<MeMusicNoteValueListPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int currentTabIndex = 0;
  List<Widget> tabBarPages = [
    const MeMusicNoteValueAllListPage(),
    const MeMusicNoteValueGetListPage(),
    const MeMusicNoteValueCostListPage(),
  ];

  ///tab
  Widget _tabBarView({
    required MeMusicNoteValueListController controller,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0XFF2E2E2E),
        borderRadius: BorderRadius.circular(12.w),
      ),
      margin: EdgeInsets.only(
        left: 12.w,
        right: 12.w,
      ),
      height: 50.w,
      child: Row(
        children: [
          ...controller.modelList.map((e) => _tabBarItemView(
                text: e.text,
                type: e.type,
                selectedType: controller.selectedType,
                click: () {
                  currentTabIndex = e.type;
                  _tabController.animateTo(currentTabIndex);
                  controller.selectedTypeEvent(
                    type: e.type,
                  );
                  if (mounted) {
                    setState(() {});
                  }
                },
              ))
        ],
      ),
    );
  }

  Widget _tabBarItemView({
    required String text,
    required int type,
    required int selectedType,
    required VoidCallback click,
  }) {
    return InkResponse(
      onTap: () {
        click();
      },
      child: Container(
        height: 46.w,
        width: (1.sw - 24.w) / 3,
        decoration: BoxDecoration(
          color: type == selectedType
              ? ByColorUtil.color00CB64
              : Colors.transparent,
          borderRadius: BorderRadius.circular(
            10.w,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16.sp,
          ),
        ),
      ),
    );
  }

  ///无数据页面
  Widget _noDataView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          Assets.noPurchaseDataIcon,
          width: 120.w,
          height: 120.w,
        ),
        Text(
          "暂无明细",
          style: TextStyle(
            color: Colors.white.withOpacity(0.5),
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        )
      ],
    );
  }


  @override
  void initState() {
    _tabController = TabController(
      length: 3,
      vsync: this,
      animationDuration: const Duration(milliseconds: 100),
    );
    super.initState();
  }

  @override
  void dispose() {
    Get.find<LaunchController>().reloadUserInfo();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ByColorUtil.color121212,
      appBar: AppBar(
        backgroundColor: ByColorUtil.color121212,
        title: Text(
          "音符值明细",
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: GetBuilder<MeMusicNoteValueListController>(
        builder: (controller) {
          return Column(
            children: [
              _tabBarView(controller: controller),
              Expanded(
                  child: TabBarView(
                controller: _tabController,
                physics: const NeverScrollableScrollPhysics(),
                children: tabBarPages,
              ))
            ],
          );
        },
      ),
    );
  }
}
