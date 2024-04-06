import 'package:app_vida_longa/core/controllers/we_exception.dart';
import 'package:app_vida_longa/core/helpers/date_time_helper.dart';
import 'package:app_vida_longa/core/helpers/print_colored_helper.dart';
import 'package:app_vida_longa/core/repositories/handle_ipa_repository/interface/handle_iap_interface.dart';
import 'package:app_vida_longa/core/services/user_service.dart';
import 'package:app_vida_longa/domain/dtos/purchase_details_dto.dart';
import 'package:app_vida_longa/domain/models/response_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';

class HandleIAPGoogleRepositoryImpl implements IHandleIAPRepository {
  FirebaseFirestore firestore;

  HandleIAPGoogleRepositoryImpl({required this.firestore});

  @override
  Future<ResponseStatusModel> savePurchase(
      List<PurchaseDetails> purchasesDetails) async {
    ResponseStatusModel responseStatusModel = ResponseStatusModel();
    List<Map<String, dynamic>> maps = [];
    List<GooglePlayPurchaseDetails> googlePlayPurchases = [];
    GooglePlayPurchaseDetails? someGooglePlayurchaseDetails;

    PrintColoredHelper.printWhite(
        "purchasesDetails.length: ${purchasesDetails.length}");

    for (var element in purchasesDetails) {
      if (element is GooglePlayPurchaseDetails) {
        someGooglePlayurchaseDetails = element;
        break;
      }
    }

    if (someGooglePlayurchaseDetails == null) {
      throw UnimplementedError(
          "No GooglePlayPurchaseDetails found in purchasesDetails");
    }

    await firestore
        .collection("googleInAppPurchases")
        .doc(UserService.instance.user.id)
        .set(
      {
        "userId": UserService.instance.user.id,
        "lastSignatureId":
            someGooglePlayurchaseDetails.billingClientPurchase.purchaseToken,
      },
      SetOptions(merge: true),
    );

    for (var element in purchasesDetails) {
      if (element is GooglePlayPurchaseDetails) {
        googlePlayPurchases.add(element);
      }
    }

    maps = googlePlayPurchases
        .map((GooglePlayPurchaseDetails purchase) =>
            PurchaseDetailsDto.toGoogleMap(purchase))
        .toList();
    PrintColoredHelper.printOrange(
        someGooglePlayurchaseDetails.billingClientPurchase.purchaseToken);
    PrintColoredHelper.printWhite(
        someGooglePlayurchaseDetails.billingClientPurchase.originalJson);

    await firestore
        .collection("googleInAppPurchases")
        .doc(UserService.instance.user.id)
        .set({"purchases": maps}, SetOptions(merge: true))
        .then((value) {})
        .onError((error, stackTrace) {
          PrintColoredHelper.printError("savePurchase ${error.toString()}");
          responseStatusModel = WeException.handle(error);
        });

    String date = DateTimeHelper.formatEpochTimestamp(
      someGooglePlayurchaseDetails.billingClientPurchase.purchaseTime,
    );
    createDocInSignaturesCollection(
      UserService.instance.user.id,
      someGooglePlayurchaseDetails.billingClientPurchase.purchaseToken,
      someGooglePlayurchaseDetails.billingClientPurchase.purchaseState.name,
      date,
    );

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
        .collection("googleInAppPurchases")
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
    final doc = await firestore.collection("signatures").doc(userId).get();

    if (doc.exists) {
      return;
    } else {
      await firestore.collection("signatures").doc(userId).set(
        {
          "userId": userId,
          "lastSignatureId": signatureId,
          "lastPlatformPaymentDate": date,
          "lastPlatform": "google_play",
          "googlePlayTransactions": [
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
