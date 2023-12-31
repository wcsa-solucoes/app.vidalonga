import 'package:app_vida_longa/core/services/user_service.dart';
import 'package:app_vida_longa/domain/contants/app_colors.dart';
import 'package:app_vida_longa/shared/widgets/custom_scaffold.dart';
import 'package:app_vida_longa/shared/widgets/decorated_text_field.dart';
import 'package:app_vida_longa/shared/widgets/default_text.dart';
import 'package:app_vida_longa/shared/widgets/flat_button.dart';
import 'package:app_vida_longa/src/auth/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class LoginView extends StatefulWidget {
  const LoginView({
    super.key,
  });

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView>
    with SingleTickerProviderStateMixin {
  late AuthBloc _authBloc;
  bool isLoginSelected = true;
  bool canViewPassword = true;
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

  final MaskTextInputFormatter maskFormatter = MaskTextInputFormatter(
      mask: '(##) # ####-####',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);

  final MaskTextInputFormatter cpfFormatter = MaskTextInputFormatter(
      mask: '###.###.###-##',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);

  @override
  void initState() {
    // _emailRegisterController.text = "f6gameplay@gmail.com";
    // _passwordRegisterController.text = "123456";
    // _passwordConfirmRegisterController.text = "123456";
    // _nameRegisterController.text = "Lucas";
    // _phoneRegisterController.text = "11999999999";
    // _cpfRegisterController.text = "08783645950";
    // _emailLoginController.text = "f6gameplay@gmail.com";
    // _passwordLoginController.text = "123456";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        _authBloc = context.read<AuthBloc>();
        return _authBloc;
      },
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {},
        builder: (context, state) {
          UserService.instance;
          if (state is AuthLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state.user!.name.isNotEmpty) {
            return Center(
              child: TextButton(
                onPressed: () {
                  _authBloc.add(AuthSignOutEvent());
                },
                child: const Text("Logado, clique para deslogar"),
              ),
            );
          }
          return CustomAppScaffold(
            isWithAppBar: false,
            hasScrollView: true,
            resizeToAvoidBottomInset: true,
            body: Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 250),
              child: Container(
                padding: const EdgeInsets.only(top: 30),
                decoration: BoxDecoration(
                    color: AppColors.backgroundColor,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.7), // Cor da sombra
                        spreadRadius: 3, // Raio de expansão da sombra
                        blurRadius: 4, // Raio de desfoque da sombra
                      ),
                    ]),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    ToggleButtons(
                      borderWidth: 2,
                      borderRadius: BorderRadius.circular(10),
                      fillColor: AppColors.selectedColor.withOpacity(0.2),
                      // selectedBorderColor: Colors.orange,
                      onPressed: (index) {
                        setState(() {
                          isLoginSelected = index == 0;
                        });
                      },
                      isSelected: [isLoginSelected, !isLoginSelected],
                      children: [
                        DefaultText(
                          "Login",
                          fontWeight: isLoginSelected ? FontWeight.bold : null,
                        ),
                        DefaultText("Cadastra-se",
                            fontWeight:
                                !isLoginSelected ? FontWeight.bold : null),
                      ],
                    ),
                    Stack(
                      children: [
                        Container(
                          //border with elevation

                          margin: const EdgeInsets.all(10),
                          padding: const EdgeInsets.all(10),
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.75,
                          child: Center(
                            child:
                                isLoginSelected ? signInView() : signUpView(),
                          ),
                        ),
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
        //textos de boas vindas e que preencha o campo
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Seja bem vindo!",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
            Text("Preencha as informações para logar no aplicativo.",
                style: TextStyle(fontSize: 16)),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        DecoratedTextFieldWidget(
          controller: _emailLoginController,
          labelText: "Email",
          hintText: "Email",
        ),

        const SizedBox(
          height: 10,
        ),
        DecoratedTextFieldWidget(
          controller: _passwordLoginController,
          isPassword: true,
          labelText: "Senha",
          hintText: "Email",
        ),

        const SizedBox(
          height: 10,
        ),
        Card(
          elevation: 1,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          child: FlatButton(
              onPressed: () {
                _authBloc.add(AuthSignInEvent(
                  email: _emailLoginController.text,
                  password: _passwordLoginController.text,
                ));
              },
              textLabel: "Entrar"),
        ),
        TextButton(
          onPressed: () {
            _authBloc.add(AuthRecoveryPasswordEvent(
              email: _emailLoginController.text,
            ));
          },
          child: const Text("Esqueceu a senha?"),
        ),
      ],
    );
  }

  Widget signUpView() {
    const double padding = 10;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Crie a sua conta",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
              Text("Preencha as informações para criar a sua conta",
                  style: TextStyle(fontSize: 16)),
            ],
          ),
          const SizedBox(
            height: padding,
          ),
          DecoratedTextFieldWidget(
            controller: _emailRegisterController,
            labelText: "Email",
            hintText: "Email",
          ),
          const SizedBox(
            height: padding,
          ),
          DecoratedTextFieldWidget(
            controller: _nameRegisterController,
            labelText: "Nome",
            hintText: "Nome",
          ),
          const SizedBox(
            height: padding,
          ),
          DecoratedTextFieldWidget(
            controller: _phoneRegisterController,
            labelText: "Telefone",
            hintText: "Telefone",
            keyboardType: TextInputType.phone,
            inputFormatters: [maskFormatter],
          ),
          const SizedBox(
            height: padding,
          ),
          DecoratedTextFieldWidget(
            controller: _cpfRegisterController,
            labelText: "CPF",
            hintText: "CPF",
            keyboardType: TextInputType.number,
            inputFormatters: [cpfFormatter],
          ),
          const SizedBox(
            height: padding,
          ),
          DecoratedTextFieldWidget(
            controller: _passwordRegisterController,
            labelText: "Senha",
            hintText: "Senha",
            isPassword: true,
          ),
          const SizedBox(
            height: padding,
          ),
          DecoratedTextFieldWidget(
            controller: _passwordConfirmRegisterController,
            isPassword: true,
            labelText: "Confirmar Senha",
            hintText: "Confirmar Senha",
          ),
          const SizedBox(
            height: padding,
          ),
          Card(
            color: Colors.blueAccent,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: InkWell(
                onTap: () {
                  if (_passwordRegisterController.text ==
                      _passwordConfirmRegisterController.text) {
                    final String cpfData = _cpfRegisterController.text
                        .replaceAll(".", "")
                        .replaceAll("-", "");
                    final String phoneData = _phoneRegisterController.text
                        .replaceAll("(", "")
                        .replaceAll(")", "")
                        .replaceAll(" ", "")
                        .replaceAll("-", "");

                    _authBloc.add(AuthSignUpEvent(
                      name: _nameRegisterController.text,
                      phone: phoneData,
                      cpf: cpfData,
                      email: _emailRegisterController.text,
                      password: _passwordRegisterController.text,
                    ));
                  }
                },
                // style: ButtonStyle(
                //   backgroundColor: MaterialStateProperty.all(Colors.blueAccent),
                // ),
                child: const Text("Cadastrar-se",
                    style: TextStyle(color: Colors.white)),
              ),
            ),
          ),
          //   Card(
          //   shape:
          //       RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          //   child: FlatButton(
          //     onPressed: () {
          //       if (_passwordRegisterController.text ==
          //           _passwordConfirmRegisterController.text) {
          //         _authBloc.add(AuthSignUpEvent(
          //           name: _nameRegisterController.text,
          //           phone: _phoneRegisterController.text,
          //           cpf: _cpfRegisterController.text,
          //           email: _emailRegisterController.text,
          //           password: _passwordRegisterController.text,
          //         ));
          //       }
          //     },
          //     textLabel: "Cadastrar-se",
          //   ),
          // ),
        ],
      ),
    );
  }
}
