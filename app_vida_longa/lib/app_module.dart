import 'package:app_vida_longa/app_wrap_view.dart';
import 'package:app_vida_longa/src/auth/auth_module.dart';
import 'package:app_vida_longa/src/categories/categories_module.dart';
import 'package:app_vida_longa/src/home/home_module.dart';
import 'package:app_vida_longa/src/navigation/navigation_module.dart';
import 'package:app_vida_longa/src/partners/partners_module.dart';
import 'package:app_vida_longa/src/profile/profile_module.dart';
import 'package:app_vida_longa/src/questions_and_answers/questions_and_ansswers_module.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AppModule extends Module {
  @override
  void binds(i) {}

  @override
  void routes(r) {
    r.child("/app", child: (context) => const AppWrapView(), children: [
      ModuleRoute("/auth", module: AuthModule()),
      ModuleRoute("/profile", module: ProfileModule()),
      ModuleRoute("/navigation", module: NavigationModule()),
      ModuleRoute("/home", module: HomeModule()),
      ModuleRoute("/categories", module: CategoriesModule()),
      ModuleRoute("/questionsAndAnswers", module: QuestionAndAnswersModule()),
      ModuleRoute("/partners", module: PartnersModule()),
    ]);
  }
}
