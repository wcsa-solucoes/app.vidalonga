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

final class AuthLoading extends AuthState {
  final UserModel? newUser;
  final ResponseStatusModel? newResponse;

  AuthLoading({this.newUser, this.newResponse})
      : super(newUser ?? UserModel.empty(), newResponse);
}
