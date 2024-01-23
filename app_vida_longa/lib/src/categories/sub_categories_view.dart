import 'package:app_vida_longa/core/services/categories_service.dart';
import 'package:app_vida_longa/domain/contants/app_colors.dart';
import 'package:app_vida_longa/domain/contants/routes.dart';
import 'package:app_vida_longa/shared/widgets/custom_scaffold.dart';
import 'package:app_vida_longa/shared/widgets/default_text.dart';
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
    return CustomAppScaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: AppColors.white,
          title: DefaultText(
            CategoriesService.instance.selectedCategory.name,
            fontSize: 20,
            fontWeight: FontWeight.w300,
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: AppColors.matterhorn),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        hasScrollView: true,
        body: SizedBox(
          width: MediaQuery.sizeOf(context).width,
          height: MediaQuery.sizeOf(context).height,
          child: ListView.builder(
              itemCount: CategoriesService
                  .instance.selectedCategory.subCategories.length,
              itemBuilder: (context, index) {
                var subCategorie = CategoriesService
                    .instance.selectedCategory.subCategories[index];

                //  NavigationController.push(
                //   routes.app.categories.subCategories.path,
                //   arguments: {"subCategory": subCategorie},
                // );
                return OpenPageButtonWiget(
                  subCategorie.name,
                  onPressed: () {
                    CategoriesService.instance.selectArticlesFromSubCategory(
                        CategoriesService
                            .instance.selectedCategory.subCategories[index]);
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
