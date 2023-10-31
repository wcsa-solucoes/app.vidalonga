// ignore_for_file: depend_on_referenced_packages

import 'dart:async';

import 'package:app_vida_longa/core/helpers/field_format_helper.dart';
import 'package:app_vida_longa/core/services/auth_service.dart';
import 'package:app_vida_longa/core/services/user_service.dart';
import 'package:app_vida_longa/domain/models/response_model.dart';
import 'package:app_vida_longa/domain/models/user_model.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial(newUser: UserService.instance.user)) {
    on<AuthSignInEvent>(_signIn);
    on<AuthLoadingEvent>(_setLoading);
    on<AuthSignUpEvent>(_register);
  }

  late bool _isEnabled = false;

  final UserService _userService = UserService.instance;
  final AuthService _authService = AuthService.instance;

  UserModel _user = UserModel.empty();

  FutureOr<void> _signIn(AuthSignInEvent event, Emitter<AuthState> emit) async {
    add(AuthLoadingEvent());

    if (!_isEnabled) {
      // _handleWaitSnackBar();//aguarde
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
    } else {
      _isEnabled = true;
    }
  }

  FutureOr<void> _register(
      AuthSignUpEvent event, Emitter<AuthState> emit) async {
    add(AuthLoadingEvent()); // _setLoading();

    _user = _userService.user;

    _user.name = event.name;
    _user.phone = FieldFormatHelper.phone(phone: event.phone);
    _user.document = FieldFormatHelper.register(register: event.cpf);
    _user.email = event.email;

    final ResponseStatusModel hasRegister =
        await _userService.validateRegister(event.cpf);

    if (hasRegister.status == ResponseStatusEnum.failed) {
      return;
    }

    final ResponseStatusModel response =
        await _authService.register(_user, event.password);

    if (response.status == ResponseStatusEnum.success) {
      _userService.initUser();
      await Future.delayed(const Duration(milliseconds: 500), () {
        emit(AuthInitial(newUser: _user));
      });
      return;
    }

    emit(AuthInitial(newUser: _user));
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
}
