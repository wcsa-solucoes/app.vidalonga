import 'package:app_vida_longa/domain/models/article_model.dart';

class SubCategoryModel {
  late String name = "";
  late String uuid = "";
  late List<ArticleModel>? articles;

  SubCategoryModel({
    this.name = "",
    this.articles = const <ArticleModel>[],
    this.uuid = "",
  });

  factory SubCategoryModel.fromMap(Map<String, dynamic> map) {
    return SubCategoryModel(
      name: map['name'] as String,
      uuid: map['uuid'] as String,
    );
  }

  SubCategoryModel copyWith({
    String? name,
    List<ArticleModel>? articles,
    String? uuid,
  }) {
    return SubCategoryModel(
      name: name ?? this.name,
      articles: articles ?? this.articles,
      uuid: uuid ?? this.uuid,
    );
  }
}
