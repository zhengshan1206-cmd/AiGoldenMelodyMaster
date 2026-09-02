import 'package:ai_golden_melody_master/view/main/main_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/assets.dart';
import '../../utils/by_color_utils.dart';
import '../lanuch_page/launch_controller.dart';

///App-主页
class MainPage extends StatelessWidget {
  const MainPage({super.key});

  ///导航底部item
  BottomNavigationBarItem tabBarItem({
    String? label,
    String? assets,
    String? selectedAssets,
  }) {
    return BottomNavigationBarItem(
      label: label,
      icon: assets == null
          ? const SizedBox()
          : Container(
              width: 24,
              height: 24,
              margin: const EdgeInsets.only(bottom: 5),
              child: Image.asset(assets, width: 24, height: 24),
            ),
      activeIcon: selectedAssets == null
          ? null
          : Container(
              width: 24,
              height: 24,
              margin: const EdgeInsets.only(bottom: 5),
              child: Image.asset(selectedAssets, width: 24, height: 24),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put((MainController()));

    ///todo 这里临时把启动的业务逻辑放在主页面 后续回到启动页面
    Get.put((LaunchController()));
    return GetBuilder<MainController>(builder: (controller) {
      return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: controller.currentIndex,
          iconSize: 24,
          selectedItemColor: ByColorUtil.tabTextColorSelected,
          unselectedItemColor: ByColorUtil.mainTextColor,
          selectedLabelStyle: const TextStyle(fontSize: 12),
          unselectedLabelStyle: const TextStyle(fontSize: 12),
          items: [
            tabBarItem(
              label: '发行',
              assets: Assets.tabPublishIcon,
              selectedAssets: Assets.selectedTabPublishIcon,
            ),
            tabBarItem(
              label: 'AI写歌',
              assets: Assets.tabAiWriteMusicIcon,
              selectedAssets: Assets.selectedTabAiWriteMusicIcon,
            ),
            // tabBarItem(
            //   label: '赚钱',
            //   assets: Assets.tabEarnMoney,
            //   selectedAssets: Assets.selectedTabEarnMoney,
            // ),
            tabBarItem(
              label: '我的',
              assets: Assets.tabMeIcon,
              selectedAssets: Assets.selectedTabMeIcon,
            ),
          ],
          onTap: (index) {
            controller.tabChanged(index: index);
          },
          backgroundColor: Colors.black,
          elevation: 0,
        ),
        body: Stack(
          children: [
            ...controller.tabBarPages.map((e) {
              return Offstage(
                offstage: controller.currentIndex !=
                    controller.tabBarPages.indexOf(e),
                child: e,
              );
            })
          ],
        ),
      );
    });
  }
}
