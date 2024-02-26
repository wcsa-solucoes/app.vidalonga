import 'dart:async';
import 'package:app_vida_longa/core/services/articles_service.dart';
import 'package:app_vida_longa/domain/models/article_model.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final ArticleService _articleService = ArticleService.instance;

  HomeBloc() : super(HomeLoadingState()) {
    on<HomeLoadedEvent>(_handleLoaded);
    on<HomeLoadingEvent>(_handleLoading);
    on<HomeCategoriesSelectedEvent>(_handleCategoriesSelected);

    for (var element in _articleService.categoriesCollection) {
      _allCategoriesChips.add(
        ChipCategorie(
          label: element!.name,
          selected: false,
          uuid: element.uuid,
        ),
      );
    }

    add(HomeLoadedEvent(
        articles: _articles, chipsCategorie: _allCategoriesChips));
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
        // Procurar por uma lista existente que tenha um artigo da mesma categoria.
        final List<ArticleModel>? foundList = previousValue.firstWhereOrNull(
          (list) => list.first.categoryUuid == element.categoryUuid,
        );

        if (foundList != null) {
          // Se encontrou, adiciona o elemento nesta lista.
          foundList.add(element);
        } else {
          // Se não encontrou, cria uma nova lista para esta categoria.
          previousValue.add(<ArticleModel>[element]);
        }
        return previousValue;
      });

//get all chips from  articles with selected false
  final List<ChipCategorie> _allCategoriesChips = [];
}
