import 'package:app_vida_longa/core/services/user_service.dart';
import 'package:app_vida_longa/domain/enums/user_service_status_enum.dart';
import 'package:app_vida_longa/src/core/navigation_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

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
        return BottomNavigationBar(
            currentIndex: handleIndex(snapshot.data!),
            unselectedItemColor: Colors.grey,
            selectedItemColor: Colors.orange,
            unselectedLabelStyle: const TextStyle(color: Colors.grey),
            selectedLabelStyle: const TextStyle(color: Colors.orange),
            showUnselectedLabels: true,
            onTap: (value) {
              setState(() {
                switch (value) {
                  case 0:
                    NavigationController.to("/app/home");
                    break;
                  case 1:
                    NavigationController.to("/app/navigation");
                  case 2:
                    if (UserService.instance.status ==
                        UserServiceStatusEnum.loggedOut) {
                      NavigationController.to("/app/auth/login");
                    } else {
                      NavigationController.to("/app/profile");
                    }
                    break;
                  case 3:
                    NavigationController.to("/app/categories/");
                    break;
                }
              });
            },
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.favorite), label: "Início"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.navigation), label: "Navigation"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.account_circle_rounded), label: "Conta"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.list), label: "Categorias"),
            ]);
      },
    );
  }

  int handleIndex(String path) {
    late int index = 0;
    for (final element in Modular.to.navigateHistory) {
      if (element.name.split("/").contains("home")) {
        index = 0;
      } else if (element.name.split("/").contains("navigation")) {
        index = 1;
      } else if (element.name.split("/").contains("auth") ||
          element.name.split("/").contains("profile")) {
        index = 2;
      } else if (element.name.split("/").contains("categories")) {
        index = 3;
      }
    }

    return index;
  }
}
