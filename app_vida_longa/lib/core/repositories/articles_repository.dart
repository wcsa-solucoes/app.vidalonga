import 'package:app_vida_longa/core/controllers/we_exception.dart';
import 'package:app_vida_longa/domain/models/article_model.dart';
import 'package:app_vida_longa/domain/models/response_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tuple/tuple.dart';

class ArticlesRepository {
  Future<Tuple2<ResponseStatusModel, List<ArticleModel>>> getAll() async {
    ResponseStatusModel response = ResponseStatusModel();
    final List<ArticleModel> articles = <ArticleModel>[];

    await FirebaseFirestore.instance
        .collection('articles')
        .orderBy('createdAt', descending: true)
        .get()
        .then((snpashot) {
      final tempArticles = snpashot.docs
          .map((QueryDocumentSnapshot<Map<String, dynamic>> e) =>
              ArticleModel.fromMap(e.data()))
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
}
