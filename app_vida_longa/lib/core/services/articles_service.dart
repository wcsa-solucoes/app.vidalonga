import 'dart:async';
import 'package:app_vida_longa/core/repositories/articles_repository.dart';
import 'package:app_vida_longa/core/repositories/categories_repository.dart';
import 'package:app_vida_longa/domain/models/article_model.dart';
import 'package:app_vida_longa/domain/models/brief_article_model.dart';
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

  static ArticleModel? _currentlyArticle;
  static ArticleModel get currentlyArticle => _currentlyArticle!;

  final ArticlesRepository _repository = ArticlesRepository();

  final List<BriefArticleModel> _articles = <BriefArticleModel>[];
  List<BriefArticleModel> get articles => _instance._articles;

  final List<CategoryModel?> _categoriesCollection = <CategoryModel?>[];

  List<CategoryModel?> get categoriesCollection =>
      _instance._categoriesCollection;

  static Future<void> init() async {
    if (!_hasInit) {
      _hasInit = true;
      await instance._init();
    }
  }

  Future<void> _init() async {
    await getCategories();

    await getAllArticles();
  }

  Future<void> setCurrentlyArticleId(String value) async {
    _currentlyArticleId = value;
    var article = await getArticle(value);
    _currentlyArticle = article;
  }

  Future<ArticleModel> getArticle(String uuid) async {
    final result = await _repository.getArticle(uuid);

    return result.article;
  }

  Future<void> getCategories() async {
    _categoriesRepository =
        CategoriesRepository(firestore: FirebaseFirestore.instance);

    final result = await _categoriesRepository.getAll();

    if (result.response.status == ResponseStatusEnum.success) {
      _categoriesCollection.clear();

      _categoriesCollection.addAll(result.categories);
      _setCategories(result.categories);
    }
  }

  void _setCategories(List<CategoryModel> categories) {
    _categories.clear();
    _categories.addAll(categories);
    _articlesStreamController.sink.add((_articles, _categories));
  }

  Future<Tuple2<ResponseStatusModel, List<BriefArticleModel>>>
      getAllArticles() async {
    final Tuple2<ResponseStatusModel, List<BriefArticleModel>> data =
        await _repository.getAll();

    if (data.item1.status == ResponseStatusEnum.success) {
      _setArticles(data.item2);
    }

    return data;
  }

  void _setArticles(List<BriefArticleModel> articles) {
    for (var article in articles) {
      article.categoryTitle = _categoriesCollection
              .firstWhereOrNull(
                  (element) => element!.uuid == article.categoryUuid)
              ?.name ??
          "";
    }

    _articles.clear();
    _articles.addAll(articles);
    _articlesStreamController.sink.add((_articles, _categories));
  }

  final StreamController<(List<BriefArticleModel>, List<CategoryModel>)>
      _articlesStreamController =
      StreamController<(List<BriefArticleModel>, List<CategoryModel>)>.broadcast();

  Stream<(List<BriefArticleModel>, List<CategoryModel>)> get articlesStream =>
      _articlesStreamController.stream;
}
