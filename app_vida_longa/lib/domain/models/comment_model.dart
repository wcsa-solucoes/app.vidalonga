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
    // required this.authorPhotoUrl,
    required this.createdAt,
    required this.articleId,
  });

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      docId: map["comment"]['doc_id'] as String,
      text: map["comment"]['text'] as String,
      author: map["comment"]['author'] as String,
      authorId: map["comment"]['author_id'] as String,
      // authorPhotoUrl: map['author_photo_url'] as String,
      createdAt: map["comment"]['created_at'],
      articleId: map["comment"]['article_id'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'doc_id': docId,
      'text': text,
      'author': author,
      'author_id': authorId,
      // 'author_photo_url': authorPhotoUrl,
      'created_at': createdAt,
      'article_id': articleId,
    };
  }
}
