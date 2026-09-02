

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../app_common/consts/assets_data.dart';
import '../app_common/consts/language_str.dart';
import 'byhy_colors.dart';


///无数据提示页面
class NoDataView extends StatelessWidget {
  final RichText? desc;
  final void Function()? onTap;
  final double? gap;
  const NoDataView({
    super.key,
    this.desc,
    this.onTap,
    this.gap,
  });

  @override
  Widget build(
      BuildContext context,
      ) {
    return Container(
      color: ByHyColorUtil.WhiteColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
           AssetsData.iconNoData,
            width: 180.w,
            height: 100.h,
            fit: BoxFit.contain,
          ),
          SizedBox(height: gap ?? 30.h),
          desc ??
              RichText(
                text: TextSpan(
                    text: LanguageStr.noData,
                    style: TextStyle(
                      color: ByHyColorUtil.CommonTextColor,
                      fontSize: 12.sp,
                    ),
                    children: [
                      TextSpan(
                        text: LanguageStr.goCreate,
                        style: TextStyle(
                          color: ByHyColorUtil.TabTextColorSelected,
                          fontWeight: FontWeight.bold,
                          fontSize: 12.sp,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            onTap?.call();
                          },
                      ),
                    ]),
              ),
        ],
      ),
    );
  }
}
