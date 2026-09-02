/*
 * @Author: cold-x
 * @Date: 2025-06-04 15:40:41
 * @LastEditors: cold-x 474647591@qq.com
 * @LastEditTime: 2025-06-18 16:01:21
 * @FilePath: /fastcreationmaster/lib/core/widget/view/by_button.dart
 * @Description: 
 */

import 'package:ai_golden_melody_master/common/lib/app_ui/by_widgets_util.dart';
import 'package:ai_golden_melody_master/view/publish/illegal_words/view/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ByButton {
  /// 通用按钮带渐变的按钮组件
  static GestureDetector gradientBtn({
    BuildContext? context,
    required String title,
    required void Function() onClick,
    EdgeInsetsGeometry? padding,
    Color? textColor = ByColorUtil.colorF2,
    Gradient? gradient,
    double? fontSize,
    FontWeight? fontWeight,
    double? borderRadius,
    BorderRadiusGeometry? customBorderRadius,
    Color? bgColor,
  }) {
    return GestureDetector(
      onTap: () {
        // FocusScope.of(context ?? navigatorKey.currentContext!).unfocus();
        onClick();
      },
      child: Container(
        alignment: Alignment.center,
        padding: padding ??
            const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
        decoration: bgColor == null
            ? BoxDecoration(
                borderRadius: customBorderRadius ??
                    BorderRadius.circular(borderRadius ?? 15.w),
                gradient: gradient ?? ByColorUtil.colorG1(),
                color: bgColor ?? ByColorUtil.colorBg2,
              )
            : BoxDecoration(
                borderRadius: customBorderRadius ??
                    BorderRadius.circular(borderRadius ?? 15.w),
                color: bgColor,
              ),
        child: Text(
          title,
          style: TextStyle(
              color: textColor ?? ByColorUtil.colorF7,
              textBaseline: TextBaseline.ideographic,
              fontSize: fontSize ?? 17,
              fontWeight: fontWeight ?? FontWeight.w500,
              decoration: TextDecoration.none),
        ),
      ),
    );
  }

  /// 通用按钮有图带渐变的按钮组件
  static GestureDetector gradientImageBtn({
    BuildContext? context,
    required String title,
    required void Function() onClick,
    EdgeInsetsGeometry? padding,
    Color? textColor = ByColorUtil.colorF2,
    Gradient? gradient,
    double? fontSize,
    FontWeight? fontWeight,
    double? borderRadius,
    BorderRadiusGeometry? customBorderRadius,
    Color? bgColor,
    String? image,
    double? imageSize,
  }) {
    return GestureDetector(
      onTap: () {
        // FocusScope.of(context ?? navigatorKey.currentContext!).unfocus();
        onClick();
      },
      child: Container(
        alignment: Alignment.center,
        padding: padding ??
            const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
        decoration: bgColor == null
            ? BoxDecoration(
                borderRadius: customBorderRadius ??
                    BorderRadius.circular(borderRadius ?? 15.w),
                gradient: gradient ?? ByColorUtil.colorG1(),
                color: bgColor ?? ByColorUtil.colorBg2,
              )
            : BoxDecoration(
                borderRadius: customBorderRadius ??
                    BorderRadius.circular(borderRadius ?? 15.w),
                color: bgColor,
              ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (image != null)
              Image.asset(
                image,
                width: imageSize ?? 16,
                height: imageSize ?? 16,
              ),
            if (image != null && title.isNotEmpty)
              const SizedBox(
                width: 4,
              ),
            if (title.isNotEmpty)
              Text(
                title,
                style: TextStyle(
                  color: textColor,
                  textBaseline: TextBaseline.ideographic,
                  fontSize: fontSize ?? 17,
                  fontWeight: fontWeight ?? FontWeight.w500,
                  decoration: TextDecoration.none,
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// 通用按钮专业版带VIP的按钮组件
  static Widget grandiantVIPBtn(
      {String? title, String? image, Function()? onClick}) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.only(right: 4.w, top: 4.w, bottom: 4.w),
          child: gradientImageBtn(
              gradient: const LinearGradient(colors: [
                Color(0xFF82D7FF),
                Color(0xFFBFE0FF),
                Color(0xFFDCC8FF)
              ]),
              title: title ?? '',
              textColor: ByColorUtil.colorF7,
              onClick: () {
                onClick?.call();
              },
              image: image),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: Image.asset(
            'assets/square/square_1.png',
            width: 32,
            height: 18,
          ),
        )
      ],
    );
  }

  ///渐变button
  ///已生成的标题名称
  ///小说名、笔名
  static Widget toolNameGrandiant(String title) {
    return SizedBox(
      height: 48.w,
      width: double.infinity,
      child: Stack(
        children: [
          ShaderMask(
            blendMode: BlendMode.srcIn,
            shaderCallback: (rect) {
              return LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFFCBF203).withOpacity(0.32),
                  const Color(0xFF5BD0CA).withOpacity(0.32),
                  const Color(0xFF0181FC).withOpacity(0.32)
                ],
              ).createShader(rect);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.w),
                  gradient: LinearGradient(colors: [
                    const Color(0xFFCBF203).withOpacity(0.16),
                    const Color(0xFF5BD0CA).withOpacity(0.16),
                    const Color(0xFF0181FC).withOpacity(0.16)
                  ], begin: Alignment.topLeft, end: Alignment.topRight),
                  border: Border.all(
                    color: ByColorUtil.colorBg1,
                  )),
            ),
          ),
          Row(
            children: [
              SizedBox(
                width: 12.w,
              ),
              Expanded(
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: 261.w,
                  ),
                  child: title.isNotEmpty
                      ? ByWidgetsUtil.commonText(
                          text: title,
                          textColor: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w500)
                      : Row(
                          children: [
                            const CupertinoActivityIndicator(
                              color: ByColorUtil.colorC1,
                              radius: 6,
                            ),
                            SizedBox(
                              width: 4.w,
                            ),
                            ByWidgetsUtil.commonText(
                                fontSize: 14.sp,
                                textColor: ByColorUtil.colorC1,
                                text: 'AI正在创作中'),
                          ],
                        ),
                ),
              ),
              ByWidgetsUtil.btnWithIcon(
                  bgColor: Colors.transparent,
                  textColor: ByColorUtil.colorC1,
                  title: '复制',
                  iconPath: 'assets/home/tool/btn_novel_name_copy.png',
                  onClick: () {
                    Clipboard.setData(ClipboardData(text: title));
                  }),
            ],
          ),
        ],
      ),
    );
  }
}

