import 'package:ai_golden_melody_master/utils/assets.dart';
import 'package:ai_golden_melody_master/view/purchase/music_note_value/value_list/no_data_view.dart';
import 'package:ai_golden_melody_master/view/purchase/music_note_value/value_list/purchase_item_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../../../../model/purchase/integral_record_bean.dart';
import 'me_music_note_value_list_controller.dart';

///所有的音符值获取页面
class MeMusicNoteValueAllListPage extends StatefulWidget {
  const MeMusicNoteValueAllListPage({super.key});

  @override
  State<MeMusicNoteValueAllListPage> createState() =>
      _MeMusicNoteValueAllListPageState();
}

class _MeMusicNoteValueAllListPageState
    extends State<MeMusicNoteValueAllListPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GetBuilder<MeMusicNoteValueListController>(builder: (controller) {
      List<IntegralRecordBean> allRecordBeanList = controller.allRecordBeanList;

      return Column(
        children: [
          Expanded(
            child: SmartRefresher(
              enablePullDown: true,
              enablePullUp: true,
              controller: controller.allRecordBeanController,
              onRefresh: controller.onRefresh,
              onLoading: controller.onLoading,
              child: allRecordBeanList.isEmpty
                  ? const NoDataViewPage(
                      title: "暂无明细",
                      iconPath: Assets.noDataIcon,
                    )
                  : ListView(
                      padding: EdgeInsets.only(top: 15.w),
                      children: [
                        ...allRecordBeanList.map(
                            (e) => PurchaseItemView(integralRecordBean: e)),
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
