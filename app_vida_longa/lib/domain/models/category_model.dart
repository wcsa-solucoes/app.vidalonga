import 'package:app_vida_longa/domain/models/sub_category_model.dart';

class CategoryModel {
  late String name;
  late String uuid;
  late List<SubCategoryModel> subCategories;

  CategoryModel({
    required this.name,
    this.subCategories = const [],
    this.uuid = "",
  });

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      name: map['name'] as String,
      subCategories: (map['subcategories'] as List<dynamic>)
          .map((e) => SubCategoryModel.fromMap(e as Map<String, dynamic>))
          .toList(),
      uuid: map['uuid'] as String,
    );
  }

  CategoryModel copyWith({
    String? name,
    String? image,
    List<SubCategoryModel>? subCategories,
    String? uuid,
  }) {
    return CategoryModel(
      name: name ?? this.name,
      // image: image ?? this.image,
      uuid: uuid ?? this.uuid,
      subCategories: subCategories ?? this.subCategories,
    );
  }
}
