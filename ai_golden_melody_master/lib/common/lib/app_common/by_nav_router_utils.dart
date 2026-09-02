
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../app_http/apis.dart';
import '../app_http/http_utils.dart';
import '../app_ui/byhy_base_web_view.dart';


/// description:  路由跳转工具类（原生封装）

class ByNavRouterUtils {
  static void fadeIn(BuildContext context, Widget scene, {String? name}) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (
            context,
            animation,
            secondaryAnimation,
            ) =>
        scene,
        transitionDuration: const Duration(milliseconds: 150),
        reverseTransitionDuration: const Duration(milliseconds: 150),
        settings: name != null ? RouteSettings(name: name) : null,
        transitionsBuilder: (
            context,
            animation,
            secondaryAnimation,
            child,
            ) {
          var begin = 0.8;
          var end = 1.0;
          var curve = Curves.easeInOut;
          var tween =
          Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return FadeTransition(
            opacity: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }

  /// 跳转
  static Future push(BuildContext context, Widget scene, {String? name}) {
    FocusScope.of(context).requestFocus(FocusNode());
    return Navigator.push(
      context,
      MaterialPageRoute(
        settings: name != null ? RouteSettings(name: name) : null,
        builder: (BuildContext ctx) => scene,
      ),
    );
  }

  /// 跳转Name
  static pushNamed(BuildContext context, String name, {Object? arguments}) {
    return Navigator.pushNamed(context, name, arguments: arguments);
  }

  /// 跳转Name
  static pushReplacementNamed(BuildContext context, String name,
      {Object? arguments}) {
    return Navigator.pushReplacementNamed(context, name, arguments: arguments);
  }

  /// 替换页面 当新的页面进入后，之前的页面将执行dispose方法
  static pushReplacement(BuildContext context, Widget scene, {String? name}) {
    return Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext ctx) => scene,
        settings: name != null ? RouteSettings(name: name) : null,
      ),
    );
  }

  /// 指定页面加入到路由中，然后将其他所有的页面全部pop
  static pushAndRemoveUntil(BuildContext context, Widget scene) {
    return Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext ctx) => scene,
        ),
            (route) => false);
  }

  ///  跳转 - 带回调参数
  static pushNamedResult(
      BuildContext context, Widget scene, Function(dynamic) function) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext ctx) => scene,
      ),
    ).then((result) {
      // 页面返回result为null
      if (result == null) {
        return;
      }
      function(result);
    }).catchError((error) {});
  }

  /// 返回
  static void goBack(BuildContext context) {
    unFocus();
    EasyLoading.dismiss();
    Navigator.pop(context);
  }

  /// 返回
  static void goBackUntilName(BuildContext context, String name) {
    unFocus();
    Navigator.popUntil(context, (route) {
      return route.settings.name == name;
    });
  }

  /// 带参数返回
  static void goBackWithParams(BuildContext context, result) {
    unFocus();
    Navigator.pop(context, result);
  }

  /// 跳到WebView页
  static jumpWebViewPage(
      BuildContext context,
      String title,
      String url, {
        bool isRisk = true,
      }) {
    if (url.isEmpty) return;
    if (isRisk) {
      HttpUtils.post(
        APIs.dnsCheck,
        {"url": url},
        success: (json) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) =>
                  ByHyBaseWebView(title: title, url: url),
            ),
          );
        },
        fail: (code, msg) {
          EasyLoading.showToast(msg);
        },
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) =>
              ByHyBaseWebView(title: title, url: url),
        ),
      );
    }
  }

  static void unFocus() {
    /// 使用下面的方式，会触发不必要的build。
    /// FocusScope.of(context).unFocus();
    /// https://blog.csdn.net/iotjin
    FocusManager.instance.primaryFocus?.unfocus();
  }
}
