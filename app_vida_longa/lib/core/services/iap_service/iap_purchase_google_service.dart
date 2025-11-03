import 'dart:async';
import 'dart:developer';

import 'package:app_vida_longa/core/helpers/app_helper.dart';
import 'package:app_vida_longa/core/helpers/print_colored_helper.dart';
import 'package:app_vida_longa/core/repositories/handle_ipa_repository/implementations/handle_iap_google_repository.dart';
import 'package:app_vida_longa/core/services/iap_service/handle_iap_service.dart';
import 'package:app_vida_longa/core/services/iap_service/interface/iap_purchase_service_interface.dart';
import 'package:app_vida_longa/core/services/plans_service.dart';
import 'package:app_vida_longa/domain/models/coupon_model.dart';
import 'package:app_vida_longa/domain/models/plan_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
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
    debugPrint('🚀 [IAP] Starting _init() method');
    debugPrint('🚀 [IAP] Available plans: ${_plansService.plans.length}');

    for (var plan in _plansService.plans) {
      debugPrint(
        '🚀 [IAP] Processing plan: ${plan.name}, googlePlanId: ${plan.googlePlanId}',
      );
      if (plan.googlePlanId != null && plan.googlePlanId!.isNotEmpty) {
        _kIds.add(plan.googlePlanId!);
        debugPrint(
          '🚀 [IAP] Added googlePlanId to _kIds: ${plan.googlePlanId}',
        );
      }
    }

    debugPrint('🚀 [IAP] Final _kIds set: $_kIds');
    debugPrint(
      '🚀 [IAP] About to call getProductsDetails with ${_kIds.length} product IDs',
    );

    await getProductsDetails(_kIds);

    debugPrint('🚀 [IAP] getProductsDetails completed successfully');

    final Stream<List<PurchaseDetails>> purchaseUpdated =
        _inAppPurchase.purchaseStream;

    _subscription = purchaseUpdated.listen(
      (purchaseDetailsList) async {
        await _handlePurchaseUpdates(purchaseDetailsList);
        isRestored = false;
      },
      onError: (error) {},
      onDone: () {},
    );
  }

  bool isRestored = false;

  Future<void> _handlePurchaseUpdates(
    List<PurchaseDetails> purchaseDetailsList,
  ) async {
    if (purchaseDetailsList.isEmpty) {
      AppHelper.displayAlertInfo('Erro ao realizar a compra, tente novamente');
      return;
    }

    final PurchaseDetails purchaseDetails = purchaseDetailsList.last;

    if (purchaseDetails.status == PurchaseStatus.pending) {
    } else {
      if (purchaseDetails.status == PurchaseStatus.error) {
      } else if (purchaseDetails.status == PurchaseStatus.purchased ||
          purchaseDetails.status == PurchaseStatus.restored) {
        final PlanModel plan = _plansService.getPlanIdByGoogleId(
          purchaseDetails.productID,
        );

        if (purchaseDetails.status == PurchaseStatus.purchased) {
          if (isRestored) {
            _handleIAPService.recoverPurchase(purchaseDetails, "google_play");
          } else {
            await _handleIAPService.handlePurchase(
              purchaseDetails,
              'google_play',
              plan,
              couponAdded: _couponAdded,
            );
          }

          isRestored = false;
        }
        _couponAdded = null;

        if (purchaseDetails.status == PurchaseStatus.restored) {
          isRestored = true;

          await _handleIAPService.recoverPurchase(
            purchaseDetails,
            "google_play",
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
    Set<String> productIds,
  ) async {
    debugPrint(
      '🚀 [IAP] getProductsDetails called with productIds: $productIds',
    );

    if (_productDetails.isNotEmpty) {
      debugPrint('🚀 [IAP] Product details already cached, returning existing');
      return _productDetails;
    }

    debugPrint('🚀 [IAP] Checking if store is available...');
    final isStoreAvailable = await _inAppPurchase.isAvailable();
    debugPrint('🚀 [IAP] isStoreAvailable: $isStoreAvailable');

    if (isStoreAvailable == false) {
      debugPrint('🚀 [IAP] Store not available, returning empty list');
      return [];
    }

    debugPrint('🚀 [IAP] About to query product details for: $productIds');
    debugPrint(
      '🚀 [IAP] This is the critical point - if it hangs, the issue is here',
    );
    debugPrint('🚀 [IAP] Possible causes if hanging:');
    debugPrint(
      '🚀 [IAP] 1. App signing key not registered in Google Play Console',
    );
    debugPrint(
      '🚀 [IAP] 2. Package name mismatch (app: com.vidalongaapp.app vs products: com.vidalonga.*)',
    );
    debugPrint(
      '🚀 [IAP] 3. Products not associated with correct app in Play Console',
    );
    debugPrint('🚀 [IAP] 4. App not published/approved for in-app billing');

    try {
      debugPrint('🚀 [IAP] Querying product details with proper configuration');
      debugPrint(
        '🚀 [IAP] Using production signing as required by Google Play Billing',
      );

      final response = await _inAppPurchase
          .queryProductDetails(productIds)
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () {
              debugPrint(
                '🚀 [IAP] queryProductDetails timed out after 30 seconds!',
              );
              debugPrint(
                '🚀 [IAP] This confirms the product is not properly configured in Google Play Console',
              );
              debugPrint('🚀 [IAP] Possible issues:');
              debugPrint(
                '🚀 [IAP] - Product not associated with package com.vidalongaapp.app',
              );
              debugPrint('🚀 [IAP] - App not published for in-app billing');
              debugPrint('🚀 [IAP] - Product not in Active status');
              throw TimeoutException(
                'queryProductDetails timeout',
                const Duration(seconds: 30),
              );
            },
          )
          .catchError((error) {
            debugPrint('🚀 [IAP] queryProductDetails failed with error: $error');
            if (error is PlatformException) {
              debugPrint('🚀 [IAP] Platform error code: ${error.code}');
              debugPrint('🚀 [IAP] Platform error message: ${error.message}');
              debugPrint('🚀 [IAP] Platform error details: ${error.details}');
            }
            throw error;
          })
          .onError<TimeoutException>((error, stackTrace) {
            debugPrint('🚀 [IAP] Timeout error caught: $error');
            debugPrint('🚀 [IAP] Stack trace: $stackTrace');
            throw error;
          })
          .onError<PlatformException>((error, stackTrace) {
            debugPrint('🚀 [IAP] Platform exception caught: $error');
            debugPrint('🚀 [IAP] Platform error code: ${error.code}');
            debugPrint('🚀 [IAP] Platform error message: ${error.message}');
            debugPrint('🚀 [IAP] Platform error details: ${error.details}');
            debugPrint('🚀 [IAP] Platform stack trace: $stackTrace');
            throw error;
          })
          .onError<StateError>((error, stackTrace) {
            debugPrint('🚀 [IAP] State error caught: $error');
            debugPrint('🚀 [IAP] State error message: ${error.message}');
            debugPrint('🚀 [IAP] State error stack trace: $stackTrace');
            throw error;
          })
          .onError<ArgumentError>((error, stackTrace) {
            debugPrint('🚀 [IAP] Argument error caught: $error');
            debugPrint('🚀 [IAP] Argument error message: ${error.message}');
            debugPrint('🚀 [IAP] Argument error invalid value: ${error.invalidValue}');
            debugPrint('🚀 [IAP] Argument error name: ${error.name}');
            debugPrint('🚀 [IAP] Argument error stack trace: $stackTrace');
            throw error;
          })
          .onError<FormatException>((error, stackTrace) {
            debugPrint('🚀 [IAP] Format exception caught: $error');
            debugPrint('🚀 [IAP] Format error message: ${error.message}');
            debugPrint('🚀 [IAP] Format error source: ${error.source}');
            debugPrint('🚀 [IAP] Format error offset: ${error.offset}');
            debugPrint('🚀 [IAP] Format error stack trace: $stackTrace');
            throw error;
          })
          .onError<Exception>((error, stackTrace) {
            debugPrint('🚀 [IAP] Generic exception caught: $error');
            debugPrint('🚀 [IAP] Exception type: ${error.runtimeType}');
            debugPrint('🚀 [IAP] Exception stack trace: $stackTrace');
            throw error;
          })
          .onError<Error>((error, stackTrace) {
            debugPrint('🚀 [IAP] Error caught: $error');
            debugPrint('🚀 [IAP] Error type: ${error.runtimeType}');
            debugPrint('🚀 [IAP] Error stack trace: $stackTrace');
            throw error;
          })
          .onError<Object>((error, stackTrace) {
            debugPrint('🚀 [IAP] Unknown error type caught: $error');
            debugPrint('🚀 [IAP] Unknown error type: ${error.runtimeType}');
            debugPrint('🚀 [IAP] Unknown error stack trace: $stackTrace');
            throw error;
          })
          .then((response) {
            debugPrint('🚀 [IAP] queryProductDetails then() handler - Success!');
            debugPrint('🚀 [IAP] Response type: ${response.runtimeType}');
            debugPrint('🚀 [IAP] Response received at: ${DateTime.now()}');
            return response;
          })
          .whenComplete(() {
            debugPrint('🚀 [IAP] queryProductDetails request completed (success or failure)');
            debugPrint('🚀 [IAP] Completion timestamp: ${DateTime.now()}');
          });
      debugPrint('🚀 [IAP] queryProductDetails completed! Response received');

      debugPrint(
        '🚀 [IAP] Found ${response.productDetails.length} product details',
      );
      debugPrint('🚀 [IAP] Not found IDs: ${response.notFoundIDs}');

      if (response.productDetails.isEmpty == true) {
        debugPrint('🚀 [IAP] No product details found, returning empty list');
        return [];
      }

      _setProductsDetails(response.productDetails);
      debugPrint('🚀 [IAP] Product details set successfully');

      return response.productDetails;
    } catch (e) {
      debugPrint('🚀 [IAP] ERROR in queryProductDetails: $e');
      log('inAppPurchase.queryProductDetails(kIds);', error: e);
      return [];
    }
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
  Future<bool> purchase(
    ProductDetails productDetails, {
    CouponModel? coupon,
  }) async {
    PurchaseParam? purchaseParam;
    _couponAdded = coupon;

    try {
      GooglePlayPurchaseDetails? oldSubscription;

      oldSubscription = _getOldSubscription(
        productDetails,
        <String, PurchaseDetails>{},
      );

      purchaseParam = GooglePlayPurchaseParam(
        productDetails: productDetails,
        // applicationUserName: packageName,
        changeSubscriptionParam: oldSubscription != null
            ? ChangeSubscriptionParam(
                oldPurchaseDetails: oldSubscription,
                replacementMode: ReplacementMode.withTimeProration,
              )
            : null,
      );

      await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
      return true;
    } on PlatformException catch (e) {
      PrintColoredHelper.printError(e.toString());
      return false;
    } catch (e) {
      return false;
    }
  }

  GooglePlayPurchaseDetails? _getOldSubscription(
    ProductDetails productDetails,
    Map<String, PurchaseDetails>? purchases,
  ) {
    // This is just to demonstrate a subscription upgrade or downgrade.
    // This method assumes that you get your old subscription id from your backend or somewhere else
    // Please remember to replace the logic of finding the old subscription Id as per your app.
    // The old subscription is only required on Android since Apple handles this internally
    // by using the subscription group feature in ItunesConnect.

    var oldSubscriptionId = productDetails.id;

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
