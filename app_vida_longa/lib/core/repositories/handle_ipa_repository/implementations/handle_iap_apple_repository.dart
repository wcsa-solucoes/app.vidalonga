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

class HandleIAPAppleRepositoryImpl implements IHandleIAPRepository {
  FirebaseFirestore firestore;

  HandleIAPAppleRepositoryImpl({required this.firestore});

  @override
  Future<ResponseStatusModel> savePurchase(
      List<PurchaseDetails> purchasesDetails) async {
    ResponseStatusModel responseStatusModel = ResponseStatusModel();
    List<Map<String, dynamic>> maps = [];
    List<AppStorePurchaseDetails> appStorePurchases = [];
    AppStorePurchaseDetails? someAppStorePurchaseDetails;

    PrintColoredHelper.printWhite(
        "purchasesDetails.length: ${purchasesDetails.length}");

    for (var element in purchasesDetails) {
      if (element is AppStorePurchaseDetails) {
        someAppStorePurchaseDetails = element;
        break;
      }
    }

    if (someAppStorePurchaseDetails == null) {
      throw UnimplementedError(
          "No AppStorePurchaseDetails found in purchasesDetails");
    }

    for (var element in purchasesDetails) {
      if (element is AppStorePurchaseDetails) {
        appStorePurchases.add(element);
      }
    }

    maps = appStorePurchases
        .map((AppStorePurchaseDetails purchase) =>
            PurchaseDetailsDto.toMapApple(purchase))
        .toList();

    await firestore
        .collection("appleInAppPurchases")
        .doc(UserService.instance.user.id)
        .set(
      {
        "userId": UserService.instance.user.id,
        "lastSignatureId": someAppStorePurchaseDetails.skPaymentTransaction
                .originalTransaction?.transactionIdentifier ??
            someAppStorePurchaseDetails
                .skPaymentTransaction.transactionIdentifier,
      },
      SetOptions(merge: true),
    );

    await firestore
        .collection("appleInAppPurchases")
        .doc(UserService.instance.user.id)
        .set({"purchases": maps}, SetOptions(merge: true))
        .then((value) {})
        .onError((error, stackTrace) {
          PrintColoredHelper.printError("savePurchase ${error.toString()}");
          responseStatusModel = WeException.handle(error);
        });

    String? date = DateTimeHelper.formatEpochTimestampFromApple(
        someAppStorePurchaseDetails.skPaymentTransaction.transactionTimeStamp);
    // someAppStorePurchaseDetails.skPaymentTransaction.transactionTimeStamp
    // 1712370299.0
    // someAppStorePurchaseDetails.transactionDate
    // "1712370299000"

    //someAppStorePurchaseDetails.purchaseID == someAppStorePurchaseDetails.skPaymentTransaction.transactionIdentifier
    // true
    if (someAppStorePurchaseDetails
            .skPaymentTransaction.transactionIdentifier !=
        null) {
      createDocInSignaturesCollection(
          UserService.instance.user.id,
          someAppStorePurchaseDetails
              .skPaymentTransaction.transactionIdentifier!,
          someAppStorePurchaseDetails
              .skPaymentTransaction.transactionState.name,
          date ??
              DateTimeHelper.formatDateTimeToYYYYMMDDHHmmss(DateTime.now()));
    }

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
  Future<void> createDocInSignaturesCollection(
      String userId, String signatureId, String status, String date) async {
    //verify if exists a document with the same userId
    final doc = await firestore.collection("signatures").doc(userId).get();

    if (doc.exists) {
      return;
    } else {
      await firestore.collection("signatures").doc(userId).set(
        {
          "userId": userId,
          "lastSignatureId": signatureId,
          "lastPlatformPaymentDate": date,
          "lastPlatform": "apple_store",
          "appStoreTransactions": [
            {
              "transactionId": signatureId,
              "transactionDate": date,
              "status": status,
            }
          ],
        },
        SetOptions(merge: true),
      );
    }
  }
}
