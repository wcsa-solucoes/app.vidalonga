class CategoriesArticlesRelationModel {
  late String uuid = "";
  late String categoryUuid = "";
  late String articleUuid = "";

  CategoriesArticlesRelationModel({
    this.uuid = "",
    this.categoryUuid = '',
    this.articleUuid = ''
  });

  factory CategoriesArticlesRelationModel.fromMap(Map<String, dynamic> map) {
    return CategoriesArticlesRelationModel(
      uuid: map['uuid'] as String,
      categoryUuid: map['categoryUuid'] as String,
      articleUuid: map['articleUuid'] as String,
    );
  }
}
