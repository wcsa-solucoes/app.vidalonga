import 'dart:async';
import 'package:app_vida_longa/core/helpers/app_helper.dart';
import 'package:app_vida_longa/core/helpers/print_colored_helper.dart';
import 'package:app_vida_longa/core/services/articles_service.dart';
import 'package:app_vida_longa/domain/models/article_model.dart';
import 'package:app_vida_longa/domain/models/category_model.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final ArticleService _articleService = ArticleService.instance;

  late final StreamSubscription<(List<ArticleModel>, List<CategoryModel>)>
      _subscription;
  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }

  HomeBloc() : super(HomeLoadingState()) {
    on<HomeLoadedEvent>(_handleLoaded);
    on<HomeLoadingEvent>(_handleLoading);
    on<HomeCategoriesSelectedEvent>(_handleCategoriesSelected);
    on<HomeSearchEvent>(_handleSearchFromTitle);
    on<RestartHomeEvent>(_handleRestartHome);

    _subscription = _articleService.articlesStream.listen((event) {
      if (event.$1.isEmpty || event.$2.isEmpty) {
        return;
      }

      add(HomeLoadedEvent(
          articles: _articles, chipsCategorie: _allCategoriesChips));
    });

    if (_articleService.articles.isNotEmpty) {
      add(HomeLoadedEvent(
          articles: _articles, chipsCategorie: _allCategoriesChips));
    }
  }

  _handleRestartHome(RestartHomeEvent event, Emitter<HomeState> emit) {
    emit(HomeLoadedState(
        articlesByCategory: _articles, chipsCategorie: _allCategoriesChips));
  }

  Future<void> _handleSearchFromTitle(
      HomeSearchEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoadingState());
    await Future.delayed(const Duration(seconds: 1));
    final List<List<ArticleModel>> tempArticles = [];
    for (var element in _articles) {
      final List<ArticleModel> temp = element
          .where((element) => element.title
              .toLowerCase()
              .contains(event.searchTerm.toLowerCase()))
          .toList();
      if (temp.isNotEmpty) {
        tempArticles.add(temp);
      }
    }

    PrintColoredHelper.printGreen(tempArticles.length.toString());
    if (tempArticles.isEmpty) {
      AppHelper.displayAlertInfo(
          "Nenhum artigo encontrado com o título pesquisado.");
    }
    emit(
      ArticlesSearchedState(
        articlesByCategory: tempArticles,
        chipsCategorie: _allCategoriesChips,
      ),
    );
  }

  FutureOr<void> _handleCategoriesSelected(
      HomeCategoriesSelectedEvent event, Emitter<HomeState> emit) {
    emit(HomeCategoriesSelectedState(
      articlesByCategorySelected: event.articles,
      chipsCategorie: event.chipsCategorie,
      articlesByCategory: _articles,
    ));
  }

  FutureOr<void> _handleLoading(
      HomeLoadingEvent event, Emitter<HomeState> emit) {
    emit(HomeLoadingState());
  }

  FutureOr<void> _handleLoaded(HomeLoadedEvent event, Emitter<HomeState> emit) {
    emit(HomeLoadedState(
      articlesByCategory: _articles,
      chipsCategorie: _allCategoriesChips,
    ));
  }

  List<List<ArticleModel>> get _articles => _articleService.articles
          .fold<List<List<ArticleModel>>>(<List<ArticleModel>>[],
              (previousValue, element) {
        final List<ArticleModel>? foundList = previousValue.firstWhereOrNull(
          (list) => list.first.categoryUuid == element.categoryUuid,
        );

        if (foundList != null) {
          foundList.add(element);
        } else {
          previousValue.add(<ArticleModel>[element]);
        }
        return previousValue;
      });

  List<ChipCategorie> get _allCategoriesChips {
    return _articleService.categories
        .map(
          (e) => ChipCategorie(
            label: e.name,
            selected: false,
            uuid: e.uuid,
          ),
        )
        .toList();
  }
}
