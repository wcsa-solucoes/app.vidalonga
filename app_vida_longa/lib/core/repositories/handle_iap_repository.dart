import 'dart:io';
import 'package:app_vida_longa/core/controllers/we_exception.dart';
import 'package:app_vida_longa/core/helpers/print_colored_helper.dart';
import 'package:app_vida_longa/core/services/user_service.dart';
import 'package:app_vida_longa/domain/dtos/purchase_details_dto.dart';
import 'package:app_vida_longa/domain/models/response_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';

abstract class IHandleIAPRepository {
  Future<ResponseStatusModel> savePurchase(
      List<PurchaseDetails> purchasesDetails, String collection);
  Future<
      ({
        ResponseStatusModel responseStatus,
        List<PurchaseDetails> purchasesDetails
      })> getPurchases();
}

class HandleIAPRepositoryImpl implements IHandleIAPRepository {
  FirebaseFirestore firestore;
  late final String platform;

  HandleIAPRepositoryImpl({required this.firestore}) {
    if (Platform.isIOS) {
      platform = "appleInAppPurchases";
    } else {
      platform = "androidInAppPurchases";
    }
  }

  @override
  Future<ResponseStatusModel> savePurchase(
      List<PurchaseDetails> purchasesDetails, String collection) async {
    ResponseStatusModel responseStatusModel = ResponseStatusModel();
    List<Map<String, dynamic>> maps = [];
    List<AppStorePurchaseDetails> appStorePurchases = [];
    AppStorePurchaseDetails? someAppStorePurchaseDetails;

    if (Platform.isIOS) {
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
          .collection(platform)
          .doc(UserService.instance.user.id)
          .set(
        {
          "userId": UserService.instance.user.id,
          "lastOriginalTransactionId": someAppStorePurchaseDetails
              .skPaymentTransaction.originalTransaction?.transactionIdentifier,
        },
        SetOptions(merge: true),
      );

      await firestore
          .collection(platform)
          .doc(UserService.instance.user.id)
          .set({"purchases": maps}, SetOptions(merge: true))
          .then((value) {})
          .onError((error, stackTrace) {
            PrintColoredHelper.printError("savePurchase ${error.toString()}");
            responseStatusModel = WeException.handle(error);
          });
    } else {
      throw UnimplementedError();
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
        .collection(platform)
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
}
