part of 'qa_bloc.dart';

@immutable
sealed class QAEvent {}

class FetchQuestionsEvent extends QAEvent {
  FetchQuestionsEvent();
}

class FetchAnswersEvent extends QAEvent {
  FetchAnswersEvent();
}

class LoadingQuestionsEvent extends QAEvent {
  LoadingQuestionsEvent();
}

class LoadedQuestionsEvent extends QAEvent {
  LoadedQuestionsEvent();
}
