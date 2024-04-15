import 'package:app_vida_longa/core/services/user_service.dart';
import 'package:app_vida_longa/domain/models/user_model.dart';
import 'package:app_vida_longa/shared/widgets/custom_scaffold.dart';
import 'package:app_vida_longa/shared/widgets/default_app_bar.dart';
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
  final UserService _userService = UserService.instance;
  @override
  Widget build(BuildContext context) {
    return CustomAppScaffold(
        appBar: const DefaultAppBar(title: "QRCode", isWithBackButton: true),
        body: body());
  }

  Widget body() {
    return StreamBuilder<UserModel>(
        initialData: _userService.user,
        stream: _userService.userStream,
        builder: (context, snapshot) {
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
                data: _userService.user.subscriptionLevel.value,
                version: QrVersions.auto,
                size: 200.0,
              ),
              DefaultText(
                qrCodeValue,
                maxLines: 2,
                fontSize: 14,
                fontWeight: FontWeight.w300,
                textAlign: TextAlign.center,
              ),
            ],
          );
        });
  }
}
