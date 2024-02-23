import 'package:app_vida_longa/domain/models/answer_model.dart';

class QuestionAnswerModel {
  final bool isAnonymous;
  final bool alreadyAnswered;
  final String userId;
  final String uuid;
  final String question;
  final String createdAt;
  final String answeredAt;
  final List<AnswerModel> answers;

  QuestionAnswerModel({
    required this.isAnonymous,
    required this.alreadyAnswered,
    required this.userId,
    required this.uuid,
    required this.question,
    required this.createdAt,
    required this.answeredAt,
    required this.answers,
  });

  factory QuestionAnswerModel.fromMap(Map<String, dynamic> json) {
    return QuestionAnswerModel(
      isAnonymous: json['isAnonymous'],
      alreadyAnswered: json['alreadyAnswered'],
      userId: json['userId'],
      uuid: json['uuid'],
      question: json['question'],
      createdAt: json['createdAt'],
      answeredAt: json['AnsweredAt'],
      // content: ContentModel.fromMap(json['answers']),
      answers: (json['answers'] as List<dynamic>)
          .map((e) => AnswerModel.fromMap(e as Map<String, dynamic>))
          .toList(),
      // content: json['answers'].map((e) => ContentModel.fromMap(e)).toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'isAnonymous': isAnonymous,
      'alreadyAnswered': alreadyAnswered,
      'userId': userId,
      'uuid': uuid,
      'question': question,
      'createdAt': createdAt,
      'AnsweredAt': answeredAt,
      'answers': answers.map((e) => e.toMap()).toList()
    };
  }
}
