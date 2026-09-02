import 'package:ai_golden_melody_master/view/purchase/music_note_value/value_list/no_data_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../../../model/ai_music/my_works_data_model.dart';
import '../../../utils/assets.dart';
import 'my_work_controller.dart';
import 'my_work_item_view.dart';

class AllMyWorkPage extends StatefulWidget {
  const AllMyWorkPage({super.key});

  @override
  State<AllMyWorkPage> createState() => _AllMyWorkPageState();
}

class _AllMyWorkPageState extends State<AllMyWorkPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GetBuilder<MyWorkController>(
      builder: (controller) {
        List<MyWorksMusicItem> allMusicDataList = controller.allMusicDataList;

        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: SmartRefresher(
                ///动态控制是否允许下拉刷新：加载中时禁止下拉
                enablePullDown: !controller.isLoading,
                ///动态控制是否允许上拉加载：刷新中时禁止上拉
                enablePullUp:  !controller.isRefreshing,
                controller: controller.allMusicDataController,
                onRefresh: controller.onRefresh,
                onLoading: controller.onLoading,
                child: allMusicDataList.isEmpty
                    ? const NoDataViewPage(
                        title: "暂无作品记录",
                        iconPath: Assets.noDataIcon,
                      )
                    : ListView(
                        padding: EdgeInsets.only(top: 7.w,bottom: 100.w),
                        children: [
                          ...allMusicDataList
                              .map((e) => MyWorkItemView(musicItem: e,type: e.status==1?0:3,)),
                        ],
                      ),
              ),
            )
          ],
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
