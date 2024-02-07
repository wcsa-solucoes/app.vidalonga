import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:app_vida_longa/core/helpers/print_colored_helper.dart';
import 'package:app_vida_longa/core/services/handle_iap_service.dart';
import 'package:flutter/services.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_android/billing_client_wrappers.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import 'package:in_app_purchase_platform_interface/in_app_purchase_platform_interface.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';

abstract class IInAppPurchaseService {
  Future<List<ProductDetails>?> getProductsDetails(Set<String> productIds);
  Future<bool> purchase(ProductDetails productDetails);
  Future<bool> restorePurchase();
  Future<void> init(InAppPurchase inAppPurchase);
  late final StreamSubscription<List<PurchaseDetails>> _subscription;
  // final List<model.ProductModel> _products = [];
  // List<model.ProductModel> get products => _products;
  final List<ProductDetails> _productDetails = [];
  List<ProductDetails> get productDetails => _productDetails;
  late final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition;
  getTransactions();

  late final Set<String> _kIds;

  Set<String> get kIds => _kIds;
}

class InAppPurchaseImplServices extends IInAppPurchaseService {
  InAppPurchaseImplServices._internal();
  static final InAppPurchaseImplServices _instance =
      InAppPurchaseImplServices._internal();
  static InAppPurchaseImplServices get instance => _instance;

  final HandleIAPService _handleIAPService = HandleIAPService.instance;

  late final InAppPurchase _inAppPurchase;

  final InAppPurchaseStoreKitPlatform iap =
      InAppPurchasePlatform.instance as InAppPurchaseStoreKitPlatform;

  // final SubscriptionService _subscriptionService = SubscriptionService();

  @override
  Future<void> init(InAppPurchase inAppPurchase) async {
    _inAppPurchase = inAppPurchase;

    await _init();
  }

  Future<void> _init() async {
    // await _handleIAPService.getPurchases();
    _kIds = {
      'app.vidalongaapp.assinaturamensal',
      'app.vidalongaapp.assinaturamensal.test.40',
      "com.vidalonga.assinaturamensal",
      "com.vidalonga.assinaturamensal.10",
    };

    final Stream<List<PurchaseDetails>> purchaseUpdated =
        _inAppPurchase.purchaseStream;

    _subscription = purchaseUpdated.listen(
      (purchaseDetailsList) {
        _handlePurchaseUpdates(purchaseDetailsList);
      },
      onError: (error) {
        PrintColoredHelper.printGreen('purchaseUpdates error: $error');
      },
      onDone: () {
        PrintColoredHelper.printGreen('purchaseUpdates onDone');
      },
    );
  }

  void _handlePurchaseUpdates(List<PurchaseDetails> purchaseDetailsList) async {
    PrintColoredHelper.printError(purchaseDetailsList.length.toString());
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.canceled) {
        PrintColoredHelper.printGreen('purchase canceled');
        if (Platform.isIOS) {
          await _finishIncompleteIosTransactions();
        }
      }
      if (purchaseDetails.verificationData.source == "app_store") {
        final AppStorePurchaseDetails applePurDet =
            purchaseDetails as AppStorePurchaseDetails;
        if (applePurDet.transactionDate != null) {
          PrintColoredHelper.printOrange(
              "Date: ${DateTime.fromMillisecondsSinceEpoch(int.parse(applePurDet.transactionDate!))} ");
        }

        PrintColoredHelper.printPink(
            'status: ${applePurDet.status}  purchaseID: ${applePurDet.purchaseID} productID: ${applePurDet.productID},');
        //green
        PrintColoredHelper.printGreen(
            "skPayTransac transcationId: ${applePurDet.skPaymentTransaction.transactionIdentifier}");
        //white
        PrintColoredHelper.printWhite(
            "orgTransac transcationId: ${applePurDet.skPaymentTransaction.originalTransaction?.transactionIdentifier}");
      }

