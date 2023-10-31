import "package:app_vida_longa/domain/enums/custom_exceptions_codes_enum.dart";
import "package:app_vida_longa/domain/models/response_model.dart";

abstract class WeErrorHelper {
  static ResponseStatusModel handle(Error error) {
    final ResponseStatusModel response = ResponseStatusModel(
        status: ResponseStatusEnum.failed,
        code: WeExceptionCodesEnum.coreNotMappedError);

    if (error is IndexError) {
      response.code = WeExceptionCodesEnum.coreIndexError;
    } else if (error is ArgumentError) {
      response.code = WeExceptionCodesEnum.coreArgumentError;
    } else if (error is RangeError) {
      response.code = WeExceptionCodesEnum.coreRangeError;
    }

    if (error is TypeError) {
      response.code = WeExceptionCodesEnum.coreTypeError;
    } else if (error is UnimplementedError) {
      response.code = WeExceptionCodesEnum.coreUnimplementedError;
    } else if (error is NoSuchMethodError) {
      response.code = WeExceptionCodesEnum.coreNoSuchMethodError;
    } else if (error is UnsupportedError) {
      response.code = WeExceptionCodesEnum.coreUnsupportedError;
    } else if (error is StateError) {
      response.code = WeExceptionCodesEnum.coreStateError;
    } else if (error is ConcurrentModificationError) {
      response.code = WeExceptionCodesEnum.coreConcurrentModificationError;
    } else if (error is OutOfMemoryError) {
      response.code = WeExceptionCodesEnum.coreOutOfMemoryError;
    } else if (error is StackOverflowError) {
      response.code = WeExceptionCodesEnum.coreStackOverflowError;
    }

    // WeException.submitError(
    //     description: "_handleErrorTypes",
    //     exception: Exception(error.toString()),
    //     reason: response.code,
    //     response: response,
    //     stackTrace:
    //         error.stackTrace ?? StackTrace.fromString(error.toString()));

    return response;
  }
}
