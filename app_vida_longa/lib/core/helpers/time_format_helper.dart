import 'package:intl/intl.dart';

abstract class TimeHelper {
  static String dateTimeNowToDDMMYYHHMMSS() {
    DateTime now = DateTime.now();

    return DateFormat('dd-MM-yyyy HH:mm:ss').format(now);
  }
}
