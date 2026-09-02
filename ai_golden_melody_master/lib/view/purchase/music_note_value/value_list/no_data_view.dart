import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

///没有数据
class NoDataViewPage extends StatelessWidget {
  final String title;
  final String iconPath;
  const NoDataViewPage({
    super.key,
    required this.title,
    required this.iconPath,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          iconPath,
          width: 120.w,
          height: 120.w,
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.white.withOpacity(0.5),
            fontWeight: FontWeight.w400,
          ),
        )
      ],
    );
  }
}
