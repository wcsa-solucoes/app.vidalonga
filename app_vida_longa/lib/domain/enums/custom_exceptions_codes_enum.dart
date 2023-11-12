import 'package:app_vida_longa/domain/enums/app_response_codes_enum.dart';

enum WeExceptionCodesEnum implements WeExceptionCodesInterface {
  /// General Flutter 42WE Reserved Codes for WeException
  exceptionDefault,
  exceptionGeneral,
  exceptionTimeout,
  exceptionNotMapped,

  /// Firebase 42WE Reserved Codes for WeException
  firebaseNotMapped,

  /// FirebaseAuth 42We Codes for WeException
  firebaseAuthEmailInUse,
  firebaseAuthInvalidEmail,
  firebaseAuthUserNotFound,
  firebaseAuthWrongPassword,
  firebaseAuthOperationNotAllowed,
  firebaseAuthWeakPassword,
  firebaseAuthUserDisabled,
  firebaseAuthNetworkFailed,
  firebaseAuthTooManyRequests,
  firebaseAuthNotMapped,
  firebaseAuthEmailNotVerified,
  firebaseAuthCredentialAlreadyInUse,
  firebaseAuthInvalidCredentialType,
  firebaseAuthInvalidLoginCredentials,

  /// Flutter Core Errors 42We Codes for WeException
  coreTypeError,
  coreIndexError,
  coreArgumentError,
  coreRangeError,
  coreNoSuchMethodError,
  coreUnsupportedError,
  coreUnimplementedError,
  coreStateError,
  coreConcurrentModificationError,
  coreOutOfMemoryError,
  coreStackOverflowError,
  coreNotMappedError,

  /// Flutter Grpc Errors 42We Codes for WeException
  grpcCancelled,
  grpcUnknown,
  grpcInvalidArgument,
  grpcDeadLineExceeded,
  grpcNotFound,
  grpcAlreadyExists,
  grpcPermissionDenied,
  grpcResourceExhausted,
  grpcFailedPreCondition,
  grpcAborted,
  grpcOutOfRange,
  grpcUnimplemented,
  grpcInternal,
  grpcUnavailable,
  grpcDataLoss,
  grpcUnauthenticated,
  grpcNotMapped,

  /// Flutter Core Errors 42We Codes for WeException
  ioExceptionFileSystemException,
  ioExceptionNotMapped,
  socketException,
}
