import 'dart:async';
import 'dart:io';
import 'package:app_vida_longa/core/helpers/app_helper.dart';
import 'package:app_vida_longa/core/repositories/favorites_repository.dart';
import 'package:app_vida_longa/core/repositories/user_repository.dart';
import 'package:app_vida_longa/core/services/favorites_service.dart';
import 'package:app_vida_longa/core/services/iap_service/iap_purchase_apple_service.dart';
import 'package:app_vida_longa/core/services/iap_service/iap_purchase_google_service.dart';
import 'package:app_vida_longa/core/services/iap_service/interface/iap_purchase_service_interface.dart';
import 'package:app_vida_longa/core/services/plans_service.dart';
import 'package:app_vida_longa/core/services/subscription_service.dart';
import 'package:app_vida_longa/domain/contants/routes.dart';
import 'package:app_vida_longa/domain/enums/custom_exceptions_codes_enum.dart';
import 'package:app_vida_longa/domain/enums/subscription_type.dart';
import 'package:app_vida_longa/domain/enums/user_service_status_enum.dart';
import 'package:app_vida_longa/domain/models/response_model.dart';
import 'package:app_vida_longa/domain/models/user_model.dart';
import 'package:app_vida_longa/src/core/navigation_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
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

  final SubscriptionService _subscriptionService = SubscriptionService();

  Stream<UserModel> get userStream => _userRepository.userStream;

  late bool _hasSentValidationEmail = false;

  static void init() {
    _instance._userRepository.userStream.listen((event) {
      _instance._setUser(event);
    });
    if (!_hasInit) {
      _hasInit = true;
    }
  }

  Future<void> uploadPhoto(String url) async {
    _user = user.copyWith(photoUrl: url);
    _userRepository.update(_user);
  }

  void handleUserLogout() {
    _user = UserModel();

    if (_status != UserServiceStatusEnum.accountedCreated) {
      _status = UserServiceStatusEnum.loggedOut;
    }
    _status = UserServiceStatusEnum.loggedOut;

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
        _user = user.copyWith(
          id: FirebaseAuth.instance.currentUser!.uid,
          email: FirebaseAuth.instance.currentUser!.email!,
        );

        unawaited(_handleSendEmail());
      }
    }

    _handleValidate();
  }

  Future<ResponseStatusModel> create(UserModel user) async {
    _status = UserServiceStatusEnum.accountedCreated;
    user = user.copyWith(id: FirebaseAuth.instance.currentUser!.uid);

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
    user = user.copyWith(
      phone: user.phone,
    );

    final ResponseStatusModel response = await _userRepository.update(user);

    if (response.status == ResponseStatusEnum.success) {
      _setUser(user);
    }

    _handleValidate();

    return response;
  }

  void initUser() async {
    _userRepository.updateListener();
    IFavoritesRepository favoritesRepository =
        FavoritesRepositoryImpl(FirebaseFirestore.instance);

    IFavoritesService favoritesService = FavoritesServiceImpl.instance;

    favoritesService.init(favoritesRepository, user.id);

    late final IInAppPurchaseService paymentService;

    if (Platform.isAndroid) {
      paymentService = InAppPurchaseImplServiceGoogleImpl.instance;
    } else {
      paymentService = InAppPurchaseImplServicesAppleImpl.instance;
    }

    PlansServiceImpl.instance.getPlans().then((value) {
      paymentService.init(InAppPurchase.instance);
    });
    //verify if path contains routes.app.home
    for (var element in Modular.to.navigateHistory) {
      if (element.name.contains(routes.app.home.path)) {
        return;
      }
    }

    NavigationController.to(routes.app.profile.path);
  }

  void _handleRecentUserRegister() {
    Modular.to.navigate(routes.app.profile.path);
  }

  Future<void> updateSubscriberStatusFromRoles(
      SubscriptionEnum subscriptionType, String platform) async {
    _user = _user.copyWith(subscriptionLevel: subscriptionType);
    _setUser(_user);
    await _subscriptionService.updateSubscriberStatusFromRoles(
        subscriptionType, platform);
  }
}
