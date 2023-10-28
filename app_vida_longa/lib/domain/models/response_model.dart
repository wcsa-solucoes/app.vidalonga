import 'package:app_vida_longa/domain/enums/app_response_codes_enum.dart';
import 'package:app_vida_longa/domain/enums/custom_exceptions_codes_enum.dart';

class ResponseStatusModel {
  late ResponseStatusEnum status;
  late String body;
  late String message;
  late WeExceptionCodesInterface code;
  late dynamic error;

  ResponseStatusModel({
    this.status = ResponseStatusEnum.success,
    this.body = "",
    this.message = "Success",
    this.code = WeExceptionCodesEnum.exceptionDefault,
    this.error,
  });
}

enum ResponseStatusEnum {
  success,
  error,
  failed,
  warning,
  info,
}
