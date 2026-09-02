import 'package:ai_golden_melody_master/view/me_center/user_profile/user_profile_controller.dart';
import 'package:get/get.dart';

class UserProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserProfileController>(
      () => UserProfileController(),
    );
  }
}
