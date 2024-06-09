import "dart:async";

import "package:app_vida_longa/core/helpers/app_helper.dart";
import "package:app_vida_longa/core/helpers/async_helper.dart";
import 'package:app_vida_longa/core/controllers/we_exception.dart';
import "package:app_vida_longa/core/helpers/date_time_helper.dart";
import "package:app_vida_longa/core/helpers/print_colored_helper.dart";
import "package:app_vida_longa/core/services/auth_service.dart";
import "package:app_vida_longa/core/services/user_service.dart";
import "package:app_vida_longa/domain/enums/custom_exceptions_codes_enum.dart";
import "package:app_vida_longa/domain/models/response_model.dart";
import "package:app_vida_longa/domain/models/user_model.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_messaging/firebase_messaging.dart";
import "package:tuple/tuple.dart";

class UserRepository {
  late final FirebaseFirestore _instance = FirebaseFirestore.instance;
  late final FirebaseAuth _auth = FirebaseAuth.instance;

  late bool _hasInitListener = false;

  late StreamSubscription<DocumentSnapshot>? _userStreamSubscription;

  final StreamController<UserModel> _userController =
      StreamController<UserModel>.broadcast();

  Stream<UserModel> get userStream => _userController.stream;
  final UserService _userService = UserService.instance;

  Future<ResponseStatusModel> create(UserModel user) async {
    late ResponseStatusModel response = ResponseStatusModel();

    await AsyncHelper.retry(() => _instance
        .collection("users")
        .doc(_auth.currentUser!.uid)
        .set({
          ...user.toJson(),
          "createdAt": DateTimeHelper.formatDateTimeToYYYYMMDDHHmmss(
            DateTime.now(),
          ),
          "isActive": true,
          "lastSubscriptionPlatform": null,
          "roles": {
            "subscriptionType": "nonPaying",
          },
          "lastSignatureId": null,
          "profile": "client",
        })
        .then((value) => null)
        .onError((error, stackTrace) {
          response = WeException.handle(error);
        }));

    return response;
  }

  //fluter pub add firestore

  Future<Tuple2<ResponseStatusModel, UserModel>> get() async {
    late ResponseStatusModel response = ResponseStatusModel();
    late UserModel user = UserModel();

    await _instance
        .collection("users")
        .doc(_auth.currentUser!.uid)
        .get()
        .then((snapshot) {
      if (snapshot.exists) {
        user = UserModel.fromJson(snapshot.data()!);
      } else {
        response.status = ResponseStatusEnum.failed;
        response.code = WeExceptionCodesEnum.firebaseAuthUserNotFound;
      }
    }).onError((error, stackTrace) {
      response = WeException.handle(error);
    });

    return Tuple2(response, user);
  }

  Future<ResponseStatusModel> update(UserModel user) async {
    late ResponseStatusModel response = ResponseStatusModel();

    await _instance
        .collection("users")
        .doc(_auth.currentUser!.uid)
        .set(user.toJson(), SetOptions(merge: true))
        .then((value) {
      response.message = "Conta atualizada com sucesso";
    }).onError((error, stackTrace) {
      response = WeException.handle(error);
    });
    return response;
  }

  Future<ResponseStatusModel> updateName({required String name}) async {
    late ResponseStatusModel response = ResponseStatusModel();

    await _auth.currentUser!
        .updateDisplayName(name)
        .onError((error, stackTrace) {
      response = WeException.handle(error);
    });

    if (response.status == ResponseStatusEnum.failed) {
      return response;
    }

    await _instance
        .collection("users")
        .doc(_auth.currentUser!.uid)
        .update({"name": name}).onError((error, stackTrace) {
      response = WeException.handle(error);
    });

    return response;
  }

  Future<ResponseStatusModel> updatePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final userCredential = EmailAuthProvider.credential(
        email: _auth.currentUser!.email!, password: currentPassword);

    late ResponseStatusModel response = ResponseStatusModel();

    try {
      await _auth.currentUser!.reauthenticateWithCredential(userCredential);
    } catch (error) {
      return WeException.handle(error);
    }

    await _auth.currentUser!.updatePassword(newPassword).then((snapshot) {
      response.message = "Senha alterada com sucesso";
    }).onError((error, stackTrace) {
      response = WeException.handle(error);
    });

    return response;
  }

  Future<Tuple2<ResponseStatusModel, bool>> verifyRegister(
    String register,
  ) async {
    late ResponseStatusModel response = ResponseStatusModel();
    late bool hasRegister = false;

    await _instance
        .collection("users")
        .where("document", isEqualTo: register)
        .limit(1)
        .get()
        .then((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        hasRegister = true;
      }
    }).onError((error, stackTrace) {
      response = WeException.handle(error);
    });

    return Tuple2(response, hasRegister);
  }

  void updateListener() {
    if (_auth.currentUser != null) {
      _hasInitListener = true;
      _userStreamSubscription = FirebaseFirestore.instance
          .collection("users")
          .doc(_auth.currentUser!.uid)
          .snapshots()
          .listen((documentSnapshot) {
        _handleStreamUpdate(documentSnapshot);
      }, onError: (error) {
        if (error is FirebaseException &&
            error.code.contains("permission-denied")) {
          closeListener();
        } else {
          WeException.handle(error);
        }
      });
    }
  }

  void closeListener() {
    if (_hasInitListener) {
      unawaited(_userStreamSubscription?.cancel());
      _hasInitListener = false;
    }
  }

  void _handleStreamUpdate(
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
    if (!documentSnapshot.exists) {
      var data = documentSnapshot.data();
      if (data == null) {
        return;
      }
    }

    if (documentSnapshot.exists) {
      String? currentToken = documentSnapshot.data()!['deviceToken'];

      if (_userService.myDeviceToken != null) {

        if (currentToken != _userService.myDeviceToken) {
          AppHelper.displayAlertWarning(
              "Você será deslogado pois logou em outro aparelho!");
          AuthService.logout();
        }
      }
    }
    final UserModel userModel = UserModel.fromJson(documentSnapshot.data()!);
    _userController.sink.add(userModel);
  }

  Future<String> storeDeviceToken() async {
    String? myToken = await FirebaseMessaging.instance.getToken();

    if (myToken != null) {
      String userId = _auth.currentUser!.uid;
      await _instance.collection('users').doc(userId).set({
        'deviceToken': myToken,
        'lastLogin': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }
    return myToken ?? "";
  }
}
