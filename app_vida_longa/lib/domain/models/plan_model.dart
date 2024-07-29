class PlanModel {
  final String name;
  final String? applePlanId;
  final String? googlePlanId;
  final double price;
  final String uuid;

  PlanModel({
    required this.name,
    required this.applePlanId,
    required this.googlePlanId,
    required this.price,
    this.uuid = "",
  });

  factory PlanModel.fromMap(Map<String, dynamic> json) {
    return PlanModel(
      name: json['name'],
      applePlanId: json['applePlanId'],
      googlePlanId: json['googlePlanId'],
      price: json['price'].toDouble(),
      uuid: json['uuid'],
    );
  }
}
