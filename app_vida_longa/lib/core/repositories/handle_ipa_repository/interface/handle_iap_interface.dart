import 'package:app_vida_longa/domain/models/response_model.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

abstract class IHandleIAPRepository {
  Future<ResponseStatusModel> savePurchase(
      List<PurchaseDetails> purchasesDetails);
  Future<
      ({
        ResponseStatusModel responseStatus,
        List<PurchaseDetails> purchasesDetails
      })> getPurchases();
  Future<void> createDocInSignaturesCollection(
    String userId,
    String signatureId,
    String status,
    String date,
  );
}
