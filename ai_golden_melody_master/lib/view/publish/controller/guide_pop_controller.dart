/*
  guide_pop_providers.dart
  Created by duncy on 25/4/16.
*/

import 'dart:io';

import 'package:ai_golden_melody_master/common/lib/app_http/apis.dart';
import 'package:ai_golden_melody_master/common/lib/app_http/http_utils.dart';
import 'package:ai_golden_melody_master/view/publish/beans/guide_pop_beans.dart';
import 'package:get/get.dart';

//已废弃，现用路由代替
enum GuideEntranceType {
  aiMusicInspiration, //灵感写歌
  aiMusicMaster, //大师模式
  aiMusicExclusive, //专属模式
}

class GuideApi extends APIs {
  static const String guidePopPage = "api/ComConfig/strategyGuideList";
}

class GuidePopController extends GetxController {
  var guideData = Rx<GuidePopBean>(GuidePopBean());
  String routeName = "";

  String getRouteName(GuideEntranceType type) {
    switch (type) {
      case GuideEntranceType.aiMusicInspiration:
        return "ai_music_inspiration";
      case GuideEntranceType.aiMusicMaster:
        return "ai_music_master";
      case GuideEntranceType.aiMusicExclusive:
        return "ai_music_exclusive";
    }
  }

  //获取攻略数据
  getGuideData({
    required GuideEntranceType type,
    required void Function(GuidePopBean data) onSuccess,
  }) {
    HttpUtils.get(
      GuideApi.guidePopPage,
      {
        "type": getRouteName(type),
        "system": Platform.isIOS ? 1 : 2,
      },
      showMsgWhenFailed: false,
      success: (data) {
        try {
          final success = data["status"] == 200;
          if (!success) {
            return onSuccess(GuidePopBean());
          }
          final Map<String, dynamic> items = data["data"] ?? {};
          // print("+++++++++++++=> $data");
          if (items.isEmpty) {
            guideData.value = GuidePopBean();
            onSuccess(guideData.value);
            return;
          }

          // 尝试解析数据，如果失败则返回空对象
          try {
            guideData.value = GuidePopBean.fromJson(items);
            onSuccess(guideData.value);
          } catch (e) {
            guideData.value = GuidePopBean();
            onSuccess(guideData.value);
          }
        } catch (e) {
          guideData.value = GuidePopBean();
          onSuccess(guideData.value);
        }
      },
      fail: (code, msg) {
        guideData.value = GuidePopBean();
        onSuccess(guideData.value);
      },
    );
  }
}
