import "package:app_vida_longa/domain/enums/subscription_type.dart";
import "package:json_annotation/json_annotation.dart";

part "user_model.g.dart";

@JsonSerializable()
class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  @JsonKey(name: "photo_url")
  final String photoUrl;
  @JsonKey(
      fromJson: subscriptionEnumFromJson, includeToJson: false, name: "roles")
  final SubscriptionEnum subscriptionLevel;
  final String? lastSubscriptionPlatform;

  UserModel({
    this.id = "",
    this.name = "",
    this.email = "",
    this.phone = "",
    this.photoUrl = "",
    this.subscriptionLevel = SubscriptionEnum.nonPaying,
    this.lastSubscriptionPlatform,
  });

  static UserModel empty() {
    return UserModel(
      id: "",
      name: "",
      email: "",
      phone: "",
      photoUrl: "",
      subscriptionLevel: SubscriptionEnum.nonPaying,
    );
  }

  static SubscriptionEnum subscriptionEnumFromJson(Map<String, dynamic> roles) {
    final subscriptionType = roles["subscriptionType"];

    if (subscriptionType == null) {
      return SubscriptionEnum.nonPaying;
    }
    return SubscriptionEnum.values.firstWhere(
      (e) => e.name == subscriptionType,
      orElse: () => SubscriptionEnum.nonPaying,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? photoUrl,
    SubscriptionEnum? subscriptionLevel,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      photoUrl: photoUrl ?? this.photoUrl,
      subscriptionLevel: subscriptionLevel ?? this.subscriptionLevel,
    );
  }
}
