import 'package:app_vida_longa/core/repositories/handle_iap_repository.dart';
import 'package:app_vida_longa/core/services/user_service.dart';
import 'package:app_vida_longa/domain/enums/subscription_type.dart';
import 'package:app_vida_longa/domain/models/response_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class HandleIAPService {
  HandleIAPService._internal();
  static final HandleIAPService _instance = HandleIAPService._internal();
  static HandleIAPService get instance => _instance;

  final List<PurchaseDetails> _purchases = [];
  List<PurchaseDetails> get purchases => _purchases;

  final IHandleIAPRepository _handleIAPRepository = HandleIAPRepositoryImpl(
    firestore: FirebaseFirestore.instance,
  );

  Future<void> handlePurchase(PurchaseDetails purchaseDetails,
      String collection, String platform) async {
    await UserService.instance
        .updateSubscriberStatusFromRoles(SubscriptionEnum.paying, platform);
    await savePurchase(purchaseDetails, collection);
  }

  Future<void> savePurchase(
      PurchaseDetails purchaseDetails, String collection) async {
    _purchases.add(purchaseDetails);
    await _handleIAPRepository.savePurchase(_purchases, collection);
  }

  Future<void> getPurchases() async {
    final result = await _handleIAPRepository.getPurchases();
    if (result.responseStatus.status == ResponseStatusEnum.success) {
      _setPurchases(result.purchasesDetails);
    }

    return;
  }

  void _setPurchases(List<PurchaseDetails> purchases) {
    _purchases.clear();
    _purchases.addAll(purchases);
  }
}
