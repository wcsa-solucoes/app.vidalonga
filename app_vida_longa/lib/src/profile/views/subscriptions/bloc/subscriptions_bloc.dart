import 'dart:async';
import 'dart:io';
import 'package:app_vida_longa/core/helpers/app_helper.dart';
import 'package:app_vida_longa/core/services/coupons_service.dart';
import 'package:app_vida_longa/core/services/iap_service/iap_purchase_apple_service.dart';
import 'package:app_vida_longa/core/services/iap_service/iap_purchase_google_service.dart';
import 'package:app_vida_longa/core/services/iap_service/interface/iap_purchase_service_interface.dart';
import 'package:app_vida_longa/core/services/plans_service.dart';
import 'package:app_vida_longa/core/services/signatures_service.dart';
import 'package:app_vida_longa/core/services/user_service.dart';
import 'package:app_vida_longa/domain/enums/subscription_type.dart';
import 'package:app_vida_longa/domain/models/coupon_model.dart';
import 'package:app_vida_longa/domain/models/plan_model.dart';
import 'package:app_vida_longa/domain/models/user_model.dart';
import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:meta/meta.dart';

part 'subscriptions_event.dart';
part 'subscriptions_state.dart';

class SubscriptionsBloc extends Bloc<SubscriptionsEvent, SubscriptionsState> {
  late final IInAppPurchaseService paymentService;
  final UserService _userService = UserService.instance;
  final ICouponsService _couponsService = CouponsServiceImpl.instance;
  final IPlansService _plansService = PlansServiceImpl.instance;
  final SignaturesService _signatgureService = SignaturesService.instance;

  late StreamSubscription<List<PurchaseDetails>> _subscription;
  late final StreamSubscription<UserModel> _userSubscription;

  late ProductDetails _productDetailsSelected;

  late final PlanModel defaultPlan;
  ProductDetails? _defaultProductDetails;

  ProductDetails? _productWithCoupon;
  final String _fullDiscountPlan = "RWGwlWCN1FyOkZfO9map";

  SubscriptionsBloc() : super(SubscriptionsLoading()) {
    if (Platform.isAndroid) {
      paymentService = InAppPurchaseImplServiceGoogleImpl.instance;
    } else {
      paymentService = InAppPurchaseImplServicesAppleImpl.instance;
    }
    defaultPlan = _plansService.defaultPlan;

    _defaultProductDetails = paymentService.productDetails.firstWhereOrNull(
      (element) {
        return element.id == defaultPlan.applePlanId ||
            element.id == defaultPlan.googlePlanId;
      },
    );

    on<FetchProductsEvent>(_handleOnFetchProducts);

    _subscription = InAppPurchase.instance.purchaseStream.listen(
      _handlePurchases,
      onError: (error) {
        add(SomeErrorEvent(error.toString()));
      },
    );

    add(FetchProductsEvent());

    on<LoadingViewEvent>(_handleOnLoading);
    on<SelectedProductEvent>(_handleOnProductSelected);
    on<PurchasedSubscriptionEvent>(_handleOnPurchased);
    on<ProductsLoadedEvent>(_handleOnProductsLoaded);
    on<RestorePurchasesEvent>(_handleOnRestorePurchases);
    on<RestoresTransactionsEvent>(_handleOnRestoresTransactions);
    on<SomeErrorEvent>(_handleOnError);
    on<PendingEvent>(_handleOnPending);
    on<AddedCouponEvent>(_handleOnCouponAdded);
    on<RestartEvent>(_handleOnRestart);

    _userSubscription = _userService.userStream.listen((event) {
      if (event.subscriptionLevel != SubscriptionEnum.nonPaying) {
        add(ProductsLoadedEvent(
          paymentService.productDetails,
        ));
      }
    });
  }
  FutureOr<void> _handleOnError(
      SomeErrorEvent event, Emitter<SubscriptionsState> emit) {
    emit(SubscriptionsErrorState(event.message));
  }

  FutureOr<void> _handleOnLoading(
      LoadingViewEvent event, Emitter<SubscriptionsState> emit) {
    emit(SubscriptionsLoading());
  }

  FutureOr<void> _handleOnFetchProducts(
      FetchProductsEvent event, Emitter<SubscriptionsState> emit) async {
    try {
      add(LoadingViewEvent());
      await paymentService.getProductsDetails(paymentService.kIds);

      add(ProductsLoadedEvent(paymentService.productDetails));
    } catch (e) {
      emit(SubscriptionsErrorState(e.toString()));
    }
  }

