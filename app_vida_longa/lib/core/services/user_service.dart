class UserService {
  //singleton service
  UserService._internal();
  static final UserService _instance = UserService._internal();
  static UserService get instance => _instance;
  static bool _hasInit = false;
  static void init() {
    if (!_hasInit) {
      _hasInit = true;
    }
  }

  void handleUserLogout() {}
  void handleCallBack() {}
  create(user) {}
  get() {}
}
