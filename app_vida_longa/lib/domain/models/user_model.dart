import "package:json_annotation/json_annotation.dart";

part "user_model.g.dart";

@JsonSerializable()
class UserModel {
  late String id;
  late String name;
  late String email;
  late String phone;
  late String document;
  late String photoUrl;
  UserModel({
    this.id = "",
    this.name = "",
    this.email = "",
    this.phone = "",
    this.document = "",
    this.photoUrl = "",
  });

  static UserModel empty() {
    return UserModel(
      id: "",
      name: "",
      email: "",
      phone: "",
      document: "",
      photoUrl: "",
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
