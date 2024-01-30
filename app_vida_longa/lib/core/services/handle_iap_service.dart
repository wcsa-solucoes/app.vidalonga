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

  Future<void> handlePurchase(PurchaseDetails purchaseDetails) async {
    if (_purchases.isEmpty) {
      await UserService.instance
          .updateSubscriberStatusFromRoles(SubscriptionEnum.paying);
      await savePurchase(purchaseDetails);
      return;
    }

    //compare the date bewtween the purchase and the last purchase date
    //if the last purchase date is older than the purchase date, then update the subscription status
    DateTime dateOfLastPurchaseDate = DateTime.fromMillisecondsSinceEpoch(
        int.parse(_purchases.last.transactionDate!));

    DateTime dateOfNewPurchaseDate = DateTime.fromMillisecondsSinceEpoch(
        int.parse(purchaseDetails.transactionDate!));

    //if the diffenrence has more than 30 days, then update the subscription status
    if (dateOfNewPurchaseDate.difference(dateOfLastPurchaseDate).inDays > 30) {
      await UserService.instance
          .updateSubscriberStatusFromRoles(SubscriptionEnum.paying);
      await savePurchase(purchaseDetails);
    }
  }

  Future<void> savePurchase(PurchaseDetails purchaseDetails) async {
    _purchases.add(purchaseDetails);
    await _handleIAPRepository.savePurchase(_purchases);
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
