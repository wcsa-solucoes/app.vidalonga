import 'package:app_vida_longa/src/benefits/views/benefits_view.dart';
import 'package:flutter_modular/flutter_modular.dart';

class BenefitsModule extends Module {
  @override
  void routes(r) {
    r.child("/", child: (context) => const BenefitsView());
  }
}
