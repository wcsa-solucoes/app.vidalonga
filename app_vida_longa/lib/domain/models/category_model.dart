import 'package:app_vida_longa/domain/models/sub_category_model.dart';

class CategoryModel {
  final String name;
  final String image;
  final List<SubCategoryModel> subCategories;

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
}
