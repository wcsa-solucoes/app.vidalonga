import 'package:app_vida_longa/src/comments/comments_module.dart';
import 'package:app_vida_longa/src/home/bloc/home_bloc.dart';
import 'package:app_vida_longa/src/home/views/article_view.dart';
import 'package:app_vida_longa/src/home/views/home_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

class HomeModule extends Module {
  @override
  void binds(i) {
    i.add(HomeBloc.new);
  }

  @override
  void routes(r) {
    r.child("/", child: (context) => const HomePage());
    r.child('/article', 
    child: (context) {
      var args = r.args;
      var articleView = ArticleView(article: args.data["article"]);
      return articleView;
    });
    r.module("/comments", module: CommentsModule());
  }
}
