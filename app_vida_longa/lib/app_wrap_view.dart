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

  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            _handleAlerts(),
            const RouterOutlet(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (value) {
              setState(() {
                switch (value) {
                  case 0:
                    // Modular.to.navigate("/app/home");
                    break;
                  case 1:
                    if (_currentIndex != 1) {
                      Modular.to.navigate("/app/navigation");
                    }
                    break;
                  case 2:
                    Modular.to.navigate("/app/auth/login");
                    break;
                }
                _currentIndex = value;
              });
            },
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.other_houses), label: "other"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.account_circle_sharp), label: "account"),
            ]),
      ),
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
