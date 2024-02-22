import 'package:app_vida_longa/domain/models/content_model.dart';
import 'package:app_vida_longa/domain/models/sub_category_model.dart';

enum SubscriptionTypeArticleEnum {
  paid("pagante"),
  free("livre");

  final String name;
  const SubscriptionTypeArticleEnum(this.name);
}

class ArticleModel {
  late String title = "";
  late String categoryUuid = "";
  late String categoryTitle = "";
  late String uuid = "";
  late String image = "";
  late List<ContentModel> contents = [];
  late List<SubCategoryModel> subCategories;
  late SubscriptionTypeArticleEnum subscriptionType;

  ArticleModel({
    this.title = "",
    this.categoryUuid = "",
    this.uuid = '',
    this.image = '',
    this.contents = const [],
    this.subCategories = const [],
    this.categoryTitle = "",
    this.subscriptionType = SubscriptionTypeArticleEnum.paid,
  });

  factory ArticleModel.fromMap(Map<String, dynamic> map) {
    return ArticleModel(
      title: map['title'] as String,
      categoryUuid: (map['categories'] as List<dynamic>)
          .map((e) => e as String)
          .toList()
          .first,
      subscriptionType: SubscriptionTypeArticleEnum.values.firstWhere(
        (SubscriptionTypeArticleEnum e) => e.name == map['subscriptionType'],
        orElse: () => SubscriptionTypeArticleEnum.paid,
      ),
      uuid: map['uuid'] as String,
      image: map['image'] as String,
      contents: (map['contents'] as List<dynamic>)
          .map((e) => ContentModel.fromMap(e as Map<String, dynamic>))
          .toList(),
      subCategories: (map['subcategories'] as List<dynamic>).map((e) {
        return SubCategoryModel(uuid: e);
      }).toList(),
    );
  }
}
