import "dart:async";
import "dart:math";

import "package:app_vida_longa/domain/models/response_model.dart";
import "package:flutter_bloc/flutter_bloc.dart";

part 'app_wrap_event.dart';

part 'app_wrap_state.dart';

class AppWrapBloc extends Bloc<AppWrapEvent, AppWrapState> {
  static final AppWrapBloc _instance = AppWrapBloc._interal();

  static AppWrapBloc get instance => _instance;

  static bool _hasInit = false;

  static void init() {
    if (!_hasInit) {
      _hasInit = true;
    }
  }

  // AppWrapBloc._internal() : super(const AppWrapState());

  final Random _random = Random();

  AppWrapBloc._interal() : super(AppWrapInitial()) {
    on<AppWrapEvent>((event, emit) {});
    on<AppWrapAlertEvent>(alert);
    on<AppWrapSnackEvent>(snackBar);
  }

  FutureOr<void> alert(AppWrapAlertEvent event, Emitter<AppWrapState> emit) {
    Future.delayed(const Duration(milliseconds: 80), () {
      emit(AppWrapAlert(
        alertResponse: event.alertResponse,
        duration: event.duration,
        // snackBarResponse: event.snackBarResponse,
      ));
    });

    _reset(event, emit, resetAlert: true);
  }

  FutureOr<void> snackBar(AppWrapSnackEvent event, Emitter<AppWrapState> emit) {
    Future.delayed(const Duration(milliseconds: 80), () {
      emit(AppWrapAlert(
        snackBarResponse: event.snackBarResponse,
        duration: event.duration,
        // alertResponse: event.alertResponse,
        canClose: event.canClose,
      ));
    });

    _reset(event, emit, resetSnackBar: true);
  }

  FutureOr<void> _reset(AppWrapEvent event, Emitter<AppWrapState> emit,
      {bool resetSnackBar = false, bool resetAlert = false}) {
    Future.delayed(Duration(milliseconds: 200 + _random.nextInt(500)), () {
      if (resetSnackBar) {
        emit(AppWrapAlert(
          snackBarResponse: null,
          alertResponse: state.alertResponse,
        ));
      }
      if (resetAlert) {
        emit(AppWrapAlert(
          alertResponse: null,
          snackBarResponse: state.snackBarResponse,
        ));
      }
    });
  }
}
