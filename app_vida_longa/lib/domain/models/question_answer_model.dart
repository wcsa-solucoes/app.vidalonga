import 'package:app_vida_longa/domain/models/answer_model.dart';

class QuestionAnswerModel {
  final bool isAnonymous;
  final bool alreadyAnswered;
  final String userId;
  final String? uuid;
  final String question;
  final String createdAt;
  final String? answeredAt;
  final List<AnswerModel> answers;
  final int createdAtMillisecondsSinceEpoch;

  QuestionAnswerModel({
    required this.isAnonymous,
    required this.alreadyAnswered,
    required this.userId,
    this.uuid,
    required this.question,
    required this.createdAt,
    this.answeredAt,
    required this.answers,
    required this.createdAtMillisecondsSinceEpoch,
  });

  factory QuestionAnswerModel.fromMap(Map<String, dynamic> json) {
    return QuestionAnswerModel(
      isAnonymous: json['isAnonymous'],
      alreadyAnswered: json['alreadyAnswered'],
      userId: json['userId'],
      uuid: json['uuid'],
      question: json['question'],
      createdAt: json['createdAt'],
      answeredAt: json['answeredAt'],
      answers: (json['answers'] as List<dynamic>)
          .map((e) => AnswerModel.fromMap(e as Map<String, dynamic>))
          .toList(),
      createdAtMillisecondsSinceEpoch: json['createdAtMillisecondsSinceEpoch'],
    );
  }

  factory QuestionAnswerModel.newQuestion({
    required bool isAnonymous,
    required String createdAt,
    required String userId,
    required String question,
  }) {
    return QuestionAnswerModel(
      isAnonymous: isAnonymous,
      alreadyAnswered: false,
      userId: userId,
      question: question,
      createdAt: createdAt,
      answeredAt: null,
      answers: [],
      createdAtMillisecondsSinceEpoch: DateTime.now().millisecondsSinceEpoch,
    );
  }

  Map<String, dynamic> newQuestionToMap(String docId) {
    return {
      'isAnonymous': isAnonymous,
      'alreadyAnswered': alreadyAnswered,
      'userId': userId,
      'uuid': docId,
      'question': question,
      'createdAt': createdAt,
      'answeredAt': null,
      'answers': answers.map((e) => e.toMap()).toList(),
      'createdAtMillisecondsSinceEpoch': createdAtMillisecondsSinceEpoch,
    };
  }
}
