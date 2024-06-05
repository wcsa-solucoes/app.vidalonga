import 'package:app_vida_longa/src/auth/views/login_view.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AuthModule extends Module {
  @override
  void routes(r) {
    r.child("/", child: (context) => const LoginView());
  }
}
