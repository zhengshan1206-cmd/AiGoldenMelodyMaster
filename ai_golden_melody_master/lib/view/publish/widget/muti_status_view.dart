import 'package:ai_golden_melody_master/common/lib/app_ui/by_widgets_util.dart';
import 'package:ai_golden_melody_master/view/publish/illegal_words/view/by_button.dart';
import 'package:ai_golden_melody_master/view/publish/illegal_words/view/colors.dart';
import 'package:ai_golden_melody_master/view/publish/illegal_words/view/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';

// 获取安全区域边距
EdgeInsets get safeAreaEdgeInsets => Get.mediaQuery.viewPadding;

enum EmptyActionType {
  ///只显示文字
  text,

  ///只显示按钮
  button,

  ///按钮文字都显示
  all,
}

enum MultiStatusType {
  ///内容
  statusContent,

  ///加载中
  statusLoading,

  ///无数据
  statusEmpty,

  ///数据错误
  statusError,

  ///无网络
  statusNoNetWork,

  ///自定义
  statusCustom,
}

class MultiStatusView extends StatefulWidget {
  const MultiStatusView({
    super.key,
    required this.child,
    this.currentStatus = MultiStatusType.statusContent,
    this.loadingWidget,
    this.errorWidget,
    this.noNetWorkWidget,
    this.customWidget,
    this.emptyWidget,
    this.emptyText,
    this.emptyActionText,
    this.emptyActionType = EmptyActionType.text,
    this.hasAppBar = true,
    this.backgroundColor = Colors.transparent,
    this.action,
    this.emptyAction,
    this.actionText,
    this.scrollController,
  });

  final Widget child;
  final MultiStatusType currentStatus;
  final Widget? loadingWidget;
  final Widget? errorWidget;
  final Widget? noNetWorkWidget;
  final Widget? customWidget;

  final Widget? emptyWidget;
  final EmptyActionType emptyActionType;
  final String? emptyText;
  final String? emptyActionText;

  final VoidCallback? action;
  final VoidCallback? emptyAction;
  final String? actionText;

  final bool hasAppBar;

  final Color backgroundColor;

  final ScrollController? scrollController;

  @override
  State<MultiStatusView> createState() => _MultiStatusViewState();
}

