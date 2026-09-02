

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../app_common/by_nav_router_utils.dart';
import '../../app_common/consts/assets_data.dart';
import '../../app_common/consts/language_str.dart';
import '../by_widgets_util.dart';
import '../byhy_colors.dart';
import '../byhy_screen_utils.dart';


typedef CommonAlertDialogConfirmCallback = void Function(BuildContext);
///公共警告弹窗
class CommonAlertDialog extends StatelessWidget {
  final String contents;
  final String? title;
  final String? confirmBtnTitle;
  final bool? showCancel;
  final String? cancelBtnTitle;
  final CommonAlertDialogConfirmCallback? confirmCallback;
  final CommonAlertDialogConfirmCallback? cancelCallback;
  final BuildContext? pageContext;
  final int? manLine;
  const CommonAlertDialog({
    super.key,
    required this.contents,
    this.title,
    this.confirmBtnTitle,
    this.confirmCallback,
    this.showCancel,
    this.cancelBtnTitle,
    this.cancelCallback,
    this.pageContext,
    this.manLine,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Material(
            color: Colors.transparent,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 28.w),
              width: double.infinity,
              decoration: BoxDecoration(
                  color: ByHyColorUtil.WhiteColor,
                  borderRadius: BorderRadius.circular(18.w)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 60.h),
                  ByWidgetsUtil.commonText(
                    text: title ?? LanguageStr.hintTitle,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  SizedBox(height: 20.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 43.w),
                    child: ByWidgetsUtil.commonText(
                      fontSize: 14.sp,
                      maxLines: manLine ?? 3,
                      textAlign: TextAlign.center,
                      text: contents,
                    ),
                  ),
                  SizedBox(height: 30.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.w),
                    child: (showCancel ?? false)
                        ? Row(
                      children: [
                        Expanded(
                          child: ByWidgetsUtil.commonBtn(
                            title: cancelBtnTitle ?? LanguageStr.cancel,
                            padding: EdgeInsets.symmetric(vertical: 15.h),
                            fontSize: 16.sp,
                            borderRadius: 12.w,
                            bgColor:
                            const Color(0xFF0E1840).withOpacity(0.3),
                            textColor: ByHyColorUtil.WhiteColor,
                            fontWeight: FontWeight.bold,
                            onClick: () {
                              ByNavRouterUtils.goBack(context);

                              cancelCallback
                                  ?.call(pageContext ?? context);
                            },
                          ),
                        ),
                        SizedBox(width: 25.w),
                        Expanded(
                          child: ByWidgetsUtil.commonBtn(
                            title: confirmBtnTitle ?? LanguageStr.confirm,
                            padding: EdgeInsets.symmetric(vertical: 15.h),
                            fontSize: 16.sp,
                            borderRadius: 12.w,
                            fontWeight: FontWeight.bold,
                            onClick: () {
                              ByNavRouterUtils.goBack(context);

                              confirmCallback
                                  ?.call(pageContext ?? context);
                            },
                          ),
                        ),
                      ],
                    )
                        : ByWidgetsUtil.commonBtn(
                      title: confirmBtnTitle ?? LanguageStr.confirm,
                      fontSize: 16.sp,
                      borderRadius: 12.w,
                      fontWeight: FontWeight.bold,
                      onClick: () {
                        ByNavRouterUtils.goBack(context);
                        confirmCallback?.call(pageContext ?? context);
                      },
                    ),
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
          Positioned(
            top: -25.h,
            left: ByScreenUtils.screenWidth * 0.5 - 30.w,
            child: Image.asset(
              AssetsData.iconBell,
              width: 60.w,
              height: 60.w,
            ),
          ),
        ],
      ),
    );
  }
}
