import 'package:app_vida_longa/domain/models/sub_category_model.dart';
import 'package:app_vida_longa/shared/article_card_widget.dart';
import 'package:app_vida_longa/shared/widgets/custom_scaffold.dart';
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
        appBar: AppBar(
          centerTitle: true,
          title: Text(widget.subCategory.name),
        ),
        body: Column(
          children: [
            Text("Artigos", style: Theme.of(context).textTheme.displaySmall),
            SizedBox(
              // color: Colors.amber,
              width: MediaQuery.sizeOf(context).width,
              height: MediaQuery.sizeOf(context).height * 0.9,
              child: ListView.builder(
                padding: const EdgeInsets.only(
                    bottom: 100, left: 8, right: 8, top: 20),
                itemCount: widget.subCategory.articles?.length ?? 0,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.height * 0.3,
                      child: ArticleCard(
                          article: widget.subCategory.articles![index]),
                    ),
                  );
                },
              ),
            ),
          ],
        ));
  }
}
