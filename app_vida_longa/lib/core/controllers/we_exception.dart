import "dart:async";
import "dart:io";

import "package:app_vida_longa/core/helpers/we_error_helper.dart";
import "package:app_vida_longa/core/helpers/we_exception_helper.dart";
import "package:app_vida_longa/domain/models/response_model.dart";
import "package:flutter/foundation.dart";

abstract class WeException {
  static bool _isProduction = true;
  static bool _isFirebaseDisabled = false;

  static final StreamController<ResponseStatusModel> _streamController =
      StreamController<ResponseStatusModel>.broadcast();

  static Stream<ResponseStatusModel> get streamException =>
      _streamController.stream;

  static void initialize({
    required bool isProduction,
    bool hasFirebase = true,
  }) {
    _isProduction = isProduction;

    if (kDebugMode) {
      print("---- WeException initialize. Production mode: $isProduction");
    }

    if (kIsWeb) {
      _setNotSupportedMode();
      return;
    }

    if (!(Platform.isAndroid || Platform.isIOS)) {
      _setNotSupportedMode();
      return;
    }

    if (!hasFirebase) {
      _setNotSupportedMode();
      return;
    }
  }

  static ResponseStatusModel handle(dynamic error, {String? functionName}) {
    if (kDebugMode) {
      print("---- WeException Error Type : ${error.runtimeType} "
          "${error is Error ? "(Error)" : "(Exception)"}");
    }

    _handleInitialLogs(error, functionName: functionName);

    late ResponseStatusModel response = ResponseStatusModel();

    if (error is Error) {
      response = WeErrorHelper.handle(error);
    } else {
      response = WeExceptionHelper.handle(error);
    }

    _streamController.sink.add(response);

    return response;
  }

  /// FirebaseCrashlytics function used to submit crashlytics error
  static void submitError({
    required String description,
    required Exception exception,
    required dynamic reason,
    required StackTrace stackTrace,
    required ResponseStatusModel response,
  }) {
    e(key: "weExceptionCode", data: response.code.toString());

    if (kDebugMode) {
      print("------------------SUBMIT ERROR------------------");
      print("Exception: $exception");
      print("StackTrace: $stackTrace");
      print("Reason: $reason");
      print("weExceptionCode: ${response.code}");
      print("errorType: ${exception.runtimeType}");
      print("-------------------------------------------------");
    }

    if (_isFirebaseDisabled) {
      return;
    }

    if (_isProduction) {
      // _crashlytics
      //     .recordError(exception, stackTrace,
      //         reason: reason, printDetails: _isProduction)
      //     .then((value) {
      //   if (kDebugMode) {
      //     print("---- WeException submitted report to firebase.");
      //   }
      // }).onError((error, stackTrace) {
      //   if (kDebugMode) {
      //     print("---- WeException failed to submit "
      //         "report to firebase. ${error.toString()}");
      //   }
      // });
    }
  }

  /// FirebaseCrashlytics Log Data
  /// Used to store custom data in the crash log
  static void data({required String key, required String data}) {
    if (!_isFirebaseDisabled) {
      // _crashlytics.setCustomKey(key, data);
    }

    if (kDebugMode) {
      print("DATA Time ${DateTime.now()} KEY {$key} | DATA {$data}");
    }
  }

  /// WeException method used to store debug data
  static void d({
    required String key,
    String? tag = "Debug",
    required String data,
  }) {
    if (!_isFirebaseDisabled) {
      // _crashlytics.log(
      //     "DEBUG Time ${DateTime.now()} TAG {$tag} | KEY {$key} | DATA {$data}");
    }

    if (kDebugMode) {
      print(
          "DEBUG Time ${DateTime.now()} TAG {$tag} | KEY {$key} | DATA {$data}");
    }
  }

  /// WeException method used to store info data
  static void i({
    required String key,
    String tag = "Info",
    required String data,
  }) {
    if (!_isFirebaseDisabled) {
      // _crashlytics.log(
      //     "INFO Time ${DateTime.now()} TAG {$tag} | KEY {$key} | DATA {$data}");
    }

    if (kDebugMode) {
      print(
          "INFO Time ${DateTime.now()} TAG {$tag} | KEY {$key} | DATA {$data}");
    }
  }

  /// WeException method used to store error data
  static void e(
      {required String key, String tag = "Error", required String data}) {
    if (!_isFirebaseDisabled) {
      // _crashlytics.log(
      //     "ERROR Time ${DateTime.now()} TAG {$tag} | KEY {$key} | DATA {$data}");
    }

    if (kDebugMode) {
      print(
          "ERROR Time ${DateTime.now()} TAG {$tag} | KEY {$key} | DATA {$data}");
    }
  }

  static void _setNotSupportedMode() {
    if (kDebugMode) {
      print("---- FirebaseCrashlytics not enabled."
          "Your program will be executed in debug mode.");
    }
    _isFirebaseDisabled = true;
  }

  static void _handleInitialLogs(
    dynamic error, {
    String? functionName,
  }) {
    if (functionName != null) {
      data(key: "method", data: functionName);
    }

    e(key: "errorData", data: error.toString());
    e(key: "errorType", data: error.runtimeType.toString());

    if (kDebugMode) {
      print("------------------INITIAL DATA ERROR------------------");
      print("Error Data: ${error.toString()}");
      print("errorType: ${error.runtimeType}");
      print("-------------------------------------------------");
    }
  }
}
