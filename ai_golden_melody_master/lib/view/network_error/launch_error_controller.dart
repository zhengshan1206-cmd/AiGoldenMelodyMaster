import 'package:get/get.dart';

class LaunchErrorController extends GetxController {
  var launching = false.obs;
  var launchFaild = false.obs;
  var progress = 0.0.obs;
  var reTryCount = 0.obs;
}
