class BranchModel {
  final String createdAt;
  final String id;
  final String name;
  final int createdAtUnixTimestamp;

  BranchModel({
    required this.createdAt,
    required this.id,
    required this.name,
    required this.createdAtUnixTimestamp,
  });

  factory BranchModel.fromMap(Map<String, dynamic> map) {
    return BranchModel(
      createdAt: map['createdAt'],
      id: map['uuid'],
      name: map['name'],
      createdAtUnixTimestamp: map['createdAtUnixTimestamp'],
    );
  }

  BranchModel copyWith({
    String? createdAt,
    String? id,
    String? name,
    int? createdAtUnixTimestamp,
  }) {
    return BranchModel(
      createdAt: createdAt ?? this.createdAt,
      id: id ?? this.id,
      name: name ?? this.name,
      createdAtUnixTimestamp:
          createdAtUnixTimestamp ?? this.createdAtUnixTimestamp,
    );
  }
}
