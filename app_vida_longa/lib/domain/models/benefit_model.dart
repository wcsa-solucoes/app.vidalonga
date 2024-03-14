class BenefitModel {
  final String title;
  final String id;
  final String description;
  final String imageUrl;
  final String categoryId;
  final String categoryTitle;

  BenefitModel({
    required this.title,
    required this.id,
    required this.description,
    required this.imageUrl,
    required this.categoryId,
    this.categoryTitle = "",
  });

  factory BenefitModel.fromMap(Map<String, dynamic> map) {
    return BenefitModel(
      title: map['title'],
      id: map['id'],
      description: map['description'],
      imageUrl: map['imageUrl'],
      categoryId: (map['categories'] as List<dynamic>)
          .map((e) => e as String)
          .toList()
          .first,
    );
  }

  //copyWith
  BenefitModel copyWith({
    String? title,
    String? id,
    String? description,
    String? imageUrl,
    String? categoryId,
    String? categoryTitle,
  }) {
    return BenefitModel(
      title: title ?? this.title,
      id: id ?? this.id,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      categoryId: categoryId ?? this.categoryId,
      categoryTitle: categoryTitle ?? this.categoryTitle,
    );
  }
}
