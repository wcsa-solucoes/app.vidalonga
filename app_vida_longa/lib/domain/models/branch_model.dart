class BranchModel {
  final String createdAt;
  final String id;
  final String name;
  final String titleColor;
  final bool haveLogo;
  final String? logoSize;
  final double logoSizeWidht;
  final double logoSizeHeight;
  final String imageUrl;
  final int createdAtUnixTimestamp;

  BranchModel({
    required this.createdAt,
    required this.id,
    required this.name,
    required this.createdAtUnixTimestamp,
    this.titleColor = "",
    this.haveLogo = false,
    this.logoSize = "",
    this.logoSizeWidht = 0,
    this.logoSizeHeight = 0,
    this.imageUrl = "",
  });

  factory BranchModel.fromMap(Map<String, dynamic> map) {
    return BranchModel(
      createdAt: map['createdAt'],
      id: map['uuid'],
      name: map['name'],
      titleColor: map['titleColor'],
      haveLogo: map['haveLogo'],
      logoSize: map['logoSize'],
      logoSizeWidht: map['logoSizeWidht'].toDouble(),
      logoSizeHeight: map['logoSizeHeight'].toDouble(),
      imageUrl: map['imageUrl'],
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
      titleColor: titleColor,
      haveLogo: haveLogo,
      logoSize: logoSize,
      logoSizeWidht: logoSizeWidht,
      logoSizeHeight: logoSizeHeight,
      imageUrl: imageUrl,
      createdAtUnixTimestamp:
          createdAtUnixTimestamp ?? this.createdAtUnixTimestamp,
    );
  }
}
