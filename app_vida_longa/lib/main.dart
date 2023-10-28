import 'package:app_vida_longa/core/services/auth_service.dart';
import 'package:app_vida_longa/main_module.dart';
import 'package:app_vida_longa/src/core/navigation_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  startServices();

  startControllers();
  runApp(ModularApp(module: MainModule(), child: const MainApp()));
}

void startControllers() {
  NavigationController.init();
}

void startServices() {
  AuthService.init();
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  void initState() {
    Modular.setInitialRoute("/app/auth/login");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // AppHelper.setStatusBarColor();
    return MaterialApp.router(
      theme: ThemeData(fontFamily: "Inter", useMaterial3: true),
      routeInformationParser: Modular.routeInformationParser,
      routerDelegate: Modular.routerDelegate,
      // localizationsDelegates: GlobalCupertinoLocalizations.delegates,
      debugShowCheckedModeBanner: false,
      title: "Beer Mine",
    );
  }
}
