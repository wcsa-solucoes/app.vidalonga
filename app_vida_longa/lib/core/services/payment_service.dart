// import 'dart:async';
// import 'package:app_vida_longa/core/helpers/print_colored_helper.dart';
// import 'package:in_app_purchase/in_app_purchase.dart';
// import 'package:in_app_purchase_platform_interface/in_app_purchase_platform_interface.dart';
// import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';

// class PaymentService {
//   PaymentService._internal();
//   static final PaymentService _instance = PaymentService._internal();
//   static PaymentService get instance => _instance;

//   bool _hasInit = false;

//   final InAppPurchaseStoreKitPlatform iap =
//       InAppPurchasePlatform.instance as InAppPurchaseStoreKitPlatform;

//   late final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition;

//   late final StreamSubscription<dynamic> _subscription;
//   late final Stream<List<PurchaseDetails>> purchaseUpdates;

//   final Set<String> _kIds = {
//     'app.vidalongaapp.assinaturamensal',
//     'app.vidalongaapp.assinaturamensal.test.40',
//   };
//   List<ProductDetails> _products = [];

//   List<ProductDetails> get products => _products;

//   void init() async {
//     if (!_hasInit) {
//       _hasInit = true;
//       _init();
//     }
//   }

//   void _init() async {
//     iosPlatformAddition = InAppPurchase.instance
//         .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();

//     purchaseUpdates = iap.purchaseStream;

//     _subscription = purchaseUpdates.listen((purchases) {
//       _handlePurchaseUpdates(purchases);
//     }, onError: (error) {
//       PrintColoredHelper.printCyan('purchaseUpdates error: $error');
//     }, onDone: () {
//       PrintColoredHelper.printCyan('purchaseUpdates onDone');
//     });

//     await _retrieveProducts();
//   }

//   Future<void> _retrieveProducts() async {
//     final ProductDetailsResponse response =
//         await iap.queryProductDetails(_kIds);
//     if (response.notFoundIDs.isNotEmpty) {}
//     if (response.error != null) {}
//     _products = response.productDetails;
//   }

//   void _handlePurchaseUpdates(List<PurchaseDetails> purchaseDetailsList) {
//     PrintColoredHelper.printCyan('purchaseDetailsList: $purchaseDetailsList');

//     for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
//       if (purchaseDetails.status == PurchaseStatus.pending) {
//         // A compra está pendente e ainda não concluída.
//       } else {
//         if (purchaseDetails.status == PurchaseStatus.error) {
//           // Houve um erro na compra.
//           // Você pode utilizar purchaseDetails.error para obter mais detalhes.
//         } else if (purchaseDetails.status == PurchaseStatus.purchased ||
//             purchaseDetails.status == PurchaseStatus.restored) {
//           // A compra foi bem-sucedida ou restaurada.
//           // Aqui, você deve entregar o produto e validar o recibo da compra.

//           // Importante: Sempre complete a transação para iOS.
//           if (purchaseDetails.pendingCompletePurchase) {
//             iap.completePurchase(purchaseDetails);
//           }
//         }
//         // Tratamento adicional, se necessário.
//       }
//     }
//   }

//   Future<void> buyProduct(ProductDetails prod) async {
//     iosPlatformAddition.presentCodeRedemptionSheet();
//     // final PurchaseParam purchaseParam = PurchaseParam(productDetails: prod);
//     // iap.buyConsumable(purchaseParam: purchaseParam);
//   }
// }
