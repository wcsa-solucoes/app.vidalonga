import 'dart:async';

import 'package:app_vida_longa/core/helpers/field_format_helper.dart';
import 'package:app_vida_longa/core/services/auth_service.dart';
import 'package:app_vida_longa/core/services/user_service.dart';
import 'package:app_vida_longa/domain/models/response_model.dart';
import 'package:app_vida_longa/domain/models/user_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial(newUser: UserService.instance.user)) {
    on<AuthSignInEvent>(_signIn);
    on<AuthGoogleSocialLoginEvent>(_googleSignIn);
    on<AuthAppleSocialLoginEvent>(_appleSignIn);
    on<AuthLoadingEvent>(_setLoading);
    on<AuthSignUpEvent>(_register);
    on<AuthSignOutEvent>(_signOut);
    on<AuthRecoveryPasswordEvent>(_recoveryPassword);
  }

  late bool _isEnabled = true;

  final UserService _userService = UserService.instance;
  final AuthService _authService = AuthService.instance;

  UserModel _user = UserModel.empty();

  FutureOr<void> _signIn(AuthSignInEvent event, Emitter<AuthState> emit) async {
    add(AuthLoadingEvent());

    if (!_isEnabled) {
      return;
    }
    _isEnabled = false;

    final ResponseStatusModel response =
        await _authService.signInUsingEmailPassword(
      email: event.email,
      password: event.password,
    );

    if (response.status == ResponseStatusEnum.failed) {
      _displaySnackBar(response);
      emit(AuthInitial());
    } else {
      _isEnabled = true;
      emit(AuthSuccess(newUser: _user, canPop: event.canPop));
    }
  }

  FutureOr<void> _googleSignIn(
      AuthGoogleSocialLoginEvent event, Emitter<AuthState> emit) async {
    add(AuthLoadingEvent());

    final ResponseStatusModel response = await _authService.googleSignIn();

    if (response.status == ResponseStatusEnum.failed) {
      _displaySnackBar(response);
      emit(AuthInitial());
    } else {
      _isEnabled = true;
      emit(AuthSuccess(newUser: _user, canPop: event.canPop));
    }
  }

  FutureOr<void> _appleSignIn(
      AuthAppleSocialLoginEvent event, Emitter<AuthState> emit) async {
    add(AuthLoadingEvent());

    final ResponseStatusModel response = await _authService.appleSignIn();

    if (response.status == ResponseStatusEnum.failed) {
      _displaySnackBar(response);
      emit(AuthInitial());
    } else {
      _isEnabled = true;
      emit(AuthSuccess(newUser: _user, canPop: event.canPop));
    }
  }

  FutureOr<void> _register(
      AuthSignUpEvent event, Emitter<AuthState> emit) async {
    add(AuthLoadingEvent()); // _setLoading();

    _user = _userService.user;

    _user = _user.copyWith(
      name: event.name,
      phone: FieldFormatHelper.phone(phone: event.phone),
      // document: FieldFormatHelper.register(register: event.cpf),
      email: event.email,
    );

    // _user.name = event.name;
    // _user.phone = FieldFormatHelper.phone(phone: event.phone);
    // _user.document = FieldFormatHelper.register(register: event.cpf);
    // _user.email = event.email;

    final ResponseStatusModel response =
        await _authService.register(_user, event.password, _user.name);

    if (response.status == ResponseStatusEnum.success) {
      _userService.initUser();
      await Future.delayed(const Duration(milliseconds: 500), () {
        emit(AuthInitial(newUser: _user));
      });
      return;
    }

    emit(AuthInitial(newUser: UserModel.empty()));
  }

  FutureOr<void> _setLoading(
      AuthLoadingEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
  }

  void _displaySnackBar(ResponseStatusModel response) {
    // emit(state.copyWith(status: AuthStatus.initial));

    Future.delayed(const Duration(seconds: 3), () {
      _isEnabled = true;
    });
  }

  void _signOut(AuthSignOutEvent event, Emitter<AuthState> emit) {
    AuthService.logout();
    emit(AuthInitial(newUser: UserModel.empty()));
  }

  void _recoveryPassword(
      AuthRecoveryPasswordEvent event, Emitter<AuthState> emit) {
    _authService.sendPasswordResetEmail(email: event.email);
  }
}
