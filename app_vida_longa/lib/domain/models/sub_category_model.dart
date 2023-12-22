import 'package:app_vida_longa/domain/models/article_model.dart';

class SubCategoryModel {
  late String name = "";
  List<ArticleModel>? articles;

  SubCategoryModel({
    required this.name,
    this.articles = const [],
  });

  factory SubCategoryModel.fromMap(Map<String, dynamic> map) {
    return SubCategoryModel(
      name: map['name'] as String,
    );
  }
}
