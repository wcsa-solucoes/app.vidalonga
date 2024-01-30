import 'package:app_vida_longa/core/controllers/we_exception.dart';
import 'package:app_vida_longa/core/services/user_service.dart';
import 'package:app_vida_longa/domain/dtos/purchase_details_dto.dart';
import 'package:app_vida_longa/domain/models/response_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

abstract class IHandleIAPRepository {
  Future<ResponseStatusModel> savePurchase(
      List<PurchaseDetails> purchasesDetails);
  Future<
      ({
        ResponseStatusModel responseStatus,
        List<PurchaseDetails> purchasesDetails
      })> getPurchases();
}

class HandleIAPRepositoryImpl implements IHandleIAPRepository {
  FirebaseFirestore firestore;

  HandleIAPRepositoryImpl({
    required this.firestore,
  });

  @override
  Future<ResponseStatusModel> savePurchase(
      List<PurchaseDetails> purchasesDetails) async {
    ResponseStatusModel responseStatusModel = ResponseStatusModel();

    await firestore
        .collection('purchases')
        .doc(UserService.instance.user.id)
        .set({
          "userId": UserService.instance.user.id,
          "purchases": purchasesDetails
              .map((PurchaseDetails purchase) =>
                  PurchaseDetailsDto.toMap(purchase))
              .toList(),
        })
        .then((value) => null)
        .onError((error, stackTrace) {
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

    await firestore
        .collection('purchases')
        .doc(UserService.instance.user.id)
        .get()
        .then((value) {
      if (value.exists) {
        final data = value.data() as Map<String, dynamic>;
        final purchase = data['purchase'] as Map<String, dynamic>;
        purchaseDetails.add(PurchaseDetailsDto.fromMap(purchase));
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
