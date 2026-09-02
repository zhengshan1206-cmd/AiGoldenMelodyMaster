import 'dart:async';

import 'package:ai_golden_melody_master/utils/assets.dart';
import 'package:ai_golden_melody_master/view/lanuch_page/launch_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:ai_golden_melody_master/common/lib/app_common/event/common_event.dart';
import '../../navigator/app_pages.dart';
import '../../utils/common_event.dart';

///启动页面
class LaunchPage extends StatefulWidget {
  const LaunchPage({super.key});

  @override
  State<LaunchPage> createState() => _LaunchPageState();
}

class _LaunchPageState extends State<LaunchPage> {
  late StreamSubscription<NetworkErrorEvent> streamSubscription;

  @override
  void initState() {
    super.initState();
    streamSubscription = eventBus.on<NetworkErrorEvent>().listen((e) {
      Get.offNamed(Routes.launchFailed);
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return GetBuilder<LaunchController>(
      builder: (controller) {
        return PopScope(
          canPop: false,
          onPopInvoked: (didPop) async {
            if (didPop) return;
            // controller.goBack();
          },
          child: Scaffold(
            body: Container(
              width: width,
              height: height,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: Colors.black,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(),
                  Positioned.fill(
                    child: Image.asset(
                      Assets.launchBg,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
