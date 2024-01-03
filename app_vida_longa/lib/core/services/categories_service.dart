import 'package:app_vida_longa/core/services/articles_service.dart';
import 'package:app_vida_longa/domain/models/article_model.dart';
import 'package:app_vida_longa/domain/models/category_model.dart';
import 'package:collection/collection.dart';
import 'package:app_vida_longa/domain/models/sub_category_model.dart';

class CategoriesService {
  CategoriesService._ineternal();
  static final CategoriesService _instance = CategoriesService._ineternal();
  static CategoriesService get instance => _instance;
  static bool _hasInit = false;
  static String _currentlyCategoryId = "";
  static String get currentlyCategoryId => _currentlyCategoryId;

  final ArticleService _articleService = ArticleService.instance;
  final List<CategoryModel> _categories = <CategoryModel>[];
  List<CategoryModel> get categories => _categories;
  late CategoryModel _selectedCategory;
  CategoryModel get selectedCategory => _instance._selectedCategory;

  static void init() async {
    if (!_hasInit) {
      _hasInit = true;
      _instance._init();
    }
  }

  static void setCurrentlyCategoryId(String value) {
    _currentlyCategoryId = value;
  }

  static void setCurrentlyCategory(CategoryModel value) {
    _instance._selectedCategory = value;
  }

  void _init() async {
    Map<String, Set<ArticleModel>> subCategoryArticlesMap = {};

    for (var article in _articleService.articles) {
      for (var subCategory in article.subCategories) {
        String key = '${article.category}|${subCategory.name}';
        subCategoryArticlesMap
            .putIfAbsent(key, () => <ArticleModel>{})
            .add(article);
      }
    }

    for (var key in subCategoryArticlesMap.keys) {
      var parts = key.split('|');
      var categoryName = parts[0];
      var subCategoryName = parts[1];

      var category = _categories.firstWhereOrNull(
        (c) => c.name == categoryName,
      );
      if (category == null) {
        category =
            CategoryModel(name: categoryName, image: "", subCategories: []);
        _categories.add(category);
      }

      var subCategory = category.subCategories.firstWhereOrNull(
        (sc) => sc.name == subCategoryName,
      );
      if (subCategory == null) {
        subCategory = SubCategoryModel(name: subCategoryName, articles: []);
        category.subCategories.add(subCategory);
      }

      var articlesToAdd = subCategoryArticlesMap[key]!;
      for (var article in articlesToAdd) {
        if (!subCategory.articles!.any((a) => a.uuid == article.uuid)) {
          subCategory.articles!.add(article);
        }
      }
    }
  }
}
