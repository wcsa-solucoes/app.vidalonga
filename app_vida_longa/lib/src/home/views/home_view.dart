import 'package:app_vida_longa/domain/contants/app_colors.dart';
import 'package:app_vida_longa/domain/models/article_model.dart';
import 'package:app_vida_longa/domain/models/categorie_chip_model.dart';
import 'package:app_vida_longa/shared/widgets/article_card_widget.dart';
import 'package:app_vida_longa/shared/widgets/custom_bottom_navigation_bar.dart';
import 'package:app_vida_longa/shared/widgets/custom_chip.dart';
import 'package:app_vida_longa/shared/widgets/custom_scaffold.dart';
import 'package:app_vida_longa/shared/widgets/decorated_text_field.dart';
import 'package:app_vida_longa/shared/widgets/default_text.dart';
import 'package:app_vida_longa/src/home/bloc/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final HomeBloc _homeBloc;
  @override
  void initState() {
    _homeBloc = Modular.get<HomeBloc>();
    super.initState();
  }

  @override
  void dispose() {
    _homeBloc.close();
    super.dispose();
  }

  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      bloc: _homeBloc,
      listener: (context, state) {},
      builder: (BuildContext context, HomeState state) {
        return CustomAppScaffold(
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: AppColors.white,
            title: const DefaultText(
              "Início",
              fontSize: 20,
              fontWeight: FontWeight.w300,
            ),
          ),
          body: SizedBox(
            width: MediaQuery.sizeOf(context).width,
            height: MediaQuery.sizeOf(context).height,
            child: Builder(builder: (context) {
              return state.when(
                initial: () => Container(),
                loading: (HomeLoadingState state) => _loadingState(state),
                loaded: _loadedState,
                articlesSearched: _searchedState,
                error: (state) => _errorState(),
                categoriesSelected: _categoriesSelectedState,
              );
            }),
          ),
          bottomNavigationBar: const CustomBottomNavigationBar(),
        );
      },
    );
  }

  Widget _searchedState(ArticlesSearchedState state) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _handleSearch(),
          _handleArticles(state.articlesByCategory!),
        ],
      ),
    );
  }

  Widget _handleSearch() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: DecoratedTextFieldWidget(
        controller: _searchController,
        hintText: "Buscar por título...",
        labelText: "Buscar por título...",
        suffixIcon: IconButton(
          icon: const Icon(Icons.close, color: AppColors.dimGray),
          onPressed: _onRestart,
        ),
        textInputAction: TextInputAction.search,
        onSubmitted: (value) {
          if (value.isEmpty) {
            _homeBloc.add(RestartHomeEvent());
          } else {
            _homeBloc.add(HomeSearchEvent(searchTerm: value));
          }
        },
      ),
    );
  }

  Widget _loadingState(HomeLoadingState state) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _loadedState(HomeLoadedState state) {
    if (state.articlesByCategory!.isEmpty) {
      return _handleEmptyArticles();
    }
    return SingleChildScrollView(
      child: Column(
        children: [
          _handleSearch(),
          SizedBox(
              height: 50,
              width: MediaQuery.of(context).size.width,
              child: _handleChips(
                  state.chipsCategorie!, state.articlesByCategory!)),
          _handleArticles(state.articlesByCategory!),
        ],
      ),
    );
  }

  void _onRestart() {
    _searchController.clear();
    _homeBloc.add(RestartHomeEvent());
  }

  Widget _handleEmptyArticles() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.9,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const DefaultText("Nenhum artigo encontrado :("),
            _handleReload(),
          ],
        ),
      ),
    );
  }

  Widget _handleReload() {
    return TextButton(
      onPressed: _onRestart,
      child: const Text("Recarregar"),
    );
  }

  Widget _errorState() {
    return const Center(
      child: Text("Erro ao carregar os dados"),
    );
  }

  Widget _categoriesSelectedState(HomeCategoriesSelectedState state) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 50,
            width: MediaQuery.of(context).size.width,
            child: _handleChips(
              state.chipsCategorie!,
              state.articlesByCategory!,
            ),
          ),
          _handleArticles(state.articlesByCategorySelected!),
        ],
      ),
    );
  }

  Widget _handleChips(List<ChipCategorieModel> chipsCategorie,
      List<List<ArticleModel>> articlesByCategorySelectedAll) {
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      scrollDirection: Axis.horizontal,
      itemCount: chipsCategorie.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(left: 10),
          child: IconChoiceChip(
            isSelected: chipsCategorie[index].selected,
            label: chipsCategorie[index].label,
            onSelected: (bool selected) {
              chipsCategorie[index] =
                  chipsCategorie[index].copyWith(selected: selected);

              var selectedChips =
                  chipsCategorie.where((chip) => chip.selected).toList();

              if (selectedChips.isEmpty) {
                _homeBloc.add(
                  HomeLoadedEvent(
                    articles: articlesByCategorySelectedAll,
                    chipsCategorie: chipsCategorie,
                  ),
                );
              } else {
                var selectedArticles = articlesByCategorySelectedAll
                    .where((articles) => selectedChips.any(
                        (chip) => articles.first.categoryUuid == chip.uuid))
                    .toList();

                _homeBloc.add(
                  HomeCategoriesSelectedEvent(
                    articles: selectedArticles,
                    chipsCategorie: chipsCategorie,
                  ),
                );
              }
            },
          ),
        );
      },
    );
  }

  Widget _handleArticles(List<List<ArticleModel>> articlesByCategory) {
    if (articlesByCategory.isEmpty) {
      return _handleEmptyArticles();
    }

    return ListView.builder(
      physics:
          const NeverScrollableScrollPhysics(), // Add this to keep the ListView from scrolling
      shrinkWrap: true,
      itemCount: articlesByCategory.length,
      padding: const EdgeInsets.only(bottom: 200),

      itemBuilder: (BuildContext context, int categoryIndex) {
        final categoryArticles = articlesByCategory[categoryIndex];

        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            color: Colors.transparent,
          ),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  categoryArticles.first.categoryTitle.toUpperCase(),
                  style: GoogleFonts.getFont(
                    'Poppins',
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                    color: AppColors.secondaryText,
                  ),
                ),
              ),
              Container(
                color: Colors.transparent,
                height: 250,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categoryArticles.length,
                  padding: const EdgeInsets.only(right: 20),
                  itemBuilder: (BuildContext context, int articleIndex) {
                    final article = categoryArticles[articleIndex];
                    return Padding(
                      padding: const EdgeInsets.only(
                          left: 10, top: 4, bottom: 0, right: 15),
                      child: ArticleCard(article: article),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
