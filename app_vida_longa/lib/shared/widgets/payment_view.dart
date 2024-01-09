import 'dart:io';

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
      paymentItems: const [
        PaymentItem(
          label: 'Total',
          amount: '0.01',
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
      paymentItems: const [
        PaymentItem(
          label: 'Total',
          amount: '0.01',
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
    return Column(
      children: [
        const Text("Pagamento", style: TextStyle(fontSize: 20)),
        const SizedBox(height: 20),
        //apple and google pay options
        Padding(
          padding: const EdgeInsets.all(10),
          child: Center(child: Platform.isIOS ? appleButton() : googleButon()),
        )
      ],
    );
  }
}
