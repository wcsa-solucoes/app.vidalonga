import 'dart:async';

import 'package:app_vida_longa/core/repositories/articles_repository.dart';
import 'package:app_vida_longa/core/repositories/categories_repository.dart';
import 'package:app_vida_longa/domain/models/article_model.dart';
import 'package:app_vida_longa/domain/models/category_model.dart';
import 'package:app_vida_longa/domain/models/response_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:tuple/tuple.dart';

class ArticleService {
  ArticleService._internal();

  static final ArticleService _instance = ArticleService._internal();

  static ArticleService get instance => _instance;

  static bool _hasInit = false;

  static String _currentlyArticleId = "";
  static String get currentlyArticleId => _currentlyArticleId;
  final List<CategoryModel> _categories = <CategoryModel>[];
  List<CategoryModel> get categories => _instance._categories;
  late final CategoriesRepository _categoriesRepository;

  static Future<void> init() async {
    if (!_hasInit) {
      _hasInit = true;
      await instance._init();
    }
  }

  static ArticleModel? _currentlyArticle;
  static ArticleModel get currentlyArticle => _currentlyArticle!;

  static void setCurrentlyArticleId(String value, ArticleModel article) {
    _currentlyArticleId = value;
    _currentlyArticle = article;
  }

  final ArticlesRepository _repository = ArticlesRepository();

  final List<ArticleModel> _articles = <ArticleModel>[];
  List<ArticleModel> get articles => _instance._articles;

  final List<List<ArticleModel>> _articlesByCategories = <List<ArticleModel>>[];
  List<List<ArticleModel>> get articlesByCategories =>
      _instance._articlesByCategories;
  List<CategoryModel?> get categoriesCollection =>
      _instance._categoriesCollection;

  final List<CategoryModel?> _categoriesCollection = <CategoryModel?>[];

  Future<void> _init() async {
    await getCategories();

    await getAll();
  }

  Future<void> getCategories() async {
    _categoriesRepository =
        CategoriesRepository(firestore: FirebaseFirestore.instance);

    _categoriesCollection.clear();

    final result = await _categoriesRepository.getAll();

    if (result.response.status == ResponseStatusEnum.success) {
      _categoriesCollection.addAll(result.categories);
    }
  }

  Future<Tuple2<ResponseStatusModel, List<ArticleModel>>> getAll() async {
    final Tuple2<ResponseStatusModel, List<ArticleModel>> data =
        await _repository.getAll();

    _updateArticles(data.item2);
    _updateArticlesByCategories(data.item2);

    return data;
  }

  void _updateArticles(List<ArticleModel> articles) {
    for (var article in articles) {
      article.categoryTitle = _categoriesCollection
              .firstWhereOrNull(
                  (element) => element!.uuid == article.categoryUuid)
              ?.name ??
          "";
    }

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
        if (lastList.first.categoryUuid == element.categoryUuid) {
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
