import 'dart:async';
import 'dart:io';
import 'package:app_vida_longa/core/services/iap_service/iap_purchase_apple_service.dart';
import 'package:app_vida_longa/core/services/iap_service/iap_purchase_google_service.dart';
import 'package:app_vida_longa/core/services/iap_service/interface/iap_purchase_service_interface.dart';
import 'package:app_vida_longa/core/services/user_service.dart';
import 'package:app_vida_longa/domain/enums/subscription_type.dart';
import 'package:app_vida_longa/domain/models/user_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:meta/meta.dart';

part 'subscriptions_event.dart';
part 'subscriptions_state.dart';

class SubscriptionsBloc extends Bloc<SubscriptionsEvent, SubscriptionsState> {
  late final IInAppPurchaseService paymentService;
  final UserService _userService = UserService.instance;

  late StreamSubscription<List<PurchaseDetails>> _subscription;
  late final StreamSubscription<UserModel> _userSubscription;

  SubscriptionsBloc() : super(SubscriptionsLoading()) {
    if (Platform.isAndroid) {
      paymentService = InAppPurchaseImplServiceGoogleImpl.instance;
    } else {
      paymentService = InAppPurchaseImplServicesAppleImpl.instance;
    }

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

  FutureOr<void> _handleOnProductSelected(
      SelectedProductEvent event, Emitter<SubscriptionsState> emit) {
    paymentService.purchase(event.productDetails);
    emit(ProductSelectedState(event.productDetails));
  }

  FutureOr<void> _handleOnPurchased(
    PurchasedSubscriptionEvent event,
    Emitter<SubscriptionsState> emit,
  ) {
    emit(SubscriptionPurchased(event.purchaseDetails));
  }

  FutureOr<void> _handleOnProductsLoaded(
      ProductsLoadedEvent event, Emitter<SubscriptionsState> emit) {
    emit(ProductsLoadedState(event.productDetails));
  }

  void _handlePurchases(purchaseDetailsList) {
    var lastPurchase = purchaseDetailsList.last;

    if (lastPurchase.status == PurchaseStatus.error) {
      add(ProductsLoadedEvent(paymentService.productDetails));
      return;
    }

    if (lastPurchase.status == PurchaseStatus.purchased) {
      add(PurchasedSubscriptionEvent(lastPurchase));
    }

    if (lastPurchase.status == PurchaseStatus.canceled) {
      add(ProductsLoadedEvent(paymentService.productDetails));
    }
    //  if (lastPurchase.status == PurchaseStatus.error) {
    //   add(SubscriptionsErrorEvent(lastPurchase.error.toString()));
    // }
    // if (lastPurchase.status == PurchaseStatus.pending) {
    //   add(SubscriptionsErrorEvent(lastPurchase.error.toString()));
    // }
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
}
