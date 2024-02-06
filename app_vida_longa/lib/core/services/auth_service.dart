import "dart:async";
import "package:app_vida_longa/core/controllers/notification_controller.dart";
import "package:app_vida_longa/core/helpers/app_helper.dart";
import "package:app_vida_longa/core/repositories/auth_repository.dart";
import "package:app_vida_longa/core/services/user_service.dart";
import "package:app_vida_longa/domain/contants/routes.dart";
import "package:app_vida_longa/domain/models/response_model.dart";
import "package:app_vida_longa/domain/models/user_model.dart";
import "package:app_vida_longa/src/core/navigation_controller.dart";
import "package:firebase_auth/firebase_auth.dart";

class AuthService {
  AuthService._internal();

  static final AuthService _instance = AuthService._internal();

  static AuthService get instance => _instance;

  static bool _hasInit = false;

  static void init() async {
    if (!_hasInit) {
      _hasInit = true;
      instance._init();
    }
  }

  final UserService _userService = UserService.instance;
  final AuthRepository _authRepository = AuthRepository();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get getCurrentUser => _auth.currentUser;

  Future<ResponseStatusModel> signInUsingEmailPassword({
    required String email,
    required String password,
  }) async {
    final ResponseStatusModel response = await _authRepository
        .signInUsingEmailPassword(email: email, password: password);

    if (response.status == ResponseStatusEnum.success) {
      await _userService.get();
    } else {
      NotificationController.alert(response: response);
    }

    return response;
  }

  Future<ResponseStatusModel> sendPasswordResetEmail({
    required String email,
  }) async {
    final ResponseStatusModel response =
        await _authRepository.sendPasswordResetEmail(email: email);

    if (response.status == ResponseStatusEnum.success) {
      AppHelper.displayAlertSuccess(
          "Verifique seu email para recuperar sua senha.");
    } else {
      NotificationController.alert(response: response);
    }

    return response;
  }

  Future<ResponseStatusModel> sendEmailValidation() async {
    return await _authRepository.sendEmailValidation();
  }

  Future<ResponseStatusModel> register(
      UserModel user, String password, String name) async {
    user = user.copyWith(phone: user.phone);

    final ResponseStatusModel response =
        await _authRepository.register(user, password, name);

    if (response.status == ResponseStatusEnum.success) {
      unawaited(_userService.create(user));
    } else {
      NotificationController.alert(response: response);
    }

    return response;
  }

  static void logout() async {
    try {
      await FirebaseAuth.instance
          .signOut()
          .onError((error, stackTrace) => null);

      UserService.instance.handleUserLogout();
      // LocalStorageService.instance.insertValueInsideMapKey(
      //     LocalStorageConstants.kKeyUserSettings,
      //     LocalStorageConstants.favoriteCity,
      //     AppConstants.kNotAvailable);
    } catch (error) {
      throw Exception(error);
    }
  }

  void _authStatusListener() {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        _handleDisconnectedRedirect();
        _userService.handleUserLogout();
        return;
      }
      _userService.handleCallBack();
    });
  }

  void _handleDisconnectedRedirect() {
    NavigationController.to(routes.app.auth.login.path);
  }

  Future<bool> changePassword(String password) async {
    final User? user = _auth.currentUser;

    if (user == null) {
      return false;
    }
    try {
      await user.updatePassword(password);
      NotificationController.alert(
          response: ResponseStatusModel(
              status: ResponseStatusEnum.success,
              message: "Senha alterada com sucesso!"));
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        NotificationController.alert(
            response: ResponseStatusModel(
                status: ResponseStatusEnum.error,
                message: "Senha muito fraca."));
      } else if (e.code == 'requires-recent-login') {
        NotificationController.alert(
            response: ResponseStatusModel(
                status: ResponseStatusEnum.error,
                message: "Faça login novamente para alterar a senha."));
      }
    } catch (e) {
      NotificationController.alert(
          response: ResponseStatusModel(
              status: ResponseStatusEnum.error,
              message: "Não foi possível alterar a senha."));
    }

    return false;
  }

  void _init() {
    _authStatusListener();
    _handleUser();
  }

  void _handleUser() async {
    final User? user = _auth.currentUser;

    if (user == null) {
      return;
    }

    await user
        .getIdToken(true)
        .then((_) => null)
        .onError((error, stackTrace) async {
      logout();
    });
  }
}
