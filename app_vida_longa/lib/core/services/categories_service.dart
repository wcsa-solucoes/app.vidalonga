import 'package:app_vida_longa/core/helpers/print_colored_helper.dart';
import 'package:app_vida_longa/core/repositories/categories_repository.dart';
import 'package:app_vida_longa/core/services/articles_service.dart';
import 'package:app_vida_longa/domain/models/article_model.dart';
import 'package:app_vida_longa/domain/models/category_model.dart';
import 'package:app_vida_longa/domain/models/response_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  final CategoriesRepository _categoriesRepository =
      CategoriesRepository(firestore: FirebaseFirestore.instance);

  final List<CategoryModel> _categoriesCollection = <CategoryModel>[];
  List<CategoryModel> get categoriesCollection => _categoriesCollection;

  final List<SubCategoryModel> _subCategoriesSelected = <SubCategoryModel>[];
  List<SubCategoryModel> get subCategories => _subCategoriesSelected;

  final List<ArticleModel> _articlesFromSubcategories = <ArticleModel>[];

  List<ArticleModel> get articlesFromSubcategories =>
      _articlesFromSubcategories;

  static Future<void> init() async {
    if (!_hasInit) {
      _hasInit = true;
      await _instance._init();
    }
  }

  static void setCurrentlyCategoryId(String value) {
    _currentlyCategoryId = value;
  }

  static void setCurrentlyCategory(CategoryModel value) {
    _instance._selectedCategory = value;
  }

  void selectSubcategoriesFromCategory(CategoryModel category) {
    _selectedCategory = category;
    _subCategoriesSelected.clear();
    _subCategoriesSelected.addAll(category.subCategories);
  }

  void selectArticlesFromSubCategory(SubCategoryModel subCategory) {
    _articlesFromSubcategories.clear();

    for (var article in _articleService.articles) {
      for (var sc in article.subCategories) {
        if (sc.uuid == subCategory.uuid) {
          _articlesFromSubcategories.add(article);
          PrintColoredHelper.printGreen(article.title);
        }
      }
    }
  }

  Future<void> _init() async {
    var response = await _categoriesRepository.getAll();
    if (response.response.status == ResponseStatusEnum.success) {
      _categoriesCollection.addAll(response.categories);
    }

    Map<String, Set<ArticleModel>> subCategoryArticlesMap = {};

    for (var article in _articleService.articles) {
      for (var subCategory in article.subCategories) {
        String key = '${article.categoryTitle}|${subCategory.uuid}';
        subCategoryArticlesMap
            .putIfAbsent(key, () => <ArticleModel>{})
            .add(article);
      }
    }

    for (var key in subCategoryArticlesMap.keys) {
      var parts = key.split('|');
      var categoryName = parts[0];
      var subCategoryUuid = parts[1];

      var category = _categories.firstWhereOrNull(
        (c) => c.name == categoryName,
      );
      if (category == null) {
        category = CategoryModel(
            name: categoryName,
            //image: "",
            subCategories: []);
        _categories.add(category);
      }

      var subCategory = category.subCategories.firstWhereOrNull(
        (sc) => sc.name == subCategoryUuid,
      );
      var fullSubcategory = _categoriesCollection
          .expand((c) => c.subCategories)
          .firstWhereOrNull((sc) => sc.uuid == subCategoryUuid);
      if (subCategory == null) {
        subCategory = SubCategoryModel(
            name: fullSubcategory!.name,
            articles: [],
            uuid: fullSubcategory.uuid);
        category.subCategories.add(subCategory);
      }

      var articlesToAdd = subCategoryArticlesMap[key]!;
      for (var article in articlesToAdd) {
        if (!subCategory.articles!.any((a) => a.uuid == article.uuid)) {
          subCategory.articles!.add(article);
        }
      }
    }

    print("CategoriesService - _init - _categoriesCollection");
  }
}
