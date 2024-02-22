import 'package:app_vida_longa/shared/widgets/custom_bottom_navigation_bar.dart';
import 'package:app_vida_longa/shared/widgets/custom_scaffold.dart';
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
          return CustomAppScaffold(
            bottomNavigationBar: const CustomBottomNavigationBar(),
            body: SizedBox(
              width: MediaQuery.sizeOf(context).width,
              height: MediaQuery.sizeOf(context).height,
              child: const RouterOutlet(),
            ),
          );
        },
      ),
    );
  }
}
