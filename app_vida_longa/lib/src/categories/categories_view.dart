import 'package:app_vida_longa/core/services/categories_service.dart';
import 'package:app_vida_longa/domain/contants/routes.dart';
import 'package:app_vida_longa/shared/widgets/custom_bottom_navigation_bar.dart';
import 'package:app_vida_longa/shared/widgets/custom_scaffold.dart';
import 'package:app_vida_longa/shared/widgets/default_app_bar.dart';
import 'package:app_vida_longa/shared/widgets/default_text.dart';
import 'package:app_vida_longa/shared/widgets/open_button_page.dart';
import 'package:app_vida_longa/src/core/navigation_controller.dart';
import 'package:flutter/material.dart';

class CategoriesView extends StatefulWidget {
  const CategoriesView({super.key});

  @override
  State<CategoriesView> createState() => _CategoriesViewState();
}

class _CategoriesViewState extends State<CategoriesView> {
  @override
  Widget build(BuildContext context) {
    return CustomAppScaffold(
      hasScrollView: true,
      appBar: const DefaultAppBar(title: "Categorias"),
      body: SizedBox(
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height,
        child: Builder(builder: (context) {
          var categories = CategoriesService.instance.categories;
          if (categories.isEmpty) {
            return const Center(
                child: Padding(
              padding: EdgeInsets.only(bottom: 100),
              child: DefaultText("Nenhuma categoria encontrada :("),
            ));
          }
          return Padding(
            padding: const EdgeInsets.only(bottom: 170.0),
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                var categorie = categories[index];
                return OpenPageButtonWiget(
                  categorie.name,
                  onPressed: () {
                    CategoriesService.setCurrentlyCategory(categories[index]);

                    NavigationController.push(
                        routes.app.categories.subCategories.path);
                  },
                  
                );
              },
            ),
          
          );
        }),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }
}
