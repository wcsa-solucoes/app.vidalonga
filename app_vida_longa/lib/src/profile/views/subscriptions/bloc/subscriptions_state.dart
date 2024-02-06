part of 'subscriptions_bloc.dart';

@immutable
sealed class SubscriptionsState {}

final class SubscriptionsInitial extends SubscriptionsState {}

final class SubscriptionsLoading extends SubscriptionsState {}

final class ProductsLoadedState extends SubscriptionsState {
  final List<ProductDetails> products;

  ProductsLoadedState(this.products);
}

final class SubscriptionsErrorState extends SubscriptionsState {
  final String message;

  SubscriptionsErrorState(this.message);
}

final class SubscriptionPurchased extends SubscriptionsState {
  final PurchaseDetails purchasedDetails;

  SubscriptionPurchased(this.purchasedDetails);
}

final class SubscriptionsRestored extends SubscriptionsState {}

final class SubscriptionsRestoredError extends SubscriptionsState {
  final String message;

  SubscriptionsRestoredError(this.message);
}

final class SubscriptionPurchasedError extends SubscriptionsState {
  final String message;

  SubscriptionPurchasedError(this.message);
}

final class SubscriptionPending extends SubscriptionsState {
  final ProductDetails productDetails;

  SubscriptionPending(this.productDetails);
}

final class ProductSelectedState extends SubscriptionsState {
  final ProductDetails productDetails;

  ProductSelectedState(this.productDetails);
}
