import 'package:app_vida_longa/src/questions_and_answers/views/health_info_result_view.dart';
import 'package:app_vida_longa/src/questions_and_answers/views/helth_info_options_view.dart';
import 'package:app_vida_longa/src/questions_and_answers/views/new_question_view.dart';
import 'package:app_vida_longa/src/questions_and_answers/views/questions_and_answers_view.dart';
import 'package:app_vida_longa/src/questions_and_answers/views/some_question_view.dart';
import 'package:flutter_modular/flutter_modular.dart';

class QuestionAndAnswersModule extends Module {
  @override
  void routes(r) {
    r.child("/", child: (context) => const QuestionsAndAnswersView());
    r.child(
      "/question",
      child: (context) => SomeQuestionView(question: r.args.data),
    );
    r.child(
      "/newQuestion",
      child: (context) => NewQuestionView(qaBloc: r.args.data),
    );
    r.child("/helthInfo", child: (context) => const HealthInfoOptionsView());
    r.child("/helthResult", child: (context) => HealthInfoResultView());
  }
}
