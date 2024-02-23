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

class AddQuestionEvent extends QAEvent {
  final String question;
  final bool isAnonymous;
  AddQuestionEvent(this.question, this.isAnonymous);
}
