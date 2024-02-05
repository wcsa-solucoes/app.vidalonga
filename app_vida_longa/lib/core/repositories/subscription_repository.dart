import 'package:app_vida_longa/core/services/user_service.dart';
import 'package:app_vida_longa/domain/enums/subscription_type.dart';
import 'package:app_vida_longa/domain/models/response_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class ISubscriptionRepository {
  Future<ResponseStatusModel> updateSubscriberStatusFromRoles(
      SubscriptionEnum subscription, String platform);
}

class SubscriptionRepositoryImpl implements ISubscriptionRepository {
  FirebaseFirestore firestore;

  SubscriptionRepositoryImpl({
    required this.firestore,
  });

  @override
  Future<ResponseStatusModel> updateSubscriberStatusFromRoles(
      SubscriptionEnum subscriptionType, String platform) async {
    ResponseStatusModel responseStatusModel = ResponseStatusModel();

    await firestore.collection('users').doc(UserService.instance.user.id).set(
      {
        "roles": {"subscriptionType": subscriptionType.name},
        "lastPlatformUpdate": platform
      },
      SetOptions(merge: true),
    );

    return responseStatusModel;
  }
}
