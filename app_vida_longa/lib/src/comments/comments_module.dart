import 'package:app_vida_longa/src/comments/bloc/comments_bloc.dart';
import 'package:app_vida_longa/src/comments/comments_view.dart';
import 'package:flutter_modular/flutter_modular.dart';

class CommentsModule extends Module {
  @override
  void binds(Injector i) {
    i.add(
      CommentsBloc.new,
    );
    super.binds(i);
  }

  @override
  void routes(r) {
    r.child(
      "/",
      child: (context) => const CommentsView(),
    );
  }
}
