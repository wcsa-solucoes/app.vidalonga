import 'package:app_vida_longa/domain/enums/subscription_type.dart';
import 'package:app_vida_longa/domain/models/content_model.dart';
import 'package:app_vida_longa/domain/models/sub_category_model.dart';

class ArticleModel {
  late String title = "";
  late String categoryUuid = "";
  late String categoryTitle = "";
  late SubscriptionEnum subscriptionType;
  late String uuid = "";
  late String image = "";
  late List<ContentModel> contents = [];
  late List<SubCategoryModel> subCategories;

  ArticleModel({
    this.title = "",
    this.categoryUuid = "",
    this.subscriptionType = SubscriptionEnum.nonPaying,
    this.uuid = '',
    this.image = '',
    this.contents = const [],
    this.subCategories = const [],
    this.categoryTitle = "",
  });

  factory ArticleModel.fromMap(Map<String, dynamic> map) {
    return ArticleModel(
      title: map['title'] as String,
      categoryUuid: (map['categories'] as List<dynamic>)
          .map((e) => e as String)
          .toList()
          .first,
      subscriptionType: SubscriptionEnum.values.firstWhere(
        (SubscriptionEnum e) => e.name == map['subscriptionType'],
        orElse: () => SubscriptionEnum.nonPaying,
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
