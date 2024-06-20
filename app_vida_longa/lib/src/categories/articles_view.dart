import 'package:app_vida_longa/core/services/categories_service.dart';
import 'package:app_vida_longa/domain/models/sub_category_model.dart';
import 'package:app_vida_longa/shared/widgets/article_card_widget.dart';
import 'package:app_vida_longa/shared/widgets/custom_scaffold.dart';
import 'package:app_vida_longa/shared/widgets/default_app_bar.dart';
import 'package:flutter/material.dart';

class ArticlesView extends StatefulWidget {
  const ArticlesView({super.key, required this.subCategory});
  final SubCategoryModel subCategory;
  @override
  State<ArticlesView> createState() => _ArticlesViewState();
}

class _ArticlesViewState extends State<ArticlesView> {
  @override
  Widget build(BuildContext context) {
    return CustomAppScaffold(
        appBar: DefaultAppBar(
            title: widget.subCategory.name, isWithBackButton: true),
        body: Column(
          children: [
            SizedBox(
              width: MediaQuery.sizeOf(context).width,
              height: MediaQuery.sizeOf(context).height * 0.9,
              child: ListView.builder(
                padding: const EdgeInsets.only(
                    bottom: 100, left: 8, right: 8, top: 20),
                itemCount:
                    CategoriesService.instance.articlesFromSubcategories.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: ArticleCard(
                        article: CategoriesService
                            .instance.articlesFromSubcategories[index],
                        containerHeight: 200,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ));
  }
}
