import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../../../model/ai_music/my_works_data_model.dart';
import '../../../utils/assets.dart';
import '../../purchase/music_note_value/value_list/no_data_view.dart';
import 'my_work_controller.dart';
import 'my_work_item_view.dart';

class CompletedMyWorkPage extends StatefulWidget {
  const CompletedMyWorkPage({super.key});

  @override
  State<CompletedMyWorkPage> createState() => _CompletedMyWorkPageState();
}

class _CompletedMyWorkPageState extends State<CompletedMyWorkPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GetBuilder<MyWorkController>(
      builder: (controller) {
        List<MyWorksMusicItem> completedMusicDataList =
            controller.completedMusicDataList;
        return Column(
          children: [
            Expanded(
              child: SmartRefresher(
                ///动态控制是否允许下拉刷新：加载中时禁止下拉
                enablePullDown: !controller.isLoading,
                ///动态控制是否允许上拉加载：刷新中时禁止上拉
                enablePullUp:  !controller.isRefreshing,
                controller: controller.completedMusicDataController,
                onRefresh: controller.onRefresh,
                onLoading: controller.onLoading,
                child: completedMusicDataList.isEmpty
                    ? const NoDataViewPage(
                        title: "暂无作品记录",
                        iconPath: Assets.noDataIcon,
                      )
                    : ListView(
                  padding: EdgeInsets.only(top: 7.w,bottom: 100.w),
                  children: [
                          ...completedMusicDataList
                              .map((e) => MyWorkItemView(musicItem: e,type: 1,)),
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
