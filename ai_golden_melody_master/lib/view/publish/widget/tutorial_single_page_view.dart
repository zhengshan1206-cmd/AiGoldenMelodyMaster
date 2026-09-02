import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ai_golden_melody_master/view/common/tutorial/tutorial_mixin.dart';
import 'package:ai_golden_melody_master/view/publish/widget/strategy_item_view.dart';
import 'package:ai_golden_melody_master/navigator/app_pages.dart';

/// 单个教程tab页面视图
class TutorialSinglePageView extends StatefulWidget {
  const TutorialSinglePageView({
    super.key,
    required this.tabIndex,
    required this.controller,
  });

  final int tabIndex;
  final GetxController controller;

  @override
  State<TutorialSinglePageView> createState() => _TutorialSinglePageViewState();
}

class _TutorialSinglePageViewState extends State<TutorialSinglePageView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    // 如果该tab还没有数据，则加载数据
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (_getTutorialMixin().getTutorialData(widget.tabIndex).isEmpty) {
        _getTutorialMixin().loadTutorialData(widget.tabIndex);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  TutorialMixin _getTutorialMixin() {
    return widget.controller as TutorialMixin;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Obx(
      () {
        final dataList = _getTutorialMixin().getTutorialData(widget.tabIndex);

        if (dataList.isEmpty) {
          return SizedBox(
            height: 1.h,
          );
        }

        // 使用ListView来更好地处理滚动和高度，自动撑高
        return Container(
          // 确保有足够的最小高度来支撑tab
          constraints: BoxConstraints(
            minHeight: 1.sh,
          ),
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(), // 禁用滚动，避免与PageView冲突
            itemCount: dataList.length,
            itemBuilder: (context, index) {
              final item = dataList[index];
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 2.5.h),
                child: StrategyItemView(
                  item: item,
                  onTap: () {
                    final tutorialMixin = _getTutorialMixin();
                    final tabs = tutorialMixin.tutorialTabs.value;
                    final selectedTab = tutorialMixin.selectedTutorialTab.value;

                    if (tabs.isNotEmpty && selectedTab < tabs.length) {
                      final groupId = tabs[selectedTab].id;
                      Get.toNamed(Routes.strategyDetailsPage, arguments: {
                        "id": item.id,
                        "type": "ai_music_app_guide_guide",
                        "groupId": groupId,
                      });
                    }
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}
