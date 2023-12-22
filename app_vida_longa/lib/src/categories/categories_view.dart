import 'package:app_vida_longa/core/services/categories_service.dart';
import 'package:app_vida_longa/domain/contants/routes.dart';
import 'package:app_vida_longa/shared/widgets/custom_bottom_navigation_bar.dart';
import 'package:app_vida_longa/shared/widgets/custom_scaffold.dart';
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
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Categorias",
          // style: TextStyle(
          //   color: Colors.black,
          //   fontFamily: 'Urbanist',
          //   fontWeight: FontWeight.bold,
          // ),
        ),
      ),
      body: SizedBox(
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height,
        child: ListView.builder(
          itemCount: CategoriesService.instance.categories.length,
          itemBuilder: (context, index) {
            var categorie = CategoriesService.instance.categories[index];
            return OpenPageButtonWiget(
              categorie.name,
              onPressed: () {
                CategoriesService.setCurrentlyCategory(
                    CategoriesService.instance.categories[index]);
                NavigationController.push(
                    routes.app.categories.subCategories.path);
              },
            );
          },
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }
}
