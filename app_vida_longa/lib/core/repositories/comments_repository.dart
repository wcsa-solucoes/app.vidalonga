import 'package:app_vida_longa/core/controllers/we_exception.dart';
import 'package:app_vida_longa/core/services/articles_service.dart';
import 'package:app_vida_longa/core/services/user_service.dart';
import 'package:app_vida_longa/domain/models/comment_model.dart';
import 'package:app_vida_longa/domain/models/response_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tuple/tuple.dart';
import 'package:uuid/uuid.dart';

abstract class ICommentsRepository {
  Future<Tuple2<ResponseStatusModel, List<CommentModel>>> getComments(
      String articleId);
  Future<Tuple2<ResponseStatusModel, CommentModel>> createComment(
      String comment);
  Future<ResponseStatusModel> deleteComment(CommentModel comment);
  Future<Tuple2<ResponseStatusModel, CommentModel>> updateComment(
      CommentModel comment);
}

class CommentsRestRepository implements ICommentsRepository {
  @override
  Future<Tuple2<ResponseStatusModel, CommentModel>> createComment(
      String commentText) async {
    ResponseStatusModel response = ResponseStatusModel();

    var uuid = const Uuid();
    String docId = uuid.v1();
    CommentModel comment = CommentModel(
      text: commentText,
      articleId: ArticleService.currentlyArticleId,
      author: UserService.instance.user.name,
      authorId: UserService.instance.user.id,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      docId: docId,
    );

    await FirebaseFirestore.instance.collection('comments').doc(docId).set({
      "comment": comment.toJson(),
      "user_id": UserService.instance.user.id,
      "email": UserService.instance.user.email,
      "created_at": DateTime.now().millisecondsSinceEpoch,
      "doc_id": docId,
      "article_id": ArticleService.currentlyArticleId,
    }).onError((error, stackTrace) {
      response = WeException.handle(error);
    });

    return Tuple2(
      response,
      comment,
    );
  }

  @override
  Future<Tuple2<ResponseStatusModel, List<CommentModel>>> getComments(
    String articleId,
  ) async {
    ResponseStatusModel response = ResponseStatusModel();
    final List<CommentModel> articles = <CommentModel>[];

    await FirebaseFirestore.instance
        .collection('comments')
        .where("article_id", isEqualTo: articleId)
        .get()
        .then((snpashot) {
      if (snpashot.docs.isNotEmpty) {
        final tempArticles = snpashot.docs
            .map((QueryDocumentSnapshot<Map<String, dynamic>> e) =>
                CommentModel.fromMap(e.data()))
            .toList();
        articles.addAll(tempArticles);
      }
    }).onError((error, stackTrace) {
      response = WeException.handle(error);
    });

    return Tuple2(
      response,
      articles,
    );
  }

  @override
  Future<ResponseStatusModel> deleteComment(CommentModel comment) async {
    ResponseStatusModel response = ResponseStatusModel();

    await FirebaseFirestore.instance
        .collection('comments')
        .doc(comment.docId)
        .delete()
        .onError((error, stackTrace) {
      response = WeException.handle(error);
    });
    return response;
  }

  @override
  Future<Tuple2<ResponseStatusModel, CommentModel>> updateComment(
      CommentModel comment) async {
    ResponseStatusModel response = ResponseStatusModel();
    await FirebaseFirestore.instance
        .collection('comments')
        .doc(comment.docId)
        .update({
      "comment": comment.toJson(),
    }).onError((error, stackTrace) {
      response = WeException.handle(error);
    });

    return Tuple2(
      response,
      comment,
    );
  }
}
