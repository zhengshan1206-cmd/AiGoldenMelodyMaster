import 'package:ai_golden_melody_master/view/purchase/music_note_value/value_list/purchase_item_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../../../../model/purchase/integral_record_bean.dart';
import '../../../../utils/assets.dart';
import 'me_music_note_value_list_controller.dart';
import 'no_data_view.dart';

///获取的音符值获取页面
class MeMusicNoteValueGetListPage extends StatefulWidget {
  const MeMusicNoteValueGetListPage({super.key});

  @override
  State<MeMusicNoteValueGetListPage> createState() =>
      _MeMusicNoteValueGetListPageState();
}

class _MeMusicNoteValueGetListPageState
    extends State<MeMusicNoteValueGetListPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GetBuilder<MeMusicNoteValueListController>(builder: (controller) {
      List<IntegralRecordBean> getRecordBeanList = controller.getRecordBeanList;

      return Column(
        children: [
          Expanded(
            child: SmartRefresher(
              enablePullDown: true,
              enablePullUp: true,
              controller: controller.getRecordBeanController,
              onRefresh: controller.onRefresh,
              onLoading: controller.onLoading,
              child:getRecordBeanList.isEmpty?const NoDataViewPage(
                title: "暂无明细",
                iconPath: Assets.noDataIcon,
              ): ListView(
                padding: EdgeInsets.only(top: 15.w),
                children: [
                  ...controller.getRecordBeanList
                      .map((e) => PurchaseItemView(integralRecordBean: e)),
                ],
              ),
            ),
          )
        ],
      );
    });
  }

  @override
  bool get wantKeepAlive => true;
}
