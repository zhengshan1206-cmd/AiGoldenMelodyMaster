import 'dart:developer';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:bda_signal/bda_signal.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:tuple/tuple.dart';
import 'app_common/channel/by_channel_operate.dart';
import 'app_common/package/byhy_package_utils.dart';

class ByDeviceInfoUtils {
  loadDeviceInfo() {
    if (ByPackageUtils.isAndroid) return DeviceInfoPlugin().androidInfo;
    return DeviceInfoPlugin().iosInfo;
  }

  /// 使用 AndroidId 替代 UUID
  static Future<Tuple2<String, String>> deviceInfo() async {
    if (ByPackageUtils.isAndroid) {
      final data = await ChannelOperate.getAppDeviceInfo();
      String androidId = "";
      String oaid = "";
      if (data != null) {
        androidId = data["androidId"];
        oaid = data["oId"];
      } else {
        final AndroidDeviceInfo info = await DeviceInfoPlugin().androidInfo;
        androidId = info.id;
      }
      return Tuple2(oaid, androidId);
    }
    final IosDeviceInfo info = await DeviceInfoPlugin().iosInfo;
    return Tuple2("", info.identifierForVendor ?? "");
  }

  static Future<dynamic> getUserDiviceInfo() async {
    if (ByPackageUtils.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      final appVersion = await ByPackageUtils.version();
      final di = await deviceInfo();
      return {
        "uuid": di.item2,
        "android": di.item2,
        "imei": di.item2,
        "oaid": di.item1,
        "brand": androidInfo.brand,
        "sys_version": androidInfo.version.release,
        "model": androidInfo.model,
        "app_versions": appVersion,
      };
    } else if (ByPackageUtils.isIOS) {
      log("进入到ios 获取信息===");
      final iosInfo = await DeviceInfoPlugin().iosInfo;
      final appVersion = await ByPackageUtils.version();
      final di = await deviceInfo();
      int systemBootTime = await BdaSignal.systemBootTime();
      String appInstallTime = await BdaSignal.appInstallTime();
      String asaToken = await BdaSignal.adToken();

      ///这里oaid 在ios里取的是idfv
      String oaid = await BdaSignal.idfv();

      final status =
          await AppTrackingTransparency.requestTrackingAuthorization();
      String systemInitialTime = await BdaSignal.getDeviceInitialTime();

      String idfa = await AppTrackingTransparency.getAdvertisingIdentifier();
      log("进入到ios 获取信息 idfa=== $idfa  系统更新时间==> $appInstallTime 系统启动时间==> $systemBootTime  系统初始化时间==> $systemInitialTime");

      return {
        "uuid": di.item2,
        "boot_time": systemBootTime.toString(),
        "mb_time": appInstallTime.toString(),
        "asa_token": asaToken,
        "sys_version": iosInfo.systemVersion,
        "oaid": oaid,
        "app_versions": appVersion,
        "model": iosInfo.utsname.machine,
        "brand": "apple",
        "idfa": idfa,
        "boot_init_time": systemInitialTime,
      };
    }
    return {
      "uuid": "",
      "android": "",
      "imei": "",
      "oaid": "",
      "brand": "",
      "sys_version": "",
      "model": "",
      "app_versions": "",
    };
  }
}
