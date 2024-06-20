import 'package:app_vida_longa/domain/models/article_model.dart';

class BriefArticleModel {
  late String title = "";
  late String uuid = "";
  late String image = "";
  late List<String> categories = [];
  late String categoryUuid = "";
  late String categoryTitle = "";
  late List<String> subCategories;
  late SubscriptionTypeArticleEnum subscriptionType;

  BriefArticleModel({
    this.title = "",
    this.uuid = '',
    this.image = '',
    this.categories = const [],
    this.categoryUuid = "",
    this.categoryTitle = "",
    this.subCategories = const [],
    this.subscriptionType = SubscriptionTypeArticleEnum.paid,
  });

  factory BriefArticleModel.fromMap(Map<String, dynamic> map) {
    return BriefArticleModel(
      title: map['title'] as String,
      uuid: map['uuid'] as String,
      image: map['image'] as String,
      categories: (map['categories'] as List<dynamic>).map((e) {
        return e.toString();
      }).toList(),
      categoryUuid: (map['categories'] as List<dynamic>)
          .map((e) => e as String)
          .toList()
          .first,
      subCategories: (map['subCategories'] as List<dynamic>).map((e) {
        return e.toString();
      }).toList(),
      subscriptionType: SubscriptionTypeArticleEnum.values.firstWhere(
        (SubscriptionTypeArticleEnum e) {
          return e.value == map['subscriptionType'];
        },
        orElse: () => SubscriptionTypeArticleEnum.paid,
      ),
    );
  }
}
