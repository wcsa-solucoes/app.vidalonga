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
    List<Map<String, dynamic>> maps = [];
    List<AppStorePurchaseDetails> appStorePurchases = [];
    AppStorePurchaseDetails? someAppStorePurchaseDetails;

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

    await Future.wait([
      firestore
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
      ),
      saveNewSignature(
          someAppStorePurchaseDetails, UserService.instance.user.id),
    ]);
    await firestore
        .collection("appleInAppPurchases")
        .doc(UserService.instance.user.id)
        .set({"purchases": maps}, SetOptions(merge: true))
        .then((value) {})
        .onError((error, stackTrace) {
          PrintColoredHelper.printError("savePurchase ${error.toString()}");
          responseStatusModel = WeException.handle(error);
        });

    // someAppStorePurchaseDetails.skPaymentTransaction.transactionTimeStamp
    // 1712370299.0
    // someAppStorePurchaseDetails.transactionDate
    // "1712370299000"

    //someAppStorePurchaseDetails.purchaseID == someAppStorePurchaseDetails.skPaymentTransaction.transactionIdentifier
    // true

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
        "appStoreTransactions": appStoreTransactions,
        "userId": userId,
        "lastSignatureId":
            purchaseDetails.skPaymentTransaction.transactionIdentifier,
        "lastPaymentDate": date,
        "lastPlatform": "app_store",
        "status": "active",
      },
      SetOptions(merge: true),
    );
  }
}
