import "package:app_vida_longa/domain/enums/date_format_enum.dart";
import "package:intl/intl.dart";

abstract class DateTimeHelper {
  static const int _kMaxTimeStamp = 21459168000000;
  static const int _kMaxTimeStampSeconds = 99999999999;
  static String _timeFormat = DateFormatEnum.h24Mm.value;
  static String _dateFormat = DateFormatEnum.ddMmYyyy.value;
  static String _dateTimeFormat = DateFormatEnum.h24MmDdMmYyyy.value;

  static String formatDateTimeToYYYYMMDDHHmmss(DateTime dateTime) {
    // Helper function to add leading zero if needed
    String padLeft(int value) => value.toString().padLeft(2, '0');

    // Extracting date components
    int year = dateTime.year;
    String month = padLeft(dateTime.month);
    String day = padLeft(dateTime.day);
    String hours = padLeft(dateTime.hour);
    String minutes = padLeft(dateTime.minute);
    String seconds = padLeft(dateTime.second);

    // Building formatted date string
    return "$year-$month-$day $hours:$minutes:$seconds";
  }

  static String formatEpochTimestamp(int epochTimestamp) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(epochTimestamp);

    String formattedDate =
        "${dateTime.year}-${_addLeadingZero(dateTime.month)}-${_addLeadingZero(dateTime.day)} ${_addLeadingZero(dateTime.hour)}:${_addLeadingZero(dateTime.minute)}:${_addLeadingZero(dateTime.second)}";

    return formattedDate;
  }

  static String _addLeadingZero(int number) {
    return number.toString().padLeft(2, '0');
  }

  static String? formatEpochTimestampFromApple(double? epochTimestamp) {
    if (epochTimestamp == null) {
      return null; // Or provide a default value or message as needed
    }

    // Convert the epoch timestamp from seconds to a DateTime object
    DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch((epochTimestamp * 1000).toInt());

    // Helper function to add leading zero if needed
    String padLeft(int value) => value.toString().padLeft(2, '0');

    // Extracting date components
    int year = dateTime.year;
    String month = padLeft(dateTime.month);
    String day = padLeft(dateTime.day);
    String hours = padLeft(dateTime.hour);
    String minutes = padLeft(dateTime.minute);
    String seconds = padLeft(dateTime.second);

    // Building formatted date string
    return "$year-$month-$day $hours:$minutes:$seconds";
  }

  static void setFormat({
    String? timeFormat,
    String? dateFormat,
    String? dateTimeFormat,
  }) {
    _timeFormat = timeFormat ?? _timeFormat;
    _dateFormat = dateFormat ?? _dateFormat;
    _dateTimeFormat = dateTimeFormat ?? _dateTimeFormat;
  }

  static String getDateStringFromDateTime(DateTime date, {String? format}) {
    return DateFormat(format ?? _dateFormat).format(
      date,
    );
  }

  static int getTimestamp() {
    return DateTime.now().millisecondsSinceEpoch;
  }

  static String getStringHourFromDuration(Duration duration) {
    String padZero(int n) => n.toString().padLeft(2, "0");
    final String min = padZero(duration.inMinutes.remainder(60));
    final String sec = padZero(duration.inSeconds.remainder(60));
    return "${padZero(duration.inHours)}:$min:$sec";
  }

  static Duration getDurationFromString(String data) {
    late int hours = 0;
    late int minutes = 0;
    late int micros;
    final List<String> parts = data.split(":");
    if (parts.length > 2) {
      hours = int.parse(parts[parts.length - 3]);
    }
    if (parts.length > 1) {
      minutes = int.parse(parts[parts.length - 2]);
    }
    micros = double.parse(parts[parts.length - 1]).round();
    return Duration(hours: hours, minutes: minutes, seconds: micros);
  }

  @Deprecated("Function makes no sense. "
      "It will be removed. Replace with the correct method []")
  static DateTime getDurationFromDateTime(Duration duration) {
    final DateTime date = DateTime.now().add(duration);
    return date;
  }

  static DateTime getDateTimeFromTimestamp(
    int timestamp, {
    bool isUtc = false,
  }) {
    return DateTime.fromMillisecondsSinceEpoch(
      assertTimestamp(timestamp),
      isUtc: isUtc,
    );
  }

  static String getDateAndTimeStringFromTimestamp(
    int timestamp, {
    bool useDash = false,
    bool isUtc = false,
    String? format,
  }) {
    final DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
      assertTimestamp(timestamp),
      isUtc: isUtc,
    );
    if (useDash) {
      final String dashed =
          (format ?? _dateTimeFormat).replaceAll("/", "-").replaceAll(":", "-");
      return DateFormat(dashed).format(dateTime);
    }

    return DateFormat(format ?? _dateTimeFormat).format(dateTime);
  }

  static String getDateStringFromTimestamp(
    int timestamp, {
    bool isUtc = false,
    String? format,
  }) {
    final DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
        assertTimestamp(timestamp),
        isUtc: isUtc);
    return DateFormat(format ?? _dateFormat).format(dateTime);
  }

  static String getTimeStringFromTimestamp(
    int timestamp, {
    bool isUtc = false,
    String? format,
  }) {
    final DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
      assertTimestamp(timestamp),
      isUtc: isUtc,
    );
    return DateFormat(format ?? _timeFormat).format(dateTime);
  }

  static DateTime getYMDFromDateTime(DateTime d) =>
      DateTime(d.year, d.month, d.day);

  static String getStringHMSectionsFromDuration(Duration duration) {
    String padZero(int n) => n.toString().padLeft(2, "0");
    final String hours = padZero(duration.inHours);
    final String minutes = padZero(duration.inMinutes.remainder(60));
    return "$hours:$minutes";
  }

  static int assertTimestamp(
    int timestamp,
  ) {
    if (timestamp < 0) {
      timestamp = timestamp.abs();
    }

    if (timestamp < _kMaxTimeStampSeconds) {
      timestamp = timestamp * 1000;
    }

    if (timestamp < _kMaxTimeStamp) {
      return timestamp;
    }

    late int finalTimestamp = timestamp;

    finalTimestamp = int.parse(timestamp.toString().substring(0, 14));

    return finalTimestamp >= _kMaxTimeStamp ? _kMaxTimeStamp : finalTimestamp;
  }
}
