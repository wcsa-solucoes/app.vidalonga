// ignore_for_file: avoid_print

sealed class PrintColoredHelper {
  //cyan
  static void printCyan(String message) {
    print('\x1B[36m$message\x1B[0m');
  }

  //pink
  static void printPink(String message) {
    print('\x1B[35m$message\x1B[0m');
  }

  //green
  static void printGreen(String message) {
    print('\x1B[32m$message\x1B[0m');
  }

  //white
  static void printWhite(String message) {
    print('\x1B[37m$message\x1B[0m');
  }

  static void printError(String text) {
    print('\x1B[31m$text\x1B[0m');
  }

  static void printOrange(String text) {
    print('\x1B[33m$text\x1B[0m');
  }
}
