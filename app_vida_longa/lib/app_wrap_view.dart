import 'package:app_vida_longa/shared/widgets/custom_app_alert_modal.dart';
import 'package:app_vida_longa/shared/widgets/modals/custom_app_snackbar_modal.dart';
import 'package:app_vida_longa/src/bloc/app_wrap_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AppWrapView extends StatefulWidget {
  const AppWrapView({super.key});

  @override
  State<AppWrapView> createState() => _AppWrapViewState();
}

class _AppWrapViewState extends State<AppWrapView> {
  final AppWrapBloc appWrapBloc = AppWrapBloc.instance;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _handleAlerts(),
        const RouterOutlet(),
      ],
    );
  }

  Widget _handleAlerts() {
    return Column(
      children: [
        BlocProvider.value(
          value: appWrapBloc,
          child: const CustomAppSnackBarModal(),
        ),
        BlocProvider.value(
          value: appWrapBloc,
          child: const CustomAppAlertModal(),
        ),
      ],
    );
  }
}
