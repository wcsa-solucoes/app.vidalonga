class BranchModel {
  final String createdAt;
  final String id;
  final String name;
  final String titleColor;
  final double? titleSize;
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
    this.titleSize = 15,
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
      titleSize: map['titleSize'].toDouble(),
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
      titleSize: titleSize,
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