  FutureOr<void> _handleOnCouponAdded(
      AddedCouponEvent event, Emitter<SubscriptionsState> emit) async {
    final int index = _couponsService.coupons.indexWhere((element) {
      final res = element.name.toUpperCase() == event.couponName.toUpperCase();
      return res;
    });
    if (index != -1) {
      var coupon = _couponsService.coupons[index];

      if (coupon.activationDateTimestamp == null ||
          DateTime.now().millisecondsSinceEpoch <
              coupon.activationDateTimestamp!) {
        AppHelper.displayAlertError('Cupom ainda não ativado');
        return;
      }

      if (coupon.haveUsageLimit && coupon.usageQuantity >= coupon.limit) {
        AppHelper.displayAlertError('Cupom esgotado');
        return;
      }
      var now = DateTime.now().millisecond;
      var res = now >= coupon.expiryDateTimestamp!;
      if (coupon.expiryDateTimestamp != null && res) {
        AppHelper.displayAlertError('Cupom expirado');
        return;
      }

      _productWithCoupon = paymentService.productDetails.firstWhereOrNull(
        (ProductDetails element) {
          return element.id == coupon.applePlanId ||
              element.id == coupon.googlePlanId;
        },
      );

      if (_productWithCoupon == null &&
          _couponsService.coupons[index].planUuid != _fullDiscountPlan) {
        AppHelper.displayAlertError('Cupom inválido');
        return;
      }

      if (_couponsService.coupons[index].planUuid == _fullDiscountPlan) {
        await _signatgureService
            .addSignature(_couponsService.coupons[index].uuid);
        await _userService.updateSubscriberStatusFromRoles(
            SubscriptionEnum.paying, null);
        await _couponsService
            .incrementUsageQuantityOfCoupon(_couponsService.coupons[index]);

        emit(
          AddedFullSubscriptionDiscountState(
              coupon: _couponsService.coupons[index]),
        );
      } else {
        emit(
          CouponAddedState(
            coupon: _couponsService.coupons[index],
            productDetails: _productWithCoupon!,
          ),
        );
      }

      return;
    }

    AppHelper.displayAlertError('Cupom inválido');
  }

  FutureOr<void> _handleOnProductSelected(
      SelectedProductEvent event, Emitter<SubscriptionsState> emit) {
    _productDetailsSelected = event.productDetails;
    paymentService.purchase(_productDetailsSelected, coupon: event.couponAdded);

    emit(ProductSelectedState(event.productDetails));
  }

  FutureOr<void> _handleOnPurchased(
    PurchasedSubscriptionEvent event,
    Emitter<SubscriptionsState> emit,
  ) {
    emit(SubscriptionPurchased(event.purchaseDetails));
  }

  FutureOr<void> _handleOnProductsLoaded(
      ProductsLoadedEvent event, Emitter<SubscriptionsState> emit) async {
    _defaultProductDetails ??= paymentService.productDetails.firstWhereOrNull(
      (element) {
        return element.id == defaultPlan.applePlanId ||
            element.id == defaultPlan.googlePlanId;
      },
    );
    if (_defaultProductDetails == null) {
      emit(SubscriptionsErrorState('Erro ao carregar a assinatura!'));
      return;
    }

    emit(ProductsLoadedState(
      event.productDetails,
      _defaultProductDetails!,
      paymentService.defaultPlan,
    ));
  }

  void _handleOnPending(PendingEvent event, Emitter<SubscriptionsState> emit) {
    emit(ProductSelectedState(_productDetailsSelected));
  }

  void _handlePurchases(List<PurchaseDetails> purchaseDetailsList) {
    if (purchaseDetailsList.isEmpty) {
      AppHelper.displayAlertInfo('Nenhuma compra encontrada');
      return;
    }

    var lastPurchase = purchaseDetailsList.last;
    switch (lastPurchase.status) {
      case PurchaseStatus.error:
        add(ProductsLoadedEvent(paymentService.productDetails));

      case PurchaseStatus.canceled:
        add(ProductsLoadedEvent(paymentService.productDetails));
        break;
      case PurchaseStatus.purchased:
        add(PurchasedSubscriptionEvent(lastPurchase));
        break;
      case PurchaseStatus.pending:
        add(PendingEvent());
        break;
      default:
        add(ProductsLoadedEvent(paymentService.productDetails));

        break;
    }
  }

  FutureOr<void> _handleOnRestorePurchases(
      RestorePurchasesEvent event, Emitter<SubscriptionsState> emit) {
    paymentService.restorePurchase();
  }

  FutureOr<void> _handleOnRestoresTransactions(
      RestoresTransactionsEvent event, Emitter<SubscriptionsState> emit) {
    paymentService.getTransactions();
  }

  void handleDispose() {
    _subscription.cancel();
    _userSubscription.cancel();
    super.close();
  }

  void _handleOnRestart(RestartEvent event, Emitter<SubscriptionsState> emit) {
    add(ProductsLoadedEvent(paymentService.productDetails));
  }
}
