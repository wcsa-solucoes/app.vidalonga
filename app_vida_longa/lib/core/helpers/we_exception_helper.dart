import "dart:async";
import "dart:io";

import "package:app_vida_longa/domain/contants/app_colors.dart";
import "package:app_vida_longa/domain/enums/app_response_codes_enum.dart";
import "package:app_vida_longa/domain/enums/custom_exceptions_codes_enum.dart";
import "package:app_vida_longa/domain/models/response_model.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

abstract class WeExceptionHelper {
  static ResponseStatusModel handle(Exception exception) {
    if (exception is FirebaseAuthException) {
      return _handleFirebaseAuthException(exception);
    } else if (exception is FirebaseException) {
      return _handleFirebaseException(exception);
    }
    return _handleException(exception);
  }

  static String getMessage(ResponseStatusModel response) {
    late String message = "";

    if (response.code is AppResponseCodesEnum) {
      return _handleAppExceptionCodes(response.code as AppResponseCodesEnum);
    }

    if (response.status == ResponseStatusEnum.success) {
      return response.message == "Success" ? "" : response.message;
    }

    if (response.message != "Success") {
      return response.message;
    }

    switch (response.code) {
      case WeExceptionCodesEnum.firebaseAuthEmailInUse:
        message = "Email já registrado.";
        break;

      case WeExceptionCodesEnum.firebaseAuthInvalidLoginCredentials:
        message =
            "Credenciais inválidas. Verifique os dados e tente novamente.";
        break;
      case WeExceptionCodesEnum.firebaseAuthInvalidEmail:
        message = "Email inválido";
        break;
      case WeExceptionCodesEnum.firebaseAuthUserNotFound:
        message = "Usuário ou senha inválidos";
        break;
      case WeExceptionCodesEnum.firebaseAuthWrongPassword:
        message = "Error : WeExceptionCodesEnum.firebaseAuthWrongPassword";
        break;
      case WeExceptionCodesEnum.firebaseAuthOperationNotAllowed:
        message =
            "Error : WeExceptionCodesEnum.firebaseAuthOperationNotAllowed";
        break;
      case WeExceptionCodesEnum.firebaseAuthWeakPassword:
        message = "Senha fraca";
        break;
      case WeExceptionCodesEnum.firebaseAuthUserDisabled:
        message = "Error : WeExceptionCodesEnum.firebaseAuthUserDisabled";
        break;
      case WeExceptionCodesEnum.firebaseAuthNetworkFailed:
        message = "Error : WeExceptionCodesEnum.firebaseAuthNetworkFailed";
        break;
      case WeExceptionCodesEnum.firebaseAuthTooManyRequests:
        message = "Muitas tentativas. Tente novamente mais tarde.";
        break;
      case WeExceptionCodesEnum.firebaseAuthNotMapped:
        message = "Erro de autenticação não mapeado";
        break;
      case WeExceptionCodesEnum.exceptionTimeout:
        message = "Tempo de espera excedido";
        break;
      case WeExceptionCodesEnum.exceptionNotMapped:
        message = "Erro não mapeado";
        break;
      case WeExceptionCodesEnum.firebaseAuthEmailNotVerified:
        message = "Email não verificado";
        break;
      case WeExceptionCodesEnum.coreTypeError:
        message = "Error : WeExceptionCodesEnum.coreTypeError";
        break;
      case WeExceptionCodesEnum.coreIndexError:
        message = "Error : WeExceptionCodesEnum.coreIndexError";
        break;
      case WeExceptionCodesEnum.coreArgumentError:
        message = "Error : WeExceptionCodesEnum.coreArgumentError";
        break;
      case WeExceptionCodesEnum.coreRangeError:
        message = "Error : WeExceptionCodesEnum.coreRangeError";
        break;
      case WeExceptionCodesEnum.coreNoSuchMethodError:
        message = "Error : WeExceptionCodesEnum.coreNoSuchMethodError";
        break;
      case WeExceptionCodesEnum.coreUnsupportedError:
        message = "Error : WeExceptionCodesEnum.coreUnsupportedError";
        break;
      case WeExceptionCodesEnum.coreUnimplementedError:
        message = "Error : WeExceptionCodesEnum.coreUnimplementedError";
        break;
      case WeExceptionCodesEnum.coreStateError:
        message = "Error : WeExceptionCodesEnum.coreStateError";
        break;
      case WeExceptionCodesEnum.coreConcurrentModificationError:
        message =
            "Error : WeExceptionCodesEnum.coreConcurrentModificationError";
        break;
      case WeExceptionCodesEnum.coreOutOfMemoryError:
        message = "Error : WeExceptionCodesEnum.coreOutOfMemoryError";
        break;
      case WeExceptionCodesEnum.coreStackOverflowError:
        message = "Error : WeExceptionCodesEnum.coreStackOverflowError";
        break;
      case WeExceptionCodesEnum.coreNotMappedError:
        message = "Error : WeExceptionCodesEnum.coreNotMappedError";
        break;
      case WeExceptionCodesEnum.exceptionGeneral:
        message = "Error : WeExceptionCodesEnum.exceptionGeneral";
        break;
      case WeExceptionCodesEnum.firebaseNotMapped:
        message = "Error : WeExceptionCodesEnum.firebaseNotMapped";
        break;
      case WeExceptionCodesEnum.firebaseAuthCredentialAlreadyInUse:
        message =
            "Error : WeExceptionCodesEnum.firebaseAuthCredentialAlreadyInUse";
        break;
      case WeExceptionCodesEnum.firebaseAuthInvalidCredentialType:
        message =
            "Error : WeExceptionCodesEnum.firebaseAuthInvalidCredentialType";
        break;
      case WeExceptionCodesEnum.grpcCancelled:
        message = "Error : WeExceptionCodesEnum.grpcCancelled";
        break;
      case WeExceptionCodesEnum.grpcUnknown:
        message = "Error : WeExceptionCodesEnum.grpcUnknown";
        break;
      case WeExceptionCodesEnum.grpcInvalidArgument:
        message = "Error : WeExceptionCodesEnum.grpcInvalidArgument";
        break;
      case WeExceptionCodesEnum.grpcDeadLineExceeded:
        message = "Error : WeExceptionCodesEnum.grpcDeadLineExceeded";
        break;
      case WeExceptionCodesEnum.grpcNotFound:
        message = "Error : WeExceptionCodesEnum.grpcNotFound";
        break;
      case WeExceptionCodesEnum.grpcAlreadyExists:
        message = "Error : WeExceptionCodesEnum.grpcAlreadyExists";
        break;
      case WeExceptionCodesEnum.grpcPermissionDenied:
        message = "Error : WeExceptionCodesEnum.grpcPermissionDenied";
        break;
      case WeExceptionCodesEnum.grpcResourceExhausted:
        message = "Error : WeExceptionCodesEnum.grpcResourceExhausted";
        break;
      case WeExceptionCodesEnum.grpcFailedPreCondition:
        message = "Error : WeExceptionCodesEnum.grpcFailedPreCondition";
        break;
      case WeExceptionCodesEnum.grpcAborted:
        message = "Error : WeExceptionCodesEnum.grpcAborted";
        break;
      case WeExceptionCodesEnum.grpcOutOfRange:
        message = "Error : WeExceptionCodesEnum.grpcOutOfRange";
        break;
      case WeExceptionCodesEnum.grpcUnimplemented:
        message = "Error : WeExceptionCodesEnum.grpcUnimplemented";
        break;
      case WeExceptionCodesEnum.grpcInternal:
        message = "Error : WeExceptionCodesEnum.grpcInternal";
        break;
      case WeExceptionCodesEnum.grpcUnavailable:
        message = "Error : WeExceptionCodesEnum.grpcUnavailable";
        break;
      case WeExceptionCodesEnum.grpcDataLoss:
        message = "Error : WeExceptionCodesEnum.grpcDataLoss";
        break;
      case WeExceptionCodesEnum.grpcUnauthenticated:
        message = "Error : WeExceptionCodesEnum.grpcUnauthenticated";
        break;
      case WeExceptionCodesEnum.grpcNotMapped:
        message = "Error : WeExceptionCodesEnum.grpcNotMapped";
        break;
      case WeExceptionCodesEnum.ioExceptionFileSystemException:
        message = "Error : WeExceptionCodesEnum.ioExceptionFileSystemException";
        break;
      case WeExceptionCodesEnum.ioExceptionNotMapped:
        message = "Error : WeExceptionCodesEnum.ioExceptionNotMapped";
        break;
      default:
        message = "Erro desconhecido ";
        break;
    }

    if (kDebugMode) {
      print(message);
    }

    message = message.contains("Error:") ? "" : message;
    return message;
  }

