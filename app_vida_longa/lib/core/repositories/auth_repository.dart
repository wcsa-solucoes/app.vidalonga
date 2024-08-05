import "dart:async";
import "package:app_vida_longa/core/controllers/we_exception.dart";
import "package:app_vida_longa/core/helpers/print_colored_helper.dart";
import "package:app_vida_longa/domain/models/response_model.dart";
import "package:app_vida_longa/domain/models/user_model.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/services.dart";
import "package:google_sign_in/google_sign_in.dart";
import "package:the_apple_sign_in/the_apple_sign_in.dart";

class AuthRepository {
  late final FirebaseAuth _auth = FirebaseAuth.instance;

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

    // late List<String> signInMethods = [];

    // await _auth.fetchSignInMethodsForEmail(email).then((data) {
    //   signInMethods = data;
    // }).onError((error, stackTrace) {
    //   response = WeException.handle(error);
    // });

    // if (response.status == ResponseStatusEnum.failed) {
    //   return response;
    // }

    // if (signInMethods.isEmpty) {
    //   response.status = ResponseStatusEnum.failed;
    //   response.code = WeExceptionCodesEnum.firebaseAuthUserNotFound;
    //   return response;
    // }

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
      const List<String> scopes = <String>[
        'email',
        'https://www.googleapis.com/auth/contacts.readonly',
      ];

      GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: scopes,
      );

      // get user
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

        // credentials for firebase
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // login
        final result = await _auth.signInWithCredential(credential);

        user = user.copyWith(
          id: result.user!.uid,
          name: result.user!.displayName,
          email: result.user!.email,
          phone: result.user!.phoneNumber,
          photoUrl: result.user!.photoURL,
          signInFrom: 'signInFromGoogle'
        );
      }
      else {
        response.message = "Prossiga até o fim para usar o login social!";
        response.status = ResponseStatusEnum.failed;
      }
    } catch (error) {
      response.message = error.toString();
      response.status = ResponseStatusEnum.failed;
    }

    return (response: response, user: user);
  }

  Future<({ResponseStatusModel response, UserModel user})> appleSignIn({List<Scope> scopes = const []}) async {
    late ResponseStatusModel response = ResponseStatusModel();
    late UserModel user = UserModel();

   try {
      final result = await TheAppleSignIn.performRequests([const AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])]);

      switch (result.status) {
        case AuthorizationStatus.authorized:
          final appleIdCredential = result.credential!;
          final oAuthProvider = OAuthProvider('apple.com');
          final credential = oAuthProvider.credential(
              idToken: String.fromCharCodes(appleIdCredential.identityToken!));
          final userCredential = await _auth.signInWithCredential(credential);
          final firebaseUser = userCredential.user!;

          late String name = firebaseUser.uid.substring(0, 4);
          late String email = "${firebaseUser.uid.substring(0, 4)}@privaterelay.appleid.com";

          user = user.copyWith(
            id: firebaseUser.uid,
            name: name,
            email: email,
            signInFrom: 'signInFromApple'
          );
        case AuthorizationStatus.error:
          throw PlatformException(
            code: 'ERROR_AUTHORIZATION_DENIED',
            message: result.error.toString());

        case AuthorizationStatus.cancelled:
          throw PlatformException(
            code: 'ERROR_ABORTED_BY_USER', message: 'Sign in aborted by user');

        default:
          throw UnimplementedError();
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
