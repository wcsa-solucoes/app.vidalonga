import 'dart:io';

import 'package:app_vida_longa/core/helpers/app_helper.dart';
import 'package:app_vida_longa/core/services/auth_service.dart';
import 'package:app_vida_longa/core/services/service_files.dart';
import 'package:app_vida_longa/core/services/user_service.dart';
import 'package:app_vida_longa/shared/widgets/custom_scaffold.dart';
import 'package:flutter/material.dart';
import 'dart:async';

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
                    child: const Text("Alterar foto"))
                : TextButton(
                    child: const Text("Salvar foto"),
                    onPressed: () async {
                      final value = await _filesService.uploadFile(image!);

                      if (value) {
                        setState(() {
                          image = null;
                        });
                      }
                    },
                  ),
            Text(UserService.instance.user.name),
            Text(UserService.instance.user.email),
            const SizedBox(
              height: 50,
            ),
            const Text("Trocar senha"),
            TextField(
              controller: password,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Senha",
              ),
            ),
            TextField(
              controller: confirmPassword,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Confirmar Senha",
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
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
                    child: const Text("Salvar"),
                  ),
          ],
        ));
  }
}
