import 'dart:io';

import 'package:app_vida_longa/core/helpers/app_helper.dart';
import 'package:app_vida_longa/core/services/auth_service.dart';
import 'package:app_vida_longa/core/services/service_files.dart';
import 'package:app_vida_longa/core/services/user_service.dart';
import 'package:app_vida_longa/domain/contants/app_colors.dart';
import 'package:app_vida_longa/domain/enums/subscription_type.dart';
import 'package:app_vida_longa/shared/widgets/custom_scaffold.dart';
import 'package:app_vida_longa/shared/widgets/decorated_text_field.dart';
import 'package:app_vida_longa/shared/widgets/default_app_bar.dart';
import 'package:app_vida_longa/shared/widgets/default_text.dart';
import 'package:app_vida_longa/shared/widgets/flat_button.dart';
import 'package:app_vida_longa/shared/widgets/wrapper_dialog.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:google_fonts/google_fonts.dart';

class MyProfileView extends StatefulWidget {
  const MyProfileView({super.key});

  @override
  State<MyProfileView> createState() => _MyProfileViewState();
}

class _MyProfileViewState extends State<MyProfileView> {
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  bool isLoading = false;

  final IFilesService _filesService = FilesService();

  File? image;

  Future pickImage() async {
    final image = await _filesService.pickFromGallery();
    if (image == null) return;
    final imageTemp = File(image.path);
    setState(() => this.image = imageTemp);
  }

  @override
  Widget build(BuildContext context) {
    return CustomAppScaffold(
      appBar: const DefaultAppBar(title: "Meu Perfil", isWithBackButton: true),
      hasScrollView: true,
      body: _body(),
    );
  }

  Widget _body() {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: image != null
              ? FileImage(image!)
              : UserService.instance.user.photoUrl.isNotEmpty
                  ? NetworkImage(UserService.instance.user.photoUrl)
                      as ImageProvider
                  : null,
          child: image == null && UserService.instance.user.photoUrl.isEmpty
              ? const Icon(
                  Icons.person,
                  size: 40,
                )
              : null,
        ),
        image == null
            ? TextButton(
                onPressed: () async {
                  pickImage();
                },
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: UserService.instance.user.photoUrl.isEmpty
                        ? const DefaultText("Adicionar foto")
                        : const DefaultText("Trocar foto"),
                  ),
                ),
              )
            : TextButton(
                child: const Card(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: DefaultText("Salvar foto"),
                  ),
                ),
                onPressed: () async {
                  final value = await _filesService.uploadFile(image!);

                  if (value) {
                    setState(() {
                      image = null;
                    });
                  }
                },
              ),
        DefaultText(UserService.instance.user.name),
        DefaultText(UserService.instance.user.email),
        const SizedBox(
          height: 50,
        ),
        Text(
          "Deseja trocar a senha?",
          style: GoogleFonts.getFont(
            'Urbanist',
            color: AppColors.dimGray,
            fontWeight: FontWeight.w500,
            fontSize: 14.0,
            //underline text
            decoration: TextDecoration.underline,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        DecoratedTextFieldWidget(
          controller: password,
          isPassword: true,
          labelText: "Nova senha",
          hintText: "Nova senha",
        ),
        const SizedBox(
          height: 10,
        ),
        DecoratedTextFieldWidget(
          isPassword: true,
          controller: confirmPassword,
          labelText: "Confirmar senha",
          hintText: "Confirmar senha",
        ),
        const SizedBox(
          height: 20,
        ),
        isLoading
            ? const CircularProgressIndicator()
            : FlatButton(
                textLabel: "Salvar nova senha",
                onPressed: () async {
                  setState(() {
                    isLoading = !isLoading;
                  });
                  if (password.text == confirmPassword.text) {
                    await AuthService.instance
                        .changePassword(password.text)
                        .then((value) {
                      if (value) {
                        password.clear();
                        confirmPassword.clear();
                      }
                      setState(() {
                        isLoading = !isLoading;
                      });
                    });
                  } else {
                    AppHelper.displayAlertError("As senhas não conferem.");
                  }
                },
              ),
        //delete account
        const SizedBox(
          height: 20,
        ),
        FlatButton(
          onPressed: () async {
            showDialog(
              context: context,
              builder: (context) => _HandleWarningTodelete(
                context: context,
              ),
            );
          },
          textLabel: "Deletar conta",
          isDangerButton: true,
        ),
      ],
    );
  }
}

