class PlanModel {
  final String name;
  final String? applePlanId;
  final String? googlePlanId;
  final double price;
  PlanModel({
    required this.name,
    required this.applePlanId,
    required this.googlePlanId,
    required this.price,
  });

  factory PlanModel.fromMap(Map<String, dynamic> json) {
    return PlanModel(
      name: json['name'],
      applePlanId: json['applePlanId'],
      googlePlanId: json['googlePlanId'],
      price: json['price'],
    );
  }
}
