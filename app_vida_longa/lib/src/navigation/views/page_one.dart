import 'package:app_vida_longa/core/services/user_service.dart';
import 'package:app_vida_longa/src/core/navigation_controller.dart';
import 'package:flutter/material.dart';

class PageOne extends StatefulWidget {
  const PageOne({super.key});

  @override
  State<PageOne> createState() => _PageOneState();
}

class _PageOneState extends State<PageOne> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Navegação")),
        body: Builder(builder: (context) {
          if (UserService.instance.user.name.isNotEmpty) {
            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Navegação"),
                  Text("Usuário logado: " + UserService.instance.user.name),
                ],
              ),
            );
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text("Pagina de navegação"),
                TextButton(
                  onPressed: () {
                    NavigationController.to("/app/auth/login");
                  },
                  child: const Text(
                      "Usuario não logado, clique aqui para ir para login!"),
                ),
              ],
            ),
          );
        }));
  }
}
