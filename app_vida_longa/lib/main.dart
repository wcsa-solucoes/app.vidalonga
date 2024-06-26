import 'dart:io';
import 'package:app_vida_longa/core/helpers/print_colored_helper.dart';
import 'package:app_vida_longa/core/repositories/questions_and_answers_repository.dart';
import 'package:app_vida_longa/core/services/articles_service.dart';
import 'package:app_vida_longa/core/services/auth_service.dart';
import 'package:app_vida_longa/core/services/categories_service.dart';
import 'package:app_vida_longa/core/services/coupons_service.dart';
import 'package:app_vida_longa/core/services/iap_service/iap_purchase_apple_service.dart';
import 'package:app_vida_longa/core/services/iap_service/iap_purchase_google_service.dart';
import 'package:app_vida_longa/core/services/iap_service/interface/iap_purchase_service_interface.dart';
import 'package:app_vida_longa/core/services/partners_and_benefits/branchs_service.dart';
import 'package:app_vida_longa/core/services/partners_and_benefits/partners_service.dart';
import 'package:app_vida_longa/core/services/plans_service.dart';
import 'package:app_vida_longa/core/services/questions_and_answers_service.dart';
import 'package:app_vida_longa/domain/contants/routes.dart';
import 'package:app_vida_longa/main_module.dart';
import 'package:app_vida_longa/src/core/navigation_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'firebase_options.dart';

import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  String mode = const String.fromEnvironment("MODE", defaultValue: "prod");

  if (Platform.isIOS) {
    AppTrackingTransparency.requestTrackingAuthorization();
  }

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
    name: mode,
  );

  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  // Bloc.observer = MyBlocObserver();
  InAppPurchaseStoreKitPlatform.registerPlatform();

  await startServices();
  startControllers();

  runApp(ModularApp(module: MainModule(), child: const MainApp()));
}

void startControllers() {
  NavigationController.init();
}

Future<void> startServices() async {
  late final IInAppPurchaseService paymentService;

  if (Platform.isAndroid) {
    paymentService = InAppPurchaseImplServiceGoogleImpl.instance;
  } else {
    paymentService = InAppPurchaseImplServicesAppleImpl.instance;
  }
  await ArticleService.init().then((value) {
    CategoriesService.init(ArticleService.instance);
  });

  Future.wait([
    AuthService.init(),
    QAServiceImpl.instance.init(QARepositoryImpl(FirebaseFirestore.instance)),
    PlansServiceImpl.instance.getPlans().then((value) {
      paymentService.init(InAppPurchase.instance);
      CouponsServiceImpl.instance.init();
    }),
    BranchsServiceImpl.instance.init(),
    PartnerServiceImpl.instance.init(),
  ]);

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
    Modular.setInitialRoute(routes.app.home.path);
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
