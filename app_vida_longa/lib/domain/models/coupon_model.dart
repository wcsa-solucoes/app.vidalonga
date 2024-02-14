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
}
