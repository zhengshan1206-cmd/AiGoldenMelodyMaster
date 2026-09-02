

///用户管理工具
class UserManagerUtil {
  static final UserManagerUtil _instance = UserManagerUtil._internal();
  factory UserManagerUtil() {
    return _instance;
  }
  UserManagerUtil._internal();

  /// 用户登录方法
  void login(String userId, String username, String email) {
    print('用户 $username 已登录');
  }

  /// 用户登出方法
  void logout() {
    print('用户已登出');
  }

  /// 检查用户是否已登录
  bool isUserLoggedIn() {
    return false;
  }

  ///更新用户信息
  void updateUserInfo({String? username, String? email}) {
    print('用户信息已更新');
  }
}
