part of 'qa_bloc.dart';

@immutable
sealed class QAState {}

final class QAInitial extends QAState {}

final class QALoading extends QAState {}

final class QALoaded extends QAState {
  final List<QuestionAnswerModel> questions;
  final List<QuestionAnswerModel> myQuestions;

  QALoaded({
    required this.questions,
    required this.myQuestions,
  });
}

final class QAError extends QAState {
  final String message;

  QAError(this.message);
}

final class QuestionAdded extends QAState {}
