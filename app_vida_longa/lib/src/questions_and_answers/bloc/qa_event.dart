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

class QuestionsSearchEvent extends QAEvent {
  final String searchTerm;
  QuestionsSearchEvent(this.searchTerm);
}

class AddQuestionEvent extends QAEvent {
  final String question;
  final bool isAnonymous;
  AddQuestionEvent(this.question, this.isAnonymous);
}

class RestartQuestionsEvent extends QAEvent {
  RestartQuestionsEvent();
}
