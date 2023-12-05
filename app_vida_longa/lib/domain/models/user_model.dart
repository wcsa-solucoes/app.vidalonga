import "package:json_annotation/json_annotation.dart";

part "user_model.g.dart";

enum SubscriptionLevelEnum {
  free("Grátis"),
  premium("Prêmio");

  final String name;
  const SubscriptionLevelEnum(this.name);
}

@JsonSerializable()
class UserModel {
  late String id;
  late String name;
  late String email;
  late String phone;
  late String document;
  @JsonKey(name: "photo_url")
  late String photoUrl;
  late SubscriptionLevelEnum subscriptionLevel;

  UserModel({
    this.id = "",
    this.name = "",
    this.email = "",
    this.phone = "",
    this.document = "",
    this.photoUrl = "",
    this.subscriptionLevel = SubscriptionLevelEnum.free,
  });

  static UserModel empty() {
    return UserModel(
      id: "",
      name: "",
      email: "",
      phone: "",
      document: "",
      photoUrl: "",
      subscriptionLevel: SubscriptionLevelEnum.free,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
