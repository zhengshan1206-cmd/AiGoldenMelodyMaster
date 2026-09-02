import 'package:ai_golden_melody_master/common/lib/app_common/by_common_utils.dart';
import 'package:ai_golden_melody_master/view/me_center/my_work/my_work_controller.dart';
import 'package:ai_golden_melody_master/view/publish/widget/banner_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../utils/assets.dart';
import '../../../utils/by_color_utils.dart';
import '../../lanuch_page/launch_controller.dart';
import 'all_my_work_page.dart';
import 'completed_my_work_page.dart';
import 'failure_my_work_page.dart';
import 'generating_my_work_page.dart';

class MyWorkPage extends StatefulWidget {
  const MyWorkPage({super.key});

  @override
  State<MyWorkPage> createState() => _MyWorkPageState();
}

class _MyWorkPageState extends State<MyWorkPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  int currentTabIndex = 0;
  List<Widget> tabBarPages = [
    const AllMyWorkPage(),
    const CompletedMyWorkPage(),
    const GeneratingMyWorkPage(),
    const FailureMyWorkPage(),
  ];

  ///tab
  Widget _tabBarView({
    required MyWorkController controller,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0XFF2E2E2E),
        borderRadius: BorderRadius.circular(12.w),
      ),
      margin: EdgeInsets.only(left: 12.w, right: 10.w),
      padding: EdgeInsets.all(3.w),
      height: 50.w,
      child: Row(
        children: [
          ...controller.modelList.map((e) => _tabBarItemView(
                text: e.text,
                type: e.type,
                selectedType: controller.selectedType,
                click: () {
                 ByCommonUtils.throttle((){
                   if (controller.isLoadingData||controller.isRefreshing||controller.isLoading) {
                     EasyLoading.showToast("正在加载数据，请勿过快点击～");
                     return;
                   }

                   currentTabIndex = e.type;
                   _tabController.animateTo(currentTabIndex);
                   controller.selectedTypeEvent(
                     type: e.type,
                   );
                   if (mounted) {
                     setState(() {});
                   }
                 },delay: 250,);
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
        // ByCommonUtils.throttle(click,3);
        click();
      },
      child: Container(
        height: 46.w,
        width: (1.sw - 32.w) / 4,
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

  ///banner
  Widget _bannerView() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: const BannerWidget(
        height: 80.0,
        position: 201,
        topMargin: 12,
        bottomMargin: 10,
      ),
    );
  }

  @override
  void initState() {
    _tabController = TabController(
      length: 4,
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
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;
        // controller.goBack();
      },
      child: Scaffold(
        backgroundColor: ByColorUtil.color121212,
        // appBar: AppBar(
        //   backgroundColor: ByColorUtil.color121212,
        //   title: Text(
        //     "我的作品",
        //     style: TextStyle(
        //       fontSize: 16.sp,
        //       fontWeight: FontWeight.bold,
        //       color: Colors.white,
        //     ),
        //   ),
        //   leading: SizedBox(
        //     width: 10.w,
        //     height: 10.w,
        //     child: Image.asset(
        //       Assets.goBack,
        //       width: 5.w,
        //       height: 5.w,
        //       fit: BoxFit.fitHeight,
        //       color: Colors.red,
        //     ),
        //   )
        // ),
        body: GetBuilder<MyWorkController>(
          builder: (controller) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 55.w,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 16.w,
                    ),
                    InkResponse(
                      onTap: () {
                        // Get.back();
                        controller.showPayDialog();
                      },
                      child: SizedBox(
                        width: 20.w,
                        height: 20.w,
                        child: Image.asset(
                          Assets.goBack,
                          width: 20.w,
                          height: 20.w,
                          fit: BoxFit.fitHeight,
                          // color: Colors.red,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 120.w,
                    ),
                    Text(
                      "我的作品",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15.w,
                ),
                _tabBarView(
                  controller: controller,
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 7.w,
                    left: 13.w,
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        Assets.icon12,
                        width: 12.w,
                        height: 12.w,
                      ),
                      SizedBox(
                        width: 2.w,
                      ),
                      Text(
                        "音乐内容由AI生成，禁止利用功能从事违法活动。",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      )
                    ],
                  ),
                ),
                _bannerView(),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: tabBarPages,
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
