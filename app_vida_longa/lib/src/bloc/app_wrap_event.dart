part of 'app_wrap_bloc.dart';

sealed class AppWrapEvent {}

final class AppWrapInitialEvent extends AppWrapEvent {}

final class AppWrapAlertEvent extends AppWrapEvent {
  final ResponseStatusModel? alertResponse;
  final int duration;

  AppWrapAlertEvent({
    required this.alertResponse,
    this.duration = 8,
  });
}

final class AppWrapSnackEvent extends AppWrapEvent {
  final ResponseStatusModel? snackBarResponse;
  final int duration;
  final bool? canClose;

  AppWrapSnackEvent({
    this.snackBarResponse,
    this.duration = 8,
    this.canClose,
  });
}
