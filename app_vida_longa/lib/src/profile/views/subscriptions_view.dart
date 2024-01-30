import 'package:app_vida_longa/core/services/in_app_purchase_service.dart';
import 'package:app_vida_longa/domain/contants/app_colors.dart';
import 'package:app_vida_longa/shared/widgets/custom_scaffold.dart';
import 'package:app_vida_longa/shared/widgets/default_text.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class SubscriptionsView extends StatefulWidget {
  const SubscriptionsView({super.key});

  @override
  State<SubscriptionsView> createState() => _SubscriptionsViewState();
}

class _SubscriptionsViewState extends State<SubscriptionsView> {
  // PaymentServiceTest paymentService = PaymentServiceTest.instance;
  // PaymentService paymentService = PaymentService.instance;
  IInAppPurchaseService paymentService = InAppPurchaseImplServices.instance;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomAppScaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.white,
        title: const DefaultText(
          'Assinatura',
          fontSize: 20,
          fontWeight: FontWeight.w300,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.matterhorn),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      hasScrollView: true,
      body: body(),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget body() {
    return Column(
      children: [
        const DefaultText(
          'Escolha um plano',
          fontSize: 20,
          fontWeight: FontWeight.w300,
        ),
        TextButton(
          onPressed: () {
            paymentService.restorePurchase();
          },
          child: const DefaultText('restorePurchase'),
        ),
        TextButton(
          onPressed: () {
            paymentService.getTransactions();
          },
          child: const DefaultText('getTransactions'),
        ),
        ListView.builder(
          shrinkWrap: true,
          itemCount: paymentService.productDetails.length,
          itemBuilder: (context, index) {
            final ProductDetails prod = paymentService.productDetails[index];
            return ListTile(
              title: Text(prod.title),
              trailing: Text(prod.price.toString()),
              onTap: () async {
                // paymentService.buyProduct(prod);
                paymentService.purchase(prod);
              },
            );
          },
        ),
      ],
    );
  }
}
