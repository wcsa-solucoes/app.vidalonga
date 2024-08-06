
class Plan {
  String includedAt;
  String planId;

  Plan({
    required this.includedAt,
    required this.planId,
  });

  Map<String, dynamic> toMap() {
    return {
      'includedAt': includedAt,
      'planId': planId,
    };
  }
}

class SignatureModel {
  final String? uuid;
  final String couponId;
  final String lastPaymentDate;
  final String? lastPlatform;
  final String? lastSignatureId;
  final List<Plan> plans;
  final int price;
  final List<String> signaturesDate;
  final List<String> appStoreTransactions;
  final List<String> googlePlayTransactions;
  final String status;
  final String userId;

  SignatureModel({
    required this.couponId,
    this.uuid,
    this.lastPaymentDate = "",
    this.lastSignatureId = "",
    this.lastPlatform = "",
    this.plans = const [],
    this.price = 0,
    this.signaturesDate = const [],
    this.appStoreTransactions = const [],
    this.googlePlayTransactions = const [],
    this.status = "",
    this.userId = "",
  });

  factory SignatureModel.fromMap(Map<String, dynamic> map) {
    return SignatureModel(
      uuid: map['uuid'] as String,
      couponId: map['couponId'],
      lastPaymentDate: map['lastPaymentDate'],
      lastSignatureId: map['lastSignatureId'],
      lastPlatform: map['lastPlatform'],
      plans: map['plans'],
      price: map['price'],
      signaturesDate: (map['signaturesDate'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      status: map['status'],
      userId: map['userId'],
    );
  }

  factory SignatureModel.newSignature({
    required String couponId,
    required String lastPaymentDate,
    required String lastPlatform,
    required String userId,
  }) {
    return SignatureModel(
      couponId: couponId,
      lastPaymentDate: lastPaymentDate,
      lastPlatform: lastPlatform,
      lastSignatureId: null,
      appStoreTransactions: [],
      googlePlayTransactions: [],
      plans: [],
      price: 0,
      signaturesDate: [],
      status: "active",
      userId: userId,
    );
  }

  Map<String, dynamic> newSignatureToMap(String docId) {
    return {
      'uuid': docId,
      'couponId': couponId,
      'lastPaymentDate': lastPaymentDate,
      'lastSignatureId': lastSignatureId,
      'lastPlatform': lastPlatform,
      'plans': plans.map((e) => e.toMap()).toList(),
      'appStoreTransactions': plans.map((e) => e.toMap()).toList(),
      'googlePlayTransactions': plans.map((e) => e.toMap()).toList(),
      'price': price,
      'signaturesDate': signaturesDate.map((e) => e).toList(),
      'status': status,
      'userId': userId
    };
  }
}
