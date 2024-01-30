// import 'dart:async';

// import 'package:app_vida_longa/core/helpers/print_colored_helper.dart';
// import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';

// abstract class IPaymentServiceTest {
//   init();
//   Future<void> _getProducts();
// }

// class PaymentServiceTest extends IPaymentServiceTest {
//   PaymentServiceTest._internal();

//   static final PaymentServiceTest _instance = PaymentServiceTest._internal();
//   static PaymentServiceTest get instance => _instance;

//   late StreamSubscription<PurchasedItem?> _purchaseUpdatedSubscription;
//   StreamSubscription<PurchasedItem?> get purchaseUpdatedSubscription =>
//       _purchaseUpdatedSubscription;

//   late StreamSubscription<PurchaseResult?> _purchaseErrorSubscription;
//   StreamSubscription<PurchaseResult?> get purchaseErrorSubscription =>
//       _purchaseErrorSubscription;

//   final Set<String> _kIds = {
//     "app.vidalongaapp.assinaturamensal",
//     "app.vidalongaapp.assinaturamensal.test.40",
//   };

//   final List<IAPItem> _products = [];
//   List<IAPItem> get products => _products;

//   @override
//   Future<void> init() async {
//     await _init();
//     _getProducts();
//   }

//   Future<void> _init() async {
//     await FlutterInappPurchase.instance.initialize();
//     _purchaseUpdatedSubscription =
//         FlutterInappPurchase.purchaseUpdated.listen((productItem) {
//       PrintColoredHelper.printCyan('purchaseUpdated: $productItem');
//     });

//     _purchaseErrorSubscription =
//         FlutterInappPurchase.purchaseError.listen((purchaseError) {
//       PrintColoredHelper.printGreen('purchaseError: $purchaseError');
//     });
//   }

//   @override
//   Future<void> _getProducts() async {
//     // List<IAPItem> items =
//     //     await FlutterInappPurchase.instance.getProducts(_kIds.toList());
//     // _setProducts(items);
//     // FlutterInappPurchase.instance.getPromotedProductIOS().then((value) {
//     //   PrintColoredHelper.printGreen('value: $value');
//     // });

//     var itemss = await FlutterInappPurchase.instance.getAvailablePurchases();
//     PrintColoredHelper.printGreen('itemss: $itemss');

//     FlutterInappPurchase.instance.getPromotedProductIOS().then((value) {
//       PrintColoredHelper.printGreen('value: $value');
//     });

//     // var list = await FlutterInappPurchase.instance.showPromoCodesIOS();
//     // PrintColoredHelper.printGreen('list: $list');
//   }

//   void _setProducts(List<IAPItem> newItens) {
//     _products.clear();
//     _products.addAll(newItens);
//   }

//   void buyProduct(IAPItem item) {
//     FlutterInappPurchase.instance.requestPurchase(
//       item.productId!,
//     );
//   }
// // 6. Concluir Compras e Restaurar
// // Certifique-se de concluir as transações, especialmente em iOS, para evitar problemas
// //   _purchaseUpdatedSubscription = FlutterInappPurchase.purchaseUpdated.listen((productItem) {
// //   if (Platform.isIOS) {
// //     FlutterInappPurchase.instance.finishTransactionIOS(productItem.purchaseToken);
// //   }
// //   // Entregar o produto ou serviço comprado
// // });
// }
