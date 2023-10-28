import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AuthWrapView extends StatefulWidget {
  const AuthWrapView({super.key});

  @override
  State<AuthWrapView> createState() => _AuthWrapViewState();
}

class _AuthWrapViewState extends State<AuthWrapView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AuthWrapView"),
      ),
      body: const RouterOutlet(),
    );
  }
}
