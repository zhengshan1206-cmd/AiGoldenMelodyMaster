import 'package:ai_golden_melody_master/utils/assets.dart';
import 'package:ai_golden_melody_master/utils/by_color_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ErrorDialog extends StatelessWidget {
  const ErrorDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 1.sw - 48.w,
        height: 40.w,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: ByColorUtil.colorFF5252,
          borderRadius: BorderRadius.circular(20.w),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              Assets.icon26,
              width: 20.w,
              height: 20.w,
            ),
            SizedBox(width: 5.w,),
            Text(
              "声音训练失败，请选择其他音频创作",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 16.sp,
              ),
            )
          ],
        ),
      ),
    );
  }
}
