/*
 * @Author: cold-x
 * @Date: 2025-06-03 11:49:04
 * @LastEditors: cold-x 474647591@qq.com
 * @LastEditTime: 2025-06-03 11:51:21
 * @FilePath: /fastcreationmaster/lib/global/ui/theme.dart
 * @Description: 
 */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'colors.dart';

EdgeInsets get safeAreaEdgeInsets => Get.mediaQuery.viewPadding;

double safeAreaTopDistance(double distance) =>
    safeAreaEdgeInsets.top + distance;

double safeAreaBottomDistance(double distance) =>
    safeAreaEdgeInsets.bottom + distance;

final theme = ThemeData(
  useMaterial3: false,
  primaryColor: ByColorUtil.colorC1,
  scaffoldBackgroundColor: ByColorUtil.colorBg1,
  colorScheme: const ColorScheme.light(),
  appBarTheme: AppBarTheme(
    centerTitle: true,
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness:
          GetPlatform.isAndroid ? Brightness.dark : Brightness.light,
    ), // 设置状态栏颜
  ),
);