  static ResponseStatusModel _handleFirebaseAuthException(
      FirebaseAuthException exception) {
    final ResponseStatusModel response = ResponseStatusModel(
      status: ResponseStatusEnum.failed,
    );

    switch (exception.code.toLowerCase()) {
      case "invalid_login_credentials":
        response.code =
            WeExceptionCodesEnum.firebaseAuthInvalidLoginCredentials;
        break;
      case "email-already-in-use":
        response.code = WeExceptionCodesEnum.firebaseAuthEmailInUse;
        break;
      case "invalid-email":
        response.code = WeExceptionCodesEnum.firebaseAuthInvalidEmail;
        break;
      case "user-not-found":
        response.code = WeExceptionCodesEnum.firebaseAuthUserNotFound;
        break;
      case "wrong-password":
        response.code = WeExceptionCodesEnum.firebaseAuthWrongPassword;
        break;
      case "operation-not-allowed":
        response.code = WeExceptionCodesEnum.firebaseAuthOperationNotAllowed;
        break;
      case "weak-password":
        response.code = WeExceptionCodesEnum.firebaseAuthWeakPassword;
        break;
      case "user-disabled":
        response.code = WeExceptionCodesEnum.firebaseAuthUserDisabled;
        break;
      case "network-request-failed":
        response.code = WeExceptionCodesEnum.firebaseAuthNetworkFailed;
        break;
      case "too-many-requests":
        response.code = WeExceptionCodesEnum.firebaseAuthTooManyRequests;
        break;
      case "credential-already-in-use":
        response.code = WeExceptionCodesEnum.firebaseAuthCredentialAlreadyInUse;
        break;
      case "42we-invalid-credential-type":
        response.code = WeExceptionCodesEnum.firebaseAuthInvalidCredentialType;
        break;
      case "invalid-credential":
        response.code = WeExceptionCodesEnum.firebaseAuthUserNotFound;
        break;
      default:
        response.code = WeExceptionCodesEnum.firebaseAuthNotMapped;
        break;
    }

    // WeException.submitError(
    //     description: "_handleFirebaseAuthError",
    //     exception: exception,
    //     reason: response.code,
    //     stackTrace:
    //         exception.stackTrace ?? StackTrace.fromString(exception.toString()),
    //     response: response);
    return response;
  }

