part of 'auth_bloc.dart';

sealed class AuthState {
  late UserModel? user;
  late ResponseStatusModel? response;
  AuthState(
    this.user,
    this.response,
  );
}

final class AuthInitial extends AuthState {
  final UserModel? newUser;
  AuthInitial({this.newUser}) : super(newUser ?? UserModel.empty(), null);
}

final class AuthSuccess extends AuthState {
  final UserModel? newUser;
  final ResponseStatusModel? newResponse;
  final bool? canPop;

  AuthSuccess({
    this.newUser,
    this.newResponse,
    this.canPop = false,
  }) : super(newUser ?? UserModel.empty(), newResponse);
}

final class AuthLoading extends AuthState {
  final UserModel? newUser;
  final ResponseStatusModel? newResponse;

  AuthLoading({this.newUser, this.newResponse})
      : super(newUser ?? UserModel.empty(), newResponse);
}
