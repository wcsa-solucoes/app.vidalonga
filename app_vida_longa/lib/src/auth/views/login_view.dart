import 'package:app_vida_longa/core/helpers/print_colored_helper.dart';
import 'package:app_vida_longa/core/services/user_service.dart';
import 'package:app_vida_longa/domain/contants/app_colors.dart';
import 'package:app_vida_longa/domain/contants/routes.dart';
import 'package:app_vida_longa/domain/enums/subscription_type.dart';
import 'package:app_vida_longa/shared/widgets/custom_bottom_navigation_bar.dart';
import 'package:app_vida_longa/shared/widgets/custom_scaffold.dart';
import 'package:app_vida_longa/shared/widgets/decorated_text_field.dart';
import 'package:app_vida_longa/shared/widgets/default_text.dart';
import 'package:app_vida_longa/shared/widgets/flat_button.dart';
import 'package:app_vida_longa/shared/widgets/policy_widget.dart';
import 'package:app_vida_longa/shared/widgets/terms_widget.dart';
import 'package:app_vida_longa/src/auth/bloc/auth_bloc.dart';
import 'package:app_vida_longa/src/core/navigation_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
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
  final AuthBloc _authBloc = AuthBloc();
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
    super.initState();
  }

  @override
  void dispose() {
    PrintColoredHelper.printError("LoginView dispose");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return _authBloc;
      },
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess && state.canPop!) {
            PrintColoredHelper.printGreen(" AuthSuccess");

            if (UserService.instance.user.subscriptionLevel ==
                SubscriptionEnum.nonPaying) {
              NavigationController.pushNamedAndRemoveUntil(
                routes.app.profile.subscriptions.path,
                (routeIterated) =>
                    routeIterated.settings.name?.contains("home") ?? false,
              );
            } else {
              NavigationController.pushNamedAndRemoveUntil(
                routes.app.home.article.path,
                (routeIterated) =>
                    routeIterated.settings.name?.contains("home") ?? false,
              );
            }
          }
        },
        builder: (context, state) {
          return CustomAppScaffold(
            isWithAppBar: true,
            hasScrollView: true,
            resizeToAvoidBottomInset: true,
            bottomNavigationBar: const CustomBottomNavigationBar(),
            body: Builder(builder: (context) {
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

              if (state is AuthSuccess) {
                return const Center(
                  child: DefaultText(
                    "Login realizado com sucesso! Clique na seta para voltar.",
                  ),
                );
              }

              return body(context);
            }),
          );
        },
      ),
    );
  }

  Widget body(BuildContext context) {
    return Padding(
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
                    fontWeight: !isLoginSelected ? FontWeight.bold : null),
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
                    child: isLoginSelected ? signInView() : signUpView(),
                  ),
                ),
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
        //textos de boas vindas ƒ que preencha o campo
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DefaultText(
              "Seja bem vindo!",
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
            DefaultText(
              "Preencha as informações para logar no aplicativo.",
              fontSize: 16,
              maxLines: 2,
            ),
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
        FlatButton(
            onPressed: () {
              bool canPop = false;
              for (var element in Modular.to.navigateHistory) {
                if (element.name.contains(routes.app.home.path)) {
                  canPop = true;
                }
              }
              _authBloc.add(
                AuthSignInEvent(
                  email: _emailLoginController.text,
                  password: _passwordLoginController.text,
                  canPop: canPop,
                ),
              );
            },
            textLabel: "Entrar"),
        TextButton(
          onPressed: () {
            _authBloc.add(AuthRecoveryPasswordEvent(
              email: _emailLoginController.text,
            ));
          },
          child: const Text("Esqueceu a senha?"),
        ),
        TextButton(
          onPressed: () {
            showDialog(
                context: context, builder: (context) => const PolicyWidget());
          },
          child: const Text("Política de Privacidade"),
        ),
        TextButton(
          onPressed: () {
            showDialog(
                context: context, builder: (context) => const TermsWiget());
          },
          child: const Text("Termos e condições"),
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
              DefaultText("Crie a sua conta",
                  fontSize: 22, fontWeight: FontWeight.w600),
              DefaultText(
                "Preencha as informações para criar a sua conta.",
                fontSize: 16,
                maxLines: 2,
              ),
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
          FlatButton(
            textLabel: "Cadastrar-se",
            onPressed: () {
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
          ),
          // ),
        ],
      ),
    );
  }
}
