abstract class AsyncHelper {
  static Future<T> retry<T>(
      FutureRetry function, {
        int retries = 3,
        int delay = 2000,
        List<Exception> exceptions = const [],
        bool enableWeException = false,
      }) async {
    try {
      return await function().timeout(Duration(milliseconds: delay));
    } catch (error) {
      if (retries > 0) {
        return retry(
          function,
          retries: retries - 1,
          delay: delay,
          enableWeException: enableWeException,
          exceptions: exceptions,
        );
      }
      rethrow;
    }
  }
}

typedef FutureRetry<T> = Future<T> Function();
