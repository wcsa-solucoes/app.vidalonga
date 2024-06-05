class CommentModel {
  final String docId;
  final String text;
  final String author;
  final String authorId;
  final int createdAt;
  final String articleId;

  CommentModel({
    required this.docId,
    required this.text,
    required this.author,
    required this.authorId,
    required this.createdAt,
    required this.articleId,
  });

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      docId: map["comment"]['docId'] as String,
      text: map["comment"]['text'] as String,
      author: map["comment"]['author'] as String,
      authorId: map["comment"]['authorId'] as String,
      createdAt: map["comment"]['createdAt'],
      articleId: map["comment"]['articleId'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'docId': docId,
      'text': text,
      'author': author,
      'authorId': authorId,
      'createdAt': createdAt,
      'articleId': articleId,
    };
  }
}
