import 'package:app_vida_longa/domain/models/sub_category_model.dart';

class CategoryModel {
  late String name;
  late String image;
  late List<SubCategoryModel> subCategories;

  CategoryModel({
    required this.name,
    required this.image,
    this.subCategories = const [],
  });

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      name: map['name'] as String,
      image: map['image'] as String,
      subCategories: (map['subCategories'] as List<dynamic>)
          .map((e) => SubCategoryModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }

  CategoryModel copyWith({
    String? name,
    String? image,
    List<SubCategoryModel>? subCategories,
  }) {
    return CategoryModel(
      name: name ?? this.name,
      image: image ?? this.image,
      subCategories: subCategories ?? this.subCategories,
    );
  }
}
