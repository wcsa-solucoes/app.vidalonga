import 'package:app_vida_longa/domain/enums/social_media_enum.dart';

class SocialMediaModel {
  final SocialMediaEnum type;
  final String url;

  SocialMediaModel({required this.type, required this.url});

  factory SocialMediaModel.fromJson(Map<String, dynamic> json) {
    return SocialMediaModel(
      type: SocialMediaEnum.values.firstWhere(
        (element) => element.type == json['type'],
        orElse: () => SocialMediaEnum.other,
      ),
      url: json['link'],
    );
  }
}
