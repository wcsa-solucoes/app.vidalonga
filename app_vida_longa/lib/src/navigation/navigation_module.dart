import 'package:app_vida_longa/src/navigation/views/navigation_view.dart';
import 'package:flutter_modular/flutter_modular.dart';

class NavigationModule extends Module {
  @override
  void routes(r) {
    r.child(
      "/",
      child: (context) => const NavigationView(),
    );
  }
}