class _MultiStatusViewState extends State<MultiStatusView>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    switch (widget.currentStatus) {
      case MultiStatusType.statusContent:
        return LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              color: widget.backgroundColor,
              height: constraints.maxHeight,
              child: widget.child,
            );
          },
        );
      case MultiStatusType.statusLoading:
        return _buildLoadingWidget();
      case MultiStatusType.statusEmpty:
        return _buildEmptyWidget();
      case MultiStatusType.statusError:
        return _buildErrorWidget();
      case MultiStatusType.statusNoNetWork:
        return _buildNoNetWorkWidget();
      case MultiStatusType.statusCustom:
        return _buildCustomWidgetWidget();
    }
  }

  _buildLoadingWidget() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: Container(
            color: widget.backgroundColor,
            width: Get.width,
            height: constraints.maxHeight,
            padding: EdgeInsets.only(
                bottom: !widget.hasAppBar
                    ? 0
                    : safeAreaEdgeInsets.top + kToolbarHeight),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: widget.loadingWidget != null
                  ? [widget.loadingWidget!]
                  : [loadingIndicator()],
            ),
          ),
        );
      },
    );
  }

  _buildEmptyWidget() {
    List<Widget> content = widget.emptyWidget != null
        ? [widget.emptyWidget!]
        : [
            Image.asset('assets/purchase/no_purchase_data_icon.png',
                width: 120.w, height: 120.w),
            SizedBox(height: 10.h),
            ..._getActions(widget.emptyActionType),
          ];

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          controller: widget.scrollController,
          child: Container(
            color: widget.backgroundColor,
            width: Get.width,
            height: constraints.maxHeight,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              ...content,
              Flexible(
                child: SizedBox(
                  height: !widget.hasAppBar
                      ? 0
                      : safeAreaEdgeInsets.top + kToolbarHeight,
                ),
              ),
            ]),
          ),
        );
      },
    );
  }

  _buildErrorWidget() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: Container(
            color: widget.backgroundColor,
            width: Get.width,
            height: constraints.maxHeight,
            padding: EdgeInsets.only(
                bottom: !widget.hasAppBar
                    ? 0
                    : safeAreaEdgeInsets.top + kToolbarHeight),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: widget.errorWidget != null
                  ? [widget.errorWidget!]
                  : [
                      ByWidgetsUtil.commonText(text: "服务错误", fontSize: 16.sp),
                    ],
            ),
          ),
        );
      },
    );
  }

  _buildNoNetWorkWidget() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: Container(
            color: widget.backgroundColor,
            width: Get.width,
            height: constraints.maxHeight,
            padding: EdgeInsets.only(
                bottom: !widget.hasAppBar
                    ? 0
                    : safeAreaEdgeInsets.top + kToolbarHeight),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: widget.noNetWorkWidget != null
                  ? [widget.noNetWorkWidget!]
                  : [
                      Image.asset('assets/purchase/no_purchase_data_icon.png',
                          width: 120.w, height: 120.w),
                      SizedBox(height: 10.h),
                      ByWidgetsUtil.commonText(
                          text: "网络异常，请检测网络后重试",
                          fontSize: 16.sp,
                          textColor: ByColorUtil.colorF1),
                      SizedBox(
                        height: 8.w,
                      ),
                      Text(
                        "如有问题，可拨打客服热线协助您解决 \n（人工客服时间早9:00-晚23:00）",
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: ByColorUtil.colorF1.withOpacity(0.5),
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 8.w,
                      ),
                      ByWidgetsUtil.commonText(
                        text: "400-869-8538",
                        fontSize: 16.sp,
                        textColor: ByColorUtil.colorF1,
                      ),
                      SizedBox(
                        height: 24.w,
                      ),
                      SizedBox(
                        width: 104.w,
                        height: 48.w,
                        child: ByButton.gradientBtn(
                            padding: const EdgeInsets.all(0),
                            fontSize: 14.sp,
                            textColor: Colors.white,
                            bgColor: const Color(0xFF00CB64),
                            title: '重新加载',
                            onClick: () {
                              widget.action?.call();
                            }),
                      )
                    ],
            ),
          ),
        );
      },
    );
  }

  _buildCustomWidgetWidget() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: Container(
            color: widget.backgroundColor,
            width: Get.width,
            height: constraints.maxHeight,
            padding: EdgeInsets.only(
                bottom: !widget.hasAppBar
                    ? 0
                    : safeAreaEdgeInsets.top + kToolbarHeight),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: widget.customWidget != null
                  ? [widget.customWidget!]
                  : [
                      ByWidgetsUtil.commonText(text: "自定义布局", fontSize: 16.sp),
                    ],
            ),
          ),
        );
      },
    );
  }

  _getActions(EmptyActionType emptyActionType) {
    switch (emptyActionType) {
      case EmptyActionType.all:
        return [
          ByWidgetsUtil.commonText(
              text: widget.emptyText ?? '暂无内容',
              fontSize: 16.sp,
              textColor: ByColorUtil.colorF2,
              textAlign: TextAlign.center),
          SizedBox(height: 22.h),
          SizedBox(
            height: 20.w,
          ),
          SizedBox(
            width: 80.w,
            height: 30.w,
            child: ByButton.gradientBtn(
                padding: const EdgeInsets.all(0),
                fontSize: 13.sp,
                textColor: Colors.black,
                title: widget.emptyActionText ?? '重新加载',
                onClick: () {
                  widget.emptyAction?.call();
                }),
          )
        ];
      case EmptyActionType.text:
        return [
          ByWidgetsUtil.commonText(
              text: widget.emptyText ?? '暂无内容',
              fontSize: 16.sp,
              textColor: ByColorUtil.colorF2,
              textAlign: TextAlign.center)
        ];
      case EmptyActionType.button:
        return [
          SizedBox(
            height: 20.w,
          ),
          SizedBox(
            width: 80.w,
            height: 30.w,
            child: ByButton.gradientBtn(
                padding: const EdgeInsets.all(0),
                fontSize: 13.sp,
                textColor: Colors.black,
                title: widget.emptyActionText ?? '重新加载',
                onClick: () {
                  widget.emptyAction?.call();
                }),
          )
        ];
    }
  }

  @override
  bool get wantKeepAlive => true;

  Widget loadingIndicator(
      {Color color = const Color(0xFF98FC4A), double size = 80}) {
    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(1),
      child: const Center(
        child: LoadingIndicator(
            indicatorType: Indicator.ballClipRotatePulse,

            /// Required, The loading type of the widget
            colors: [ByColorUtil.colorC1],

            /// Optional, The color collections
            strokeWidth: 2,

            /// Optional, The stroke of the line, only applicable to widget which contains line
            backgroundColor: ByColorUtil.colorBg1,

            /// Optional, Background of the widget
            pathBackgroundColor: Colors.black

            /// Optional, the stroke backgroundColor
            ),
      ),
    );
  }
}
