import 'package:app_vida_longa/core/services/user_service.dart';
import 'package:app_vida_longa/domain/enums/user_service_status_enum.dart';
import 'package:app_vida_longa/src/auth/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AuthWrapView extends StatefulWidget {
  const AuthWrapView({super.key});

  @override
  State<AuthWrapView> createState() => _AuthWrapViewState();
}

class _AuthWrapViewState extends State<AuthWrapView> {
  final AuthBloc _authBloc = AuthBloc();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _authBloc,
      child: BlocConsumer<AuthBloc, AuthState>(
        bloc: _authBloc,
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            appBar: UserService.instance.status ==
                        UserServiceStatusEnum.accountedCreated ||
                    UserService.instance.status == UserServiceStatusEnum.valid
                ? AppBar(
                    title: const Text("Minha conta"),
                  )
                : null,
            body: const RouterOutlet(),
          );
        },
      ),
    );
  }
}
