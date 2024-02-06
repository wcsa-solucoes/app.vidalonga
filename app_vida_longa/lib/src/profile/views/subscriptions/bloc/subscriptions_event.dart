part of 'subscriptions_bloc.dart';

@immutable
sealed class SubscriptionsEvent {}

class FetchProductsEvent extends SubscriptionsEvent {}

class SelectedProductEvent extends SubscriptionsEvent {
  final ProductDetails productDetails;

  SelectedProductEvent(this.productDetails);
}

class RestorePurchaseEvent extends SubscriptionsEvent {}

class LoadingViewEvent extends SubscriptionsEvent {
  LoadingViewEvent();
}

class PurchasedSubscriptionEvent extends SubscriptionsEvent {
  final PurchaseDetails purchaseDetails;

  PurchasedSubscriptionEvent(this.purchaseDetails);
}

class ProductsLoadedEvent extends SubscriptionsEvent {
  final List<ProductDetails> productDetails;

  ProductsLoadedEvent(this.productDetails);
}

class RestorePurchasesEvent extends SubscriptionsEvent {
  RestorePurchasesEvent();
}

class RestoresTransactionsEvent extends SubscriptionsEvent {
  RestoresTransactionsEvent();
}

class SomeErrorEvent extends SubscriptionsEvent {
  final String message;

  SomeErrorEvent(this.message);
}
