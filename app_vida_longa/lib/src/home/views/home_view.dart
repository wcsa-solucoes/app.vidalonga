import 'package:app_vida_longa/domain/contants/app_colors.dart';
import 'package:app_vida_longa/domain/models/article_model.dart';
import 'package:app_vida_longa/shared/article_card_widget.dart';
import 'package:app_vida_longa/shared/widgets/custom_bottom_navigation_bar.dart';
import 'package:app_vida_longa/shared/widgets/custom_chip.dart';
import 'package:app_vida_longa/shared/widgets/custom_scaffold.dart';
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
                loading: _loadingState,
                loaded: _loadedState,
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

  Widget _loadingState(HomeLoadingState state) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _loadedState(HomeLoadedState state) {
    if (state.articlesByCategory!.isEmpty) {
      return const SizedBox(
          child: Center(
              child: Padding(
        padding: EdgeInsets.only(bottom: 100),
        child: DefaultText("Nenhum artigo encontrado :("),
      )));
    }
    return SingleChildScrollView(
      child: Column(
        children: [
          // search(),
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

  Widget _errorState() {
    return const Center(
      child: Text("Erro ao carregar os dados"),
    );
  }

  Widget _categoriesSelectedState(HomeCategoriesSelectedState state) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // search(),
          SizedBox(
              height: 50,
              width: MediaQuery.of(context).size.width,
              child: _handleChips(
                state.chipsCategorie!,
                state.articlesByCategory!,
              )),
          _handleArticles(state.articlesByCategorySelected!),
        ],
      ),
    );
  }

  Widget _handleChips(List<ChipCategorie> chipsCategorie,
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
              chipsCategorie[index].selected = selected;

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
                    .where((articles) => selectedChips
                        .any((chip) => articles.first.category == chip.label))
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
    return ListView.separated(
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
            color: AppColors.white,
          ),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  categoryArticles.first.category.toUpperCase(),
                  style: GoogleFonts.getFont(
                    'Poppins',
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                    color: AppColors.secondaryText,
                  ),
                ),
              ),
              // Row(
              //   children: categoryArticles.first.subCategories.map((e) {
              //     return Padding(
              //       padding: const EdgeInsets.all(8.0),
              //       child: IconChoiceChip(
              //         isSelected: false,
              //         label: e.name,
              //         onSelected: (bool selected) {},
              //       ),
              //     );
              //   }).toList(),
              // ),
              Container(
                color: AppColors.white,
                height: 250,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categoryArticles.length,
                  padding: const EdgeInsets.only(right: 20),
                  itemBuilder: (BuildContext context, int articleIndex) {
                    final article = categoryArticles[articleIndex];
                    return Padding(
                      padding: const EdgeInsets.only(
                          left: 10, top: 0, bottom: 0, right: 15),
                      child: ArticleCard(article: article),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return const Divider(
          thickness: 0,
          color: AppColors.dimGray,
        );
      },
    );
  }

  Widget search() {
    return TextFormField(
      controller: TextEditingController(),
      autofocus: false,
      obscureText: false,
      decoration: InputDecoration(
        labelText: 'Buscar aqui...',
        // labelStyle: FlutterFlowTheme.of(context).labelMedium,
        // hintStyle: FlutterFlowTheme.of(context).labelMedium,
        enabledBorder: UnderlineInputBorder(
          borderSide: const BorderSide(
            // color: FlutterFlowTheme.of(context).alternate,
            width: 4.0,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: const BorderSide(
            // color: FlutterFlowTheme.of(context).primary,
            width: 4.0,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        errorBorder: UnderlineInputBorder(
          borderSide: const BorderSide(
            // color: FlutterFlowTheme.of(context).error,
            width: 4.0,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        focusedErrorBorder: UnderlineInputBorder(
          borderSide: const BorderSide(
            // color: FlutterFlowTheme.of(context).error,
            width: 4.0,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        prefixIcon: const Icon(
          Icons.search,
          size: 15.0,
        ),
        suffixIcon: const Icon(
          Icons.close,
        ),
      ),
      // style: FlutterFlowTheme.of(context).bodyMedium,
    );
  }
}
