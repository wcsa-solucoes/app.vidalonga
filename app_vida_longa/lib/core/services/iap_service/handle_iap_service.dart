import 'package:app_vida_longa/core/repositories/handle_ipa_repository/interface/handle_iap_repository_interface.dart';
import 'package:app_vida_longa/core/services/coupons_service.dart';
import 'package:app_vida_longa/core/services/user_service.dart';
import 'package:app_vida_longa/domain/enums/subscription_type.dart';
import 'package:app_vida_longa/domain/models/coupon_model.dart';
import 'package:app_vida_longa/domain/models/plan_model.dart';
import 'package:app_vida_longa/domain/models/response_model.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class HandleIAPService implements IHandleIAPService {
  final List<PurchaseDetails> _purchases = [];
  List<PurchaseDetails> get purchases => _purchases;
  final IHandleIAPRepository handleIAPRepository;
  final ICouponsService _couponsService = CouponsServiceImpl.instance;

  HandleIAPService({required this.handleIAPRepository});

  Future<void> handlePurchase(
    PurchaseDetails purchaseDetails,
    String platform,
    PlanModel plan, {
    CouponModel? couponAdded,
  }) async {
    await Future.wait([
      _handleCoupon(couponAdded),
      savePurchase(purchaseDetails, plan, couponAdded: couponAdded),
      UserService.instance
          .updateSubscriberStatusFromRoles(SubscriptionEnum.paying, platform),
    ]);
  }

  Future<void> _handleCoupon(CouponModel? couponAdded) async {
    if (couponAdded != null) {
      await _couponsService.incrementUsageQuantityOfCoupon(couponAdded);
    }
  }

  Future<void> savePurchase(
    PurchaseDetails purchaseDetails,
    PlanModel plan, {
    CouponModel? couponAdded,
  }) async {
    _purchases.add(purchaseDetails);
    await handleIAPRepository.savePurchase(_purchases, plan,
        couponId: couponAdded?.uuid);
  }

  Future<void> getPurchases() async {
    final result = await handleIAPRepository.getPurchases();
    if (result.responseStatus.status == ResponseStatusEnum.success) {
      _setPurchases(result.purchasesDetails);
    }

    return;
  }

  void _setPurchases(List<PurchaseDetails> purchases) {
    _purchases.clear();
    _purchases.addAll(purchases);
  }

  @override
  Future<void> recoverPurchase(
      PurchaseDetails purchasesDetails, String platform) async {
    UserService.instance
        .updateSubscriberStatusFromRoles(SubscriptionEnum.paying, platform);

    handleIAPRepository.recoverPurchase(purchasesDetails);
  }
}

abstract class IHandleIAPService extends IHandleRecoveryService {}

abstract class IHandleRecoveryService {
  Future<void> recoverPurchase(
      PurchaseDetails purchasesDetail, String platform);
}
