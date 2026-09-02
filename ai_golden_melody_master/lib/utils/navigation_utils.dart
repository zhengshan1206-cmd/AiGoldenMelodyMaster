import 'package:get/get.dart';
import '../navigator/app_pages.dart';
import '../view/main/main_controller.dart';

/// 导航工具类
class NavigationUtils {
  /// 跳转到指定Tab
  /// [tabIndex] Tab索引：0-发行，1-AI写歌，2-我的
  static void navigateToTab(int tabIndex) {
    // 检查是否已经在主页面
    if (Get.currentRoute == Routes.main) {
      // 如果已经在主页面，直接切换Tab
      if (Get.isRegistered<MainController>()) {
        Get.find<MainController>().switchToTab(tabIndex);
      }
    } else {
      // 如果不在主页面，跳转到主页面并传递参数
      Get.toNamed(Routes.main, arguments: {'tabIndex': tabIndex});
    }
  }

  /// 返回并跳转到指定Tab
  /// [tabIndex] Tab索引：0-发行，1-AI写歌，2-我的
  static void backAndNavigateToTab(int tabIndex) {
    Get.back();
    navigateToTab(tabIndex);
  }
}
