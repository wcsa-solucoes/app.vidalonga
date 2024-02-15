class CouponModel {
  final String activationDate;
  final String createdAt;
  final String expiryDate;
  final bool haveUsageLimit;
  final int limit;
  final String name;
  final String applePlanId;
  final String googlePlanId;
  final String uuid;
  final int usageQuantity;

  CouponModel({
    required this.activationDate,
    required this.createdAt,
    required this.expiryDate,
    required this.haveUsageLimit,
    required this.limit,
    required this.name,
    required this.applePlanId,
    required this.googlePlanId,
    required this.uuid,
    this.usageQuantity = 0,
  });

  factory CouponModel.fromMap(Map<String, dynamic> json) {
    return CouponModel(
      activationDate: json['activationDate'],
      createdAt: json['createdAt'],
      expiryDate: json['expiryDate'],
      haveUsageLimit: json['haveUsageLimit'],
      limit: json['limit'],
      name: json['name'],
      applePlanId: json['applePlanId'],
      googlePlanId: json['googlePlanId'],
      uuid: json['uuid'],
      usageQuantity: json['usageQuantity'],
    );
  }

  static Map<String, dynamic> toMap(CouponModel coupon) {
    return {
      'activationDate': coupon.activationDate,
      'createdAt': coupon.createdAt,
      'expiryDate': coupon.expiryDate,
      'haveUsageLimit': coupon.haveUsageLimit,
      'limit': coupon.limit,
      'name': coupon.name,
      'applePlanId': coupon.applePlanId,
      'googlePlanId': coupon.googlePlanId,
      'uuid': coupon.uuid,
      'usageQuantity': coupon.usageQuantity,
    };
  }

  //copyWith
  CouponModel copyWith({
    String? activationDate,
    String? createdAt,
    String? expiryDate,
    bool? haveUsageLimit,
    int? limit,
    String? name,
    String? applePlanId,
    String? googlePlanId,
    String? uuid,
    int? usageQuantity,
  }) {
    return CouponModel(
      activationDate: activationDate ?? this.activationDate,
      createdAt: createdAt ?? this.createdAt,
      expiryDate: expiryDate ?? this.expiryDate,
      haveUsageLimit: haveUsageLimit ?? this.haveUsageLimit,
      limit: limit ?? this.limit,
      name: name ?? this.name,
      applePlanId: applePlanId ?? this.applePlanId,
      googlePlanId: googlePlanId ?? this.googlePlanId,
      uuid: uuid ?? this.uuid,
      usageQuantity: usageQuantity ?? this.usageQuantity,
    );
  }
}
