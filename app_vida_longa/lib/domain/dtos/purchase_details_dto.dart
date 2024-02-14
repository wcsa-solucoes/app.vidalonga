import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';

abstract class PurchaseDetailsDto {
  static Map<String, dynamic> toMapApple(
      AppStorePurchaseDetails purchaseDetails) {
    var map = {
      'purchaseId': purchaseDetails.purchaseID,
      'productId': purchaseDetails.productID,
      'transactionDate': purchaseDetails.transactionDate,
      "pendingCompletePurchase": purchaseDetails.pendingCompletePurchase,
      "source": "app_store",
      "status": purchaseDetails.status.name,
      "skPaymentTransaction": {
        "transactionIdentifier":
            purchaseDetails.skPaymentTransaction.transactionIdentifier,
        "transactionTimeStamp":
            purchaseDetails.skPaymentTransaction.transactionTimeStamp,
        "transactionState":
            purchaseDetails.skPaymentTransaction.transactionState.name,
        "payment": {
          "applicationUsername":
              purchaseDetails.skPaymentTransaction.payment.applicationUsername,
        },
        "originalTransaction": {
          "transactionIdentifier": purchaseDetails
              .skPaymentTransaction.originalTransaction?.transactionIdentifier,
          "transactionState": purchaseDetails
              .skPaymentTransaction.originalTransaction?.transactionState.name,
          "transactionTimeStamp": purchaseDetails
              .skPaymentTransaction.originalTransaction?.transactionTimeStamp,
        }
      },
    };

    return map;
  }

  static Map<String, dynamic> toGoogleMap(
      GooglePlayPurchaseDetails purchaseDetails) {
    return {
      'purchaseId': purchaseDetails.purchaseID,
      'productId': purchaseDetails.productID,
      'transactionDate': purchaseDetails.transactionDate,
      "pendingCompletePurchase": purchaseDetails.pendingCompletePurchase,
      "source": "google_play",
      "status": purchaseDetails.status.name,
      "billingClientPurchase": {
        "purchaseTime": purchaseDetails.billingClientPurchase.purchaseTime,
        "orderId": purchaseDetails.billingClientPurchase.orderId,
        "packageName": purchaseDetails.billingClientPurchase.packageName,
        "purchaseToken": purchaseDetails.billingClientPurchase.purchaseToken,
        "signature": purchaseDetails.billingClientPurchase.signature,
        "purchaseState":
            purchaseDetails.billingClientPurchase.purchaseState.name,
        "isAcknowledged": purchaseDetails.billingClientPurchase.isAcknowledged,
        "originalJson": purchaseDetails.billingClientPurchase.originalJson,
      },
    };
  }

  static PurchaseDetails fromMap(Map<String, dynamic> data) {
    return PurchaseDetails(
      purchaseID: data["purchaseId"],
      productID: data["productId"],
      transactionDate: data["transactionDate"],
      verificationData: PurchaseVerificationData(
        localVerificationData: data["verificationData"]
            ["localVerificationData"],
        serverVerificationData: data["verificationData"]
            ["serverVerificationData"],
        source: data["verificationData"]["source"],
      ),
      status: PurchaseStatus.values
          .firstWhere((element) => element.name == data["status"]),
    );
  }
}
