import 'package:app_vida_longa/core/repositories/comments_repository.dart';
import 'package:app_vida_longa/domain/models/comment_model.dart';
import 'package:app_vida_longa/domain/models/response_model.dart';
import 'package:tuple/tuple.dart';

class CommentService {
  CommentService._internal();

  static final CommentService _instance = CommentService._internal();

  static CommentService get instance => _instance;

  static bool _hasInit = false;

  static void init() async {
    if (!_hasInit) {
      _hasInit = true;
    }
  }

  final ICommentsRepository _repository = CommentsRestRepository();

  final List<CommentModel> _articles = <CommentModel>[];
  List<CommentModel> get articles => _instance._articles;

  Future<Tuple2<ResponseStatusModel, CommentModel>> createComment(
      String comment) async {
    final response = await _repository.createComment(comment);
    _addComment(response.item2);
    return response;
  }

  Future<List<CommentModel>> getAllCommentsFromArticle(String articleId) async {
    final comments = await _repository.getComments(articleId);
    _setComments(comments.item2);
    return comments.item2;
  }

  void _setComments(List<CommentModel> articles) {
    _articles.clear();
    _articles.addAll(articles);
  }

  void _addComment(CommentModel article) {
    _articles.add(article);
  }

  Future<ResponseStatusModel> deleteComment(CommentModel comment) async {
    final response = await _repository.deleteComment(comment);
    _articles.remove(comment);
    return response;
  }

  Future<Tuple2<ResponseStatusModel, CommentModel>> updateComment(
      CommentModel comment) async {
    final response = await _repository.updateComment(comment);
    _updateComment(response.item2);
    return response;
  }

  void _updateComment(CommentModel comment) {
    final index =
        _articles.indexWhere((element) => element.docId == comment.docId);
    _articles[index] = comment;
  }
}
