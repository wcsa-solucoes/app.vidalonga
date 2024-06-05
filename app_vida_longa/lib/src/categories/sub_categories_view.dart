import 'package:app_vida_longa/core/services/categories_service.dart';
import 'package:app_vida_longa/domain/contants/routes.dart';
import 'package:app_vida_longa/domain/models/sub_category_model.dart';
import 'package:app_vida_longa/shared/widgets/custom_scaffold.dart';
import 'package:app_vida_longa/shared/widgets/default_app_bar.dart';
import 'package:app_vida_longa/shared/widgets/open_button_page.dart';
import 'package:app_vida_longa/src/core/navigation_controller.dart';
import 'package:flutter/material.dart';

class SubCategoriesView extends StatefulWidget {
  const SubCategoriesView({super.key});

  @override
  State<SubCategoriesView> createState() => _SubCategoriesViewState();
}

class _SubCategoriesViewState extends State<SubCategoriesView> {
  @override
  Widget build(BuildContext context) {
    final subCategories =
        CategoriesService.instance.selectedCategory.subCategories;
    return CustomAppScaffold(
        appBar: DefaultAppBar(
            title: CategoriesService.instance.selectedCategory.name,
            isWithBackButton: true),
        hasScrollView: true,
        body: SizedBox(
          width: MediaQuery.sizeOf(context).width,
          height: MediaQuery.sizeOf(context).height,
          child: ListView.builder(
              itemCount: subCategories.length,
              itemBuilder: (context, index) {
                SubCategoryModel subCategorie = subCategories[index];

                return OpenPageButtonWiget(
                  subCategorie.name,
                  onPressed: () {
                    CategoriesService.instance
                        .selectArticlesFromSubCategory(subCategories[index]);
                    NavigationController.push(
                      routes.app.categories.subCategories.articles.path,
                      arguments: {"subCategory": subCategorie},
                    );
                  },
                );
              }),
        ));
  }
}
