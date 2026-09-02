import 'package:ai_golden_melody_master/utils/by_color_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../model/ai_music/my_works_data_model.dart';
import 'ai_edit_music_cover_page.dart';
import 'edit_music_cover_controller.dart';
import 'local_upload_image.dart';

///修改音乐封面
class EditMusicCoverPage extends StatefulWidget {
  final MyWorksMusicItem musicItem;

  const EditMusicCoverPage({
    super.key,
    required this.musicItem,
  });

  @override
  State<EditMusicCoverPage> createState() => _EditMusicCoverPageState();
}

class _EditMusicCoverPageState extends State<EditMusicCoverPage>  with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int currentTabIndex = 0;


  List<Widget> tabBarPages = [
    const AiEditMusicCoverPage(),
    const LocalUploadImage(),
  ];


  ///选择切换弹窗
  Widget _tabSelectView({
    required EditMusicCoverController controller,
  }) {
    return Container(
      width: 1.sw,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12.w),
      ),
      padding: EdgeInsets.all(3.w),
      height: 55.w,
      child: Row(
        children: [
          ...controller.tabModeList.map(
            (e) => _selectTabItemView(
              tabModel: e,
              selectedType: controller.selectedTabIndex,
              controller: controller,
            ),
          ),
        ],
      ),
    );
  }

  ///选择弹窗
  Widget _selectTabItemView({
    required EditMusicCoverTabModel tabModel,
    int selectedType = 0,
    required EditMusicCoverController controller,
  }) {
    bool selected = false;
    if (tabModel.type == selectedType) {
      selected = true;
    }

    return Expanded(
        child: InkResponse(
      onTap: () {
        // controller.updateSelectedTabIndex(tabIndex: tabModel.type);
        // if (mounted) {
        //   setState(() {});
        // }

        currentTabIndex = tabModel.type;
        _tabController.animateTo(currentTabIndex);
        controller.updateSelectedTabIndex(tabIndex: tabModel.type);
        if (mounted) {
          setState(() {});
        }


      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.w),
          color: selected ? ByColorUtil.color00CB64 : Colors.transparent,
        ),
        padding: EdgeInsets.only(
          top: 14.w,
          bottom: 14.w,
        ),
        alignment: Alignment.center,
        child: Text(
          tabModel.name,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ));
  }


  @override
  void initState() {
    _tabController = TabController(
      length: 2,
      vsync: this,
      animationDuration: const Duration(milliseconds: 100),
    );
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    Get.find<EditMusicCoverController>().selectedTabIndex = 0;
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 0.78.sh,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12.w),
            topRight: Radius.circular(12.w),
          ),
          color: ByColorUtil.color2e2e2e,
        ),
        padding: EdgeInsets.only(
          top: 20.w,
          left: 12.w,
          right: 12.w,
        ),
        child: GetBuilder<EditMusicCoverController>(
          builder: (controller) {
            return Column(
              children: [
                ///修改封面
                Row(
                  children: [
                    Text(
                      "修改封面",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Icon(
                        Icons.close,
                        size: 24.w,
                        color: Colors.grey.withOpacity(0.3),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 18.w,
                ),

                ///
                _tabSelectView(
                  controller: controller,
                ),
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



