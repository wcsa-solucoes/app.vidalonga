import 'dart:async';
import 'package:app_vida_longa/core/helpers/app_helper.dart';
import 'package:app_vida_longa/core/services/questions_and_answers_service.dart';
import 'package:app_vida_longa/core/services/user_service.dart';
import 'package:app_vida_longa/core/utils/string_util.dart';
import 'package:app_vida_longa/domain/enums/user_service_status_enum.dart';
import 'package:app_vida_longa/domain/models/question_answer_model.dart';
import 'package:app_vida_longa/domain/models/response_model.dart';
import "package:flutter_bloc/flutter_bloc.dart";
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';

part 'qa_event.dart';
part 'qa_state.dart';

class QABloc extends Bloc<QAEvent, QAState> {
  QABloc() : super(QAInitial()) {
    on<FetchQuestionsEvent>(_handleOnFetch);
    on<LoadingQuestionsEvent>(_handleOnLoading);
    on<LoadedQuestionsEvent>(_handleOnLoaded);
    on<QuestionsSearchEvent>(_handleSearchFromTitle);
    on<AddQuestionEvent>(_handleOnAddQuestion);
    on<RestartQuestionsEvent>(_handleRestartQuestions);

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

  Future<void> _handleSearchFromTitle(
      QuestionsSearchEvent event, Emitter<QAState> emit) async {
    emit(QALoading());

    final List<QuestionAnswerModel> tempQAs = [];

    for (var element in _questions) {
      final String normalizedSearchTerm = removeDiacritics(event.searchTerm);
      final List<QuestionAnswerModel> temp = element.where((element) {
        final String normalizedTitle = removeDiacritics(element.question);
        return normalizedTitle.toLowerCase().contains(normalizedSearchTerm);
      }).toList();

      if (temp.isNotEmpty) {
        for (var element in temp) {
          tempQAs.add(element);
        }
      }
    }

    emit(
      QALoaded(questions: tempQAs, myQuestions: filterList),
    );
  }

  List<List<QuestionAnswerModel>> get _questions => _qaService.qaList
          .fold<List<List<QuestionAnswerModel>>>(<List<QuestionAnswerModel>>[],
              (previousValue, element) {
        previousValue.add(<QuestionAnswerModel>[element]);

        return previousValue;
      });

  FutureOr<void> _handleOnAddQuestion(
      AddQuestionEvent event, Emitter<QAState> emit) async {
    if (_verifyIfExceedTheLimit()) {
      AppHelper.displayAlertError(
          'Você pode fazer apenas 3 perguntas por mês!');
      return;
    }

    add(LoadingQuestionsEvent());
    final ResponseStatusModel response =
        await _qaService.addQuestion(event.question, event.isAnonymous);

    if (response.status == ResponseStatusEnum.success) {
      emit(QuestionAdded());
      AppHelper.displayAlertSuccess('Pergunta enviada com sucesso!');
      return;
    }
    emit(QAError("Erro ao adicionar pergunta."));
  }

  bool _verifyIfExceedTheLimit() {
    DateFormat dateFormat = DateFormat("dd-MM-yyyy HH:mm:ss");
    DateTime now = DateTime.now();
    int currentMonth = now.month;
    int currentYear = now.year;

    int qty = 0;
    for (var element in _qaService.qaList) {
      DateTime dateTime = dateFormat.parse(element.createdAt);
      int month = dateTime.month;
      int year = dateTime.year;

      if (UserService.instance.user.id == element.userId &&
          (currentMonth == month && currentYear == year)) {
        qty++;
      }
    }

    if (qty >= 3) {
      return true;
    } else {
      return false;
    }
  }

  void _handleRestartQuestions(
      RestartQuestionsEvent event, Emitter<QAState> emit) {
    emit(QALoaded(myQuestions: filterList, questions: _qaService.qaList));
  }
}
