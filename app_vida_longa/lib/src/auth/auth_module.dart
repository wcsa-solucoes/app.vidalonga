import 'package:app_vida_longa/src/auth/views/login_view.dart';
import 'package:app_vida_longa/src/auth/views/register_view.dart';
import 'package:app_vida_longa/src/auth/views/recovery_password.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AuthModule extends Module {
  @override
  void routes(r) {
    r.child("/", child: (context) => const LoginView());
    r.child("/login", child: (context) => const LoginView());
    r.child("/register", child: (context) => const RegisterView());
    r.child("/recovery", child: (context) => const RecoveryPasswordView());
  }
}
