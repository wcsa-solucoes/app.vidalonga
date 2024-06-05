import 'dart:async';
import 'package:app_vida_longa/core/controllers/we_exception.dart';
import 'package:app_vida_longa/core/helpers/date_time_helper.dart';
import 'package:app_vida_longa/core/helpers/print_colored_helper.dart';
import 'package:app_vida_longa/core/repositories/handle_ipa_repository/interface/handle_iap_repository_interface.dart';
import 'package:app_vida_longa/core/services/user_service.dart';
import 'package:app_vida_longa/domain/dtos/purchase_details_dto.dart';
import 'package:app_vida_longa/domain/models/plan_model.dart';
import 'package:app_vida_longa/domain/models/response_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';

class HandleIAPAppleRepositoryImpl implements IHandleIAPRepository {
  FirebaseFirestore firestore;

  HandleIAPAppleRepositoryImpl({required this.firestore});

  @override
  Future<ResponseStatusModel> savePurchase(
    List<PurchaseDetails> purchasesDetails,
    PlanModel plan, {
    String? couponId,
  }) async {
    ResponseStatusModel responseStatusModel = ResponseStatusModel();
    AppStorePurchaseDetails? lastPurchase;

    lastPurchase = purchasesDetails.last as AppStorePurchaseDetails?;

    if (lastPurchase == null) {
      throw UnimplementedError(
          "No AppStorePurchaseDetails found in purchasesDetails");
    }

    unawaited(saveNewSignature(
      lastPurchase,
      UserService.instance.user.id,
      plan,
      couponId: couponId,
    ));

    String? originalTransactionId = lastPurchase
            .skPaymentTransaction.originalTransaction?.transactionIdentifier ??
        lastPurchase.skPaymentTransaction.transactionIdentifier;

    Map<String, dynamic> payload = {
      "purchases": FieldValue.arrayUnion(
        [PurchaseDetailsDto.toMapApple(lastPurchase)],
      ),
      "userId": UserService.instance.user.id,
      "lastUpdateFrom": "mobileApplication",
      "lastSignatureId":
          lastPurchase.skPaymentTransaction.transactionIdentifier,
      "originalTransactionIdAppStore": originalTransactionId,
    };

    await firestore
        .collection("appleInAppPurchases")
        .doc(UserService.instance.user.id)
        .set(payload, SetOptions(merge: true))
        .then((value) {})
        .onError((error, stackTrace) {
      PrintColoredHelper.printError("savePurchase ${error.toString()}");
      responseStatusModel = WeException.handle(error);
    });

    // someAppStorePurchaseDetails.skPaymentTransaction.transactionTimeStamp
    // 1712370299.0
    // someAppStorePurchaseDetails.transactionDate
    // "1712370299000"

    return responseStatusModel;
  }

  @override
  Future<
      ({
        ResponseStatusModel responseStatus,
        List<PurchaseDetails> purchasesDetails
      })> getPurchases() async {
    ResponseStatusModel responseStatusModel = ResponseStatusModel();
    final List<PurchaseDetails> purchaseDetails = [];

    await FirebaseFirestore.instance
        .collection("appleInAppPurchases")
        .doc(UserService.instance.user.id)
        .get()
        .then((value) {
      if (value.exists) {
        final data = value.data() as Map<String, dynamic>;
        final purchases = data['purchases'] as List<dynamic>;

        purchaseDetails.addAll(purchases
            .map((purchase) => PurchaseDetailsDto.fromMap(purchase))
            .toList());
      }
    }).onError((error, stackTrace) {
      responseStatusModel = WeException.handle(error);
    });

    return (
      responseStatus: responseStatusModel,
      purchasesDetails: purchaseDetails
    );
  }

  @override
  Future<void> saveNewSignature(
      PurchaseDetails purchaseDetails, String userId, PlanModel plan,
      {String? couponId}) async {
    purchaseDetails as AppStorePurchaseDetails;

    String? date = DateTimeHelper.formatEpochTimestampFromApple(
      purchaseDetails.skPaymentTransaction.transactionTimeStamp ??
          DateTime.now().millisecondsSinceEpoch.toDouble(),
    );

    Map<String, dynamic>? signaturesData =
        (await firestore.collection("signatures").doc(userId).get()).data();

    Map<String, dynamic> payload = {
      "userId": userId,
      "uuid": userId,
      "price": plan.price,
      "lastSignatureId":
          purchaseDetails.skPaymentTransaction.transactionIdentifier,
      "lastPaymentDate": date,
      "lastPlatform": "app_store",
      "status": "active",
      "originalTransactionIdAppStore": purchaseDetails.skPaymentTransaction
              .originalTransaction?.transactionIdentifier ??
          purchaseDetails.skPaymentTransaction.transactionIdentifier,
      "lastUpdateFrom": "mobileApplication",
    };

    if (!(signaturesData?["status"] == "active")) {
      payload = {
        ...payload,
        "signaturesDate": FieldValue.arrayUnion([date]),
        "plans": FieldValue.arrayUnion([
          {
            "includedAt": date,
            "planId": plan.uuid,
          }
        ]),
      };
    }

    if (couponId != null) {
      payload = {
        ...payload,
        "couponId": couponId,
      };
    }

    await firestore
        .collection("signatures")
        .doc(userId)
        .set(payload, SetOptions(merge: true));
  }

  @override
  Future<void> recoverPurchase(PurchaseDetails purchasesDetail) async {
    purchasesDetail as AppStorePurchaseDetails;

    String? recoveryOriginal = purchasesDetail
            .skPaymentTransaction.originalTransaction?.transactionIdentifier ??
        purchasesDetail.skPaymentTransaction.transactionIdentifier;

    firestore
        .collection("appleInAppPurchases")
        .doc(UserService.instance.user.id)
        .set({
      "recoveriesDate": FieldValue.arrayUnion(
        [
          DateTime.now().microsecondsSinceEpoch,
        ],
      ),
      "lastUpdateFrom": "mobileApplication",
      "lastRecoveredSignatureId":
          purchasesDetail.skPaymentTransaction.transactionIdentifier,
      "recoveryOriginalTransactionIdAppStore": recoveryOriginal,
    }, SetOptions(merge: true));
  }
}
