import 'package:app_vida_longa/app_module.dart';
import 'package:flutter_modular/flutter_modular.dart';

class MainModule extends Module {
  @override
  void routes(r) {
    r.module('/', module: AppModule());
  }
}
