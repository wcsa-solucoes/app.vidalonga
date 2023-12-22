import 'package:app_vida_longa/core/services/articles_service.dart';
import 'package:app_vida_longa/domain/models/category_model.dart';

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

  // void _init() async {
  //   //popule categories em funcao dos artigos
  //   for (var article in _articleService.articles) {
  //     if (!_categories.any((category) => category.name == article.category)) {
  //       _categories.add(CategoryModel(
  //           name: article.category,
  //           image: "",
  //           subCategories: article.subCategories));
  //     }

  //     // for (var subCategory in article.subCategories) {
  //     //   if (!_categories.any((category) => category.name == subCategory.name)) {
  //     //     _categories.add(CategoryModel(name: subCategory.name, image: "", subCategories: ));
  //     //   }
  //     // }
  //   }
  // }
  void _init() async {
    // populate categories based on the articles
    for (var article in _articleService.articles) {
      if (!_categories.any((category) => category.name == article.category)) {
        _categories.add(CategoryModel(
            name: article.category,
            image: "",
            subCategories: article.subCategories));
      }
      for (var subCategory in article.subCategories) {
        if (!_categories.any((category) => category.name == subCategory.name)) {
          subCategory.articles = _articleService.articles
              .where((article) => article.subCategories.contains(subCategory))
              .toList();
        }
      }
    }
    _categories.length;
  }
}
