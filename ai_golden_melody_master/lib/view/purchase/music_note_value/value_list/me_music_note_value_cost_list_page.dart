import 'package:ai_golden_melody_master/view/purchase/music_note_value/value_list/no_data_view.dart';
import 'package:ai_golden_melody_master/view/purchase/music_note_value/value_list/purchase_item_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../../../../model/purchase/integral_record_bean.dart';
import '../../../../utils/assets.dart';
import 'me_music_note_value_list_controller.dart';



///消耗的音符值获取页面
class MeMusicNoteValueCostListPage extends StatefulWidget {
  const MeMusicNoteValueCostListPage({super.key});

  @override
  State<MeMusicNoteValueCostListPage> createState() =>
      _MeMusicNoteValueCostListPageState();
}

class _MeMusicNoteValueCostListPageState
    extends State<MeMusicNoteValueCostListPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    super.build(context);
    return GetBuilder<MeMusicNoteValueListController>(builder: (controller) {
      List<IntegralRecordBean> costRecordBeanList = controller.costRecordBeanList;

      return Column(
        children: [
          Expanded(
            child: SmartRefresher(
              enablePullDown: true,
              enablePullUp: true,
              controller: controller.costRecordBeanController,
              onRefresh: controller.onRefresh,
              onLoading: controller.onLoading,
              child:costRecordBeanList.isEmpty?const NoDataViewPage(
                title: "暂无明细",
                iconPath: Assets.noDataIcon,
              ): ListView(
                padding: EdgeInsets.only(top: 15.w),
                children: [
                  ...controller.costRecordBeanList
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
  bool get wantKeepAlive =>  true;
}
