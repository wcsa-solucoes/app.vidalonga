class AnswerModel {
  final String type;
  final String? answer;

  AnswerModel({
    this.type = "",
    this.answer = "",
  });

  factory AnswerModel.fromMap(Map<String, dynamic> map) {
    return AnswerModel(
      type: map['type'] as String,
      answer: map['answer'] ?? "",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'answer': answer,
    };
  }
}
