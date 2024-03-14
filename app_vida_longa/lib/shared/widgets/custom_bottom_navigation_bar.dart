import 'package:app_vida_longa/core/services/user_service.dart';
import 'package:app_vida_longa/domain/contants/app_colors.dart';
import 'package:app_vida_longa/domain/contants/routes.dart';
import 'package:app_vida_longa/domain/enums/user_service_status_enum.dart';
import 'package:app_vida_longa/src/core/navigation_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  const CustomBottomNavigationBar({super.key});

  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
      stream: NavigationController.routeStream,
      initialData: Modular.to.path,
      builder: (context, snapshot) {
        return !(Modular.to.navigateHistory.length > 3)
            ? BottomNavigationBar(
                currentIndex: handleIndex(snapshot.data!),
                unselectedItemColor: Colors.grey,
                selectedItemColor: AppColors.unselectedTextStyleColor,
                unselectedLabelStyle: const TextStyle(color: Colors.grey),
                selectedLabelStyle: const TextStyle(color: Colors.orange),
                showUnselectedLabels: true,
                onTap: (value) {
                  setState(() {
                    switch (value) {
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
                        NavigationController.to(routes.app.benefits.path);

                        break;
                    }
                  });
                },
                items: const [
                    BottomNavigationBarItem(
                        icon: Icon(Icons.favorite), label: "Início"),
                    BottomNavigationBarItem(
                        icon: FaIcon(
                          FontAwesomeIcons.layerGroup,
                          size: 20,
                        ),
                        label: "Categorias"),
                    BottomNavigationBarItem(
                        icon: FaIcon(Icons.account_circle_rounded),
                        label: "Conta"),
                    BottomNavigationBarItem(
                        icon: FaIcon(FontAwesomeIcons.comment),
                        label: "Perguntas"),
                    BottomNavigationBarItem(
                      icon: FaIcon(FontAwesomeIcons.gift),
                      label: "Benefícios",
                    ),
                  ])
            : const SizedBox.shrink();
      },
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
      } else if (element.name.split("/").contains("benefits")) {
        index = 4;
      }
    }

    return index;
  }
}
