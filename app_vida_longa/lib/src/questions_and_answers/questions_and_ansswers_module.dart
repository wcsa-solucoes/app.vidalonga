import 'package:app_vida_longa/src/questions_and_answers/views/questions_and_answers_view.dart';
import 'package:flutter_modular/flutter_modular.dart';

class QuestionAndAnswersModule extends Module {
  @override
  void binds(Injector i) {
    // i.add(QaBloc.new);
    super.binds(i);
  }

  @override
  void routes(r) {
    r.child("/", child: (context) => const QuestionsAndAnswersView());
  }
}
