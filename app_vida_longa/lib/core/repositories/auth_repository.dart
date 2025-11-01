import "dart:async";
import "package:app_vida_longa/core/controllers/we_exception.dart";
import "package:app_vida_longa/core/helpers/print_colored_helper.dart";
import "package:app_vida_longa/domain/models/response_model.dart";
import "package:app_vida_longa/domain/models/user_model.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/services.dart";
import "package:google_sign_in/google_sign_in.dart";
import "package:the_apple_sign_in/the_apple_sign_in.dart";

class AuthRepository {
  late final FirebaseAuth _auth = FirebaseAuth.instance;
  late final FirebaseFirestore _instance = FirebaseFirestore.instance;

  Future<ResponseStatusModel> register(
      UserModel user, String password, String name) async {
    late ResponseStatusModel response = ResponseStatusModel();

    UserCredential? userCredential;
    await _auth
        .createUserWithEmailAndPassword(email: user.email, password: password)
        .then((snapshot) {
      userCredential = snapshot;
    }).onError((error, stackTrace) {
      response = WeException.handle(error);
    });
    if (userCredential != null) {
      User? user = userCredential?.user;
      await user
          ?.updateDisplayName(name)
          .then((value) => null)
          .onError((error, stackTrace) {
        PrintColoredHelper.printCyan(error.toString());
        response = WeException.handle(error);
      });
    }

    return response;
  }

  Future<ResponseStatusModel> signInUsingEmailPassword({
    required String email,
    required String password,
  }) async {
    late ResponseStatusModel response = ResponseStatusModel();

    await _auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((snapshot) => null)
        .onError((error, stackTrace) {
      response = WeException.handle(error);
    });

    return response;
  }

  Future<({ResponseStatusModel response, UserModel user})>
      googleSignIn() async {
    late ResponseStatusModel response = ResponseStatusModel();
    late UserModel user = UserModel();

    try {
      const List<String> scopes = <String>['email'];
      const String serverClientId =
          '307746117848-lfbhtjaj2h4rsesmts1t90nstq97i6qp.apps.googleusercontent.com';

      final GoogleSignIn googleSignIn = GoogleSignIn.instance;

      // Initialize Google Sign-In with serverClientId
      await googleSignIn.initialize(serverClientId: serverClientId);

      // Attempt authentication
      GoogleSignInAccount? googleUser;
      try {
        googleUser = await googleSignIn.authenticate();
      } catch (e) {
        if (e is PlatformException && e.code == 'sign_in_canceled') {
          response.message = "Login cancelado pelo usuário";
          response.status = ResponseStatusEnum.failed;
          return (response: response, user: user);
        }
        rethrow;
      }

      // googleUser is guaranteed to be non-null after authenticate() succeeds
      // Check for authorization
      final GoogleSignInClientAuthorization? authorization =
          await googleUser.authorizationClient.authorizationForScopes(scopes);

      if (authorization == null) {
        // Request authorization for required scopes
        try {
          await googleUser.authorizationClient.authorizeScopes(scopes);
        } catch (e) {
          response.message =
              "Autorização negada para acessar dados necessários";
          response.status = ResponseStatusEnum.failed;
          return (response: response, user: user);
        }
      }

      late bool loggedInAnotherWay = false;

      await _instance
          .collection("users")
          .where('email', isEqualTo: googleUser.email)
          .get()
          .then((snapshot) {
        if (snapshot.docs.isNotEmpty) {
          user = UserModel.fromJson(snapshot.docs.first.data());
          if (user.signInFrom == "" || user.signInFrom != "signInFromGoogle") {
            loggedInAnotherWay = true;
          }
        }
      });

      if (loggedInAnotherWay == false) {
        // Get authorization headers for Firebase authentication
        final Map<String, String>? authHeaders =
            await googleUser.authorizationClient.authorizationHeaders(scopes);

        if (authHeaders == null) {
          response.message = "Falha ao obter credenciais de autenticação";
          response.status = ResponseStatusEnum.failed;
          return (response: response, user: user);
        }

        final GoogleSignInAuthentication googleAuth =
            googleUser.authentication;

        // credentials for firebase
        final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
        );

        // login
        final result = await _auth.signInWithCredential(credential);

        user = user.copyWith(
            id: result.user!.uid,
            name: result.user!.displayName,
            email: result.user!.email,
            photoUrl: result.user!.photoURL,
            signInFrom: 'signInFromGoogle');
      } else {
        response.message =
            "Logue de outra maneira, o seu e-mail já está cadastrado!";
        response.status = ResponseStatusEnum.failed;
      }
    } catch (error) {
      response.message = error.toString();
      response.status = ResponseStatusEnum.failed;
    }

    return (response: response, user: user);
  }

  Future<({ResponseStatusModel response, UserModel user})> appleSignIn(
      {List<Scope> scopes = const []}) async {
    late ResponseStatusModel response = ResponseStatusModel();
    late UserModel user = UserModel();

    try {
      final result = await TheAppleSignIn.performRequests([
        const AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
      ]);

      switch (result.status) {
        case AuthorizationStatus.authorized:
          final appleIdCredential = result.credential!;
          final oAuthProvider = OAuthProvider('apple.com');
          final credential = oAuthProvider.credential(
              idToken: String.fromCharCodes(appleIdCredential.identityToken!));
          final userCredential = await _auth.signInWithCredential(credential);
          final firebaseUser = userCredential.user!;

          late String name = firebaseUser.uid.substring(0, 4);
          late String email =
              "${firebaseUser.uid.substring(0, 4)}@privaterelay.appleid.com";

          user = user.copyWith(
              id: firebaseUser.uid,
              name: name,
              email: email,
              signInFrom: 'signInFromApple');
        case AuthorizationStatus.error:
          throw PlatformException(
              code: 'ERROR_AUTHORIZATION_DENIED',
              message: result.error.toString());

        case AuthorizationStatus.cancelled:
          throw PlatformException(
              code: 'ERROR_ABORTED_BY_USER',
              message: 'Sign in aborted by user');
      }
    } catch (error) {
      response.message = error.toString();
      response.status = ResponseStatusEnum.failed;
    }

    return (response: response, user: user);
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
