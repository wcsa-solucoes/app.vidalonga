import 'package:app_vida_longa/domain/enums/subscription_type.dart';

class ArticleModel {
  late String title = "";
  late String comment = "";
  late String category = "";
  late SubscriptionTypeEnum subscriptionType;
  late String uuid = "";
  late String image = "";

  ArticleModel({
    this.title = "",
    this.comment = "",
    this.category = "",
    this.subscriptionType = SubscriptionTypeEnum.free,
    this.uuid = '',
    this.image = '',
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
    );
  }
}
