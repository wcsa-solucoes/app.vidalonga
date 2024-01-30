import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';

abstract class PurchaseDetailsDto {
  static const String appleStoreSource = "apple_store";

  static Map<String, dynamic> toMap(PurchaseDetails purchaseDetails) {
    if (purchaseDetails is AppStorePurchaseDetails) {
      return {
        'purchaseId': purchaseDetails.purchaseID,
        'productId': purchaseDetails.productID,
        'transactionDate': purchaseDetails.transactionDate,
        "pendingCompletePurchase": purchaseDetails.pendingCompletePurchase,
        "verificationData": {
          "localVerificationData":
              purchaseDetails.verificationData.localVerificationData,
          "serverVerificationData":
              purchaseDetails.verificationData.serverVerificationData,
          "source": purchaseDetails.verificationData.source,
        },
        "source": purchaseDetails.verificationData.source,
        "status": purchaseDetails.status.name,
        "billingClientPurchase": null,
        //storekit specific
        "skPaymentTransaction": {
          "transactionIdentifier":
              purchaseDetails.skPaymentTransaction.transactionIdentifier,
          "transactionTimeStamp":
              purchaseDetails.skPaymentTransaction.transactionTimeStamp,
          "transactionState":
              purchaseDetails.skPaymentTransaction.transactionState.name,
          "payment": {
            "applicationUsername": purchaseDetails
                .skPaymentTransaction.payment.applicationUsername,
          }
        }
      };
      // purchaseDetails.skPaymentTransaction.
    } else if (purchaseDetails is GooglePlayPurchaseDetails) {
      return {
        'purchaseId': purchaseDetails.purchaseID,
        'productId': purchaseDetails.productID,
        'transactionDate': purchaseDetails.transactionDate,
        "pendingCompletePurchase": purchaseDetails.pendingCompletePurchase,
        "verificationData": {
          "localVerificationData":
              purchaseDetails.verificationData.localVerificationData,
          "serverVerificationData":
              purchaseDetails.verificationData.serverVerificationData,
          "source": purchaseDetails.verificationData.source,
        },
        "source": purchaseDetails.verificationData.source,
        "status": purchaseDetails.status.name,
        "skPaymentTransaction": null,
        //billing specific
        "billingClientPurchase": {
          "purchaseTime": purchaseDetails.billingClientPurchase.purchaseTime,
          "orderId": purchaseDetails.billingClientPurchase.orderId,
          "packageName": purchaseDetails.billingClientPurchase.packageName,
          "purchaseToken": purchaseDetails.billingClientPurchase.purchaseToken,
          "signature": purchaseDetails.billingClientPurchase.signature,
          "purchaseState":
              purchaseDetails.billingClientPurchase.purchaseState.name,
          "isAcknowledged":
              purchaseDetails.billingClientPurchase.isAcknowledged,
          "originalJson": purchaseDetails.billingClientPurchase.originalJson,
        }
      };
    }
    return {};
  }

  static PurchaseDetails fromMap(Map<String, dynamic> data) {
    return PurchaseDetails(
      purchaseID: data["purchaseID"],
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