      if (purchaseDetails.status == PurchaseStatus.pending) {
        // Não mostre ao usuário que uma compra está pendente. A atualização automática do aplicativo
        // irá notificar o usuário quando a compra for concluída ou falhar.
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          // Você pode utilizar purchaseDetails.error para obter mais detalhes.
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          // A compra foi bem-sucedida ou restaurada.
          // Aqui, você deve entregar o produto e validar o recibo da compra.
          PrintColoredHelper.printCyan(
              "pendingCompletePurchase :${purchaseDetails.pendingCompletePurchase}");

          if (purchaseDetails.status == PurchaseStatus.purchased) {
            if (Platform.isIOS) {
              await _handleIAPService.handlePurchase(
                  purchaseDetails, 'applePurchases', 'app_store');
            } else if (Platform.isAndroid) {
              await _handleIAPService.handlePurchase(
                  purchaseDetails, 'googlePurchases', 'google_play');
            }
            //red
            PrintColoredHelper.printError(
                'handlePurchase purchaseID: ${purchaseDetails.purchaseID}');
          }

          // Importante: Sempre complete a transação para iOS.
          if (purchaseDetails.pendingCompletePurchase && Platform.isIOS) {
            await _inAppPurchase.completePurchase(purchaseDetails);
            PrintColoredHelper.printCyan('completePurchase');
          }
        }
      }
    }
  }

  @override
  Future<List<ProductDetails>?> getProductsDetails(
      Set<String> productIds) async {
    if (_productDetails.isNotEmpty) {
      return _productDetails;
    }

    final isStoreAvailable = await _inAppPurchase.isAvailable();

    if (isStoreAvailable == false) return [];

    if (Platform.isIOS) {
      iosPlatformAddition = _inAppPurchase
          .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      await iosPlatformAddition.setDelegate(_IosPaymentQueueDelegate());
    }

    final response = await _inAppPurchase.queryProductDetails(_kIds);

    if (response.productDetails.isEmpty == true) return [];

    _setProductsDetails(response.productDetails);

    return response.productDetails;
  }

  void _setProductsDetails(List<ProductDetails> newItens) {
    _productDetails.clear();
    // AppStorePurchaseDetails appStorePurchaseDetails;

    _productDetails.addAll(newItens);
  }

  @override
  Future<bool> purchase(ProductDetails productDetails) async {
    PurchaseParam? purchaseParam;

    try {
      if (Platform.isAndroid) {
        GooglePlayPurchaseDetails? oldSubscription;

        // if (product.productType == model.ProductType.subscription)
        //  {
        oldSubscription =
            _getOldSubscription(productDetails, <String, PurchaseDetails>{});
        // }

        purchaseParam = GooglePlayPurchaseParam(
          productDetails: productDetails,
          // applicationUserName: packageName,
          changeSubscriptionParam: oldSubscription != null
              ? ChangeSubscriptionParam(
                  oldPurchaseDetails: oldSubscription,
                  prorationMode: ProrationMode.immediateWithTimeProration,
                )
              : null,
        );
      } else if (Platform.isIOS) {
        purchaseParam = PurchaseParam(
          productDetails: productDetails,
          // applicationUserName: packageName,
        );
      }

      if (purchaseParam != null) {
        await _inAppPurchase
            .buyNonConsumable(purchaseParam: purchaseParam)
            .then(
              (value) => PrintColoredHelper.printCyan(
                  'buyNonConsumable value: $value'),
            );
        return true;
      }
    } on PlatformException catch (e) {
      log('Error making ${Platform.isAndroid ? 'Android' : 'IOS'} purchase:$e');
      if (Platform.isIOS) await _finishIncompleteIosTransactions();
      return false;
    } catch (e) {
      return false;
    }
    return false;
  }

  @override
  Future<bool> restorePurchase() {
    InAppPurchase.instance.restorePurchases();
    return Future.value(true);
  }

  GooglePlayPurchaseDetails? _getOldSubscription(
      ProductDetails productDetails, Map<String, PurchaseDetails>? purchases) {
    // This is just to demonstrate a subscription upgrade or downgrade.
    // This method assumes that you get your old subscription id from your backend or somewhere else
    // Please remember to replace the logic of finding the old subscription Id as per your app.
    // The old subscription is only required on Android since Apple handles this internally
    // by using the subscription group feature in ItunesConnect.

    const oldSubscriptionId = 'old.subscription.teste';

    if (purchases?.containsKey(oldSubscriptionId) == true) {
      return purchases?[oldSubscriptionId] as GooglePlayPurchaseDetails;
    }
    return null;
  }

  @override
  getTransactions() async {
    final transactions = await SKPaymentQueueWrapper().transactions();
    for (var element in transactions) {
      log('transaction: ${element.transactionState} ${element.transactionTimeStamp}');
    }
  }

  Future<void> dispose() async {
    _subscription.cancel();
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
