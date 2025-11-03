import 'dart:async';
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
import 'package:in_app_purchase_android/in_app_purchase_android.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  String mode = const String.fromEnvironment("MODE", defaultValue: "prod");

  if (Platform.isIOS) {
    await AppTrackingTransparency.requestTrackingAuthorization();
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

  // Register platform-specific implementations for in-app purchases
  if (Platform.isAndroid) {
    // Register Android billing client
    InAppPurchaseAndroidPlatform.registerPlatform();
    debugPrint('🚀 [MAIN] Android in-app purchase platform registered');
  } else if (Platform.isIOS) {
    // Register iOS StoreKit
    InAppPurchaseStoreKitPlatform.registerPlatform();
    debugPrint('🚀 [MAIN] iOS in-app purchase platform registered');
  }

  await startServices();
  startControllers();

  runApp(ModularApp(module: MainModule(), child: const MainApp()));
}

void startControllers() {
  NavigationController.init();
}

Future<void> startServices() async {
  final stopwatch = Stopwatch()..start();
  debugPrint(
    '🚀 [SERVICES] Starting service initialization at ${DateTime.now()}',
  );
  late final IInAppPurchaseService paymentService;

  if (Platform.isAndroid) {
    paymentService = InAppPurchaseImplServiceGoogleImpl.instance;
  } else {
    paymentService = InAppPurchaseImplServicesAppleImpl.instance;
  }

  debugPrint(
    '🚀 [SERVICES] Initializing ArticleService at ${stopwatch.elapsedMilliseconds}ms',
  );
  await ArticleService.init();
  debugPrint(
    '🚀 [SERVICES] ArticleService completed at ${stopwatch.elapsedMilliseconds}ms',
  );
  debugPrint(
    '🚀 [SERVICES] Initializing CategoriesService at ${stopwatch.elapsedMilliseconds}ms',
  );
  await CategoriesService.init(ArticleService.instance);
  debugPrint(
    '🚀 [SERVICES] CategoriesService completed at ${stopwatch.elapsedMilliseconds}ms',
  );
  debugPrint(
    '🚀 [SERVICES] Starting parallel services at ${stopwatch.elapsedMilliseconds}ms',
  );

  try {
    debugPrint(
      '🚀 [SERVICES] Starting Future.wait with ${stopwatch.elapsedMilliseconds}ms elapsed',
    );
    final futures = [
      () async {
        debugPrint(
          '🚀 [SERVICES] AuthService starting at ${stopwatch.elapsedMilliseconds}ms',
        );
        await AuthService.init();
        debugPrint(
          '🚀 [SERVICES] AuthService completed at ${stopwatch.elapsedMilliseconds}ms',
        );
      }(),
      () async {
        debugPrint(
          '🚀 [SERVICES] QAService starting at ${stopwatch.elapsedMilliseconds}ms',
        );
        await QAServiceImpl.instance.init(
          QARepositoryImpl(FirebaseFirestore.instance),
        );
        debugPrint(
          '🚀 [SERVICES] QAService completed at ${stopwatch.elapsedMilliseconds}ms',
        );
      }(),
      () async {
        debugPrint(
          '🚀 [SERVICES] PlansService starting at ${stopwatch.elapsedMilliseconds}ms',
        );
        await PlansServiceImpl.instance.getPlans();
        debugPrint(
          '🚀 [SERVICES] Plans loaded at ${stopwatch.elapsedMilliseconds}ms, checking store availability',
        );

        // CRITICAL: Check store availability BEFORE initializing payment service
        final bool available = await InAppPurchase.instance.isAvailable();
        debugPrint('🚀 [SERVICES] Store availability check: $available');

        if (!available) {
          debugPrint(
            '🚀 [SERVICES] Store not available, skipping payment service initialization',
          );
          return;
        }

        debugPrint(
          '🚀 [SERVICES] Store available, initializing payment service',
        );
        try {
          await paymentService
              .init(InAppPurchase.instance)
              .timeout(
                const Duration(seconds: 15),
                onTimeout: () {
                  debugPrint(
                    '🚀 [SERVICES] Payment service initialization timed out after 15 seconds at ${stopwatch.elapsedMilliseconds}ms',
                  );
                  throw TimeoutException(
                    'Payment service timeout',
                    const Duration(seconds: 15),
                  );
                },
              );
          debugPrint(
            '🚀 [SERVICES] Payment service initialized at ${stopwatch.elapsedMilliseconds}ms',
          );
        } catch (e) {
          debugPrint(
            '🚀 [SERVICES] Payment service failed at ${stopwatch.elapsedMilliseconds}ms: $e',
          );
          // Continue without payment service for now
        }
        await CouponsServiceImpl.instance.init();
        debugPrint(
          '🚀 [SERVICES] Coupons service initialized at ${stopwatch.elapsedMilliseconds}ms',
        );
      }(),
      () async {
        debugPrint(
          '🚀 [SERVICES] BranchsService starting at ${stopwatch.elapsedMilliseconds}ms',
        );
        await BranchsServiceImpl.instance.init();
        debugPrint(
          '🚀 [SERVICES] BranchsService completed at ${stopwatch.elapsedMilliseconds}ms',
        );
      }(),
      () async {
        debugPrint(
          '🚀 [SERVICES] PartnerService starting at ${stopwatch.elapsedMilliseconds}ms',
        );
        await PartnerServiceImpl.instance.init();
        debugPrint(
          '🚀 [SERVICES] PartnerService completed at ${stopwatch.elapsedMilliseconds}ms',
        );
      }(),
    ];

    await Future.wait(futures).timeout(
      const Duration(seconds: 30),
      onTimeout: () {
        debugPrint(
          '🚀 [SERVICES] Service initialization timed out after 30 seconds at ${stopwatch.elapsedMilliseconds}ms',
        );
        throw TimeoutException(
          'Service initialization timeout',
          const Duration(seconds: 30),
        );
      },
    );
    debugPrint(
      '🚀 [SERVICES] All parallel services completed successfully at ${stopwatch.elapsedMilliseconds}ms',
    );
  } catch (e) {
    debugPrint(
      '🚀 [SERVICES] Error during service initialization at ${stopwatch.elapsedMilliseconds}ms: $e',
    );
    debugPrint(
      '🚀 [SERVICES] Some services failed to initialize within timeout period',
    );
    // Continue with app startup even if some services fail
  }

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  debugPrint(
    '🚀 [SERVICES] Service initialization completed at ${stopwatch.elapsedMilliseconds}ms',
  );
  stopwatch.stop();
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
