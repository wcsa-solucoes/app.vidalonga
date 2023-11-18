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
            selectedItemColor: Colors.orange,
            onTap: (value) {
              setState(() {
                switch (value) {
                  case 0:
                    NavigationController.to("/app/home");
                    break;
                  case 1:
                    NavigationController.to("/app/navigation");
                  case 2:
                    NavigationController.to("/app/auth/login");
                    break;
                }
              });
            },
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.favorite), label: "Home"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.navigation), label: "Navigation"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.account_circle_rounded), label: "Conta"),
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
      } else if (element.name.split("/").contains("auth")) {
        index = 2;
      }
    }

    return index;
  }
}
