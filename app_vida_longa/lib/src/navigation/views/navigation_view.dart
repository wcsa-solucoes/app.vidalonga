import 'package:app_vida_longa/core/services/user_service.dart';
import 'package:app_vida_longa/shared/widgets/custom_bottom_navigation_bar.dart';
import 'package:app_vida_longa/shared/widgets/custom_scaffold.dart';
import 'package:app_vida_longa/src/core/navigation_controller.dart';
import 'package:flutter/material.dart';

class NavigationView extends StatefulWidget {
  const NavigationView({super.key});

  @override
  State<NavigationView> createState() => _NavigationViewState();
}

class _NavigationViewState extends State<NavigationView> {
  @override
  Widget build(BuildContext context) {
    return CustomAppScaffold(
        appBar: AppBar(title: const Text("Navegação")),
        bottomNavigationBar: const CustomBottomNavigationBar(),
        body: Builder(builder: (context) {
          if (UserService.instance.user.name.isNotEmpty) {
            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Navegação"),
                  Text("Usuário logado: ${UserService.instance.user.name}"),
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
