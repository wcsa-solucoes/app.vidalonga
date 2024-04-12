import 'dart:async';
import 'package:app_vida_longa/core/controllers/we_exception.dart';
import 'package:app_vida_longa/core/helpers/date_time_helper.dart';
import 'package:app_vida_longa/core/helpers/print_colored_helper.dart';
import 'package:app_vida_longa/core/repositories/handle_ipa_repository/interface/handle_iap_interface.dart';
import 'package:app_vida_longa/core/services/user_service.dart';
import 'package:app_vida_longa/domain/dtos/purchase_details_dto.dart';
import 'package:app_vida_longa/domain/models/response_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';

class HandleIAPAppleRepositoryImpl
    implements IHandleIAPRepository, ISignaturesRepository {
  FirebaseFirestore firestore;

  HandleIAPAppleRepositoryImpl({required this.firestore});

  @override
  Future<ResponseStatusModel> savePurchase(
      List<PurchaseDetails> purchasesDetails) async {
    ResponseStatusModel responseStatusModel = ResponseStatusModel();
    AppStorePurchaseDetails? lastPurchase;

    lastPurchase = purchasesDetails.last as AppStorePurchaseDetails?;

    if (lastPurchase == null) {
      throw UnimplementedError(
          "No AppStorePurchaseDetails found in purchasesDetails");
    }

    unawaited(saveNewSignature(lastPurchase, UserService.instance.user.id));

    Map<String, dynamic> payload = {
      "purchases": FieldValue.arrayUnion(
        [PurchaseDetailsDto.toMapApple(lastPurchase)],
      ),
      "userId": UserService.instance.user.id,
    };

    if (lastPurchase
            .skPaymentTransaction.originalTransaction?.transactionIdentifier !=
        null) {
      payload = {
        ...payload,
        "originalTransactionId": lastPurchase.skPaymentTransaction
                .originalTransaction?.transactionIdentifier ??
            lastPurchase.skPaymentTransaction.transactionIdentifier,
        "lastSignatureId":
            lastPurchase.skPaymentTransaction.transactionIdentifier,
      };
    }

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
  Future<void> saveNewSignature(PurchaseDetails purchaseDetails, userId) async {
    purchaseDetails as AppStorePurchaseDetails;

    String? date = DateTimeHelper.formatEpochTimestampFromApple(
      purchaseDetails.skPaymentTransaction.transactionTimeStamp ??
          DateTime.now().millisecondsSinceEpoch.toDouble(),
    );

    List<dynamic>? appStoreTransactions =
        (await firestore.collection("signatures").doc(userId).get())
            .data()?['appStoreTransactions'] as List<dynamic>?;

    final newTransaction = {
      "transactionId":
          purchaseDetails.skPaymentTransaction.transactionIdentifier,
      "transactionDate": date,
      "status": purchaseDetails.skPaymentTransaction.transactionState.name,
    };

    if (appStoreTransactions != null) {
      appStoreTransactions.add(newTransaction);
    } else {
      appStoreTransactions = [newTransaction];
    }

    await firestore.collection("signatures").doc(userId).set(
      {
        //not need here because webhook will handle this
        // "appStoreTransactions": appStoreTransactions,
        "userId": userId,
        "lastSignatureId":
            purchaseDetails.skPaymentTransaction.transactionIdentifier,
        "lastPaymentDate": date,
        "lastPlatform": "app_store",
        "status": "active",
        "originalTransactionIdAppStore": purchaseDetails.skPaymentTransaction
                .originalTransaction?.transactionIdentifier ??
            purchaseDetails.skPaymentTransaction.transactionIdentifier,
      },
      SetOptions(merge: true),
    );
  }
}
