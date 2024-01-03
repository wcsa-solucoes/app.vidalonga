import 'dart:io';

import 'package:app_vida_longa/core/helpers/app_helper.dart';
import 'package:app_vida_longa/core/services/auth_service.dart';
import 'package:app_vida_longa/core/services/service_files.dart';
import 'package:app_vida_longa/core/services/user_service.dart';
import 'package:app_vida_longa/domain/contants/app_colors.dart';
import 'package:app_vida_longa/shared/widgets/custom_scaffold.dart';
import 'package:app_vida_longa/shared/widgets/decorated_text_field.dart';
import 'package:app_vida_longa/shared/widgets/default_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
        appBar: AppBar(
          title: const Text('Meu Perfil'),
        ),
        hasScrollView: true,
        body: Column(
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
                    child: const Card(
                        child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: DefaultText("Alterar foto"),
                    )))
                : TextButton(
                    child: const Card(
                        child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: DefaultText("Salvar foto"),
                    )),
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
                    })
          ],
        ));
  }
}

class FlatButton extends StatefulWidget {
  const FlatButton({
    super.key,
    required this.textLabel,
    this.onPressed,
  });
  final String textLabel;
  final void Function()? onPressed;

  @override
  State<FlatButton> createState() => _FlatButtonState();
}

class _FlatButtonState extends State<FlatButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onPressed,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.0),
          color: AppColors.white,
        ),
        width: MediaQuery.of(context).size.width * 0.5,
        height: 50.0,
        child: const Center(
          child: DefaultText(
            'Salvar nova senha',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
