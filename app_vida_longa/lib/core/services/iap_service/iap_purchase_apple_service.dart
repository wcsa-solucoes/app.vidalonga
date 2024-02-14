import 'dart:async';
import 'package:app_vida_longa/core/helpers/print_colored_helper.dart';
import 'package:app_vida_longa/core/repositories/handle_ipa_repository/implementations/handle_iap_apple_repository.dart';
import 'package:app_vida_longa/core/services/handle_iap_service.dart';
import 'package:app_vida_longa/core/services/iap_service/interface/iap_purchase_service_interface.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_platform_interface/in_app_purchase_platform_interface.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';

class InAppPurchaseImplServicesAppleImpl extends IInAppPurchaseService {
  InAppPurchaseImplServicesAppleImpl._internal();
  static final InAppPurchaseImplServicesAppleImpl _instance =
      InAppPurchaseImplServicesAppleImpl._internal();
  static InAppPurchaseImplServicesAppleImpl get instance => _instance;

  final HandleIAPService _handleIAPService = HandleIAPService(
    handleIAPRepository: HandleIAPAppleRepositoryImpl(
      firestore: FirebaseFirestore.instance,
    ),
  );

  final InAppPurchaseStoreKitPlatform iap =
      InAppPurchasePlatform.instance as InAppPurchaseStoreKitPlatform;

  late final InAppPurchaseStoreKitPlatformAddition _iosPlatformAddition;

  late final InAppPurchase _inAppPurchase;

  late final StreamSubscription<List<PurchaseDetails>> _subscription;
  @override
  StreamSubscription<List<PurchaseDetails>> get subscription => _subscription;

  Set<String> _kIds = {};
  @override
  Set<String> get kIds => _kIds;

  late final List<ProductDetails> _productDetails = [];
  @override
  List<ProductDetails> get productDetails => _productDetails;

  @override
  Future<void> init(InAppPurchase inAppPurchase) async {
    _inAppPurchase = inAppPurchase;

    await _init();
  }

  Future<void> _init() async {
    _kIds = {
      'app.vidalongaapp.assinaturamensal',
      'app.vidalongaapp.assinaturamensal.test.40',
    };

    final Stream<List<PurchaseDetails>> purchaseUpdated =
        _inAppPurchase.purchaseStream;

    _subscription = purchaseUpdated.listen(
      (purchaseDetailsList) {
        _handlePurchaseUpdatesFromApples(purchaseDetailsList);
      },
      onError: (error) {},
      onDone: () {},
    );
  }

  void _handlePurchaseUpdatesFromApples(
      List<PurchaseDetails> purchaseDetailsList) async {
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.canceled) {
        await _finishIncompleteIosTransactions();
      }

      if (purchaseDetails.status == PurchaseStatus.pending) {
        //
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          if (purchaseDetails.status == PurchaseStatus.purchased) {
            await _handleIAPService.handlePurchase(
                purchaseDetails, 'app_store');
          }

          if (purchaseDetails.pendingCompletePurchase) {
            await _inAppPurchase.completePurchase(purchaseDetails);
          }
        }
      }
    }
  }

  @override
  Future<List<ProductDetails>?> getProductsDetails(
      Set<String> productIds) async {
    if (productDetails.isNotEmpty) {
      return productDetails;
    }

    final isStoreAvailable = await _inAppPurchase.isAvailable();

    if (isStoreAvailable == false) return [];

    _iosPlatformAddition = _inAppPurchase
        .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
    await _iosPlatformAddition.setDelegate(_IosPaymentQueueDelegate());

    final response = await _inAppPurchase.queryProductDetails(kIds);

    if (response.productDetails.isEmpty == true) return [];

    _setProductsDetails(response.productDetails);

    return response.productDetails;
  }

  void _setProductsDetails(List<ProductDetails> newItens) {
    productDetails.clear();
    productDetails.addAll(newItens);
  }

  @override
  Future<void> getTransactions() async {
    await SKPaymentQueueWrapper().transactions();
  }

  @override
  Future<bool> purchase(ProductDetails productDetails) async {
    PurchaseParam? purchaseParam;

    try {
      purchaseParam = PurchaseParam(productDetails: productDetails);
      await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
      return true;
    } on PlatformException catch (e) {
      PrintColoredHelper.printWhite(e.toString());

      await _finishIncompleteIosTransactions();
      return false;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> restorePurchase() {
    InAppPurchase.instance.restorePurchases();
    return Future.value(true);
  }
}

Future<void> _finishIncompleteIosTransactions() async {
  final transactions = await SKPaymentQueueWrapper().transactions();
  for (final skPaymentTransactionWrapper in transactions) {
    skPaymentTransactionWrapper.payment.productIdentifier;
    SKPaymentQueueWrapper().finishTransaction(skPaymentTransactionWrapper);
    PrintColoredHelper.printWhite('finishing incompleted IOS transaction');
  }
}

class _IosPaymentQueueDelegate implements SKPaymentQueueDelegateWrapper {
  @override
  bool shouldContinueTransaction(
      SKPaymentTransactionWrapper transaction, SKStorefrontWrapper storefront) {
    return true;
  }

  @override
  bool shouldShowPriceConsent() {
    return false;
  }
}