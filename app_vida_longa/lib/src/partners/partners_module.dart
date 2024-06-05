import 'package:app_vida_longa/src/partners/views/benefit_details.dart';
import 'package:app_vida_longa/src/partners/views/partners_view.dart';
import 'package:flutter_modular/flutter_modular.dart';

class PartnersModule extends Module {
  @override
  void routes(r) {
    r.child("/", child: (context) => const PartnersView());
    r.child("/benefitDetails", child: (context) => const BenefitsDetailsView());
  }
}
