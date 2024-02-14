import 'dart:async';

import 'package:in_app_purchase/in_app_purchase.dart';

abstract class IInAppPurchaseService {
  Future<List<ProductDetails>?> getProductsDetails(Set<String> productIds);
  Future<bool> purchase(ProductDetails productDetails);
  Future<bool> restorePurchase();
  Future<void> init(InAppPurchase inAppPurchase);
  StreamSubscription<List<PurchaseDetails>> get subscription;

  Future<void> getTransactions();

  List<ProductDetails> get productDetails;
  Set<String> get kIds;
}
