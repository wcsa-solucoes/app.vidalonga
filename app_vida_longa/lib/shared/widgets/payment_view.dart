import 'dart:io';

import 'package:app_vida_longa/domain/contants/app_colors.dart';
import 'package:app_vida_longa/shared/payment_config.dart';
import 'package:app_vida_longa/shared/widgets/custom_scaffold.dart';
import 'package:app_vida_longa/shared/widgets/default_text.dart';
import 'package:flutter/material.dart';
import 'package:pay/pay.dart';

class PaymentView extends StatefulWidget {
  const PaymentView({super.key});

  @override
  State<PaymentView> createState() => _PaymentViewState();
}

class _PaymentViewState extends State<PaymentView> {
  Widget appleButton() {
    return ApplePayButton(
      paymentConfiguration:
          PaymentConfiguration.fromJsonString(defaultApplePay),
      paymentItems: const [
        PaymentItem(
          label: 'Total',
          amount: '10.0',
          status: PaymentItemStatus.final_price,
        )
      ],
      style: ApplePayButtonStyle.black,
      type: ApplePayButtonType.buy,
      margin: const EdgeInsets.only(top: 15.0),
      onPaymentResult: onApplePayResult,
      loadingIndicator: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget googleButon() {
    return GooglePayButton(
      paymentConfiguration:
          PaymentConfiguration.fromJsonString(defaultGooglePay),
      paymentItems: const [
        PaymentItem(
          label: 'Total',
          amount: '10.0',
          status: PaymentItemStatus.final_price,
        )
      ],
      type: GooglePayButtonType.pay,
      margin: const EdgeInsets.only(top: 15.0),
      onPaymentResult: onGooglePayResult,
      loadingIndicator: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  void onApplePayResult(Map<String, dynamic> data) {}

  void onGooglePayResult(Map<String, dynamic> data) {}

  @override
  Widget build(BuildContext context) {
    return CustomAppScaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: AppColors.white,
          title: const DefaultText(
            "Assinatura",
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
        body: Column(
          children: [
            const Text("Pagamento", style: TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            //apple and google pay options
            Padding(
              padding: const EdgeInsets.all(10),
              child:
                  Center(child: Platform.isIOS ? appleButton() : googleButon()),
            )
          ],
        ));
  }
}
