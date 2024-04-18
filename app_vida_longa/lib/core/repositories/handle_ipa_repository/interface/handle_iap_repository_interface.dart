import 'package:app_vida_longa/domain/models/plan_model.dart';
import 'package:app_vida_longa/domain/models/response_model.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

abstract class IHandleIAPRepository
    implements
        ISavePurchaseRepository,
        IGetPurchasesRepository,
        ISignaturesRepository,
        IRecoversRepository {}

abstract class ISavePurchaseRepository {
  Future<ResponseStatusModel> savePurchase(
      List<PurchaseDetails> purchasesDetails, PlanModel plan,
      {String? couponId});
}

abstract class IGetPurchasesRepository {
  Future<
      ({
        ResponseStatusModel responseStatus,
        List<PurchaseDetails> purchasesDetails
      })> getPurchases();
}

abstract class ISignaturesRepository {
  Future<void> saveNewSignature(
    PurchaseDetails purchasesDetails,
    String userId,
    PlanModel plan, {
    String? couponId,
  });
}

abstract class IRecoversRepository {
  Future<void> recoverPurchase(PurchaseDetails purchasesDetails);
}
