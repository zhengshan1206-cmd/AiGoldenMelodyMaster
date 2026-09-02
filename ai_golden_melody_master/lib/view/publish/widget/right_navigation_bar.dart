/*
  right_navition_bar.dart
  右上角导航栏组件
  Created by duncy on 25/4/16.
*/
import 'package:ai_golden_melody_master/common/lib/app_common/by_common_utils.dart';
import 'package:ai_golden_melody_master/common/lib/app_common/by_nav_router_utils.dart';
import 'package:ai_golden_melody_master/common/lib/app_ui/video/byhy_video_clip_preview.dart';
import 'package:ai_golden_melody_master/view/publish/beans/guide_pop_beans.dart';
import 'package:ai_golden_melody_master/view/publish/controller/guide_pop_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class RightNavigationBar extends StatefulWidget {
  const RightNavigationBar({
    super.key,
    required this.entranceType,
    this.hasMultipilePage = false,
  });
  //页面入口类型
  //展示位置 1：文生视频，2：图生视频，3：小说推文，4：短剧混剪，5：短剧解说，6：音乐生成，7：小说生成，8：数字人，9：文生图 10：爆文创作 (已废弃)
  final GuideEntranceType entranceType;
  //是否有多页面
  final bool? hasMultipilePage;

  @override
  State<RightNavigationBar> createState() => _RightNavigationBarState();
}

class _RightNavigationBarState extends State<RightNavigationBar> {
  final GuidePopController controller = Get.put(GuidePopController());
  Map<String, GuidePopBean> guidePopBeans = {};

  @override
  void initState() {
    controller.routeName = controller.getRouteName(widget.entranceType);
    addGuideBean();
    super.initState();
  }

  @override
  void didUpdateWidget(RightNavigationBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 当 entranceType 改变时，重新获取数据
    if (oldWidget.entranceType != widget.entranceType) {
      controller.routeName = controller.getRouteName(widget.entranceType);
      addGuideBean();
    }
  }

  //添加攻略弹窗数据
  void addGuideBean() {
    controller.getGuideData(
        type: widget.entranceType,
        onSuccess: (data) {
          if (data.jumpType != null) {
            setState(() {
              guidePopBeans[controller.routeName] = data;
            });
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return _buildRightBar(context);
  }

  //初始化右上角导航栏按钮
  Widget _buildRightBar(BuildContext context) {
    controller.routeName = controller.getRouteName(widget.entranceType);
    //多页面时需要重新获取新的页面数据
    if (guidePopBeans.isEmpty || guidePopBeans[controller.routeName] == null) {
      addGuideBean();
      return SizedBox(width: 28.w);
    }
    GuidePopBean guidePopBean = guidePopBeans[controller.routeName]!;
    //异常数据处理
    if (guidePopBean.jumpType == null) {
      return SizedBox(width: 28.w);
    }
    //判断跳转类型是否是已知的
    if (![1, 3, 4].contains(guidePopBean.jumpType)) {
      return SizedBox(width: 28.w);
    }
    // return Container(
    //   height: 30.h,
    //   margin: EdgeInsets.only(right: 12.w),
    //   child: ByWidgetsUtil.btnWithIcon(
    //     context: context,
    //     iconH: 12.w,
    //     iconW: 12.w,
    //     fontSize: 12.sp,
    //     title: "使用攻略",
    //     borderRadius: 100.w,
    //     padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10.w),
    //     bgColor: ByColorUtil.WhiteColor,
    //     iconPath: "assets/home/icon_strategy.png",
    //     textColor: ByColorUtil.CommonTextColor,
    //     onClick: () {
    //       _routerPush(guidePopBean, context);
    //     },
    //   ),
    // );

    return InkResponse(
      onTap: () {
        _routerPush(guidePopBean, context);
      },
      child: Container(
        height: 28.h,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(90.w),
        ),
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        alignment: Alignment.center,
        child: Text(
          "使用攻略",
          style: TextStyle(
            color: Colors.white,
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

  ///跳转到不同的页面
  _routerPush(GuidePopBean bean, BuildContext context) {
    ///异常处理
    int? type = bean.jumpType;
    String? url = bean.url;
    if (type == null || url == null) {
      // _showNormalGuidePage(context);
      return;
    }

    /// 1:内部链接 3:视频播放 4:外部网页
    if (type == 3) {
      // 跳转到视频播放页面
      //  Get.to(GuidePopPage(url: url));
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VideoClipPreview(
            url,
          ),
        ),
      );
    } else if (type == 4) {
      // 跳转到外部链接页面
      ByCommonUtils.launchWebURL(url);
    } else if (type == 1) {
      // 跳转到内嵌网页页面
      ByNavRouterUtils.jumpWebViewPage(
        context,
        "",
        url,
        isRisk: false,
      );
    }

    Get.log("攻略类型===> $type");
  }

}
