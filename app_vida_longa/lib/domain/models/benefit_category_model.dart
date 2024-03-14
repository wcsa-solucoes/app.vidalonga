class BenefitCategoryModel {
  final String name;
  final String id;

  BenefitCategoryModel({
    required this.name,
    required this.id,
  });

  factory BenefitCategoryModel.fromMap(Map<String, dynamic> map) {
    return BenefitCategoryModel(
      name: map['name'],
      id: map['id'],
    );
  }
}
