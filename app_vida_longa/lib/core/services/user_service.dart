import 'dart:async';

import 'package:app_vida_longa/core/helpers/app_helper.dart';
import 'package:app_vida_longa/core/helpers/field_format_helper.dart';
import 'package:app_vida_longa/core/repositories/user_repository.dart';
import 'package:app_vida_longa/domain/enums/custom_exceptions_codes_enum.dart';
import 'package:app_vida_longa/domain/enums/user_service_status_enum.dart';
import 'package:app_vida_longa/domain/models/response_model.dart';
import 'package:app_vida_longa/domain/models/user_model.dart';
import 'package:app_vida_longa/src/core/navigation_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:tuple/tuple.dart';

class UserService {
  UserService._internal();
  static final UserService _instance = UserService._internal();
  static UserService get instance => _instance;
  static bool _hasInit = false;

  late UserModel _user = UserModel();
  UserModel get user => _user;

  late final UserRepository _userRepository = UserRepository();

  late UserServiceStatusEnum _status = UserServiceStatusEnum.loggedOut;

  UserServiceStatusEnum get status => _status;

  final StreamController<UserModel> _userController =
      StreamController<UserModel>.broadcast();

  Stream<UserModel> get userStream => _userController.stream;

  late bool _hasSentValidationEmail = false;

  static void init() {
    if (!_hasInit) {
      _hasInit = true;
    }
  }

  void handleUserLogout() {
    _user = UserModel();

    if (_status != UserServiceStatusEnum.accountedCreated) {
      _status = UserServiceStatusEnum.loggedOut;
    }

    _hasSentValidationEmail = false;
  }

  void handleCallBack() async {
    if (_status == UserServiceStatusEnum.accountedCreated) {
      _handleValidate();
      // TODO(any): redirecionar para pagina de conta criada e depoois pra login
      return;
    }

    final ResponseStatusModel response = await get();

    if (response.status == ResponseStatusEnum.failed) {
      if (response.code == WeExceptionCodesEnum.firebaseAuthUserNotFound) {
        user.id = FirebaseAuth.instance.currentUser!.uid;
        user.email = FirebaseAuth.instance.currentUser!.email!;

        unawaited(_handleSendEmail());
      }
    }

    _handleValidate();
  }

  Future<ResponseStatusModel> create(UserModel user) async {
    _status = UserServiceStatusEnum.accountedCreated;
    user.id = FirebaseAuth.instance.currentUser!.uid;
    _setUser(user);
    return await _userRepository.create(user);
  }

  Future<ResponseStatusModel> get() async {
    final Tuple2<ResponseStatusModel, UserModel> data =
        await _userRepository.get();

    if (data.item1.status == ResponseStatusEnum.success) {
      _setUser(data.item2);
    }

    return data.item1;
  }

  void _setUser(UserModel user) {
    _user = user;
  }

  void _validateUser() {
    if (_status == UserServiceStatusEnum.accountedCreated) {
      return;
    }
    _status = UserServiceStatusEnum.valid;

    if (!FirebaseAuth.instance.currentUser!.emailVerified) {
      AppHelper.displayAlertInfo("Verifique seu e-mail para ativar sua conta");
      return;
    }
  }

  Future<void> _handleValidate() async {
    _validateUser();
    _handleRedirectStatus();
  }

  Future<ResponseStatusModel> validateRegister(String register) async {
    final Tuple2<ResponseStatusModel, bool> data = await _userRepository
        .verifyRegister(FieldFormatHelper.register(register: register));

    if (data.item2) {
      data.item1.status = ResponseStatusEnum.failed;
      AppHelper.displayAlertError("CPF já cadastrado");
    }

    return data.item1;
  }

  Future<void> _handleSendEmail() async {
    if (!_hasSentValidationEmail) {
      _hasSentValidationEmail = true;

      await FirebaseAuth.instance.currentUser!
          .sendEmailVerification()
          .then((value) => _hasSentValidationEmail = true)
          .onError((error, stackTrace) => _hasSentValidationEmail = false);
    }
  }

  void _handleRedirectStatus() async {
    switch (_status) {
      case UserServiceStatusEnum.valid:
        initUser();
        return;
      case UserServiceStatusEnum.accountedCreated:
        await _handleSendEmail();
        _handleRecentUserRegister();
        break;
      case UserServiceStatusEnum.loggedOut:
        return;
    }
  }

  Future<ResponseStatusModel> update(UserModel user) async {
    user.phone = FieldFormatHelper.phone(phone: user.phone);
    user.document = FieldFormatHelper.register(register: user.document);

    final ResponseStatusModel response = await _userRepository.update(user);

    if (response.status == ResponseStatusEnum.success) {
      _setUser(user);
    }

    _handleValidate();

    return response;
  }

  void initUser() {
    _userRepository.updateListener();
    NavigationController.to("/app/navigation");

    //init others services
  }

  void _handleRecentUserRegister() {
    Modular.to.navigate('/app/auth/register');
  }
}
