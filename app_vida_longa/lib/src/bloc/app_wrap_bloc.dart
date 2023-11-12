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

  final Random _random = Random();

  AppWrapBloc._interal() : super(AppWrapInitial()) {
    on<AppWrapAlertEvent>(alert);
    on<AppWrapSnackEvent>(snackBar);
  }

  Future<void> alert(
      AppWrapAlertEvent event, Emitter<AppWrapState> emit) async {
    Future.delayed(const Duration(milliseconds: 80), () {
      emit(AppWrapAlert(
        alertResponse: event.alertResponse,
        duration: event.duration,
        // snackBarResponse: event.snackBarResponse,
      ));
    });
    await _reset(event, emit, resetAlert: true);
  }

  Future<void> snackBar(
      AppWrapSnackEvent event, Emitter<AppWrapState> emit) async {
    Future<void>.delayed(const Duration(milliseconds: 80), () {
      emit(AppWrapAlert(
        snackBarResponse: event.snackBarResponse,
        duration: event.duration,
        // alertResponse: event.alertResponse,
        // canClose: event.canClose,
      ));
    });
    await _reset(event, emit, resetSnackBar: true);
  }

  Future<void> _reset(AppWrapEvent event, Emitter<AppWrapState> emit,
      {bool resetSnackBar = false, bool resetAlert = false}) async {
    await Future.delayed(Duration(milliseconds: 200 + _random.nextInt(500)));

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
  }
}