class _HandleWarningTodelete extends StatelessWidget {
  const _HandleWarningTodelete({
    required this.context,
  });
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    var isSubscribed =
        UserService.instance.user.subscriptionLevel == SubscriptionEnum.paying;
    return WrapperDialog(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          isSubscribed
              ? const DefaultText(
                  "Você tem assinatura em andamento, e o pagamento é feito diretamente na loja de aplicativos, você deve cancelar a assinatura por lá. E lembre-se que essa ação, deletar conta, é irreversível e todos os seus dados serão deletados.",
                  fontSize: 16,
                  maxLines: 7,
                  textAlign: TextAlign.center,
                )
              : const DefaultText(
                  "Tem certeza que deseja deletar a conta? Lembre-se que essa ação é irreversível e todos os seus dados serão deletados.",
                  fontSize: 16,
                  maxLines: 3,
                  textAlign: TextAlign.center,
                ),
          const SizedBox(height: 20),
          FlatButton(
            textLabel: "Sim",
            onPressed: () async {
              AuthService.instance.deleteAccount().then((value) {
                Navigator.pop(context);
              });
            },
            isDangerButton: true,
          ),
          const SizedBox(
            height: 20,
          ),
          FlatButton(
            textLabel: "Não",
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          const SizedBox(
            height: 20,
          ),
          _handleOrientationOnIos(isSubscribed),
          _handleOrientationOnAndroid(isSubscribed),
        ],
      ),
    );
  }

  Widget _handleOrientationOnAndroid(bool isSubscribed) {
    List<SelectableText> listText = [
      SelectableText.rich(
        TextSpan(
          text: 'Como Cancelar Sua Assinatura no Google Play Store (Android)',
          style: getDefaultFont(
            fontSize: sectionSize,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      SelectableText.rich(
        TextSpan(
          text:
              'Para usuários de dispositivos Android, siga estas etapas para cancelar sua assinatura através da Google Play Store:',
          style: getDefaultFont(
            fontSize: paragraphSize,
          ),
        ),
      ),
      SelectableText.rich(
        TextSpan(
          text: '1. Abra o app Google Play Store no seu dispositivo Android.',
          style: getDefaultFont(
            fontSize: paragraphSize,
          ),
        ),
      ),
      SelectableText.rich(
        TextSpan(
          text:
              '2. Toque no ícone do seu perfil no canto superior direito da tela. Em seguida, toque em "Assinaturas e Pagamentos".',
          style: getDefaultFont(
            fontSize: paragraphSize,
          ),
        ),
      ),
      SelectableText.rich(
        TextSpan(
          text: '3. Clique em assinaturas.',
          style: getDefaultFont(
            fontSize: paragraphSize,
          ),
        ),
      ),
      SelectableText.rich(
        TextSpan(
          text: '4. Encontre a assinatura que deseja cancelar e toque nela...',
          style: getDefaultFont(
            fontSize: paragraphSize,
          ),
        ),
      ),
      SelectableText.rich(
        TextSpan(
          text:
              '5. Toque em "Cancelar Assinatura" e siga as instruções para confirmar o cancelamento.',
          style: getDefaultFont(
            fontSize: paragraphSize,
          ),
        ),
      ),
    ];

    if (Platform.isAndroid && isSubscribed) {
      return Column(
        children: [
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.4,
            child: Scrollbar(
              thumbVisibility: true,
              child: ListView.builder(
                itemCount: listText.length,
                itemBuilder: (_, index) => Padding(
                  padding: const EdgeInsets.only(
                    top: 10,
                  ),
                  child: listText[index],
                ),
              ),
            ),
          ),
        ],
      );
    }
    return const SizedBox.shrink();
  }

  Widget _handleOrientationOnIos(bool isSubscribed) {
    List<SelectableText> listText = [
      SelectableText.rich(
        TextSpan(
          text: 'Como Cancelar Sua Assinatura na App Store (iOS)',
          style: getDefaultFont(
            fontSize: sectionSize,
          ),
        ),
      ),
      SelectableText.rich(
        TextSpan(
          text: '1. Abra o app "Ajustes" no seu dispositivo iOS.',
          style: getDefaultFont(
            fontSize: paragraphSize,
          ),
        ),
      ),
      SelectableText.rich(
        TextSpan(
          text:
              '2. Toque no seu nome no topo da tela, e então em "Assinaturas".',
          style: getDefaultFont(
            fontSize: paragraphSize,
          ),
        ),
      ),
      SelectableText.rich(
        TextSpan(
          text:
              '3. Você verá uma lista de todas as suas assinaturas ativas. Encontre e selecione a assinatura que deseja cancelar.',
          style: getDefaultFont(
            fontSize: paragraphSize,
          ),
        ),
      ),
      SelectableText.rich(
        TextSpan(
          text: "4. Toque em \"Cancelar Assinatura\" e confirme sua escolha.",
          style: getDefaultFont(
            fontSize: paragraphSize,
          ),
        ),
      ),
      SelectableText.rich(
        TextSpan(
          text:
              "Se não encontrar a opção \"Assinaturas\" após tocar no seu nome, toque em \"iTunes & App Store\", toque no seu ID Apple, toque em \"Ver ID Apple\", faça login se necessário, desça até \"Assinaturas\", e então siga os passos 3 e 4.",
          style: getDefaultFont(
            fontSize: paragraphSize,
          ),
        ),
      ),
    ];

    if (Platform.isIOS && isSubscribed) {
      return Column(
        children: [
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.4,
            child: Scrollbar(
              thumbVisibility: true,
              child: ListView.builder(
                itemCount: listText.length,
                itemBuilder: (_, index) => Padding(
                  padding: const EdgeInsets.only(
                    top: 10,
                  ),
                  child: listText[index],
                ),
              ),
            ),
          ),
        ],
      );
    }
    return const SizedBox.shrink();
  }

  TextStyle getDefaultFont(
      {FontWeight? fontWeight, double? fontSize, Color? color}) {
    return GoogleFonts.getFont(
      'Urbanist',
      color: AppColors.dimGray,
      fontWeight: FontWeight.w500,
      fontSize: 22.0,
    ).copyWith(
      fontWeight: fontWeight,
      fontSize: fontSize,
      color: color ?? AppColors.blackCard,
      overflow: TextOverflow.ellipsis,
    );
  }

  final double sectionSize = 24.0;
  final double paragraphSize = 16.0;
}
