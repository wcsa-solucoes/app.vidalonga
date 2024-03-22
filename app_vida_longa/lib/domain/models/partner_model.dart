import 'package:app_vida_longa/domain/enums/social_media_enum.dart';
import 'package:app_vida_longa/domain/models/social_media_model.dart';

class PartnerCompanyModel {
  final String id;

  final String createdAt;
  final int createdAtUnixTimestamp;

  final List<String> benefitsId;
  final List<String> branchesId;

  final String name;
  final String? urlLogo;
  final List<String>? presentationImagesUrl;
  final String presentationText;

  final String? state;
  final String? city;
  final String? neighborhood;
  final String? number;
  final String? fullAddress;

  final bool isHighlighted;
  final List<SocialMediaModel> socialMedias;

  PartnerCompanyModel({
    required this.id,
    this.createdAt = "",
    this.createdAtUnixTimestamp = 0,
    this.benefitsId = const [],
    this.branchesId = const [],
    this.name = "default name",
    this.urlLogo,
    this.presentationImagesUrl,
    this.presentationText = "",
    this.state,
    this.city,
    this.neighborhood,
    this.number,
    this.fullAddress,
    this.isHighlighted = false,
    this.socialMedias = const [],
  });

  factory PartnerCompanyModel.fromMap(Map<String, dynamic> map) {
    return PartnerCompanyModel(
      id: map['uuid'] ?? "",
      createdAt: map['createdAt'] ?? "",
      createdAtUnixTimestamp: map['createdAtUnixTimestamp'] ?? 0,
      benefitsId: List<String>.from(map['benefitsId'] ?? const []),
      branchesId: List<String>.from(map['branchesId'] ?? const []),
      name: map['name'] ?? "default name",
      urlLogo: map['imageCoverUrl'],
      presentationImagesUrl:
          List<String>.from(map['presentationImagesUrl'] ?? const []),
      presentationText: map['presentationText'] ?? "",
      state: map['state'],
      city: map['city'],
      neighborhood: map['neighborhood'],
      number: map['number'],
      fullAddress: map['fullAddress'],
      isHighlighted: map['isHighlighted'] ?? false,
      // socialMedias: map['socialMedias'] != null
      //     ? List.from(map['socialMedias'].map((x) =>
      //         SocialMediaEnum.values.firstWhere((e) => e.type == x['type'])))
      //     : [],
      socialMedias: newMethod(map),
    );
  }

  //  static List<SocialMediaEnum> newMethod(Map<String, dynamic> map) {
  //   List<dynamic> medias = map['socialMedias'] as List<dynamic>;

  //   List<SocialMediaEnum> socialMedias = [];
  //   for (var element in medias) {
  //     socialMedias.add(
  //         SocialMediaEnum.values.firstWhere((e) => e.type == element['type']));
  //   }

  //   return socialMedias;
  // }
  static List<SocialMediaModel> newMethod(Map<String, dynamic> map) {
    List<dynamic> medias = map['socialMedias'] as List<dynamic>;
    List<SocialMediaModel> socialMedias = [];
    for (var element in medias) {
      socialMedias.add(SocialMediaModel.fromJson(element));
    }

    return socialMedias;
  }

  PartnerCompanyModel copyWith({
    String? id,
    String? createdAt,
    int? createdAtUnixTimestamp,
    List<String>? benefitsId,
    List<String>? branchesId,
    String? name,
    String? urlLogo,
    List<String>? presentationImagesUrl,
    String? presentationText,
    String? state,
    String? city,
    String? neighborhood,
    String? address,
    String? number,
    String? fullAddress,
    bool? isHighlighted,
    List<SocialMediaEnum>? socialMedias,
  }) {
    return PartnerCompanyModel(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      createdAtUnixTimestamp:
          createdAtUnixTimestamp ?? this.createdAtUnixTimestamp,
      benefitsId: benefitsId ?? this.benefitsId,
      branchesId: branchesId ?? this.branchesId,
      name: name ?? this.name,
      urlLogo: urlLogo ?? this.urlLogo,
      presentationImagesUrl:
          presentationImagesUrl ?? this.presentationImagesUrl,
      presentationText: presentationText ?? this.presentationText,
      state: state ?? this.state,
      city: city ?? this.city,
      neighborhood: neighborhood ?? this.neighborhood,
      number: number ?? this.number,
      fullAddress: fullAddress ?? this.fullAddress,
      isHighlighted: isHighlighted ?? this.isHighlighted,
    );
  }
}
