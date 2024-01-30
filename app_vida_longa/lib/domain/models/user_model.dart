import "package:app_vida_longa/domain/enums/subscription_type.dart";
import "package:json_annotation/json_annotation.dart";

part "user_model.g.dart";

@JsonSerializable()
class UserModel {
  late String id;
  late String name;
  late String email;
  late String phone;
  late String document;
  @JsonKey(name: "photo_url")
  late String photoUrl;
  late SubscriptionEnum subscriptionLevel;

  UserModel({
    this.id = "",
    this.name = "",
    this.email = "",
    this.phone = "",
    this.document = "",
    this.photoUrl = "",
    this.subscriptionLevel = SubscriptionEnum.nonPaying,
  });

  static UserModel empty() {
    return UserModel(
      id: "",
      name: "",
      email: "",
      phone: "",
      document: "",
      photoUrl: "",
      subscriptionLevel: SubscriptionEnum.nonPaying,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
