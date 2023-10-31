part of 'app_wrap_bloc.dart';

sealed class AppWrapState {
  ResponseStatusModel? get alertResponse;
  ResponseStatusModel? get snackBarResponse;
  int get duration;
  bool get canClose;
}

final class AppWrapInitial extends AppWrapState {
  @override
  final ResponseStatusModel? alertResponse;
  @override
  final ResponseStatusModel? snackBarResponse;
  @override
  final int duration;
  @override
  final bool canClose;

  final int? newDuration;

  AppWrapInitial({
    this.alertResponse,
    this.snackBarResponse,
    this.duration = 8,
    this.canClose = true,
    this.newDuration,
  });

  AppWrapState copyWith({
    ResponseStatusModel? alertResponse,
    ResponseStatusModel? snackBarResponse,
    int? duration,
    bool? canClose,
    int? index,
  }) {
    return AppWrapInitial(
      alertResponse: alertResponse,
      snackBarResponse: snackBarResponse,
      duration: duration ?? this.duration,
      canClose: canClose ?? this.canClose,
    );
  }
}

final class AppWrapAlert extends AppWrapState {
  @override
  final ResponseStatusModel? alertResponse;
  @override
  final ResponseStatusModel? snackBarResponse;
  @override
  final int duration;
  @override
  final bool canClose;

  AppWrapAlert({
    this.alertResponse,
    this.snackBarResponse,
    this.canClose = true,
    this.duration = 8,
  });

  AppWrapState copyWith({
    ResponseStatusModel? alertResponse,
    ResponseStatusModel? snackBarResponse,
    int? duration,
    bool? canClose,
  }) {
    return AppWrapAlert(
      alertResponse: alertResponse ?? this.alertResponse,
      snackBarResponse: snackBarResponse ?? this.snackBarResponse,
      duration: duration ?? this.duration,
      canClose: canClose ?? this.canClose,
    );
  }
}
