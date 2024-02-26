import "dart:async";
import "dart:developer";
import "package:flutter/material.dart";
import "package:flutter_modular/flutter_modular.dart";

abstract class NavigationController {
  static final StreamController<String> _routeController =
      StreamController<String>.broadcast();

  static Stream<String> get routeStream => _routeController.stream;

  static void init() {
    Modular.to.addListener(() {
      log(Modular.to.path);
      _routeController.sink.add(Modular.to.path);
    });
  }

  static void push(String route, {dynamic arguments}) {
    if (route == Modular.to.path) {
      return;
    }

    _pushNamed(route, arguments: arguments);
  }

  static void pushNamedAndRemoveUntil(
      String route, bool Function(Route<dynamic>) predicate,
      {dynamic arguments}) {
    if (route == Modular.to.path) {
      return;
    }
    _pushNamedAndRemoveUntil(route, predicate, arguments: arguments);
  }

  static void pop() {
    if (Modular.to.canPop()) {
      Modular.to.pop();
    }
  }

  static void to(String route, {dynamic arguments}) {
    if (route == Modular.to.path) {
      return;
    }

    _to(route, arguments: arguments);
  }

  static void pushReplacementNamed(String route, {dynamic arguments}) {
    if (route == Modular.to.path) {
      return;
    }

    _pushReplacementNamed(route, arguments: arguments);
  }

  static void back() {
    final int size = Modular.to.navigateHistory.length;

    if (size == 1) {
      return;
    }
    late int backPos = 2;

    if (size == 2) {
      backPos = 1;
    }
    final String route = Modular
        .to.navigateHistory[Modular.to.navigateHistory.length - backPos].name;

    _pushNamed(route);
  }

  static void _pushNamed(String route, {dynamic arguments}) {
    unawaited(Modular.to.pushNamed(route, arguments: arguments));
    _routeController.sink.add(route);
  }

  static void _pushReplacementNamed(String route, {dynamic arguments}) {
    unawaited(Modular.to.pushReplacementNamed(route, arguments: arguments));
    _routeController.sink.add(route);
  }

  static void _to(String route, {dynamic arguments}) {
    Modular.to.navigate(route, arguments: arguments);
    _routeController.sink.add(route);
  }

  static void _pushNamedAndRemoveUntil(
      String route, bool Function(Route<dynamic>) predicate,
      {dynamic arguments}) {
    unawaited(
      Modular.to
          .pushNamedAndRemoveUntil(route, predicate, arguments: arguments),
    );

    _routeController.sink.add(route);
  }
}
