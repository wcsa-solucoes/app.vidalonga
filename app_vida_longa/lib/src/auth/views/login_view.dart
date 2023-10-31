import 'dart:developer';

import 'package:app_vida_longa/core/services/user_service.dart';
import 'package:app_vida_longa/src/auth/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView>
    with SingleTickerProviderStateMixin {
  late AuthBloc _authBloc;
  bool isLoginSelected = true;
  final TextEditingController _emailLoginController = TextEditingController();
  final TextEditingController _passwordLoginController =
      TextEditingController();

  final TextEditingController _emailRegisterController =
      TextEditingController();
  final TextEditingController _passwordRegisterController =
      TextEditingController();
  final TextEditingController _passwordConfirmRegisterController =
      TextEditingController();
  final TextEditingController _nameRegisterController = TextEditingController();
  final TextEditingController _phoneRegisterController =
      TextEditingController();
  final TextEditingController _cpfRegisterController = TextEditingController();

  @override
  void initState() {
    _emailRegisterController.text = "f6gameplay@gmail.com";

    _passwordRegisterController.text = "123456";
    _passwordConfirmRegisterController.text = "123456";

    _nameRegisterController.text = "Lucas";
    _phoneRegisterController.text = "11999999999";
    _cpfRegisterController.text = "08783645950";

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        _authBloc = AuthBloc();
        return _authBloc;
      },
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          UserService.instance;
          if (state is AuthLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state.user!.name.isNotEmpty) {
            return const Center(
              child: Text("Logado"),
            );
          }
          return Scaffold(
            appBar: AppBar(title: const Text("Login")),
            body: SingleChildScrollView(
              child: Container(
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
                        isSelected: [
                          isLoginSelected,
                          !isLoginSelected
                        ],
                        children: const [
                          Text("Login"),
                          Text("Cadastro"),
                        ]),
                    Stack(
                      children: [
                        Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.7,
                            color: Colors.amber,
                            child: Center(
                              child:
                                  isLoginSelected ? signInView() : signUpView(),
                            )),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        },
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
          controller: _nameRegisterController,
          decoration: const InputDecoration(
            labelText: "Nome",
          ),
        ),
        TextField(
          controller: _phoneRegisterController,
          decoration: const InputDecoration(
            labelText: "Telefone",
          ),
        ),
        TextField(
          controller: _cpfRegisterController,
          decoration: const InputDecoration(
            labelText: "CPF",
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
          onPressed: () {
            if (_passwordRegisterController.text ==
                _passwordConfirmRegisterController.text) {
              _authBloc.add(AuthSignUpEvent(
                  name: _nameRegisterController.text,
                  phone: _phoneRegisterController.text,
                  cpf: _cpfRegisterController.text,
                  email: _emailRegisterController.text,
                  password: _passwordRegisterController.text));
            }
          },
          child: const Text("Cadastrar"),
        ),
      ],
    );
  }
}
