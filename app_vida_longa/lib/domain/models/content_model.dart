class ContentModel {
  late String type = "";
  late String content = "";

  ContentModel({
    this.type = "",
    this.content = "",
  });

  factory ContentModel.fromMap(Map<String, dynamic> map) {
    return ContentModel(
      type: map['type'] as String,
      content: map['content'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'content': content,
    };
  }
}
