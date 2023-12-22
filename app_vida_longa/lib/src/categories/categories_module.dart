import 'package:app_vida_longa/src/categories/articles_view.dart';
import 'package:app_vida_longa/src/categories/categories_view.dart';
import 'package:app_vida_longa/src/categories/sub_categories_view.dart';
import 'package:flutter_modular/flutter_modular.dart';

class CategoriesModule extends Module {
  @override
  void binds(i) {}

  @override
  void routes(r) {
    r.child("/", child: (context) => const CategoriesView());
    r.child("/subCategories", child: (context) => const SubCategoriesView());
    r.child(
      "/subCategories/articles",
      child: (context) => ArticlesView(subCategory: r.args.data["subCategory"]),
    );
  }
}
