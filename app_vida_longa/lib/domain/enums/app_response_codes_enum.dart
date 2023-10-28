import "package:app_vida_longa/domain/models/response_model.dart";

enum AppResponseCodesEnum implements WeExceptionCodesInterface {
  /// Default Application related codes
  defaultInfo(ResponseStatusEnum.info),
  defaultWarning(ResponseStatusEnum.warning),
  defaultError(ResponseStatusEnum.failed),
  defaultSuccess(ResponseStatusEnum.success),

  /// Application related codes
  appInDevelopmentMode(ResponseStatusEnum.info),

  /// Account related codes
  loginFailed(ResponseStatusEnum.failed),
  restartAppWarning(ResponseStatusEnum.warning),
  accountRegisterAlreadyRegistered(ResponseStatusEnum.failed);

  final ResponseStatusEnum status;

  const AppResponseCodesEnum(this.status);
}

abstract class WeExceptionCodesInterface {}
