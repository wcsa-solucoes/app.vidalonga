import 'dart:io';

import 'package:app_vida_longa/core/services/user_service.dart';
import 'package:app_vida_longa/domain/contants/app_colors.dart';
import 'package:app_vida_longa/domain/contants/routes.dart';
import 'package:app_vida_longa/domain/enums/user_service_status_enum.dart';
import 'package:app_vida_longa/shared/widgets/custom_app_alert_modal.dart';
import 'package:app_vida_longa/shared/widgets/default_text.dart';
import 'package:app_vida_longa/shared/widgets/modals/custom_app_snackbar_modal.dart';
import 'package:app_vida_longa/src/bloc/app_wrap_bloc.dart';
import 'package:app_vida_longa/src/core/navigation_controller.dart';
import 'package:circle_nav_bar/circle_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppWrapView extends StatefulWidget {
  const AppWrapView({super.key});

  @override
  State<AppWrapView> createState() => _AppWrapViewState();
}

class _AppWrapViewState extends State<AppWrapView> {
  final AppWrapBloc appWrapBloc = AppWrapBloc.instance;

  final double labelSize = 16.0;
  double bottomPadding = 0;

  @override
  void initState() {
    if (Platform.isIOS) {
      bottomPadding = 10;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: StreamBuilder<String>(
          stream: NavigationController.routeStream,
          initialData: Modular.to.path,
          builder: (context, snapshot) {
            int count =
                NavigationController.countWordsBetweenSlashes(Modular.to.path);

            if (count > 2) {
              return const SizedBox.shrink();
            }

            return CircleNavBar(
              activeIndex: handleIndex(snapshot.data!),
              circleColor: AppColors.primary,
              activeIcons: const [
                Center(
                  child: Icon(
                    Icons.home,
                    color: AppColors.bottomSelectedColor,
                  ),
                ),
                Center(
                  child: FaIcon(
                    FontAwesomeIcons.layerGroup,
                    color: AppColors.bottomSelectedColor,
                  ),
                ),
                Center(
                  child: FaIcon(
                    FontAwesomeIcons.circleUser,
                    color: AppColors.bottomSelectedColor,
                  ),
                ),
                Center(
                  child: FaIcon(
                    FontAwesomeIcons.comment,
                    color: AppColors.bottomSelectedColor,
                  ),
                ),
                Center(
                  child: FaIcon(
                    FontAwesomeIcons.gift,
                    color: AppColors.bottomSelectedColor,
                  ),
                ),
              ],
              inactiveIcons: [
                Padding(
                  padding: EdgeInsets.only(bottom: bottomPadding),
                  child: DefaultText(
                    "Início",
                    color: AppColors.white,
                    fontSize: labelSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: bottomPadding),
                  child: DefaultText(
                    "Categorias",
                    color: AppColors.white,
                    fontSize: labelSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: bottomPadding),
                  child: DefaultText(
                    "Conta",
                    color: AppColors.white,
                    fontSize: labelSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: bottomPadding),
                  child: DefaultText(
                    "Perguntas",
                    color: AppColors.white,
                    fontSize: labelSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: bottomPadding),
                  child: DefaultText(
                    "Benefícios",
                    color: AppColors.white,
                    fontSize: labelSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
              height: 70,
              circleWidth: 60,
              color: AppColors.secondary,
              onTap: (index) {
                switch (index) {
                  case 0:
                    NavigationController.to(routes.app.home.path);
                    break;
                  case 1:
                    NavigationController.to(routes.app.categories.path);
                    break;
                  case 2:
                    if (UserService.instance.status ==
                        UserServiceStatusEnum.loggedOut) {
                      NavigationController.to(routes.app.auth.login.path);
                    } else {
                      NavigationController.to(routes.app.profile.path);
                    }
                    break;
                  case 3:
                    NavigationController.to(routes.app.qa.path);
                    break;
                  case 4:
                    NavigationController.to(routes.app.partners.path);
                    break;
                }
                handleIndex(snapshot.data!);
              },
            );
          }),
      body: Stack(
        children: [
          _handleAlerts(),
          const RouterOutlet(),
        ],
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

  int handleIndex(String path) {
    late int index = 0;
    for (final element in Modular.to.navigateHistory) {
      if (element.name.split("/").contains("home")) {
        index = 0;
      } else if (element.name.split("/").contains("categories")) {
        index = 1;
      } else if (element.name.split("/").contains("auth") ||
          element.name.split("/").contains("profile")) {
        index = 2;
      } else if (element.name.split("/").contains("questionsAndAnswers")) {
        index = 3;
      } else if (element.name.split("/").contains("partners")) {
        index = 4;
      }
    }

    return index;
  }
}
