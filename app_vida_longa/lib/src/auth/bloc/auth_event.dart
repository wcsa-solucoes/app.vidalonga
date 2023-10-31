part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

final class AuthSignInEvent extends AuthEvent {
  final String email;
  final String password;

  AuthSignInEvent({
    required this.email,
    required this.password,
  });
}

class AuthLoadingEvent extends AuthEvent {}

final class AuthSignOutEvent extends AuthEvent {}

final class AuthSignUpEvent extends AuthEvent {
  final String name;
  final String email;
  final String password;
  final String phone;
  final String cpf;

  AuthSignUpEvent({
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
    required this.cpf,
  });
}
