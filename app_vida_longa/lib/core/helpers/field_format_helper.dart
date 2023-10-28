import "package:app_vida_longa/core/helpers/date_time_helper.dart";
import "package:app_vida_longa/domain/contants/app_constants.dart";
import "package:app_vida_longa/domain/contants/regex_constants.dart";

abstract class FieldFormatHelper {
  static String phone({String phone = ""}) {
    return phone.replaceAll(
        RegexConstants.kNumberOnly, AppConstants.kNullConst);
  }

  static String register({String register = ""}) {
    return register.replaceAll(
        RegexConstants.kNumberOnly, AppConstants.kNullConst);
  }

  static String getMonthTextFromTimeStamp(int timestamp) {
    final int month = DateTimeHelper.getDateTimeFromTimestamp(timestamp).month;
    switch (month) {
      case 1:
        return "Janeiro";
      case 2:
        return "Fevereiro";
      case 3:
        return "Março";
      case 4:
        return "Abril";
      case 5:
        return "Maio";
      case 6:
        return "Junho";
      case 7:
        return "Julho";
      case 8:
        return "Agosto";
      case 9:
        return "Setembro";
      case 10:
        return "Outubro";
      case 11:
        return "Novembro";
      case 12:
        return "Dezembro";
      default:
        return "N/A";
    }
  }
}
