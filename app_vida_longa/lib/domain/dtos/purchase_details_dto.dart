import 'package:app_vida_longa/core/helpers/print_colored_helper.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';

abstract class PurchaseDetailsDto {
  static const String appleStoreSource = "apple_store";

  static bool isPrimitiveType(dynamic value) {
    return value is String ||
        value is int ||
        value is double ||
        value is bool ||
        value == null;
  }

  static void checkForNonPrimitiveValues(Map<String, dynamic> map) {
    map.forEach((key, value) {
      if (isPrimitiveType(value)) {
        // O valor é primitivo, não precisa fazer nada
      } else if (value is Map<String, dynamic>) {
        // Se o valor for outro Map, chama a função recursivamente
        checkForNonPrimitiveValues(value);
      } else if (value is List) {
        // Se for uma lista, verifica cada elemento
        for (var item in value) {
          if (!isPrimitiveType(item)) {
            // Se algum item da lista não for primitivo, trata o caso
            PrintColoredHelper.printError(
                'Encontrado valor não primitivo na lista: $item');
          }
        }
      } else {
        // Encontrou um valor não primitivo
        PrintColoredHelper.printOrange(
            'Encontrado valor não primitivo: $value do tipo ${value.runtimeType}');
      }
    });

    return;
  }

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
      // "verificationData": {
      //   "localVerificationData":
      //       purchaseDetails.verificationData.localVerificationData,
      //   "serverVerificationData":
      //       purchaseDetails.verificationData.serverVerificationData,
      //   "source": purchaseDetails.verificationData.source,
      // },
    };
    // checkForNonPrimitiveValues(map);
    // PrintColoredHelper.printOrange(
    //     'Verificação de valores não primitivos concluída');

    return map;
  }

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
        "skPaymentTransaction": {
          "transactionIdentifier":
              purchaseDetails.skPaymentTransaction.transactionIdentifier,
          "transactionTimeStamp":
              purchaseDetails.skPaymentTransaction.transactionTimeStamp,
          "transactionState":
              purchaseDetails.skPaymentTransaction.transactionState.name,
          "payment": {
            "applicationUsername":
                purchaseDetails.skPaymentTransaction.payment.applicationUsername
          }
        }
      };
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
