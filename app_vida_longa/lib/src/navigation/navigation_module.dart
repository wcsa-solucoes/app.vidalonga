import 'package:app_vida_longa/src/navigation/views/page_one.dart';
import 'package:flutter_modular/flutter_modular.dart';

class NavigationModule extends Module {
  @override
  void routes(r) {
    r.child(
      "/",
      child: (context) => const PageOne(),
    );
  }
}