/// 图标位置
enum SuffixDirectional {
  top,
  bottom,
  left,
  right,
}

class CommonButton extends StatelessWidget {
  const CommonButton({
    super.key,
    this.text,
    this.color,
    this.borderRadius = const BorderRadius.all(Radius.circular(8.0)),
    this.disabledColor = CupertinoColors.quaternarySystemFill,
    this.minSize = 0,
    this.spacing,
    this.padding,
    this.suffixDirectional,
    this.suffixWidget,
    this.child,
    this.onPressed,
  });

  /// 按钮背景颜色
  final Color? color;

  /// 不可点击时颜色
  final Color disabledColor;

  final BorderRadius? borderRadius;

  /// 最小尺寸
  final double? minSize;

  /// 图文间距，默认 4
  final double? spacing;

  /// icon方向，默认文字右侧
  final SuffixDirectional? suffixDirectional;
  final Widget? suffixWidget;

  final VoidCallback? onPressed;

  /// 默认 EdgeInsets.zero
  final EdgeInsetsGeometry? padding;
  final Widget? child;

  final String? text;

  _getChild() {
    Widget childWidget = child ??
        ByWidgetsUtil.commonText(
            text: text ?? '', fontSize: 16, fontWeight: FontWeight.w500);

    if (suffixWidget != null) {
      if (suffixDirectional == SuffixDirectional.bottom ||
          suffixDirectional == SuffixDirectional.top) {
        Widget spacWidget = SizedBox(height: spacing ?? 6);
        List<Widget> children = [suffixWidget!, spacWidget, childWidget];

        if (suffixDirectional == SuffixDirectional.bottom) {
          children = [childWidget, spacWidget, suffixWidget!];
        }

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: children,
        );
      } else {
        Widget spacWidget = SizedBox(width: spacing ?? 6);
        List<Widget> children = [childWidget, spacWidget, suffixWidget!];

        if (suffixDirectional == SuffixDirectional.left) {
          children = [suffixWidget!, spacWidget, childWidget];
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: children,
        );
      }
    }

    return child;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      color: color,
      disabledColor: disabledColor,
      borderRadius: borderRadius,
      minSize: minSize,
      padding: padding ?? EdgeInsets.zero,
      child: _getChild(),
      onPressed: onPressed,
    );
  }
}
