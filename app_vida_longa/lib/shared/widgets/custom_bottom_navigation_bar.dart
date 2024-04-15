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
        return const SizedBox.shrink();
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
      } else if (element.name.split("/").contains("partners")) {
        index = 4;
      }
    }

    return index;
  }
}
