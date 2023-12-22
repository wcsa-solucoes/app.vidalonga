import 'dart:async';

import 'package:app_vida_longa/core/repositories/articles_repository.dart';
import 'package:app_vida_longa/domain/models/article_model.dart';
import 'package:app_vida_longa/domain/models/response_model.dart';
import 'package:tuple/tuple.dart';

class ArticleService {
  ArticleService._internal();

  static final ArticleService _instance = ArticleService._internal();

  static ArticleService get instance => _instance;

  static bool _hasInit = false;

  static String _currentlyArticleId = "";
  static String get currentlyArticleId => _currentlyArticleId;

  static Future<void> init() async {
    if (!_hasInit) {
      _hasInit = true;
      await instance._init();
    }
  }

  static void setCurrentlyArticleId(String value) {
    _currentlyArticleId = value;
  }

  final ArticlesRepository _repository = ArticlesRepository();

  final List<ArticleModel> _articles = <ArticleModel>[];
  List<ArticleModel> get articles => _instance._articles;

  final List<List<ArticleModel>> _articlesByCategories = <List<ArticleModel>>[];
  List<List<ArticleModel>> get articlesByCategories =>
      _instance._articlesByCategories;

  Future<void> _init() async {
    await getAll();
  }

  Future<Tuple2<ResponseStatusModel, List<ArticleModel>>> getAll() async {
    final Tuple2<ResponseStatusModel, List<ArticleModel>> data =
        await _repository.getAll();

    _updateArticles(data.item2);
    _updateArticlesByCategories(data.item2);

    return data;
  }

  void _updateArticles(List<ArticleModel> articles) {
    _articles.clear();
    _articles.addAll(articles);
  }

  void _updateArticlesByCategories(List<ArticleModel> articles) {
    List<List<ArticleModel>> articleAgrouped = _articles
        .fold<List<List<ArticleModel>>>(<List<ArticleModel>>[],
            (previousValue, element) {
      if (previousValue.isEmpty) {
        previousValue.add(<ArticleModel>[element]);
      } else {
        final List<ArticleModel> lastList = previousValue.last;
        if (lastList.first.category == element.category) {
          lastList.add(element);
        } else {
          previousValue.add(<ArticleModel>[element]);
        }
      }
      return previousValue;
    });
    if (articleAgrouped.isNotEmpty) articles.clear();
    _articlesByCategories.clear();

    _articlesByCategories.addAll(articleAgrouped);
  }
}
