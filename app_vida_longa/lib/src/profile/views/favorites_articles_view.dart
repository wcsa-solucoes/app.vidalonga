import 'package:app_vida_longa/core/services/favorites_service.dart';
import 'package:app_vida_longa/domain/contants/app_colors.dart';
import 'package:app_vida_longa/shared/widgets/article_card_widget.dart';
import 'package:app_vida_longa/shared/widgets/custom_scaffold.dart';
import 'package:app_vida_longa/shared/widgets/default_text.dart';
import 'package:flutter/material.dart';

class FavoritesArticlesView extends StatefulWidget {
  const FavoritesArticlesView({super.key});

  @override
  State<FavoritesArticlesView> createState() => _FavoritesArticlesViewState();
}

class _FavoritesArticlesViewState extends State<FavoritesArticlesView> {
  final IFavoritesService _favoritesService = FavoritesServiceImpl.instance;

  @override
  Widget build(BuildContext context) {
    return CustomAppScaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: AppColors.white,
          title: const DefaultText(
            "Artigos favoritos",
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
        body: body());
  }

  Widget body() {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      height: MediaQuery.sizeOf(context).height * 0.9,
      child: StreamBuilder(
          initialData: _favoritesService.favorites,
          stream: _favoritesService.favoritesStream,
          builder: (context, snapshot) {
            if (_favoritesService.favorites.isEmpty) {
              return const Center(child: Text("Nenhum artigo favorito :("));
            }
            return ListView.builder(
              padding: const EdgeInsets.only(
                  bottom: 100, left: 8, right: 8, top: 20),
              itemCount: _favoritesService.favorites.length,
              itemBuilder: (context, index) {
                final article = _favoritesService.favorites[index];
                return Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.height * 0.3,
                    child: ArticleCard(article: article),
                  ),
                );
              },
            );
          }),
    );
  }
}
