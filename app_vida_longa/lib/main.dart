import 'package:app_vida_longa/core/helpers/print_colored_helper.dart';
import 'package:app_vida_longa/core/services/articles_service.dart';
import 'package:app_vida_longa/core/services/auth_service.dart';
import 'package:app_vida_longa/core/services/categories_service.dart';
import 'package:app_vida_longa/core/services/in_app_purchase_service.dart';
import 'package:app_vida_longa/main_module.dart';
import 'package:app_vida_longa/src/core/navigation_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'firebase_options.dart';

import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  String mode = const String.fromEnvironment("MODE", defaultValue: "dev");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
    name: mode,
  );
  Bloc.observer = MyBlocObserver();
  InAppPurchaseStoreKitPlatform.registerPlatform();

  startServices();
  startControllers();

  runApp(ModularApp(module: MainModule(), child: const MainApp()));
}

void startControllers() {
  NavigationController.init();
}

void startServices() async {
  AuthService.init();
  await ArticleService.init();
  await CategoriesService.init();

  InAppPurchaseImplServices.instance.init(InAppPurchase.instance);
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
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
      theme: ThemeData(fontFamily: "Inter", useMaterial3: false),
      routeInformationParser: Modular.routeInformationParser,
      routerDelegate: Modular.routerDelegate,
      // localizationsDelegates: GlobalCupertinoLocalizations.delegates,
      debugShowCheckedModeBanner: false,
      title: "Vida longa",
    );
  }
}

class MyBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    PrintColoredHelper.printError('onCreate -- ${bloc.runtimeType}');
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    PrintColoredHelper.printError("onEvent ${event.runtimeType}");
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
  }
}
