// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      id: json['id'] as String? ?? "",
      name: json['name'] as String? ?? "",
      email: json['email'] as String? ?? "",
      phone: json['phone'] as String? ?? "",
      document: json['document'] as String? ?? "",
      photoUrl: json['photo_url'] as String? ?? "",
      subscriptionLevel: json['roles'] == null
          ? SubscriptionEnum.nonPaying
          : UserModel.subscriptionEnumFromJson(
              json['roles'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'phone': instance.phone,
      'document': instance.document,
      'photo_url': instance.photoUrl,
    };
