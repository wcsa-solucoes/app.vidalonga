import 'package:app_vida_longa/core/repositories/subscription_repository.dart';
import 'package:app_vida_longa/domain/enums/subscription_type.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SubscriptionService {
  final ISubscriptionRepository _subscriptionRepository =
      SubscriptionRepositoryImpl(
    firestore: FirebaseFirestore.instance,
  );

  Future<void> updateSubscriberStatusFromRoles(
      SubscriptionEnum subscription) async {
    await _subscriptionRepository.updateSubscriberStatusFromRoles(subscription);
    return;
  }
}
