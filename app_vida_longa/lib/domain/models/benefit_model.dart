class BenefitModel {
  final String name;
  final String id;
  final bool isHighlighted;
  final int createdAtUnixTimestamp;
  final String createdAt;

  BenefitModel({
    required this.name,
    required this.id,
    this.isHighlighted = false,
    this.createdAtUnixTimestamp = 0,
    this.createdAt = '',
  });

  factory BenefitModel.fromMap(Map<String, dynamic> map) {
    return BenefitModel(
      name: map['name'],
      id: map['uuid'],
      isHighlighted: map['isHighlighted'],
      createdAtUnixTimestamp: map['createdAtUnixTimestamp'],
      createdAt: map['createdAt'],
    );
  }

  BenefitModel copyWith({
    String? name,
    String? id,
    bool? isHighlighted,
    int? createdAtUnixTimestamp,
    String? createdAt,
  }) {
    return BenefitModel(
      name: name ?? this.name,
      id: id ?? this.id,
      isHighlighted: isHighlighted ?? this.isHighlighted,
      createdAtUnixTimestamp:
          createdAtUnixTimestamp ?? this.createdAtUnixTimestamp,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
