import 'dart:developer';

import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView>
    with SingleTickerProviderStateMixin {
  bool isLoginSelected = true;
  //text controllers to login and register
  final TextEditingController _emailLoginController = TextEditingController();
  final TextEditingController _passwordLoginController =
      TextEditingController();

  final TextEditingController _emailRegisterController =
      TextEditingController();
  final TextEditingController _passwordRegisterController =
      TextEditingController();
  final TextEditingController _passwordConfirmRegisterController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Container(
        color: Colors.grey,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            ToggleButtons(
                borderWidth: 2,
                borderRadius: BorderRadius.circular(10),
                onPressed: (index) {
                  setState(() {
                    isLoginSelected = !isLoginSelected;
                  });
                  log("index: $index");
                },
                children: [
                  const Text("Login"),
                  const Text("Cadastro"),
                ],
                isSelected: [
                  isLoginSelected,
                  !isLoginSelected
                ]),
            Stack(
              children: [
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.5,
                    color: Colors.amber,
                    child: Center(
                      child: isLoginSelected ? signInView() : signUpView(),
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget signInView() {
    return Column(
      children: [
        TextField(
          controller: _emailLoginController,
          decoration: const InputDecoration(
            labelText: "Email",
          ),
        ),
        TextField(
          controller: _passwordLoginController,
          decoration: const InputDecoration(
            labelText: "Senha",
          ),
        ),
        ElevatedButton(
          onPressed: () {},
          child: const Text("Entrar"),
        ),
      ],
    );
  }

  Widget signUpView() {
    return Column(
      children: [
        TextField(
          controller: _emailRegisterController,
          decoration: const InputDecoration(
            labelText: "Email",
          ),
        ),
        TextField(
          controller: _passwordRegisterController,
          decoration: const InputDecoration(
            labelText: "Senha",
          ),
        ),
        TextField(
          controller: _passwordConfirmRegisterController,
          decoration: const InputDecoration(
            labelText: "Confirmar Senha",
          ),
        ),
        ElevatedButton(
          onPressed: () {},
          child: const Text("Cadastrar"),
        ),
      ],
    );
  }
}
