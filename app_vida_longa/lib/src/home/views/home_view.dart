import 'dart:developer';

import 'package:app_vida_longa/core/services/articles_service.dart';
import 'package:app_vida_longa/domain/contants/app_colors.dart';
import 'package:app_vida_longa/domain/models/article_model.dart';
import 'package:app_vida_longa/shared/widgets/custom_bottom_navigation_bar.dart';
import 'package:app_vida_longa/shared/widgets/custom_chip.dart';
import 'package:app_vida_longa/shared/widgets/custom_scaffold.dart';
import 'package:app_vida_longa/src/core/navigation_controller.dart';
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
  final url =
      'https://www.selecoes.com.br/media/_versions/legacy/f/f/29c14d1e8e6937dd549d3cbf3fc86b1ac12b956e_widemd.jpg';

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
      builder: (context, state) {
        if (state is HomeError) {
          return const Center(
            child: Text("Erro ao carregar os dados"),
          );
        }
        if (state is HomeLoaded) {
          return CustomAppScaffold(
            appBar: AppBar(title: const Text("Home")),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  // search(),
                  SizedBox(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      child: chips2(
                          state.chipsCategorie!, state.articlesByCategory!)),
                  testListView(state.articlesByCategory!),
                ],
              ),
            ),
            bottomNavigationBar: const CustomBottomNavigationBar(),
          );
        }

        if (state is HomeCategoriesSelected) {
          return SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: CustomAppScaffold(
              appBar: AppBar(title: const Text("Home")),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    // search(),
                    SizedBox(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        child: chips2(
                          state.chipsCategorie!,
                          state.articlesByCategory!,
                        )),
                    testListView(state.articlesByCategorySelected!),
                  ],
                ),
              ),
            ),
          );
        }
        // if (state is HomeCategoriesSelected) {
        //   return
        // }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget chips2(List<ChipCategorie> chipsCategorie,
      List<List<ArticleModel>> articlesByCategorySelectedAll) {
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      scrollDirection: Axis.horizontal,
      itemCount: chipsCategorie.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(left: 10),
          child: IconChoiceChip(
            label: chipsCategorie[index].label,
            onSelected: (bool selected) {
              // Atualizar o status de seleção do chip atual
              chipsCategorie[index].selected = selected;

              // Filtrar os chips selecionados
              var selectedChips =
                  chipsCategorie.where((chip) => chip.selected).toList();

              // Se nenhum chip está selecionado, dispara o evento HomeLoadedEvent
              if (selectedChips.isEmpty) {
                _homeBloc.add(
                  HomeLoadedEvent(
                    articles: articlesByCategorySelectedAll,
                    chipsCategorie: chipsCategorie,
                  ),
                );
              } else {
                // Filtrar artigos pelas categorias selecionadas
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

  Widget chips(HomeState state) {
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      scrollDirection: Axis.horizontal,
      itemCount: state.chipsCategorie?.length ?? 0,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(
            left: 10,
          ),
          child: IconChoiceChip(
            label: state.chipsCategorie![index].label,
            onSelected: (bool selected) {
              //returning all categories but updated the selected one
              final List<ChipCategorie> chips = state.chipsCategorie!
                  .map((e) => ChipCategorie(
                      label: e.label,
                      selected: e.label ==
                              state.articlesByCategory![index].first.category
                          ? selected
                          : e.selected))
                  .toList();
              final List<List<ArticleModel>> selecteds = state
                  .articlesByCategory!
                  .where((element) =>
                      element.first.category ==
                      state.articlesByCategory![index].first.category)
                  .toList();

              _homeBloc.add(
                HomeCategoriesSelectedEvent(
                  articles: selecteds,
                  chipsCategorie: chips,
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget testListView(List<List<ArticleModel>> articlesByCategory) {
    return ListView.separated(
      physics:
          const NeverScrollableScrollPhysics(), // Add this to keep the ListView from scrolling
      shrinkWrap: true,
      itemCount: articlesByCategory.length,
      padding: const EdgeInsets.only(bottom: 20),

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
                      padding:
                          const EdgeInsets.only(left: 15, top: 0, bottom: 0),
                      child: articleCard(article),
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

  Widget articleCard(ArticleModel article) {
    return Material(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 1.0,
              color: Colors.grey.withOpacity(0.5),
              offset: const Offset(2.0, 3.0),
            )
          ],
        ),
        child: Column(
          children: [
            Expanded(
              child: Tooltip(
                message: article.title,
                preferBelow: false,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      article.title,
                      maxLines: 1,
                      style: GoogleFonts.getFont(
                        'Poppins',
                        fontWeight: FontWeight.w500,
                        fontSize: 20.0,
                        color: AppColors.titleColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                // Navigator.of(context).pushNamed("/article");
                NavigationController.push("/app/home/article");
              },
              child: Container(
                height: 190,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                    color: AppColors.white,
                    image: DecorationImage(
                        image: NetworkImage(url), fit: BoxFit.fill)),
                width: MediaQuery.of(context).size.width,
              ),
            ),
          ],
        ),
      ),
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

  Widget newCArd() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 15.0, 0.0),
            child: Container(
              width: 278.0,
              height: 240.0,
              decoration: BoxDecoration(
                // color: FlutterFlowTheme.of(context)
                //     .secondaryBackground,
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 4.0,
                    color: Color(0x33000000),
                    offset: Offset(0.0, 2.0),
                  )
                ],
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Align(
                alignment: const AlignmentDirectional(0.00, 0.00),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Stack(
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(0.0),
                                    bottomRight: Radius.circular(0.0),
                                    topLeft: Radius.circular(15.0),
                                    topRight: Radius.circular(15.0),
                                  ),
                                  child: Image.network(
                                    'https://www.selecoes.com.br/media/_versions/legacy/f/f/29c14d1e8e6937dd549d3cbf3fc86b1ac12b956e_widemd.jpg',
                                    width: 278.0,
                                    height: 168.0,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(20.0, 10.0, 20.0, 0.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Vitaminas que irão fortaceler \no seu sistema imonológico',
                            // style: FlutterFlowTheme.of(context)
                            //     .titleMedium
                            //     .override(
                            //       fontFamily: 'Urbanist',
                            //       color: Color(0xBB052F72),
                            //       fontSize: 18.0,
                            //     ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
