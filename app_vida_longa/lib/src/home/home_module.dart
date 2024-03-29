import 'package:app_vida_longa/src/comments/comments_module.dart';
import 'package:app_vida_longa/src/home/bloc/home_bloc.dart';
import 'package:app_vida_longa/src/home/views/article_view.dart';
import 'package:app_vida_longa/src/home/views/home_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

class HomeModule extends Module {
  @override
  void binds(i) {
    i.add<HomeBloc>(
      HomeBloc.new,
      config: BindConfig(
        onDispose: (HomeBloc bloc) => bloc.close(),
      ),
    );
  }

  @override
  void routes(r) {
    r.child("/", child: (context) => const HomePage());
    r.child(
      '/article',
      child: (context) => const ArticleView(),
    );
    r.module("/comments", module: CommentsModule());
  }
}