  static ResponseStatusModel _handleFirebaseException(
      FirebaseException exception) {
    final ResponseStatusModel response =
        ResponseStatusModel(status: ResponseStatusEnum.failed);

    switch (exception.code) {
      case "email-already-in-use":
        response.code = WeExceptionCodesEnum.firebaseAuthEmailInUse;
        break;
      case "invalid-email":
        response.code = WeExceptionCodesEnum.firebaseAuthInvalidEmail;
        break;
      case "user-not-found":
        response.code = WeExceptionCodesEnum.firebaseAuthUserNotFound;
        break;
      case "wrong-password":
        response.code = WeExceptionCodesEnum.firebaseAuthWrongPassword;
        break;
      case "operation-not-allowed":
        response.code = WeExceptionCodesEnum.firebaseAuthOperationNotAllowed;
        break;
      case "weak-password":
        response.code = WeExceptionCodesEnum.firebaseAuthWeakPassword;
        break;
      case "user-disabled":
        response.code = WeExceptionCodesEnum.firebaseAuthUserDisabled;
        break;
      case "network-request-failed":
        response.code = WeExceptionCodesEnum.firebaseAuthNetworkFailed;
        break;
      case "too-many-requests":
        response.code = WeExceptionCodesEnum.firebaseAuthTooManyRequests;
        break;
      case "credential-already-in-use":
        response.code = WeExceptionCodesEnum.firebaseAuthCredentialAlreadyInUse;
        break;
      case "42we-invalid-credential-type":
        response.code = WeExceptionCodesEnum.firebaseAuthInvalidCredentialType;
        break;
      default:
        response.code = WeExceptionCodesEnum.exceptionNotMapped;
        break;
    }

    // WeException.submitError(
    //     description: "_handleFirebaseException",
    //     exception: exception,
    //     reason: response.code,
    //     stackTrace:
    //         exception.stackTrace ?? StackTrace.fromString(exception.toString()),
    //     response: response);

    return response;
  }

