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

class HandleIAPGoogleRepositoryImpl
    implements IHandleIAPRepository, ISignaturesRepository {
  FirebaseFirestore firestore;

  HandleIAPGoogleRepositoryImpl({required this.firestore});

  @override
  Future<ResponseStatusModel> savePurchase(
      List<PurchaseDetails> purchasesDetails) async {
    ResponseStatusModel responseStatusModel = ResponseStatusModel();
    List<Map<String, dynamic>> maps = [];
    List<GooglePlayPurchaseDetails> googlePlayPurchases = [];
    GooglePlayPurchaseDetails? someGooglePlayurchaseDetails;

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

    await Future.wait([
      firestore
          .collection("googleInAppPurchases")
          .doc(UserService.instance.user.id)
          .set(
        {
          "userId": UserService.instance.user.id,
          "lastSignatureId":
              someGooglePlayurchaseDetails.billingClientPurchase.purchaseToken,
        },
        SetOptions(merge: true),
      ),
      saveNewSignature(
          someGooglePlayurchaseDetails, UserService.instance.user.id),
    ]);

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
  Future<void> saveNewSignature(
      PurchaseDetails purchasesDetails, String userId) async {
    purchasesDetails as GooglePlayPurchaseDetails;

    List<dynamic>? googlePlayTransactions =
        (await firestore.collection("signatures").doc(userId).get())
            .data()?['googlePlayTransactions'] as List<dynamic>?;

    String date = DateTimeHelper.formatEpochTimestamp(
        purchasesDetails.billingClientPurchase.purchaseTime);

    PrintColoredHelper.printError(
        "purchaseTime: ${purchasesDetails.billingClientPurchase.purchaseTime} date: $date");

    final newTransaction = {
      "transactionId": purchasesDetails.billingClientPurchase.purchaseToken,
      "transactionDate": date,
      "status":
          4, //4 = "purchased" = SUBSCRIPTION_PURCHASED = purchaseDetails.skPaymentTransaction.transactionState.name,
    };

    if (googlePlayTransactions != null) {
      googlePlayTransactions.add(newTransaction);
    } else {
      googlePlayTransactions = [newTransaction];
    }

    await firestore.collection("signatures").doc(userId).set(
      {
        "googlePlayTransactions": googlePlayTransactions,
        "userId": userId,
        "lastSignatureId": purchasesDetails.billingClientPurchase.purchaseToken,
        "lastPaymentDate": date,
        "lastPlatform": "google_play",
        "status": "active",
      },
      SetOptions(merge: true),
    );
  }
}
