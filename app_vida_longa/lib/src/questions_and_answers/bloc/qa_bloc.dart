import 'dart:async';
import 'package:app_vida_longa/core/services/questions_and_answers_service.dart';
import 'package:app_vida_longa/domain/models/question_answer_model.dart';
import 'package:app_vida_longa/domain/models/response_model.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'qa_event.dart';
part 'qa_state.dart';

class QABloc extends Bloc<QAEvent, QAState> {
  QABloc() : super(QAInitial()) {
    on<FetchQuestionsEvent>(_handleOnFetch);
    on<LoadingQuestionsEvent>(_handleOnLoading);
    on<LoadedQuestionsEvent>(_handleOnLoaded);

    if (_qaService.qaList.isEmpty) {
      add(FetchQuestionsEvent());
    } else {
      add(LoadedQuestionsEvent());
    }
  }

  final IQAService _qaService = QAServiceImpl.instance;

  FutureOr<void> _handleOnFetch(
      FetchQuestionsEvent event, Emitter<QAState> emit) async {
    //
    add(LoadingQuestionsEvent());
    final ResponseStatusModel response = await _qaService.getAll();
    if (response.status == ResponseStatusEnum.success) {
      emit(QALoaded(_qaService.qaList));
      return;
    }
    emit(QAError("Erro ao carregar perguntas."));
  }

  FutureOr<void> _handleOnLoading(
      LoadingQuestionsEvent event, Emitter<QAState> emit) {
    //
  }

  FutureOr<void> _handleOnLoaded(
      LoadedQuestionsEvent event, Emitter<QAState> emit) {
    emit(QALoaded(_qaService.qaList));
  }
}
