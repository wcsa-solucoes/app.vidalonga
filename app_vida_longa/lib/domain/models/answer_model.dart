class AnswerModel {
  late String type = "";
  late String answer = "";

  AnswerModel({
    this.type = "",
    this.answer = "",
  });

  factory AnswerModel.fromMap(Map<String, dynamic> map) {
    return AnswerModel(
      type: map['type'] as String,
      answer: map['answer'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'answer': answer,
    };
  }
}
