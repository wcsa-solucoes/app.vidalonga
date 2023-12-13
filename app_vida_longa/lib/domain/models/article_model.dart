import 'package:app_vida_longa/domain/enums/subscription_type.dart';
import 'package:app_vida_longa/domain/models/content_model.dart';

class ArticleModel {
  late String title = "";
  late String comment = "";
  late String category = "";
  late SubscriptionTypeEnum subscriptionType;
  late String uuid = "";
  late String image = "";
  late List<ContentModel> contents = [];

  ArticleModel({
    this.title = "",
    this.comment = "",
    this.category = "",
    this.subscriptionType = SubscriptionTypeEnum.free,
    this.uuid = '',
    this.image = '',
    this.contents = const [],
  });

  factory ArticleModel.fromMap(Map<String, dynamic> map) {
    return ArticleModel(
      title: map['title'] as String,
      comment: map['comment'] as String,
      category: map['category'] as String,
      subscriptionType: SubscriptionTypeEnum.values.firstWhere(
        (SubscriptionTypeEnum e) => e.name == map['subscription_type'],
        orElse: () => SubscriptionTypeEnum.free,
      ),
      uuid: map['uuid'] as String,
      image: map['image'] as String,
      contents: (map['contents'] as List<dynamic>)
          .map((e) => ContentModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
