import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'app_wrap_event.dart';
part 'app_wrap_state.dart';

class AppWrapBloc extends Bloc<AppWrapEvent, AppWrapState> {
  AppWrapBloc() : super(AppWrapInitial()) {
    on<AppWrapEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
