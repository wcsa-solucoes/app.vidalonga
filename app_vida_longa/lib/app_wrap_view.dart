import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AppWrapView extends StatefulWidget {
  const AppWrapView({super.key});

  @override
  State<AppWrapView> createState() => _AppWrapViewState();
}

class _AppWrapViewState extends State<AppWrapView> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: const RouterOutlet(),
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
}
