import 'package:app_vida_longa/core/controllers/we_exception.dart';
import 'package:app_vida_longa/domain/models/article_model.dart';
import 'package:app_vida_longa/domain/models/brief_article_model.dart';
import 'package:app_vida_longa/domain/models/response_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tuple/tuple.dart';

class ArticlesRepository {
  Future<Tuple2<ResponseStatusModel, List<BriefArticleModel>>> getAll() async {
    ResponseStatusModel response = ResponseStatusModel();
    final List<BriefArticleModel> articles = <BriefArticleModel>[];

    await FirebaseFirestore.instance
        .collection('briefArticles')
        .where('status', isEqualTo: 'published')
        .orderBy('createdAt', descending: true)
        .get()
        .then((snpashot) {
      final tempArticles = snpashot.docs
          .map((QueryDocumentSnapshot<Map<String, dynamic>> e) =>
              BriefArticleModel.fromMap(e.data()))
          .toList();
      articles.addAll(tempArticles);
    }).onError((error, stackTrace) {
      response = WeException.handle(error);
    });

    return Tuple2(
      response,
      articles,
    );
  }

  Future<({ResponseStatusModel response, ArticleModel article})> getArticle(
      String uuid) async {
    ResponseStatusModel response = ResponseStatusModel();
    late ArticleModel article;

    await FirebaseFirestore.instance
        .collection('articles')
        .where('uuid', isEqualTo: uuid)
        .get()
        .then((snpashot) {
      final tempArticle = snpashot.docs
          .map((QueryDocumentSnapshot<Map<String, dynamic>> e) =>
              ArticleModel.fromMap(e.data()))
          .first;
      article = tempArticle;
    }).onError((error, stackTrace) {
      response = WeException.handle(error);
    });

    return (response: response, article: article);
  }
}
