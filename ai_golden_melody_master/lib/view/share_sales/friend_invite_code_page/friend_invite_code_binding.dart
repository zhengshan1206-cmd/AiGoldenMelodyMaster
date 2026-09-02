
import 'package:get/get.dart';

import 'friend_invite_code_troller.dart';

class FriendInviteCodeBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => FriendInviteCodeController());
  }

}