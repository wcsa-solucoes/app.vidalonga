import 'package:app_vida_longa/domain/models/article_model.dart';
import 'package:app_vida_longa/domain/models/brief_article_model.dart';

class SubCategoryModel {
  late String name = "";
  late String uuid = "";
  late List<BriefArticleModel>? articles;

  SubCategoryModel({
    this.name = "",
    this.articles = const <BriefArticleModel>[],
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
    List<BriefArticleModel>? articles,
    String? uuid,
  }) {
    return SubCategoryModel(
      name: name ?? this.name,
      articles: articles ?? this.articles,
      uuid: uuid ?? this.uuid,
    );
  }
}
