import "dart:convert";

import "package:app_vida_longa/core/controllers/notification_controller.dart";
import "package:app_vida_longa/domain/contants/app_colors.dart";
import "package:app_vida_longa/domain/models/response_model.dart";
import "package:flutter/foundation.dart";
import "package:flutter/services.dart";

abstract class AppHelper {
  // static LanguageEnum getLanguage() {
  //   late final LanguageEnum language;
  //   if (Platform.localeName.contains("pt_")) {
  //     language = LanguageEnum.portuguese;
  //   } else {
  //     language = LanguageEnum.english;
  //   }

  //   return language;
  // }

  // static void setAppLanguage(LanguageEnum language) {
  //   LocaleSettings.setLocale(language.appLocale);
  // }

  static String getStringVersionFromInt(int value) {
    late String version = "$value".padLeft(3, "0");
    final List<String> chars = version.substring(0, 3).split("");
    version = "";

    for (final char in chars) {
      version += "$char.";
    }

    version = version.substring(0, version.length - 1);
    return version;
  }

  static void displayAlertSuccess(String title) {
    final ResponseStatusModel response = ResponseStatusModel(
      status: ResponseStatusEnum.success,
      message: title,
    );
    NotificationController.alert(response: response);
  }

  static void displayAlertError(String title) {
    final ResponseStatusModel response = ResponseStatusModel(
      status: ResponseStatusEnum.failed,
      message: title,
    );
    NotificationController.alert(response: response);
  }

  static void displayAlertWarning(String title) {
    final ResponseStatusModel response = ResponseStatusModel(
      status: ResponseStatusEnum.warning,
      message: title,
    );
    NotificationController.alert(response: response);
  }

  static void displayAlertInfo(String title) {
    final ResponseStatusModel response = ResponseStatusModel(
      status: ResponseStatusEnum.info,
      message: title,
    );
    NotificationController.alert(response: response);
  }

  static void setStatusBarColor({
    Color backgroundColor = AppColors.backgroundDark,
    Brightness iconBrightness = Brightness.light,
  }) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: backgroundColor,
      statusBarIconBrightness: iconBrightness,
    ));
  }

  static void printWrapped(String text) {
    final RegExp pattern = RegExp(".{1,800}");
    pattern.allMatches(text).forEach((match) {
      if (kDebugMode) {
        print("-------------------------------");
        print(jsonEncode(match.group(0)));
      }
    });
  }

  static void printWrappedObject(Map<String, dynamic> data) {
    final String text = jsonEncode(data);
    final RegExp pattern = RegExp(".{1,800}");
    pattern.allMatches(text).forEach((match) {
      if (kDebugMode) {
        print("-------------------------------");
        print(jsonEncode(match.group(0)).replaceAll("\\", ""));
      }
    });
  }
}
