import 'dart:async';
import 'package:app_vida_longa/core/helpers/app_helper.dart';
import 'package:app_vida_longa/core/services/questions_and_answers_service.dart';
import 'package:app_vida_longa/core/services/user_service.dart';
import 'package:app_vida_longa/domain/enums/user_service_status_enum.dart';
import 'package:app_vida_longa/domain/models/question_answer_model.dart';
import 'package:app_vida_longa/domain/models/response_model.dart';
import "package:flutter_bloc/flutter_bloc.dart";
import 'package:meta/meta.dart';

part 'qa_event.dart';
part 'qa_state.dart';

class QABloc extends Bloc<QAEvent, QAState> {
  QABloc() : super(QAInitial()) {
    on<FetchQuestionsEvent>(_handleOnFetch);
    on<LoadingQuestionsEvent>(_handleOnLoading);
    on<LoadedQuestionsEvent>(_handleOnLoaded);
    on<AddQuestionEvent>(_handleOnAddQuestion);

    if (_qaService.qaList.isEmpty) {
      add(FetchQuestionsEvent());
    } else {
      add(LoadedQuestionsEvent());
    }
  }

  final List<QuestionAnswerModel> myQuestions = [];

  final IQAService _qaService = QAServiceImpl.instance;

  FutureOr<void> _handleOnFetch(
      FetchQuestionsEvent event, Emitter<QAState> emit) async {
    add(LoadingQuestionsEvent());
    final ResponseStatusModel response = await _qaService.getAll();

    if (response.status == ResponseStatusEnum.success) {
      emit(QALoaded(myQuestions: filterList, questions: _qaService.qaList));
      return;
    }
    emit(QAError("Erro ao carregar perguntas."));
  }

  FutureOr<void> _handleOnLoading(
          LoadingQuestionsEvent event, Emitter<QAState> emit) =>
      {emit(QALoading())};

  FutureOr<void> _handleOnLoaded(
          LoadedQuestionsEvent event, Emitter<QAState> emit) =>
      {emit(QALoaded(myQuestions: filterList, questions: _qaService.qaList))};

  List<QuestionAnswerModel> get filterList {
    List<QuestionAnswerModel> tempQuestions = [];
    if (UserService.instance.status != UserServiceStatusEnum.loggedOut) {
      for (var element in _qaService.qaList) {
        if (element.userId == UserService.instance.user.id) {
          tempQuestions.add(element);
        }
      }
    }

    return tempQuestions;
  }

  FutureOr<void> _handleOnAddQuestion(
      AddQuestionEvent event, Emitter<QAState> emit) async {
    add(LoadingQuestionsEvent());
    final ResponseStatusModel response =
        await _qaService.addQuestion(event.question, event.isAnonymous);

    if (response.status == ResponseStatusEnum.success) {
      emit(QuestionAdded());
      AppHelper.displayAlertSuccess('Pergunta realizada enviada.');
      return;
    }
    emit(QAError("Erro ao adicionar pergunta."));
  }
}
