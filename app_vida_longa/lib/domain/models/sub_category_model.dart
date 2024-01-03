import 'package:app_vida_longa/domain/models/article_model.dart';

class SubCategoryModel {
  late String name = "";
  late List<ArticleModel>? articles;

  SubCategoryModel({
    required this.name,
    this.articles = const <ArticleModel>[],
  });

  factory SubCategoryModel.fromMap(Map<String, dynamic> map) {
    return SubCategoryModel(
      name: map['name'] as String,
    );
  }

  SubCategoryModel copyWith({
    String? name,
    List<ArticleModel>? articles,
  }) {
    return SubCategoryModel(
      name: name ?? this.name,
      articles: articles ?? this.articles,
    );
  }
}
