

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../app_common/consts/assets_data.dart';
import '../by_widgets_util.dart';
import '../byhy_colors.dart';
import '../byhy_screen_utils.dart';


///一些公共弹窗
class CommonDialog extends StatelessWidget {
  final String contents;
  final String? title;
  final String? confirmBtnTitle;
  final String? cancelBtnTitle;
  final Function? confirmCallback;
  final Function? cancelCallback;
  final int? maxLine;
  final bool reverse;
  final TextAlign? textAlign;
  final bool isDanger;

  const CommonDialog({
    super.key,
    required this.contents,
    this.title,
    this.confirmBtnTitle,
    this.confirmCallback,
    this.cancelBtnTitle,
    this.cancelCallback,
    this.maxLine,
    this.textAlign,
    this.reverse = false,
    this.isDanger = false,
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
                    text: title ?? "温馨提示",
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  SizedBox(height: 20.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 43.w),
                    child: ByWidgetsUtil.commonText(
                      fontSize: 14.sp,
                      maxLines: maxLine ?? 1,
                      textAlign: textAlign ?? TextAlign.center,
                      text: contents,
                    ),
                  ),
                  SizedBox(height: 50.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.w),
                    child: Row(
                      children: reverse
                          ? [
                        Expanded(
                          child: SizedBox(
                            height: 48.h,
                            child: ByWidgetsUtil.commonBtn(
                              title: cancelBtnTitle ?? "取消",
                              fontSize: 16.sp,
                              borderRadius: 12.w,
                              bgColor: const Color(0xFF0E1840)
                                  .withOpacity(0.3),
                              textColor: ByHyColorUtil.WhiteColor,
                              fontWeight: FontWeight.bold,
                              onClick: () {
                                Navigator.of(context).pop(false);
                                cancelCallback?.call();
                              },
                            ),
                          ),
                        ),
                        SizedBox(width: 25.w),
                        Expanded(
                          child: SizedBox(
                            height: 48.h,
                            child: ByWidgetsUtil.commonBtn(
                              title: confirmBtnTitle ?? "确定",
                              fontSize: 16.sp,
                              borderRadius: 12.w,
                              bgColor: isDanger ? const Color(0xFFFF5373) : ByHyColorUtil.LoginBtnBgColor,
                              fontWeight: FontWeight.bold,
                              onClick: () {
                                Navigator.of(context).pop(true);
                                confirmCallback?.call();
                              },
                            ),
                          ),
                        ),
                      ]
                          : [
                        Expanded(
                          child: SizedBox(
                            height: 48.h,
                            child: ByWidgetsUtil.commonBtn(
                              title: confirmBtnTitle ?? "确定",
                              fontSize: 16.sp,
                              borderRadius: 12.w,
                              fontWeight: FontWeight.bold,
                              onClick: () {
                                Navigator.of(context).pop(true);
                                confirmCallback?.call();
                              },
                            ),
                          ),
                        ),
                        SizedBox(width: 25.w),
                        Expanded(
                          child: SizedBox(
                            height: 48.h,
                            child: ByWidgetsUtil.commonBtn(
                              title: cancelBtnTitle ?? "取消",
                              fontSize: 16.sp,
                              borderRadius: 12.w,
                              bgColor: const Color(0xFF0E1840)
                                  .withOpacity(0.3),
                              textColor: ByHyColorUtil.WhiteColor,
                              fontWeight: FontWeight.bold,
                              onClick: () {
                                Navigator.of(context).pop(false);
                                cancelCallback?.call();
                              },
                            ),
                          ),
                        ),
                      ],
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