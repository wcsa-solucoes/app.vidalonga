import 'dart:async';

import 'package:app_vida_longa/core/helpers/print_colored_helper.dart';
import 'package:app_vida_longa/core/repositories/handle_ipa_repository/implementations/handle_iap_google_repository.dart';
import 'package:app_vida_longa/core/services/handle_iap_service.dart';
import 'package:app_vida_longa/core/services/iap_service/interface/iap_purchase_service_interface.dart';
import 'package:app_vida_longa/core/services/plans_service.dart';
import 'package:app_vida_longa/domain/models/coupon_model.dart';
import 'package:app_vida_longa/domain/models/plan_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/billing_client_wrappers.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';

class InAppPurchaseImplServiceGoogleImpl extends IInAppPurchaseService {
  InAppPurchaseImplServiceGoogleImpl._internal();
  static final InAppPurchaseImplServiceGoogleImpl _instance =
      InAppPurchaseImplServiceGoogleImpl._internal();
  static InAppPurchaseImplServiceGoogleImpl get instance => _instance;

  bool _hasInit = false;

  final HandleIAPService _handleIAPService = HandleIAPService(
    handleIAPRepository: HandleIAPGoogleRepositoryImpl(
      firestore: FirebaseFirestore.instance,
    ),
  );

  final IPlansService _plansService = PlansServiceImpl.instance;

  late final InAppPurchase _inAppPurchase;

  late final StreamSubscription<List<PurchaseDetails>> _subscription;
  @override
  StreamSubscription<List<PurchaseDetails>> get subscription => _subscription;

  final Set<String> _kIds = {};
  @override
  Set<String> get kIds => _kIds;

  @override
  PlanModel get defaultPlan => _plansService.defaultPlan;

  late final List<ProductDetails> _productDetails = [];
  @override
  List<ProductDetails> get productDetails => _productDetails;

  CouponModel? _couponAdded;
  @override
  CouponModel? get couponAdded => _couponAdded;

  @override
  Future<void> init(InAppPurchase inAppPurchase) async {
    if (_hasInit) {
      return;
    }

    _hasInit = true;
    _inAppPurchase = inAppPurchase;

    await _init();
  }

  Future<void> _init() async {
    for (var plan in _plansService.plans) {
      _kIds.add(plan.googlePlanId);
    }

    getProductsDetails(_kIds);

    final Stream<List<PurchaseDetails>> purchaseUpdated =
        _inAppPurchase.purchaseStream;

    _subscription = purchaseUpdated.listen(
      (purchaseDetailsList) {
        _handlePurchaseUpdates(purchaseDetailsList);
      },
      onError: (error) {},
      onDone: () {},
    );
  }

  void _handlePurchaseUpdates(List<PurchaseDetails> purchaseDetailsList) async {
    if (purchaseDetailsList.isEmpty) return;

    PrintColoredHelper.printPink(purchaseDetailsList.toString());
    final PurchaseDetails purchaseDetails = purchaseDetailsList.last;

    if (purchaseDetails.status == PurchaseStatus.pending) {
    } else {
      if (purchaseDetails.status == PurchaseStatus.error) {
      } else if (purchaseDetails.status == PurchaseStatus.purchased ||
          purchaseDetails.status == PurchaseStatus.restored) {
        if (purchaseDetails.status == PurchaseStatus.purchased) {
          await _handleIAPService.handlePurchase(
            purchaseDetails,
            'google_play',
            couponAdded: _couponAdded,
          );
        }
        _couponAdded = null;

        if (purchaseDetails.status == PurchaseStatus.restored) {
          await _handleIAPService.handlePurchase(
            purchaseDetails,
            'google_play',
          );
        }

        if (purchaseDetails.pendingCompletePurchase) {
          await _inAppPurchase.completePurchase(purchaseDetails);
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

    final response = await _inAppPurchase.queryProductDetails(kIds);

    if (response.productDetails.isEmpty == true) return [];

    _setProductsDetails(response.productDetails);

    return response.productDetails;
  }

  void _setProductsDetails(List<ProductDetails> newItens) {
    _productDetails.clear();
    _productDetails.addAll(newItens);
  }

  @override
  Future<void> getTransactions() {
    throw UnimplementedError();
  }

  @override
  Future<bool> purchase(ProductDetails productDetails,
      {CouponModel? coupon}) async {
    PurchaseParam? purchaseParam;
    _couponAdded = coupon;

    try {
      GooglePlayPurchaseDetails? oldSubscription;

      oldSubscription =
          _getOldSubscription(productDetails, <String, PurchaseDetails>{});

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

      await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
      return true;
    } on PlatformException catch (e) {
      PrintColoredHelper.printOrange(e.toString());
      return false;
    } catch (e) {
      return false;
    }
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
  Future<bool> restorePurchase() {
    InAppPurchase.instance.restorePurchases();
    return Future.value(true);
  }
}