  static Color getStatusColorFromStatus(ResponseStatusEnum status) {
    switch (status) {
      case ResponseStatusEnum.success:
        return AppColors.success;
      case ResponseStatusEnum.failed:
        return AppColors.redError;
      case ResponseStatusEnum.warning:
        return AppColors.warning;
      case ResponseStatusEnum.info:
        return AppColors.info;
      default:
        return AppColors.redError;
    }
  }

  static ResponseStatusModel _handleException(Exception exception) {
    final ResponseStatusModel response =
        ResponseStatusModel(status: ResponseStatusEnum.failed);

    response.code = WeExceptionCodesEnum.exceptionNotMapped;

    if (exception is TimeoutException) {
      response.code = WeExceptionCodesEnum.exceptionTimeout;
    } else if (exception is FileSystemException) {
      response.code = WeExceptionCodesEnum.ioExceptionFileSystemException;
    } else if (exception is SocketException) {
      response.code = WeExceptionCodesEnum.socketException;
    } else if (exception is IOException) {
      response.code = WeExceptionCodesEnum.ioExceptionNotMapped;
    }

    // WeException.submitError(
    //     description: "_handleException",
    //     exception: exception,
    //     reason: response.code,
    //     stackTrace: StackTrace.fromString(exception.toString()),
    //     response: response);

    return response;
  }

  static String _handleAppExceptionCodes(AppResponseCodesEnum code) {
    late String message = "";

    switch (code) {
      case AppResponseCodesEnum.defaultInfo:
        message = "defaultInfo";
        break;
      case AppResponseCodesEnum.defaultWarning:
        message = "defaultWarning";
        break;
      case AppResponseCodesEnum.defaultError:
        message = "defaultError";
        break;
      case AppResponseCodesEnum.defaultSuccess:
        message = "defaultSuccess";
        break;
      case AppResponseCodesEnum.appInDevelopmentMode:
        message = "appInDevelopmentMode";
        break;
      case AppResponseCodesEnum.loginFailed:
        message = "loginFailed";
        break;
      case AppResponseCodesEnum.restartAppWarning:
        message = "restartAppWarning";
        break;
      case AppResponseCodesEnum.accountRegisterAlreadyRegistered:
        message = "accountRegisterAlreadyRegistered";
        break;
    }

    return message;
  }

  static String getAlertIconNameFromStatus(ResponseStatusEnum status) {
    switch (status) {
      case ResponseStatusEnum.success:
        return "success";
      case ResponseStatusEnum.failed:
        return "errorRed";
      case ResponseStatusEnum.warning:
        return "warning";
      case ResponseStatusEnum.info:
        return "info";
      default:
        return "warning";
    }
  }

  static IconData getSnackBarIconDataFromStatus(ResponseStatusEnum status) {
    switch (status) {
      case ResponseStatusEnum.success:
        return Icons.check;
      case ResponseStatusEnum.failed:
        return Icons.warning;
      case ResponseStatusEnum.warning:
        return Icons.warning;
      case ResponseStatusEnum.info:
        return Icons.info;
      default:
        return Icons.warning;
    }
  }
}
