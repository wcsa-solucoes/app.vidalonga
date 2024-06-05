import "package:app_vida_longa/domain/enums/app_response_codes_enum.dart";
import "package:app_vida_longa/domain/models/response_model.dart";
import "package:app_vida_longa/src/bloc/app_wrap_bloc.dart";

abstract class NotificationController {
  static final AppWrapBloc _appWrapBloc = AppWrapBloc.instance;

  static void alert({
    ResponseStatusModel? response,
    int duration = 8,
    bool canClose = true,
    WeExceptionCodesInterface? code,
  }) {
    assert(response != null || code != null);
    late ResponseStatusModel data;

    if (code != null) {
      data = _overrideResponse(code as AppResponseCodesEnum);
    } else {
      data = response ?? ResponseStatusModel();
    }

    _appWrapBloc.add(AppWrapAlertEvent(
      alertResponse: data,
      duration: duration,
    ));
  }

  static void snackBar({
    ResponseStatusModel? response,
    int duration = 8,
    bool canClose = true,
    WeExceptionCodesInterface? code,
  }) {
    assert(response != null || code != null);

    late ResponseStatusModel data;

    if (code != null) {
      data = _overrideResponse(code as AppResponseCodesEnum);
    } else {
      data = response ?? ResponseStatusModel();
    }

    _appWrapBloc.add(AppWrapSnackEvent(
      snackBarResponse: data,
      duration: duration,
      canClose: canClose,
    ));
  }

  static ResponseStatusModel _overrideResponse(AppResponseCodesEnum code) {
    return ResponseStatusModel(status: code.status, code: code);
  }
}
