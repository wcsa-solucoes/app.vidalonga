import "dart:async";
import "package:app_vida_longa/domain/models/response_model.dart";
import "package:app_vida_longa/domain/models/user_model.dart";
import "package:firebase_auth/firebase_auth.dart";

class AuthRepository {
  late final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<ResponseStatusModel> register(UserModel user, String password) async {
    late ResponseStatusModel response = ResponseStatusModel();

    await _auth
        .createUserWithEmailAndPassword(email: user.email, password: password)
        .then((snapshot) => null)
        .onError((error, stackTrace) {});

    return response;
  }

  Future<ResponseStatusModel> signInUsingEmailPassword({
    required String email,
    required String password,
  }) async {
    late ResponseStatusModel response = ResponseStatusModel();

    late List<String> signInMethods = [];

    await _auth.fetchSignInMethodsForEmail(email).then((data) {
      signInMethods = data;
    }).onError((error, stackTrace) {});

    if (response.status == ResponseStatusEnum.failed) {
      return response;
    }

    if (signInMethods.isEmpty) {
      response.status = ResponseStatusEnum.failed;
      return response;
    }

    await _auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((snapshot) => null)
        .onError((error, stackTrace) {});

    return response;
  }

  Future<ResponseStatusModel> sendEmailValidation() async {
    late ResponseStatusModel response = ResponseStatusModel();

    await _auth.currentUser!
        .sendEmailVerification()
        .then((value) => null)
        .onError((error, stackTrace) {});

    return response;
  }

  Future<ResponseStatusModel> sendPasswordResetEmail({
    required String email,
  }) async {
    late ResponseStatusModel response = ResponseStatusModel();

    await _auth
        .sendPasswordResetEmail(email: email)
        .then((snapshot) => null)
        .onError((error, stackTrace) {
      if (error is FirebaseAuthException) {
        if (error.code != "user-not-found") {}
      } else {}
    });

    return response;
  }
}
