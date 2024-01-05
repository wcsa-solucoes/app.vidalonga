import 'package:app_vida_longa/domain/contants/app_colors.dart';
import 'package:app_vida_longa/shared/widgets/custom_scaffold.dart';
import 'package:app_vida_longa/shared/widgets/default_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCodeView extends StatefulWidget {
  const QrCodeView({super.key});

  @override
  State<QrCodeView> createState() => _QrCodeViewState();
}

class _QrCodeViewState extends State<QrCodeView> {
  @override
  Widget build(BuildContext context) {
    return CustomAppScaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: AppColors.white,
          title: const DefaultText(
            "QRCode",
            fontSize: 20,
            fontWeight: FontWeight.w300,
          ),
          //back button syle
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: AppColors.matterhorn),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: body());
  }

  Widget body() {
    var qrCodeValue =
        "Gerado em ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())}";
    return Column(
      children: [
        const DefaultText(
          maxLines: 2,
          "Escaneie o QRCode para validar o certificado",
          fontSize: 20,
          fontWeight: FontWeight.w300,
          textAlign: TextAlign.center,
        ),
        QrImageView(
          //convert para dd/MM/yyyy
          data: qrCodeValue,
          version: QrVersions.auto,
          size: 200.0,
        ),
        DefaultText(
          qrCodeValue,
          fontSize: 14,
          fontWeight: FontWeight.w300,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
